import * as fs from 'fs';
import * as path from 'path';
import * as vscode from 'vscode';
import { getFsBridgeWorkspaceRoot, getFacmdPath, getFAInstanceDir, extractFormIdFromFileName } from './fsBridge';

/**
 * Sleduje facmd.txt a zpracovává příkazy z FA
 */
export class CommandWatcher implements vscode.Disposable {
	private fileWatcher: fs.FSWatcher | null = null;
	private lastProcessedTime: number = 0;
	private outputChannel: vscode.OutputChannel | null;
	private pollingInterval: NodeJS.Timeout | null = null;
	private editorChangeListener: vscode.Disposable | null = null;

	constructor(outputChannel: vscode.OutputChannel | null) {
		this.outputChannel = outputChannel;
		this.startWatching();
		
		// Sleduj změny aktivního editoru - když se otevře FA script, restartuj watcher
		this.editorChangeListener = vscode.window.onDidChangeActiveTextEditor(() => {
			this.restartWatching();
		});
	}

	private log(message: string): void {
		if (this.outputChannel) {
			this.outputChannel.appendLine(message);
		}
		console.log(message);
	}

	private restartWatching(): void {
		this.stopWatching();
		this.startWatching();
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

		const instanceDir = getFAInstanceDir(workspaceRoot);
		if (!instanceDir) {
			this.log('[CommandWatcher] Instance dir nenalezena - použiji polling');
			// Pokud není instance složka, použij polling jako fallback
			this.startPolling(workspaceRoot);
			return;
		}

		// facmd_from_fa.txt je pro příkazy z FA do Cursoru (např. check_unsaved_and_close)
		// facmd.txt je pouze pro příkazy z Cursoru do FA (activate, compile, atd.)
		const facmdPath = path.join(instanceDir, 'facmd_from_fa.txt');
		const facmdDir = path.dirname(facmdPath);

		this.log(`[CommandWatcher] Watching file: ${facmdPath}`);

		// Sleduj změny v instance složce
		if (fs.existsSync(facmdDir)) {
			this.fileWatcher = fs.watch(facmdDir, (eventType, filename) => {
				if (filename === 'facmd_from_fa.txt' && (eventType === 'rename' || eventType === 'change')) {
					// Malé zpoždění pro zajištění, že soubor je plně zapsán
					setTimeout(() => {
						this.processCommand(facmdPath);
					}, 50); // Zkráceno z 100ms na 50ms pro rychlejší reakci
				}
			});
			
			// Spusť také polling jako fallback mechanismus (pro případ, že file watcher nefunguje)
			// Polling kontroluje každých 200ms, jestli se neobjevil nový příkaz
			this.pollingInterval = setInterval(() => {
				if (fs.existsSync(facmdPath)) {
					this.processCommand(facmdPath);
				}
			}, 200);
		} else {
			this.log(`[CommandWatcher] WARNING: Directory does not exist: ${facmdDir} - použiji polling`);
			this.startPolling(workspaceRoot);
		}
	}

	private startPolling(workspaceRoot: string): void {
		// Polling každých 200ms - zkontroluj, jestli se neobjevila instance složka nebo facmd_from_fa.txt
		this.pollingInterval = setInterval(() => {
			const instanceDir = getFAInstanceDir(workspaceRoot);
			if (instanceDir) {
				// Instance složka se objevila - přepni na file watcher
				this.log('[CommandWatcher] Instance dir nalezena - přepínám na file watcher');
				this.restartWatching();
				return;
			}

			// Zkontroluj všechny možné instance složky a zkus najít facmd_from_fa.txt
			const fsbridgeDir = path.join(workspaceRoot, '.fsbridge');
			if (fs.existsSync(fsbridgeDir)) {
				try {
					const entries = fs.readdirSync(fsbridgeDir, { withFileTypes: true });
					for (const entry of entries) {
						if (entry.isDirectory() && /^\d+$/.test(entry.name)) {
							const facmdPath = path.join(fsbridgeDir, entry.name, 'facmd_from_fa.txt');
							if (fs.existsSync(facmdPath)) {
								this.log(`[CommandWatcher] Nalezen facmd_from_fa.txt v polling módu: ${facmdPath}`);
								this.processCommand(facmdPath);
							}
						}
					}
				} catch (error) {
					// Ignoruj chyby při čtení složky
				}
			}
		}, 200); // Zkráceno z 500ms na 200ms pro rychlejší reakci
	}

