import * as vscode from 'vscode';
import * as fs from 'fs';
import * as path from 'path';

/**
 * Tree item pro zobrazení stavu komunikace
 */
class CommunicationStatusTreeItem extends vscode.TreeItem {
	constructor(
		public readonly label: string,
		public readonly description: string,
		public readonly collapsibleState: vscode.TreeItemCollapsibleState,
		public readonly tooltip?: string
	) {
		super(label, collapsibleState);
		this.description = description;
		this.tooltip = tooltip || `${label}: ${description}`;
	}
}

/**
 * Provider pro zobrazení stavu komunikace mezi Cursor a FA
 */
export class CommunicationStatusProvider implements vscode.TreeDataProvider<CommunicationStatusTreeItem> {
	private _onDidChangeTreeData: vscode.EventEmitter<CommunicationStatusTreeItem | undefined | null | void> =
		new vscode.EventEmitter<CommunicationStatusTreeItem | undefined | null | void>();
	readonly onDidChangeTreeData: vscode.Event<CommunicationStatusTreeItem | undefined | null | void> =
		this._onDidChangeTreeData.event;

	private fsbridgePath: string;
	private outputChannel: vscode.OutputChannel | null;

	constructor(fsbridgePath: string, outputChannel: vscode.OutputChannel | null = null) {
		this.fsbridgePath = fsbridgePath;
		this.outputChannel = outputChannel;
		
		// Aktualizuj každých 2 sekundy
		setInterval(() => {
			this.refresh();
		}, 2000);
	}

	refresh(): void {
		this._onDidChangeTreeData.fire();
	}

	getTreeItem(element: CommunicationStatusTreeItem): vscode.TreeItem {
		return element;
	}

	getChildren(element?: CommunicationStatusTreeItem): Thenable<CommunicationStatusTreeItem[]> {
		if (element) {
			// Pokud je element rozbalitelný, vrať jeho děti
			return Promise.resolve(this.getChildItems(element));
		} else {
			// Kořenové položky
			return Promise.resolve(this.getRootItems());
		}
	}

