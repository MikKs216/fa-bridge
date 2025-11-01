import * as vscode from 'vscode';
import * as fs from 'fs';
import * as path from 'path';

export interface DebugState {
	status: 'stopped' | 'running' | 'paused';
	currentLine?: number;
	breakpoints?: number[];
	variables?: { [key: string]: string };
	callStack?: Array<{ name: string; line: number }>;
}

/**
 * Jednoduchý debugger pro TMS Scripter
 * Komunikuje s FA přes .fsbridge/fadebug.txt a fadebugstate.json
 * POZOR: Používá fixní fsbridgePath (ne workspace!) aby fungoval i pro soubory mimo workspace
 */
export class SimpleDebugger {
	private statusBar: vscode.StatusBarItem;
	private currentState: DebugState | null = null;
	private stateWatcher: fs.FSWatcher | null = null;
	private decorationType: vscode.TextEditorDecorationType | null = null;
	private breakpointDecorationType: vscode.TextEditorDecorationType | null = null;
	private fsbridgePath: string;

	constructor(fsbridgePath: string) {
		this.fsbridgePath = fsbridgePath;
		
		// Vytvoř status bar
		this.statusBar = vscode.window.createStatusBarItem(
			vscode.StatusBarAlignment.Left,
			100
		);
		this.statusBar.command = 'faBridge.debugPanel';
		this.statusBar.tooltip = 'FA Debugger - klikni pro ovládání';

		// Vytvoř decoration pro zvýraznění aktuálního řádku (jemné žluté pozadí)
		this.decorationType = vscode.window.createTextEditorDecorationType({
			backgroundColor: 'rgba(255, 215, 0, 0.2)',
			isWholeLine: true,
			overviewRulerColor: '#FFD700',
			overviewRulerLane: vscode.OverviewRulerLane.Center,
		});

		// Vytvoř decoration pro zobrazení breakpointů v gutteru
		this.breakpointDecorationType = vscode.window.createTextEditorDecorationType({
			gutterIconPath: vscode.Uri.parse('data:image/svg+xml;base64,' + Buffer.from(
				'<svg width="16" height="16" viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg"><circle cx="8" cy="8" r="5" fill="#f14c4c" stroke="#8b0000" stroke-width="1"/></svg>'
			).toString('base64')),
			gutterIconSize: 'contain',
			overviewRulerColor: new vscode.ThemeColor('editorGutter.background'),
			overviewRulerLane: vscode.OverviewRulerLane.Left,
		});
	}

	/**
	 * Zápis debug příkazu do fadebug.txt
	 */
	private async writeDebugCommand(command: string): Promise<void> {
		try {
			const debugPath = path.join(this.fsbridgePath, 'fadebug.txt');
			const fsbridgeDir = this.fsbridgePath;

			// Zajisti že .fsbridge složka existuje
			if (!fs.existsSync(fsbridgeDir)) {
				fs.mkdirSync(fsbridgeDir, { recursive: true });
			}

			// UTF-8 s BOM (EF BB BF)
			const bom = Buffer.from([0xef, 0xbb, 0xbf]);
			const commandBuffer = Buffer.from(command, 'utf-8');
			const content = Buffer.concat([bom, commandBuffer]);

			// Atomický zápis: tmp → rename
			const tmpPath = debugPath + '.tmp';
			fs.writeFileSync(tmpPath, content);
			fs.renameSync(tmpPath, debugPath);

			console.log(`[FA Debugger] Odeslán příkaz: ${command}`);
		} catch (error) {
			const msg = error instanceof Error ? error.message : String(error);
			console.error(`[FA Debugger] Chyba při zápisu příkazu: ${msg}`);
			vscode.window.showErrorMessage(`FA Debugger: Chyba při odesílání příkazu: ${msg}`);
		}
	}

	/**
	 * Pokračovat v běhu (F5)
	 */
	async continue(): Promise<void> {
		await this.writeDebugCommand('DEBUG_CONTINUE');
	}

	/**
	 * Pozastavit běh
	 */
	async pause(): Promise<void> {
		await this.writeDebugCommand('DEBUG_PAUSE');
	}

	/**
	 * Krok přes (F10)
	 */
	async stepOver(): Promise<void> {
		await this.writeDebugCommand('DEBUG_STEP_OVER');
	}

	/**
	 * Zastavit debugování
	 */
	async stop(): Promise<void> {
		await this.writeDebugCommand('DEBUG_STOP');
	}

	/**
	 * Přepnout breakpoint na řádku
	 */
	async toggleBreakpoint(line: number): Promise<void> {
		// Zjisti jestli breakpoint existuje
		if (this.currentState?.breakpoints?.includes(line)) {
			await this.writeDebugCommand(`DEBUG_CLEAR_BREAKPOINT:${line}`);
			// Odstraň z lokálního stavu
			if (this.currentState.breakpoints) {
				const index = this.currentState.breakpoints.indexOf(line);
				if (index > -1) {
					this.currentState.breakpoints.splice(index, 1);
					this.updateBreakpoints();
				}
			}
		} else {
			await this.writeDebugCommand(`DEBUG_SET_BREAKPOINT:${line}`);
			// Přidej do lokálního stavu
			if (!this.currentState) {
				this.currentState = { status: 'stopped', breakpoints: [] };
			}
			if (!this.currentState.breakpoints) {
				this.currentState.breakpoints = [];
			}
			if (!this.currentState.breakpoints.includes(line)) {
				this.currentState.breakpoints.push(line);
				this.updateBreakpoints();
			}
		}
	}

