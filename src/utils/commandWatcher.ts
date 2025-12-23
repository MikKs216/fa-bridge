import * as fs from 'fs';
import * as path from 'path';
import * as vscode from 'vscode';
import { getFsBridgeWorkspaceRoot, getFacmdPath, getFAInstanceDir, extractFormIdFromFileName } from './fsBridge';
import { hledatPodleAktUdaje } from '../commands/sendCommand';

/**
 * Sleduje facmd.txt a zpracovává příkazy z FA
 */
export class CommandWatcher implements vscode.Disposable {
	private fileWatcher: fs.FSWatcher | null = null;
	private lastProcessedTimes: Map<string, number> = new Map(); // Časy zpracování pro každou instanci
	private outputChannel: vscode.OutputChannel | null;
	private pollingInterval: NodeJS.Timeout | null = null;

	constructor(outputChannel: vscode.OutputChannel | null) {
		this.outputChannel = outputChannel;
		this.startWatching();
	}

	private log(message: string): void {
		if (this.outputChannel) {
			this.outputChannel.appendLine(message);
		}
		console.log(message);
		
		// DEBUG: Logování do souboru - odkomentuj pro ladění
		// try {
		// 	const workspaceRoot = getFsBridgeWorkspaceRoot();
		// 	if (workspaceRoot) {
		// 		const logPath = path.join(workspaceRoot, '.fsbridge', 'cursor_debug.log');
		// 		const timestamp = new Date().toISOString().replace('T', ' ').substring(0, 19);
		// 		fs.appendFileSync(logPath, `[${timestamp}] ${message}\n`, 'utf-8');
		// 	}
		// } catch (e) {
		// 	// Ignoruj chyby při zápisu logu
		// }
	}

	private stopWatching(): void {
		if (this.fileWatcher) {
			this.fileWatcher.close();
			this.fileWatcher = null;
		}
		if (this.pollingInterval) {
			clearInterval(this.pollingInterval);
			this.pollingInterval = null;
		}
	}

	private startWatching(): void {
		const workspaceRoot = getFsBridgeWorkspaceRoot();
		if (!workspaceRoot) {
			this.log('[CommandWatcher] Workspace root nenalezen');
			return;
		}

		const fsbridgeDir = path.join(workspaceRoot, '.fsbridge');
		this.log(`[CommandWatcher] Startuji polling pro VŠECHNY FA instance v: ${fsbridgeDir}`);

		// Polling přes VŠECHNY instance složky - každých 150ms
		// Tím zajistíme, že zachytíme příkazy ze všech FA instancí, ne jen z aktivní
		this.pollingInterval = setInterval(() => {
			this.pollAllInstances(fsbridgeDir);
		}, 150);
	}

	private pollAllInstances(fsbridgeDir: string): void {
		if (!fs.existsSync(fsbridgeDir)) {
			return;
		}

		try {
			const entries = fs.readdirSync(fsbridgeDir, { withFileTypes: true });
			for (const entry of entries) {
				// Hledej pouze složky s číselnými názvy (PID)
				if (entry.isDirectory() && /^\d+$/.test(entry.name)) {
					const facmdPath = path.join(fsbridgeDir, entry.name, 'facmd_from_fa.txt');
					if (fs.existsSync(facmdPath)) {
						this.processCommand(facmdPath);
					}
				}
			}
		} catch (error) {
			// Ignoruj chyby při čtení složky
		}
	}

	private async processCommand(facmdPath: string): Promise<void> {
		if (!fs.existsSync(facmdPath)) {
			return;
		}

		// Zkontroluj čas modifikace - pokud je stejný jako poslední zpracovaný pro tuto instanci, přeskoč
		const stats = fs.statSync(facmdPath);
		const lastTime = this.lastProcessedTimes.get(facmdPath) || 0;
		if (stats.mtimeMs === lastTime) {
			return;
		}

		this.lastProcessedTimes.set(facmdPath, stats.mtimeMs);

		try {
			// Načti příkaz
			let content = fs.readFileSync(facmdPath, 'utf-8');
			
			// Odstraň BOM pokud existuje
			if (content.charCodeAt(0) === 0xFEFF) {
				content = content.slice(1);
			}
			
			const command = content.trim();
			
			if (!command) {
				return;
			}

			this.log(`[CommandWatcher] Příkaz přijat: ${command}`);

			// Zpracuj příkaz - vrať true pokud byl příkaz zpracován
			const wasProcessed = await this.handleCommand(command, facmdPath);

			// Smaž soubor POUZE pokud byl příkaz skutečně zpracován
			// (jinak může být příkaz určený pro FA, ne pro Cursor)
			if (wasProcessed) {
				try {
					fs.unlinkSync(facmdPath);
					this.log(`[CommandWatcher] Soubor smazán po zpracování příkazu`);
				} catch (error) {
					this.log(`[CommandWatcher] Chyba při mazání facmd.txt: ${error}`);
				}
			} else {
				this.log(`[CommandWatcher] Příkaz není pro Cursor - soubor ponechán (FA ho zpracuje)`);
			}
		} catch (error) {
			const msg = error instanceof Error ? error.message : String(error);
			this.log(`[CommandWatcher] Chyba při zpracování příkazu: ${msg}`);
		}
	}