	private async processCommand(facmdPath: string): Promise<void> {
		if (!fs.existsSync(facmdPath)) {
			return;
		}

		// Zkontroluj čas modifikace - pokud je stejný jako poslední zpracovaný, přeskoč
		const stats = fs.statSync(facmdPath);
		if (stats.mtimeMs === this.lastProcessedTime) {
			return;
		}

		this.lastProcessedTime = stats.mtimeMs;

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
		// Zde můžeme přidat další příkazy v budoucnu
		return false; // Příkaz není pro Cursor - necháme ho pro FA
	}

	private async handleCheckUnsavedAndClose(facmdPath: string): Promise<void> {
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
			fs.writeFileSync(responsePath, 'NOT_OPEN', 'utf-8');
			this.log('[CommandWatcher] Žádný editor otevřený');
			return;
		}

		const document = editor.document;
		const fileName = path.basename(document.fileName);

		// Zkontroluj, jestli je to FA script soubor
		if (!fileName.match(/^(script_|u_)[a-zA-Z0-9_]+\.pas$/)) {
			// Není to FA script - zavři záložku bez kontroly
			await vscode.commands.executeCommand('workbench.action.closeActiveEditor');
			fs.writeFileSync(responsePath, 'OK', 'utf-8');
			this.log('[CommandWatcher] Zavřena záložka (není FA script)');
			return;
		}

		// Zkontroluj neuložené změny
		if (document.isDirty) {
			// Má neuložené změny - odpověz a NEZAVÍREJ
			const formId = extractFormIdFromFileName(fileName);
			const message = `UNSAVED:Script ${formId} má neuložené změny`;
			fs.writeFileSync(responsePath, message, 'utf-8');
			this.log(`[CommandWatcher] Script má neuložené změny: ${formId}`);
			return;
		}

		// Soubor je uložený - zavři záložku
		await vscode.commands.executeCommand('workbench.action.closeActiveEditor');
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
			fs.writeFileSync(responsePath, 'NOT_OPEN', 'utf-8');
			this.log('[CommandWatcher] Žádný editor otevřený');
			return;
		}

		const document = editor.document;
		const fileName = path.basename(document.fileName);

		// Zkontroluj, jestli je to FA script soubor
		if (!fileName.match(/^(script_|u_)[a-zA-Z0-9_]+\.pas$/)) {
			// Není to FA script - zavři záložku bez kontroly
			await vscode.commands.executeCommand('workbench.action.closeActiveEditor');
			fs.writeFileSync(responsePath, 'OK', 'utf-8');
			this.log('[CommandWatcher] Zavřena záložka (není FA script)');
			
			// Zkontroluj, zda jsou ještě nějaké otevřené záložky
			if (vscode.window.visibleTextEditors.length === 0) {
				this.log('[CommandWatcher] Žádné otevřené záložky - zavírám Cursor');
				setTimeout(() => {
					vscode.commands.executeCommand('workbench.action.quit');
				}, 100);
			}
			return;
		}

		// Zavři záložku (bez kontroly neuložených změn - to už bylo zkontrolováno dříve)
		await vscode.commands.executeCommand('workbench.action.closeActiveEditor');
		fs.writeFileSync(responsePath, 'OK', 'utf-8');
		this.log('[CommandWatcher] Script zavřen');
		
		// Zkontroluj, zda jsou ještě nějaké otevřené záložky
		if (vscode.window.visibleTextEditors.length === 0) {
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
		if (this.editorChangeListener) {
			this.editorChangeListener.dispose();
			this.editorChangeListener = null;
		}
	}
}

