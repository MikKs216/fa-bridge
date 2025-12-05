import * as fs from 'fs';
import * as path from 'path';
import * as vscode from 'vscode';

/**
 * Formát timestampu pro názvy souborů: YYYYMMDD-HHMMSS
 */
function formatTimestamp(date: Date): string {
	const year = date.getFullYear();
	const month = String(date.getMonth() + 1).padStart(2, '0');
	const day = String(date.getDate()).padStart(2, '0');
	const hours = String(date.getHours()).padStart(2, '0');
	const minutes = String(date.getMinutes()).padStart(2, '0');
	const seconds = String(date.getSeconds()).padStart(2, '0');
	return `${year}${month}${day}-${hours}${minutes}${seconds}`;
}

/**
 * Vytvoří název souboru s timestampem
 * Příklad: script_test.pas -> script_test-20250115-143022.pas
 */
function createHistoryFileName(originalFileName: string, timestamp: string): string {
	const ext = path.extname(originalFileName);
	const baseName = path.basename(originalFileName, ext);
	return `${baseName}-${timestamp}${ext}`;
}

/**
 * Uloží kopii souboru do .history složky
 * @param filePath Cesta k editovanému souboru
 * @returns Cesta k uloženému souboru v historii nebo null pokud se nepodařilo
 */
export async function saveFileHistory(filePath: string): Promise<string | null> {
	try {
		const config = vscode.workspace.getConfiguration('faBridge');
		const enableHistory = config.get<boolean>('enableFileHistory', true);
		
		if (!enableHistory) {
			return null;
		}

		// Zkontroluj, jestli je to FA script soubor
		const fileName = path.basename(filePath);
		if (!fileName.match(/^(script_|u_)[a-zA-Z0-9_]+\.pas$/)) {
			return null; // Není FA script, neukládat historii
		}

		// Zkontroluj, jestli soubor existuje
		if (!fs.existsSync(filePath)) {
			return null;
		}

		const fileDir = path.dirname(filePath);
		const historyDir = path.join(fileDir, '.history');
		
		// Vytvoř .history složku pokud neexistuje
		if (!fs.existsSync(historyDir)) {
			fs.mkdirSync(historyDir, { recursive: true });
		}

		// Vytvoř název souboru s timestampem
		const timestamp = formatTimestamp(new Date());
		const historyFileName = createHistoryFileName(fileName, timestamp);
		const historyFilePath = path.join(historyDir, historyFileName);

		// Zkopíruj soubor
		fs.copyFileSync(filePath, historyFilePath);

		console.log(`[FA Bridge] Historie uložena: ${historyFilePath}`);
		return historyFilePath;
	} catch (error) {
		const msg = error instanceof Error ? error.message : String(error);
		console.error(`[FA Bridge] Chyba při ukládání historie: ${msg}`);
		return null;
	}
}

/**
 * Získá seznam všech verzí souboru v historii (seřazeno od nejnovější)
 */
export function getFileHistoryVersions(filePath: string): string[] {
	try {
		const fileDir = path.dirname(filePath);
		const historyDir = path.join(fileDir, '.history');
		
		if (!fs.existsSync(historyDir)) {
			return [];
		}

		const fileName = path.basename(filePath);
		const baseName = path.basename(fileName, path.extname(fileName));
		const ext = path.extname(fileName);

		// Najdi všechny soubory v historii, které odpovídají tomuto souboru
		const entries = fs.readdirSync(historyDir);
		const versions = entries
			.filter(entry => {
				// Formát: baseName-YYYYMMDD-HHMMSS.ext
				const pattern = new RegExp(`^${baseName.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}-\\d{8}-\\d{6}${ext.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}$`);
				return pattern.test(entry);
			})
			.map(entry => path.join(historyDir, entry))
			.sort((a, b) => {
				// Seřaď podle času modifikace (nejnovější první)
				const statA = fs.statSync(a);
				const statB = fs.statSync(b);
				return statB.mtimeMs - statA.mtimeMs;
			});

		return versions;
	} catch (error) {
		console.error(`[FA Bridge] Chyba při čtení historie: ${error}`);
		return [];
	}
}

/**
 * Porovná aktuální soubor s předchozí verzí v historii
 */
export async function compareWithPreviousVersion(filePath: string): Promise<void> {
	try {
		const versions = getFileHistoryVersions(filePath);
		
		if (versions.length === 0) {
			vscode.window.showInformationMessage('Žádná předchozí verze v historii');
			return;
		}

		const previousVersion = versions[0]; // Nejnovější verze
		const currentUri = vscode.Uri.file(filePath);
		const previousUri = vscode.Uri.file(previousVersion);

		// Získej timestamp z názvu souboru pro zobrazení
		const previousFileName = path.basename(previousVersion);
		const timestampMatch = previousFileName.match(/-(\d{8}-\d{6})\./);
		const timestamp = timestampMatch ? timestampMatch[1] : 'předchozí';

		// Otevři diff viewer
		await vscode.commands.executeCommand('vscode.diff', 
			previousUri, 
			currentUri, 
			`${previousFileName} ↔ ${path.basename(filePath)}`
		);
	} catch (error) {
		const msg = error instanceof Error ? error.message : String(error);
		vscode.window.showErrorMessage(`Chyba při porovnávání: ${msg}`);
	}
}

/**
 * Zobrazí seznam verzí a umožní vybrat verzi k porovnání
 */
export async function showHistoryVersions(filePath: string): Promise<void> {
	try {
		const versions = getFileHistoryVersions(filePath);
		
		if (versions.length === 0) {
			vscode.window.showInformationMessage('Žádné verze v historii');
			return;
		}

		// Vytvoř seznam pro QuickPick
		const items = versions.map((version, index) => {
			const fileName = path.basename(version);
			const timestampMatch = fileName.match(/-(\d{8})-(\d{6})\./);
			let timestamp = fileName;
			
			if (timestampMatch) {
				// Formát: YYYYMMDD-HHMMSS -> YYYY-MM-DD HH:MM:SS
				const dateStr = timestampMatch[1];
				const timeStr = timestampMatch[2];
				timestamp = `${dateStr.substring(0, 4)}-${dateStr.substring(4, 6)}-${dateStr.substring(6, 8)} ${timeStr.substring(0, 2)}:${timeStr.substring(2, 4)}:${timeStr.substring(4, 6)}`;
			}
			
			const stat = fs.statSync(version);
			const size = (stat.size / 1024).toFixed(1);
			
			return {
				label: timestamp,
				description: `${size} KB`,
				detail: version,
				version: version
			};
		});

		// Přidej možnost porovnat s aktuálním souborem
		const currentItem = {
			label: '$(file) Aktuální soubor',
			description: 'Porovnat s aktuálním souborem',
			detail: filePath,
			version: filePath
		};

		const selected = await vscode.window.showQuickPick([currentItem, ...items], {
			placeHolder: 'Vyberte verzi k porovnání s aktuálním souborem'
		});

		if (!selected) {
			return;
		}

		const currentUri = vscode.Uri.file(filePath);
		const selectedUri = vscode.Uri.file(selected.version);
		const selectedFileName = path.basename(selected.version);

		// Otevři diff viewer
		await vscode.commands.executeCommand('vscode.diff', 
			selectedUri, 
			currentUri, 
			`${selectedFileName} ↔ ${path.basename(filePath)}`
		);
	} catch (error) {
		const msg = error instanceof Error ? error.message : String(error);
		vscode.window.showErrorMessage(`Chyba při zobrazování historie: ${msg}`);
	}
}