	private async handleCommand(command: string, facmdPath: string): Promise<boolean> {
		if (command === 'check_unsaved_and_close') {
			await this.handleCheckUnsavedAndClose(facmdPath);
			return true; // Příkaz byl zpracován
		}
		if (command === 'check_unsaved') {
			await this.handleCheckUnsaved(facmdPath);
			return true; // Příkaz byl zpracován
		}
		if (command === 'close_file') {
			await this.handleCloseFile(facmdPath);
			return true; // Příkaz byl zpracován
		}
		if (command === 'check_if_open') {
			await this.handleCheckIfOpen(facmdPath);
			return true; // Příkaz byl zpracován
		}
		if (command === 'Hledat_podle_akt_udaje') {
			await hledatPodleAktUdaje();
			return true; // Příkaz byl zpracován
		}
		// Zde můžeme přidat další příkazy v budoucnu
		return false; // Příkaz není pro Cursor - necháme ho pro FA
	}

	private async handleCheckUnsavedAndClose(facmdPath: string): Promise<void> {
		// OPRAVA: Extrahuj instance složku přímo z facmdPath, ne podle aktivní záložky!
		const instanceDir = path.dirname(facmdPath);
		const responsePath = path.join(instanceDir, 'facmd_response.txt');
		
		// Přečti current_form.txt z instance složky - tím zjistíme, který FormId má FA zavřít
		const currentFormFile = path.join(instanceDir, 'current_form.txt');
		let targetFormId = '';
		
		if (fs.existsSync(currentFormFile)) {
			try {
				let content = fs.readFileSync(currentFormFile, 'utf-8');
				if (content.charCodeAt(0) === 0xFEFF) {
					content = content.slice(1);
				}
				targetFormId = content.trim();
				this.log(`[CommandWatcher] Target FormId from current_form.txt: ${targetFormId}`);
			} catch (error) {
				this.log(`[CommandWatcher] Chyba při čtení current_form.txt: ${error}`);
			}
		}
		
		// Najdi záložku s odpovídajícím FormId
		let targetTab: vscode.Tab | null = null;
		let targetDocument: vscode.TextDocument | null = null;
		
		if (targetFormId) {
			for (const tabGroup of vscode.window.tabGroups.all) {
				for (const tab of tabGroup.tabs) {
					if (tab.input instanceof vscode.TabInputText) {
						const tabInput = tab.input as vscode.TabInputText;
						const tabFileName = path.basename(tabInput.uri.fsPath);
						const tabFormId = extractFormIdFromFileName(tabFileName);
						
						if (tabFormId === targetFormId) {
							targetTab = tab;
							// Zkus najít odpovídající dokument
							targetDocument = vscode.workspace.textDocuments.find(
								doc => doc.uri.fsPath === tabInput.uri.fsPath
							) || null;
							break;
						}
					}
				}
				if (targetTab) break;
			}
		}
		
		if (!targetTab) {
			// Záložka nenalezena
			fs.writeFileSync(responsePath, 'NOT_OPEN', 'utf-8');
			this.log('[CommandWatcher] Záložka pro FormId nenalezena');
			return;
		}
		
		// Zkontroluj neuložené změny
		if (targetDocument && targetDocument.isDirty) {
			// Má neuložené změny - odpověz a NEZAVÍREJ
			const message = `UNSAVED:Script ${targetFormId} má neuložené změny`;
			fs.writeFileSync(responsePath, message, 'utf-8');
			this.log(`[CommandWatcher] Script má neuložené změny: ${targetFormId}`);
			return;
		}
		
		// Soubor je uložený - zavři záložku
		await vscode.window.tabGroups.close(targetTab);
		fs.writeFileSync(responsePath, 'OK', 'utf-8');
		this.log('[CommandWatcher] Script zavřen (uložený)');
	}

