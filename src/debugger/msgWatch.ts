import * as vscode from 'vscode';
import * as fs from 'fs';
import * as path from 'path';

/**
 * Interface pro data z famsgstate.json
 */
interface MsgWatchState {
	message?: string;
	variables?: { [key: string]: string };
	mtValuesRow?: { [key: string]: string };
}

/**
 * TreeItem pro watch window
 */
class MsgWatchTreeItem extends vscode.TreeItem {
	constructor(
		public readonly label: string,
		public readonly description: string,
		public readonly collapsibleState: vscode.TreeItemCollapsibleState = vscode.TreeItemCollapsibleState.None
	) {
		super(label, collapsibleState);
		this.tooltip = description ? `${label}: ${description}` : label;
	}
}

/**
 * Provider pro TreeView s watch window daty z Msg volání
 */
export class MsgWatchProvider implements vscode.TreeDataProvider<MsgWatchTreeItem> {
	private _onDidChangeTreeData: vscode.EventEmitter<MsgWatchTreeItem | undefined | null | void> =
		new vscode.EventEmitter<MsgWatchTreeItem | undefined | null | void>();
	readonly onDidChangeTreeData: vscode.Event<MsgWatchTreeItem | undefined | null | void> =
		this._onDidChangeTreeData.event;

	private fsbridgePath: string;
	private fileWatcher: fs.FSWatcher | null = null;
	private outputChannel: vscode.OutputChannel | null;

	constructor(fsbridgePath: string, outputChannel: vscode.OutputChannel | null = null) {
		this.fsbridgePath = fsbridgePath;
		this.outputChannel = outputChannel;
		this.startWatching();
	}

	/**
	 * Spustit sledování souboru famsgstate.json
	 */
	private startWatching(): void {
		if (!this.fsbridgePath || this.fsbridgePath === '') {
			this.log('[MsgWatch] WARNING: fsbridgePath není nastaven. Panel nebude fungovat.');
			return;
		}

		const statePath = path.join(this.fsbridgePath, 'famsgstate.json');
		const fsbridgeDir = path.dirname(statePath);

		this.log('[MsgWatch] Watching file: ' + statePath);
		this.log('[MsgWatch] fsbridgeDir exists: ' + fs.existsSync(fsbridgeDir));

		// Sleduj změny v souboru
		if (fs.existsSync(fsbridgeDir)) {
			this.fileWatcher = fs.watch(fsbridgeDir, (eventType, filename) => {
				if (filename === 'famsgstate.json' || filename === 'famsgstate.json.tmp') {
					this.log('[MsgWatch] File changed: ' + filename);
					// Debounce update
					setTimeout(() => {
						this.refresh();
					}, 100);
				}
			});
		} else {
			this.log('[MsgWatch] WARNING: Directory does not exist: ' + fsbridgeDir);
		}
	}

	private log(message: string): void {
		if (this.outputChannel) {
			this.outputChannel.appendLine(message);
		}
		console.log(message);
	}

	refresh(): void {
		this._onDidChangeTreeData.fire();
	}

	getTreeItem(element: MsgWatchTreeItem): vscode.TreeItem {
		return element;
	}

	getChildren(element?: MsgWatchTreeItem): Thenable<MsgWatchTreeItem[]> {
		if (element) {
			// Pokud je element objekt (variables nebo mtValuesRow), zobraz jeho vlastnosti
			if (element.collapsibleState === vscode.TreeItemCollapsibleState.Expanded) {
				return Promise.resolve(this.expandObject(element));
			}
			return Promise.resolve([]);
		}

		// Root level - načti a zobraz data z famsgstate.json
		return Promise.resolve(this.loadMsgState());
	}

