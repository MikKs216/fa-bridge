import * as fs from 'fs';
import * as path from 'path';
import * as vscode from 'vscode';
import { execSync } from 'child_process';

/**
 * Najde workspace folder, který obsahuje .fsbridge složku
 * V multi-root workspace může být .fsbridge v sekundárním workspace
 */
export function getFsBridgeWorkspaceRoot(): string | null {
	const workspaceFolders = vscode.workspace.workspaceFolders;
	if (!workspaceFolders || workspaceFolders.length === 0) {
		return null;
	}

	// Prohledej všechny workspace folders a najdi ten, který obsahuje .fsbridge
	for (const folder of workspaceFolders) {
		const fsbridgePath = path.join(folder.uri.fsPath, '.fsbridge');
		if (fs.existsSync(fsbridgePath)) {
			return folder.uri.fsPath;
		}
	}

	// .fsbridge neexistuje - použij sekundární workspace (Common Files)
	// V multi-root workspace je sekundární workspace ten s názvem "Common Files"
	// nebo druhý workspace folder (pokud máme více než jeden)
	if (workspaceFolders.length > 1) {
		// Najdi workspace folder s názvem "Common Files"
		for (const folder of workspaceFolders) {
			if (folder.name === 'Common Files') {
				return folder.uri.fsPath;
			}
		}
		// Pokud není "Common Files", použij druhý workspace folder (sekundární)
		return workspaceFolders[1].uri.fsPath;
	}

	// Fallback: použij první workspace folder (pro zpětnou kompatibilitu)
	return workspaceFolders[0]?.uri.fsPath || null;
}

/**
 * Zkontroluje, jestli proces s daným PID existuje (Windows)
 */
export function isProcessAlive(pid: number): boolean {
	try {
		const result = execSync(`tasklist /FI "PID eq ${pid}" /NH`, { encoding: 'utf-8' });
		// Pokud proces existuje, výstup obsahuje jeho jméno
		// Pokud neexistuje, výstup obsahuje "INFO: No tasks..."
		return !result.includes('No tasks') && result.trim().length > 0;
	} catch {
		return false;
	}
}

/**
 * Extrahuje FormId z názvu souboru
 * Např. "script_dz_15DPFO5252_2.pas" → "dz_15DPFO5252_2"
 */
export function extractFormIdFromFileName(fileName: string): string | null {
	// Očekávaný formát: script_{FormId}.pas nebo u_{FormId}.pas
	const baseName = path.basename(fileName, path.extname(fileName));
	
	// Zkus script_ prefix
	if (baseName.startsWith('script_')) {
		return baseName.substring(7); // odstrani "script_"
	}
	
	// Zkus u_ prefix
	if (baseName.startsWith('u_')) {
		return baseName.substring(2); // odstrani "u_"
	}
	
	return null;
}

/**
 * Najde složku instance FA podle current_form.txt, který odpovídá aktivnímu souboru
 * Vrací cestu ke složce .fsbridge/{FA_PID}/ nebo null
 * 
 * Nový koncept: JEDEN společný workspace, scripty jako záložky
 * Každá FA instance má soubor current_form.txt s FormId, který právě edituje
 */
export function getFAInstanceDir(workspaceRoot: string): string | null {
	const fsbridgeDir = path.join(workspaceRoot, '.fsbridge');
	
	if (!fs.existsSync(fsbridgeDir)) {
		return null;
	}

	// Metoda 1: Najdi FA instanci podle FormId aktivního souboru
	// Získej FormId z názvu aktivního souboru
	const activeEditor = vscode.window.activeTextEditor;
	if (activeEditor) {
		const activeFileName = activeEditor.document.fileName;
		const formId = extractFormIdFromFileName(activeFileName);
		
		if (formId) {
			console.log(`[FA Bridge] Aktivní soubor FormId: ${formId}`);
			
			// Prohledej všechny FA instance a najdi tu s odpovídajícím current_form.txt
			try {
				const entries = fs.readdirSync(fsbridgeDir, { withFileTypes: true });
				const dirs = entries.filter(d => d.isDirectory() && /^\d+$/.test(d.name));
				
				for (const dir of dirs) {
					const instanceDir = path.join(fsbridgeDir, dir.name);
					const currentFormFile = path.join(instanceDir, 'current_form.txt');
					
					if (fs.existsSync(currentFormFile)) {
						let content = fs.readFileSync(currentFormFile, 'utf-8');
						// Odstraň BOM pokud existuje
						if (content.charCodeAt(0) === 0xFEFF) {
							content = content.slice(1);
						}
						const instanceFormId = content.trim();
						
						if (instanceFormId === formId) {
							// Zkontroluj, jestli FA proces ještě běží
							const faInstanceFile = path.join(instanceDir, 'fa_instance.txt');
							if (fs.existsSync(faInstanceFile)) {
								let pidContent = fs.readFileSync(faInstanceFile, 'utf-8');
								if (pidContent.charCodeAt(0) === 0xFEFF) {
									pidContent = pidContent.slice(1);
								}
								const faPID = parseInt(pidContent.trim(), 10);
								if (!isNaN(faPID) && isProcessAlive(faPID)) {
									console.log(`[FA Bridge] Nalezena FA instance pro FormId ${formId}: ${dir.name}`);
									return instanceDir;
								}
							}
						}
					}
				}
			} catch (error) {
				console.error(`[FA Bridge] Chyba při hledání FA instance podle FormId: ${error}`);
			}
		}
	}

	// Metoda 2: Fallback - najdi první běžící FA instanci
	try {
		const entries = fs.readdirSync(fsbridgeDir, { withFileTypes: true });
		const dirs = entries.filter(d => d.isDirectory() && /^\d+$/.test(d.name));
		
		for (const dir of dirs) {
			const instanceDir = path.join(fsbridgeDir, dir.name);
			const faInstanceFile = path.join(instanceDir, 'fa_instance.txt');
			if (fs.existsSync(faInstanceFile)) {
				// Zkontroluj, jestli FA proces ještě běží
				let content = fs.readFileSync(faInstanceFile, 'utf-8');
				// Odstraň BOM pokud existuje
				if (content.charCodeAt(0) === 0xFEFF) {
					content = content.slice(1);
				}
				const faPID = parseInt(content.trim(), 10);
				if (!isNaN(faPID) && isProcessAlive(faPID)) {
					console.log(`[FA Bridge] Nalezena aktivní instance složka (fallback): ${dir.name}`);
					return instanceDir;
				}
			}
		}
	} catch (error) {
		console.error(`[FA Bridge] Chyba při prohledávání složek: ${error}`);
	}

	console.log(`[FA Bridge] Žádná instance složka nenalezena v ${fsbridgeDir}`);
	return null;
}