	private async handleCheckUnsaved(facmdPath: string): Promise<void> {
		try {
			const workspaceRoot = getFsBridgeWorkspaceRoot();
			if (!workspaceRoot) {
				this.log('[CommandWatcher] handleCheckUnsaved: Workspace root nenalezen');
				return;
			}

			const instanceDir = getFAInstanceDir(workspaceRoot);
			if (!instanceDir) {
				this.log('[CommandWatcher] handleCheckUnsaved: Instance dir nenalezena');
				return;
			}

			const responsePath = path.join(instanceDir, 'facmd_response.txt');
			this.log(`[CommandWatcher] handleCheckUnsaved: Response path: ${responsePath}`);
			
			const editor = vscode.window.activeTextEditor;

			if (!editor) {
				// Žádný editor otevřený
				fs.writeFileSync(responsePath, 'NOT_OPEN', 'utf-8');
				this.log('[CommandWatcher] handleCheckUnsaved: Žádný editor otevřený - NOT_OPEN');
				return;
			}

			const document = editor.document;
			const fileName = path.basename(document.fileName);
			this.log(`[CommandWatcher] handleCheckUnsaved: Kontroluji soubor: ${fileName}, isDirty: ${document.isDirty}`);

			// Zkontroluj, jestli je to FA script soubor
			if (!fileName.match(/^(script_|u_)[a-zA-Z0-9_]+\.pas$/)) {
				// Není to FA script - odpověz OK (není co kontrolovat)
				fs.writeFileSync(responsePath, 'OK', 'utf-8');
				this.log('[CommandWatcher] handleCheckUnsaved: Není FA script - OK');
				return;
			}

			// Zkontroluj neuložené změny
			if (document.isDirty) {
				// Má neuložené změny - odpověz
				const formId = extractFormIdFromFileName(fileName);
				const message = `UNSAVED:Script ${formId} má neuložené změny`;
				fs.writeFileSync(responsePath, message, 'utf-8');
				this.log(`[CommandWatcher] handleCheckUnsaved: Script má neuložené změny: ${formId} - UNSAVED`);
				return;
			}

			// Soubor je uložený - odpověz OK
			fs.writeFileSync(responsePath, 'OK', 'utf-8');
			this.log('[CommandWatcher] handleCheckUnsaved: Script je uložený - OK');
		} catch (error) {
			const msg = error instanceof Error ? error.message : String(error);
			this.log(`[CommandWatcher] handleCheckUnsaved: Chyba: ${msg}`);
			// Zkus zapsat chybovou odpověď
			try {
				const workspaceRoot = getFsBridgeWorkspaceRoot();
				if (workspaceRoot) {
					const instanceDir = getFAInstanceDir(workspaceRoot);
					if (instanceDir) {
						const responsePath = path.join(instanceDir, 'facmd_response.txt');
						fs.writeFileSync(responsePath, 'ERROR', 'utf-8');
					}
				}
			} catch (e) {
				// Ignoruj chybu při zápisu chybové odpovědi
			}
		}
	}