	private getRootItems(): CommunicationStatusTreeItem[] {
		const items: CommunicationStatusTreeItem[] = [];

		if (!this.fsbridgePath || this.fsbridgePath === '') {
			items.push(
				new CommunicationStatusTreeItem(
					'⚠️ Konfigurace',
					'fsbridgePath není nastaveno',
					vscode.TreeItemCollapsibleState.None,
					'Nastavte faBridge.fsbridgePath v nastavení Cursoru'
				)
			);
			return items;
		}

		// Kontrola existence .fsbridge složky
		const fsbridgeDirExists = fs.existsSync(this.fsbridgePath);
		items.push(
			new CommunicationStatusTreeItem(
				fsbridgeDirExists ? '✅ .fsbridge' : '❌ .fsbridge',
				fsbridgeDirExists ? 'Existuje' : 'Neexistuje',
				vscode.TreeItemCollapsibleState.None,
				`Cesta: ${this.fsbridgePath}`
			)
		);

		// Kontrola facmd.txt (příkazy do FA)
		const facmdPath = path.join(this.fsbridgePath, 'facmd.txt');
		const facmdExists = fs.existsSync(facmdPath);
		let facmdInfo = facmdExists ? 'Existuje' : 'Neexistuje';
		if (facmdExists) {
			try {
				const stats = fs.statSync(facmdPath);
				const lastModified = stats.mtime;
				const now = new Date();
				const ageSeconds = Math.floor((now.getTime() - lastModified.getTime()) / 1000);
				facmdInfo += ` (${ageSeconds}s)`;
			} catch (error) {
				facmdInfo = `Chyba: ${error}`;
			}
		}
		items.push(
			new CommunicationStatusTreeItem(
				facmdExists ? '📝 facmd.txt' : '⚪ facmd.txt',
				facmdInfo,
				vscode.TreeItemCollapsibleState.None,
				`Příkazy do FA: ${facmdPath}`
			)
		);

		// Kontrola famsgstate.json
		const msgStatePath = path.join(this.fsbridgePath, 'famsgstate.json');
		const msgStateExists = fs.existsSync(msgStatePath);
		let msgStateInfo = msgStateExists ? 'Existuje' : 'Neexistuje';
		if (msgStateExists) {
			try {
				const stats = fs.statSync(msgStatePath);
				const lastModified = stats.mtime;
				const now = new Date();
				const ageSeconds = Math.floor((now.getTime() - lastModified.getTime()) / 1000);
				msgStateInfo += ` (${ageSeconds}s)`;
			} catch (error) {
				msgStateInfo = `Chyba: ${error}`;
			}
		}
		items.push(
			new CommunicationStatusTreeItem(
				msgStateExists ? '📄 famsgstate.json' : '⚪ famsgstate.json',
				msgStateInfo,
				vscode.TreeItemCollapsibleState.None,
				`Msg Watch data: ${msgStatePath}`
			)
		);

		// Kontrola fadebug.txt
		const debugCommandPath = path.join(this.fsbridgePath, 'fadebug.txt');
		const debugCommandExists = fs.existsSync(debugCommandPath);
		let debugInfo = debugCommandExists ? 'Existuje' : 'Neexistuje';
		if (debugCommandExists) {
			try {
				const stats = fs.statSync(debugCommandPath);
				const lastModified = stats.mtime;
				const now = new Date();
				const ageSeconds = Math.floor((now.getTime() - lastModified.getTime()) / 1000);
				debugInfo += ` (${ageSeconds}s)`;
			} catch (error) {
				debugInfo = `Chyba: ${error}`;
			}
		}
		items.push(
			new CommunicationStatusTreeItem(
				debugCommandExists ? '📝 fadebug.txt' : '⚪ fadebug.txt',
				debugInfo,
				vscode.TreeItemCollapsibleState.None,
				`Cesta: ${debugCommandPath}`
			)
		);

		// Omezení na přesně 4 položky pro kompaktní zobrazení
		return items.slice(0, 4);
	}

	private getChildItems(element: CommunicationStatusTreeItem): CommunicationStatusTreeItem[] {
		// Prozatím žádné podpoložky
		return [];
	}
}

/**
 * Registruje Communication Status panel v sidebaru
 */
export function registerCommunicationStatusPanel(
	context: vscode.ExtensionContext,
	fsbridgePath: string | null,
	outputChannel: vscode.OutputChannel | null = null
): void {
	const logMsg = `[CommunicationStatus] Registering panel with fsbridgePath: ${fsbridgePath || '(není nastaveno)'}`;
	if (outputChannel) {
		outputChannel.appendLine(logMsg);
	}
	console.log(logMsg);
	
	const treeProvider = new CommunicationStatusProvider(fsbridgePath || '', outputChannel);

	const treeView = vscode.window.createTreeView('faBridgeCommunicationStatus', {
		treeDataProvider: treeProvider,
		showCollapseAll: false,
		canSelectMany: false,
	});

	const treeViewMsg = '[CommunicationStatus] TreeView created';
	if (outputChannel) {
		outputChannel.appendLine(treeViewMsg);
	}
	console.log(treeViewMsg);

	// Refresh command
	const refreshCommand = vscode.commands.registerCommand('faBridge.communicationStatus.refresh', () => {
		const refreshMsg = '[CommunicationStatus] Refresh command called';
		if (outputChannel) {
			outputChannel.appendLine(refreshMsg);
		}
		console.log(refreshMsg);
		treeProvider.refresh();
	});

	context.subscriptions.push(treeView, refreshCommand, {
		dispose: () => {
			// Cleanup
		}
	});
	
	const successMsg = '[CommunicationStatus] Panel registered successfully';
	if (outputChannel) {
		outputChannel.appendLine(successMsg);
	}
	console.log(successMsg);
}