/**
 * Načte FA instance ID ze složky instance
 */
export function getFAInstanceId(workspaceRoot: string): string | null {
	const instanceDir = getFAInstanceDir(workspaceRoot);
	if (!instanceDir) {
		return null;
	}
	
	const faInstanceFile = path.join(instanceDir, 'fa_instance.txt');
	if (fs.existsSync(faInstanceFile)) {
		let content = fs.readFileSync(faInstanceFile, 'utf-8');
		// Odstraň BOM pokud existuje
		if (content.charCodeAt(0) === 0xFEFF) {
			content = content.slice(1);
		}
		const trimmed = content.trim();
		console.log(`[FA Bridge] Načteno FA instance ID: ${trimmed}`);
		return trimmed || null;
	}
	return null;
}

/**
 * Vrátí validní instance ID nebo null pro fallback
 */
export function getValidInstanceId(workspaceRoot: string): string | null {
	return getFAInstanceId(workspaceRoot);
}

/**
 * Vrátí cestu k facmd souboru
 * Vrací null pokud není nalezena instance složka
 */
export function getFacmdPath(workspaceRoot: string): string | null {
	const instanceDir = getFAInstanceDir(workspaceRoot);
	if (instanceDir) {
		return path.join(instanceDir, 'facmd.txt');
	}
	// NENÍ fallback - pokud není instance složka, vrátíme null
	// aby se facmd.txt nevytvářel ve špatné složce
	return null;
}

/**
 * Vrátí cestu k fafield souboru
 * Vrací null pokud není nalezena instance složka
 */
export function getFafieldPath(workspaceRoot: string): string | null {
	const instanceDir = getFAInstanceDir(workspaceRoot);
	if (instanceDir) {
		return path.join(instanceDir, 'fafield.txt');
	}
	// NENÍ fallback - pokud není instance složka, vrátíme null
	// aby se fafield.txt nevytvářel ve špatné složce
	return null;
}

/**
 * Zapíše příkaz do .fsbridge/{FA_PID}/facmd.txt s UTF-8 BOM
 * Atomicky (tmp → rename) aby se FA nezbláznila
 * Používá vždy .fsbridge složku z workspace, který obsahuje .fsbridge
 * Podporuje více instancí FA (instance-specific složky)
 */
export async function writeFACommand(command: string): Promise<void> {
	try {
		// Najdi workspace folder, který obsahuje .fsbridge (může být v sekundárním workspace)
		const workspaceRoot = getFsBridgeWorkspaceRoot();
		if (!workspaceRoot) {
			throw new Error('Žádný workspace otevřen nebo .fsbridge složka nenalezena');
		}

		const facmdPath = getFacmdPath(workspaceRoot);
		if (!facmdPath) {
			throw new Error('Nenalezena FA instance složka. Ujisti se, že máš otevřený FA script a že FA aplikace běží.');
		}
		
		// DŮLEŽITÉ: Ověř, že cesta obsahuje PID složku (formát: .fsbridge/{PID}/facmd.txt)
		// Pokud by se náhodou použila špatná cesta, zabráníme zápisu přímo do .fsbridge/facmd.txt
		const fsbridgeDir = path.join(workspaceRoot, '.fsbridge');
		const relativePath = path.relative(fsbridgeDir, facmdPath);
		const pathParts = relativePath.split(path.sep);
		
		// Cesta musí být ve formátu: {PID}/facmd.txt
		if (pathParts.length !== 2 || !/^\d+$/.test(pathParts[0]) || pathParts[1] !== 'facmd.txt') {
			throw new Error(`Neplatná cesta k facmd.txt: ${facmdPath}. Cesta musí být ve formátu .fsbridge/{FA_PID}/facmd.txt`);
		}
		
		const instanceDir = path.dirname(facmdPath);
		
		// Vytvoř složku pokud neexistuje
		if (!fs.existsSync(instanceDir)) {
			fs.mkdirSync(instanceDir, { recursive: true });
		}

		// UTF-8 s BOM (EF BB BF)
		const bom = Buffer.from([0xef, 0xbb, 0xbf]);
		const commandBuffer = Buffer.from(command, 'utf-8');
		const content = Buffer.concat([bom, commandBuffer]);

		// Atomický zápis: tmp → rename
		const tmpPath = facmdPath + '.tmp';
		fs.writeFileSync(tmpPath, content);
		fs.renameSync(tmpPath, facmdPath);

		const instanceId = getFAInstanceId(workspaceRoot);
		console.log(`[FA Bridge] Odeslán příkaz: ${command} → ${facmdPath} (FA instance: ${instanceId || 'none'})`);
	} catch (error) {
		const msg = error instanceof Error ? error.message : String(error);
		console.error(`[FA Bridge] Chyba: ${msg}`);
		throw error;
	}
}