	private async handleCloseFile(facmdPath: string): Promise<void> {
		// OPRAVA: Extrahuj instance složku přímo z facmdPath, ne podle aktivní záložky!
		// facmdPath je např. "D:\...\Scripts\.fsbridge\12345\facmd_from_fa.txt"
		const instanceDir = path.dirname(facmdPath);
		const responsePath = path.join(instanceDir, 'facmd_response.txt');
		
		// Přečti current_form.txt z instance složky - tím zjistíme, který FormId má FA zavřít
		const currentFormFile = path.join(instanceDir, 'current_form.txt');
		let targetFormId = '';
		
		if (fs.existsSync(currentFormFile)) {
			try {
				let content = fs.readFileSync(currentFormFile, 'utf-8');
				// Odstraň BOM pokud existuje
				if (content.charCodeAt(0) === 0xFEFF) {
					content = content.slice(1);
				}
				targetFormId = content.trim();
				this.log(`[CommandWatcher] Target FormId from current_form.txt: ${targetFormId}`);
			} catch (error) {
				this.log(`[CommandWatcher] Chyba při čtení current_form.txt: ${error}`);
			}
		}
		
		// Najdi záložku s odpovídajícím FormId a zavři ji
		let tabClosed = false;
		
		if (targetFormId) {
			// Projdi všechny tab groups a najdi záložku s odpovídajícím FormId
			this.log(`[CommandWatcher] Hledám záložku pro targetFormId: "${targetFormId}"`);
			for (const tabGroup of vscode.window.tabGroups.all) {
				for (const tab of tabGroup.tabs) {
					if (tab.input instanceof vscode.TabInputText) {
						const tabInput = tab.input as vscode.TabInputText;
						const tabFileName = path.basename(tabInput.uri.fsPath);
						const tabFormId = extractFormIdFromFileName(tabFileName);
						this.log(`[CommandWatcher] Záložka: "${tabFileName}" -> FormId: "${tabFormId}"`);
						
						if (tabFormId === targetFormId) {
							// Našli jsme správnou záložku - zavři ji
							this.log(`[CommandWatcher] MATCH! Zavírám záložku pro FormId: ${targetFormId}`);
							await vscode.window.tabGroups.close(tab);
							tabClosed = true;
							break;
						}
					}
				}
				if (tabClosed) break;
			}
		}
		
		if (!tabClosed) {
			// Fallback: pokud jsme nenašli záložku podle FormId, zavři aktivní
			this.log('[CommandWatcher] Záložka pro FormId nenalezena, zavírám aktivní');
			await vscode.commands.executeCommand('workbench.action.closeActiveEditor');
			tabClosed = true;
		}
		
		fs.writeFileSync(responsePath, 'OK', 'utf-8');
		this.log('[CommandWatcher] Script zavřen');
		
		// Zkontroluj, zda jsou ještě nějaké otevřené záložky (počítej skutečné taby, ne viditelné editory)
		let totalTabs = 0;
		for (const tabGroup of vscode.window.tabGroups.all) {
			totalTabs += tabGroup.tabs.length;
		}
		this.log(`[CommandWatcher] Zbývající záložky: ${totalTabs}`);
		
		if (totalTabs === 0) {
			this.log('[CommandWatcher] Žádné otevřené záložky - zavírám Cursor');
			setTimeout(() => {
				vscode.commands.executeCommand('workbench.action.quit');
			}, 100);
		}
	}

	private async handleCheckIfOpen(facmdPath: string): Promise<void> {
		const workspaceRoot = getFsBridgeWorkspaceRoot();
		if (!workspaceRoot) {
			return;
		}

		const instanceDir = getFAInstanceDir(workspaceRoot);
		if (!instanceDir) {
			return;
		}

		const responsePath = path.join(instanceDir, 'facmd_response.txt');
		const editor = vscode.window.activeTextEditor;

		if (!editor) {
			// Žádný editor otevřený
			fs.writeFileSync(responsePath, 'NO_EDITOR', 'utf-8');
			this.log('[CommandWatcher] Žádný editor otevřený');
			return;
		}

		const document = editor.document;
		const fileName = path.basename(document.fileName);

		// Zkontroluj, jestli je to FA script soubor
		if (!fileName.match(/^(script_|u_)[a-zA-Z0-9_]+\.pas$/)) {
			// Není to FA script
			fs.writeFileSync(responsePath, 'NOT_FA_SCRIPT', 'utf-8');
			this.log('[CommandWatcher] Aktivní soubor není FA script');
			return;
		}

		// Extrahuj FormId z názvu souboru
		const formId = extractFormIdFromFileName(fileName);
		if (!formId) {
			fs.writeFileSync(responsePath, 'NOT_FA_SCRIPT', 'utf-8');
			this.log('[CommandWatcher] Nelze extrahovat FormId z názvu souboru');
			return;
		}

		// Zkontroluj, jestli je tento script otevřený v aktivní záložce
		// Porovnejme FormId z názvu souboru s FormId z current_form.txt
		const currentFormFile = path.join(instanceDir, 'current_form.txt');
		if (fs.existsSync(currentFormFile)) {
			let currentFormId = '';
			try {
				let content = fs.readFileSync(currentFormFile, 'utf-8');
				// Odstraň BOM pokud existuje
				if (content.charCodeAt(0) === 0xFEFF) {
					content = content.slice(1);
				}
				currentFormId = content.trim();
			} catch (error) {
				this.log(`[CommandWatcher] Chyba při čtení current_form.txt: ${error}`);
			}

			// Pokud FormId odpovídá, script je otevřený
			if (currentFormId === formId) {
				fs.writeFileSync(responsePath, 'OPEN', 'utf-8');
				this.log(`[CommandWatcher] Script je otevřený: ${formId}`);
				return;
			}
		}

		// Script není otevřený (nebo je otevřený jiný script)
		fs.writeFileSync(responsePath, 'NOT_OPEN', 'utf-8');
		this.log(`[CommandWatcher] Script není otevřený: ${formId}`);
	}

	public dispose(): void {
		this.stopWatching();
	}
}