	/**
	 * Načti data z famsgstate.json
	 */
	private loadMsgState(): MsgWatchTreeItem[] {
		if (!this.fsbridgePath || this.fsbridgePath === '') {
			return [
				new MsgWatchTreeItem(
					'Chybí konfigurace',
					'Nastavte faBridge.fsbridgePath v nastavení Cursoru',
					vscode.TreeItemCollapsibleState.None
				)
			];
		}

		const statePath = path.join(this.fsbridgePath, 'famsgstate.json');

		this.log('[MsgWatch] Loading state from: ' + statePath);
		this.log('[MsgWatch] File exists: ' + fs.existsSync(statePath));

		if (!fs.existsSync(statePath)) {
			return [
				new MsgWatchTreeItem(
					'Žádná data',
					'Zavolejte Msg() ve skriptu pro zobrazení dat',
					vscode.TreeItemCollapsibleState.None
				)
			];
		}

		try {
			// Přečti soubor s podporou UTF-8 BOM
			let content = fs.readFileSync(statePath, 'utf8');
			if (content.charCodeAt(0) === 0xFEFF) {
				content = content.slice(1); // Odstraň BOM
			}

			const state: MsgWatchState = JSON.parse(content);
			const items: MsgWatchTreeItem[] = [];

			// Zpráva
			if (state.message) {
				items.push(
					new MsgWatchTreeItem(
						'Zpráva',
						state.message,
						vscode.TreeItemCollapsibleState.None
					)
				);
			}

			// Proměnné
			if (state.variables && Object.keys(state.variables).length > 0) {
				items.push(
					new MsgWatchTreeItem(
						'Proměnné',
						`${Object.keys(state.variables).length} proměnných`,
						vscode.TreeItemCollapsibleState.Expanded
					)
				);
			}

			// mtValues aktuální řádek
			if (state.mtValuesRow && Object.keys(state.mtValuesRow).length > 0) {
				items.push(
					new MsgWatchTreeItem(
						'mtValues (aktuální řádek)',
						`${Object.keys(state.mtValuesRow).length} polí`,
						vscode.TreeItemCollapsibleState.Expanded
					)
				);
			}

			if (items.length === 0) {
				items.push(
					new MsgWatchTreeItem(
						'Prázdná data',
						'Famsgstate.json je prázdný',
						vscode.TreeItemCollapsibleState.None
					)
				);
			}

			return items;
		} catch (error) {
			const errorMsg = `[MsgWatch] Chyba při načítání famsgstate.json: ${error}`;
			this.log(errorMsg);
			console.error(errorMsg);
			return [
				new MsgWatchTreeItem(
					'Chyba při načítání',
					`${error}`,
					vscode.TreeItemCollapsibleState.None
				)
			];
		}
	}

	/**
	 * Rozbal objekt (variables nebo mtValuesRow) a zobraz jeho vlastnosti
	 */
	private expandObject(parent: MsgWatchTreeItem): MsgWatchTreeItem[] {
		const statePath = path.join(this.fsbridgePath, 'famsgstate.json');

		if (!fs.existsSync(statePath)) {
			return [];
		}

		try {
			let content = fs.readFileSync(statePath, 'utf8');
			if (content.charCodeAt(0) === 0xFEFF) {
				content = content.slice(1);
			}

			const state: MsgWatchState = JSON.parse(content);
			const items: MsgWatchTreeItem[] = [];

			if (parent.label === 'Proměnné' && state.variables) {
				const sortedVars = Object.keys(state.variables).sort();
				for (const varName of sortedVars) {
					const varValue = state.variables[varName];
					items.push(
						new MsgWatchTreeItem(
							varName,
							varValue,
							vscode.TreeItemCollapsibleState.None
						)
					);
				}
			} else if (parent.label === 'mtValues (aktuální řádek)' && state.mtValuesRow) {
				const sortedFields = Object.keys(state.mtValuesRow).sort();
				for (const fieldName of sortedFields) {
					const fieldValue = state.mtValuesRow[fieldName];
					items.push(
						new MsgWatchTreeItem(
							fieldName,
							fieldValue,
							vscode.TreeItemCollapsibleState.None
						)
					);
				}
			}

			return items;
		} catch (error) {
			const errorMsg = `[MsgWatch] Chyba při rozbalování objektu: ${error}`;
			this.log(errorMsg);
			console.error(errorMsg);
			return [];
		}
	}

	/**
	 * Dispose resources
	 */
	dispose(): void {
		if (this.fileWatcher) {
			this.fileWatcher.close();
			this.fileWatcher = null;
		}
	}
}

/**
 * Registruje Msg Watch panel v sidebaru
 */
export function registerMsgWatchPanel(
	context: vscode.ExtensionContext,
	fsbridgePath: string,
	outputChannel: vscode.OutputChannel | null = null
): void {
	const logMsg = `[MsgWatch] Registering panel with fsbridgePath: ${fsbridgePath}`;
	if (outputChannel) {
		outputChannel.appendLine(logMsg);
	}
	console.log(logMsg);
	
	const treeProvider = new MsgWatchProvider(fsbridgePath, outputChannel);

	const treeView = vscode.window.createTreeView('faBridgeMsgWatch', {
		treeDataProvider: treeProvider,
		showCollapseAll: false,
	});

	const treeViewMsg = '[MsgWatch] TreeView created';
	if (outputChannel) {
		outputChannel.appendLine(treeViewMsg);
	}
	console.log(treeViewMsg);

	// Refresh command
	const refreshCommand = vscode.commands.registerCommand('faBridge.msgWatch.refresh', () => {
		const refreshMsg = '[MsgWatch] Refresh command called';
		if (outputChannel) {
			outputChannel.appendLine(refreshMsg);
		}
		console.log(refreshMsg);
		treeProvider.refresh();
	});

	context.subscriptions.push(treeView, refreshCommand, {
		dispose: () => {
			treeProvider.dispose();
		}
	});
	
	const successMsg = '[MsgWatch] Panel registered successfully';
	if (outputChannel) {
		outputChannel.appendLine(successMsg);
	}
	console.log(successMsg);
}



