import * as vscode from 'vscode';
import * as fs from 'fs';
import * as path from 'path';

/**
 * TreeItem pro Help panel - zobrazuje obsah z fa-bridge-help.txt
 */
class HelpTreeItem extends vscode.TreeItem {
	constructor(
		public readonly label: string,
		public readonly content: string,
		public readonly collapsibleState: vscode.TreeItemCollapsibleState = vscode.TreeItemCollapsibleState.None
	) {
		super(label, collapsibleState);
		this.tooltip = content;
		// Nezobrazuj description, aby se text nezdvojoval
	}
}

/**
 * Provider pro Help panel - načítá obsah z fa-bridge-help.txt
 */
export class HelpPanelProvider implements vscode.TreeDataProvider<HelpTreeItem> {
	private _onDidChangeTreeData: vscode.EventEmitter<HelpTreeItem | undefined | null | void> = 
		new vscode.EventEmitter<HelpTreeItem | undefined | null | void>();
	readonly onDidChangeTreeData: vscode.Event<HelpTreeItem | undefined | null | void> = 
		this._onDidChangeTreeData.event;

	private helpContent: string = '';
	private helpFilePath: string | null = null;

	constructor(private outputChannel: vscode.OutputChannel | null) {
		this.loadHelpFile();
	}

	/**
	 * Načte obsah help souboru ze složky _source ve workspace
	 */
	private loadHelpFile(): void {
		const workspaceFolders = vscode.workspace.workspaceFolders;
		if (!workspaceFolders || workspaceFolders.length === 0) {
			this.helpContent = 'Workspace není otevřený';
			return;
		}

		// Hledej _source/fa-bridge-help.txt v každém workspace folderu
		for (const folder of workspaceFolders) {
			const helpPath = path.join(folder.uri.fsPath, '_source', 'fa-bridge-help.txt');
			if (fs.existsSync(helpPath)) {
				try {
					this.helpContent = fs.readFileSync(helpPath, 'utf-8');
					this.helpFilePath = helpPath;
					if (this.outputChannel) {
						this.outputChannel.appendLine(`[Help Panel] Načten help soubor: ${helpPath}`);
					}
					return;
				} catch (error) {
					const msg = error instanceof Error ? error.message : String(error);
					this.helpContent = `Chyba při čtení help souboru: ${msg}`;
					if (this.outputChannel) {
						this.outputChannel.appendLine(`[Help Panel] Chyba při čtení: ${msg}`);
					}
					return;
				}
			}
		}

		// Pokud soubor není nalezen
		this.helpContent = 'Soubor _source/fa-bridge-help.txt nebyl nalezen ve workspace';
		if (this.outputChannel) {
			this.outputChannel.appendLine('[Help Panel] Help soubor nebyl nalezen');
		}
	}

	refresh(): void {
		this.loadHelpFile();
		this._onDidChangeTreeData.fire();
	}

	getTreeItem(element: HelpTreeItem): vscode.TreeItem {
		return element;
	}

	getChildren(element?: HelpTreeItem): Thenable<HelpTreeItem[]> {
		if (element) {
			// Element nemá děti
			return Promise.resolve([]);
		}

		// Root level - rozděl obsah na řádky a vytvoř TreeItems
		const lines = this.helpContent.split('\n').filter(line => line.trim().length > 0);
		
		if (lines.length === 0) {
			return Promise.resolve([
				new HelpTreeItem('Žádný obsah', 'Help soubor je prázdný nebo nebyl nalezen')
			]);
		}

		// Vytvoř TreeItems pro každý řádek (bez description, aby se text nezdvojoval)
		const items: HelpTreeItem[] = lines.map((line) => {
			return new HelpTreeItem(
				line.trim(),
				line.trim(),
				vscode.TreeItemCollapsibleState.None
			);
		});

		return Promise.resolve(items);
	}

	/**
	 * Vrátí celý obsah help souboru
	 */
	public getFullContent(): string {
		return this.helpContent;
	}

	/**
	 * Vrátí cestu k help souboru
	 */
	public getHelpFilePath(): string | null {
		return this.helpFilePath;
	}
}

/**
 * Registruje Help panel v sidebaru
 */
export function registerHelpPanel(context: vscode.ExtensionContext, outputChannel: vscode.OutputChannel | null): void {
	const helpProvider = new HelpPanelProvider(outputChannel);
	
	const treeView = vscode.window.createTreeView('faBridgeHelp', {
		treeDataProvider: helpProvider,
		showCollapseAll: false,
	});

	// Přidej command pro refresh
	const refreshCommand = vscode.commands.registerCommand('faBridge.refreshHelp', () => {
		helpProvider.refresh();
	});

	context.subscriptions.push(treeView, refreshCommand);
}