	/**
	 * Nastavit breakpoint
	 */
	async setBreakpoint(line: number): Promise<void> {
		await this.writeDebugCommand(`DEBUG_SET_BREAKPOINT:${line}`);
	}

	/**
	 * Zrušit breakpoint
	 */
	async clearBreakpoint(line: number): Promise<void> {
		await this.writeDebugCommand(`DEBUG_CLEAR_BREAKPOINT:${line}`);
	}

	/**
	 * Požádat o aktualizaci proměnných
	 */
	async requestVariables(): Promise<void> {
		await this.writeDebugCommand('DEBUG_GET_VARIABLES');
	}

	/**
	 * Vyhodnotit výraz/proměnnou
	 */
	async evaluate(expression: string): Promise<void> {
		await this.writeDebugCommand(`DEBUG_EVALUATE:${expression}`);
	}

	/**
	 * Spustit sledování stavu debuggeru
	 */
	startWatching(): void {
		const statePath = path.join(this.fsbridgePath, 'fadebugstate.json');

		// Zajisti že .fsbridge složka existuje
		const fsbridgeDir = this.fsbridgePath;
		if (!fs.existsSync(fsbridgeDir)) {
			fs.mkdirSync(fsbridgeDir, { recursive: true });
		}

		// Sleduj změny souboru
		try {
			this.stateWatcher = fs.watch(statePath, (eventType) => {
				if (eventType === 'change') {
					// Delay pro případ, že soubor se ještě zapisuje
					setTimeout(() => {
						this.updateState();
					}, 100);
				}
			});

			// Inicializuj stav
			this.updateState();

			// Také sleduj vytvoření souboru (pokud ještě neexistuje)
			fs.watch(fsbridgeDir, (eventType, filename) => {
				if (filename === 'fadebugstate.json' && eventType === 'rename') {
					this.updateState();
				}
			});
		} catch (error) {
			console.error('[FA Debugger] Chyba při sledování stavu:', error);
		}
	}

	/**
	 * Aktualizace stavu z fadebugstate.json
	 */
	private updateState(): void {
		try {
			const statePath = path.join(this.fsbridgePath, 'fadebugstate.json');

			if (!fs.existsSync(statePath)) {
				// Pokud soubor neexistuje, ale máme lokální breakpointy, NEVYMAZUJ je
				// (může být soubor ještě nevytvořen nebo FA ještě neposlala stav)
				if (this.currentState?.breakpoints && this.currentState.breakpoints.length > 0) {
					console.log('[FA Debugger] State file not found, but keeping local breakpoints');
					// Pouze aktualizuj status, ale zachovej breakpointy
					if (!this.currentState.status) {
						this.currentState.status = 'stopped';
						this.updateStatusBar();
					}
					return;
				}
				
				// Jinak resetuj stav (první spuštění nebo žádné breakpointy)
				this.currentState = { status: 'stopped' };
				this.updateStatusBar();
				this.clearCurrentLineDecoration();
				this.clearBreakpoints();
				return;
			}

			const content = fs.readFileSync(statePath, 'utf-8');
			
			// Odstraň BOM pokud existuje
			const cleanContent = content.length > 0 && content.charCodeAt(0) === 0xFEFF ? content.slice(1) : content;
			
			if (cleanContent.trim() === '') {
				// Pokud soubor je prázdný, ale máme lokální breakpointy, NEVYMAZUJ je
				if (this.currentState?.breakpoints && this.currentState.breakpoints.length > 0) {
					console.log('[FA Debugger] State file is empty, but keeping local breakpoints');
					// Pouze aktualizuj status, ale zachovej breakpointy
					if (!this.currentState.status) {
						this.currentState.status = 'stopped';
						this.updateStatusBar();
					}
					return;
				}
				
				// Jinak resetuj stav
				this.currentState = { status: 'stopped' };
				this.updateStatusBar();
				this.clearCurrentLineDecoration();
				this.clearBreakpoints();
				return;
			}
			
			const parsedState = JSON.parse(cleanContent.trim()) as DebugState;
			
			// DŮLEŽITÉ: Pokud FA posílá prázdný seznam breakpointů, ale máme lokální breakpointy,
			// ponecháme lokální breakpointy (FA ještě nemusí mít skript načten)
			if (parsedState.breakpoints && parsedState.breakpoints.length === 0 && 
			    this.currentState?.breakpoints && this.currentState.breakpoints.length > 0) {
				console.log('[FA Debugger] FA sent empty breakpoints, but keeping local breakpoints');
				// Pouze aktualizuj status a currentLine, ale zachovej lokální breakpointy
				this.currentState.status = parsedState.status;
				this.currentState.currentLine = parsedState.currentLine;
				this.updateStatusBar();
				this.highlightCurrentLine();
				// NEOBŘÍVEJ updateBreakpoints() - zachovej lokální breakpointy
				return;
			}
			
			// Aktualizuj celý stav (včetně breakpointů)
			this.currentState = parsedState;

			// Aktualizuj UI
			this.updateStatusBar();
			this.highlightCurrentLine();
			this.updateBreakpoints();

			// Informuj o změně stavu
			vscode.commands.executeCommand('faBridge.debugVariables.refresh');
		} catch (error) {
			// Soubor může být prázdný nebo nevalidní JSON - ignoruj
			if (fs.existsSync(path.join(this.fsbridgePath, 'fadebugstate.json'))) {
				console.log('[FA Debugger] Chyba při čtení stavu (možná nevalidní JSON):', error);
			}
		}
	}

