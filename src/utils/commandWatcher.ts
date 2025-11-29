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

		const facmdPath = path.join(instanceDir, 'facmd.txt');
		const facmdDir = path.dirname(facmdPath);

		this.log(`[CommandWatcher] Watching file: ${facmdPath}`);

		// Sleduj změny v instance složce
		if (fs.existsSync(facmdDir)) {
			this.fileWatcher = fs.watch(facmdDir, (eventType, filename) => {
				if (filename === 'facmd.txt' && (eventType === 'rename' || eventType === 'change')) {
					// Malé zpoždění pro zajištění, že soubor je plně zapsán
					setTimeout(() => {
						this.processCommand(facmdPath);
					}, 100);
				}
			});
		} else {
			this.log(`[CommandWatcher] WARNING: Directory does not exist: ${facmdDir} - použiji polling`);
			this.startPolling(workspaceRoot);
		}
	}

	private startPolling(workspaceRoot: string): void {
		// Polling každých 500ms - zkontroluj, jestli se neobjevila instance složka nebo facmd.txt
		this.pollingInterval = setInterval(() => {
			const instanceDir = getFAInstanceDir(workspaceRoot);
			if (instanceDir) {
				// Instance složka se objevila - přepni na file watcher
				this.log('[CommandWatcher] Instance dir nalezena - přepínám na file watcher');
				this.restartWatching();
				return;
			}

			// Zkontroluj všechny možné instance složky a zkus najít facmd.txt
			const fsbridgeDir = path.join(workspaceRoot, '.fsbridge');
			if (fs.existsSync(fsbridgeDir)) {
				try {
					const entries = fs.readdirSync(fsbridgeDir, { withFileTypes: true });
					for (const entry of entries) {
						if (entry.isDirectory() && /^\d+$/.test(entry.name)) {
							const facmdPath = path.join(fsbridgeDir, entry.name, 'facmd.txt');
							if (fs.existsSync(facmdPath)) {
								this.log(`[CommandWatcher] Nalezen facmd.txt v polling módu: ${facmdPath}`);
								this.processCommand(facmdPath);
							}
						}
					}
				} catch (error) {
					// Ignoruj chyby při čtení složky
				}
			}
		}, 500);
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

			// Zpracuj příkaz
			await this.handleCommand(command, facmdPath);

			// Smaž soubor po zpracování
			try {
				fs.unlinkSync(facmdPath);
			} catch (error) {
				this.log(`[CommandWatcher] Chyba při mazání facmd.txt: ${error}`);
			}
		} catch (error) {
			const msg = error instanceof Error ? error.message : String(error);
			this.log(`[CommandWatcher] Chyba při zpracování příkazu: ${msg}`);
		}
	}

	private async handleCommand(command: string, facmdPath: string): Promise<void> {
		if (command === 'check_unsaved_and_close') {
			await this.handleCheckUnsavedAndClose(facmdPath);
		}
		// Zde můžeme přidat další příkazy v budoucnu
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

	public dispose(): void {
		this.stopWatching();
		if (this.editorChangeListener) {
			this.editorChangeListener.dispose();
			this.editorChangeListener = null;
		}
	}
}