	/**
	 * Aktualizace status baru
	 */
	private updateStatusBar(): void {
		const status = this.currentState?.status || 'stopped';
		const line = this.currentState?.currentLine || 0;

		let text = '';

		switch (status) {
			case 'running':
				text = `$(debug-continue) Debug: běží`;
				break;
			case 'paused':
				text = `$(debug-pause) Debug: pozastaveno`;
				if (line > 0) {
					text += ` (řádek ${line})`;
				}
				break;
			default:
				text = `$(debug-stackframe) Debug: zastaveno`;
		}

		this.statusBar.text = text;
		this.statusBar.show();
	}

	/**
	 * Zvýraznění aktuálního řádku v editoru
	 */
	private highlightCurrentLine(): void {
		const line = this.currentState?.currentLine;
		this.clearCurrentLineDecoration();
		
		const editor = vscode.window.activeTextEditor;
		if (!editor || !line || line <= 0) {
			return;
		}

		// FA posílá 0-based čísla řádků (stejně jako VS Code), použij přímo
		const lineNumber = line;
		
		if (lineNumber < 0 || lineNumber >= editor.document.lineCount) {
			console.error(`[FA Debugger] Invalid line: ${line} (max: ${editor.document.lineCount})`);
			return;
		}
		
		// Použij lineAt() pro přesný range jednoho řádku
		const lineRange = editor.document.lineAt(lineNumber).range;
		const position = new vscode.Position(lineNumber, 0);

		// Nastav decoration (žluté pozadí na správném řádku)
		editor.setDecorations(this.decorationType!, [lineRange]);

		// Skoč na řádek pokud je pozastaveno
		if (this.currentState?.status === 'paused') {
			editor.selection = new vscode.Selection(position, position);
			editor.revealRange(
				lineRange,
				vscode.TextEditorRevealType.InCenter
			);
		}
	}

	/**
	 * Odstranění zvýraznění aktuálního řádku
	 */
	private clearCurrentLineDecoration(): void {
		if (!this.decorationType) {
			return;
		}

		const editor = vscode.window.activeTextEditor;
		if (editor) {
			editor.setDecorations(this.decorationType!, []);
		}
	}

	/**
	 * Získat aktuální stav
	 */
	getState(): DebugState | null {
		return this.currentState;
	}

	/**
	 * Získat seznam breakpointů
	 */
	getBreakpoints(): number[] {
		return this.currentState?.breakpoints || [];
	}

	/**
	 * Získat proměnné
	 */
	getVariables(): { [key: string]: string } {
		return this.currentState?.variables || {};
	}

	/**
	 * Aktualizace zobrazení breakpointů v gutteru
	 */
	private updateBreakpoints(): void {
		const breakpoints = this.currentState?.breakpoints || [];
		if (!breakpoints.length || !this.breakpointDecorationType) {
			this.clearBreakpoints();
			return;
		}

		const editor = vscode.window.activeTextEditor;
		if (!editor) {
			return;
		}

		// Vytvoř range pro každý breakpoint
		const ranges: vscode.Range[] = [];
		for (const line of breakpoints) {
			// VS Code používá 0-based indexy, FA posílá 1-based
			const lineNumber = line - 1;
			if (lineNumber >= 0 && lineNumber < editor.document.lineCount) {
				const position = new vscode.Position(lineNumber, 0);
				const range = new vscode.Range(position, position);
				ranges.push(range);
			}
		}

		// Nastav decoration
		editor.setDecorations(this.breakpointDecorationType, ranges);
	}

	/**
	 * Odstranění zobrazení breakpointů
	 */
	private clearBreakpoints(): void {
		if (!this.breakpointDecorationType) {
			return;
		}

		const editor = vscode.window.activeTextEditor;
		if (editor) {
			editor.setDecorations(this.breakpointDecorationType, []);
		}
	}

	/**
	 * Dispose resources
	 */
	dispose(): void {
		this.statusBar.dispose();
		this.stateWatcher?.close();
		this.clearCurrentLineDecoration();
		this.clearBreakpoints();
		this.decorationType?.dispose();
		this.breakpointDecorationType?.dispose();
	}
}

