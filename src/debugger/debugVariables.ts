import * as vscode from 'vscode';
import { SimpleDebugger, DebugState } from './simpleDebugger';

/**
 * TreeItem pro proměnnou v debuggeru
 */
class VariableTreeItem extends vscode.TreeItem {
	constructor(
		public readonly name: string,
		public readonly value: string,
		public readonly collapsibleState: vscode.TreeItemCollapsibleState = vscode.TreeItemCollapsibleState.None
	) {
		super(`${name}: ${value}`, collapsibleState);
		this.tooltip = `${name} = ${value}`;
		this.contextValue = 'variable';
	}
}

/**
 * Provider pro TreeView s debugger proměnnými
 */
export class DebugVariablesProvider implements vscode.TreeDataProvider<VariableTreeItem> {
	private _onDidChangeTreeData: vscode.EventEmitter<VariableTreeItem | undefined | null | void> =
		new vscode.EventEmitter<VariableTreeItem | undefined | null | void>();
	readonly onDidChangeTreeData: vscode.Event<VariableTreeItem | undefined | null | void> =
		this._onDidChangeTreeData.event;

	private faDebugger: SimpleDebugger | null = null;

	setDebugger(faDebugger: SimpleDebugger): void {
		this.faDebugger = faDebugger;
	}

	refresh(): void {
		this._onDidChangeTreeData.fire();
	}

	getTreeItem(element: VariableTreeItem): vscode.TreeItem {
		return element;
	}

	getChildren(element?: VariableTreeItem): Thenable<VariableTreeItem[]> {
		if (element) {
			// Pokud je element objekt, můžeš zde přidat rozbalení vlastností
			return Promise.resolve([]);
		}

		if (!this.faDebugger) {
			return Promise.resolve([
				new VariableTreeItem(
					'Žádný debugger',
					'Spusť debugger pro zobrazení proměnných',
					vscode.TreeItemCollapsibleState.None
				)
			]);
		}

		const state = this.faDebugger.getState();
		if (!state || state.status === 'stopped') {
			return Promise.resolve([
				new VariableTreeItem(
					'Debugger zastaven',
					'Spusť debugger pro zobrazení proměnných',
					vscode.TreeItemCollapsibleState.None
				)
			]);
		}

		const variables = this.faDebugger.getVariables();
		const items: VariableTreeItem[] = [];

		if (Object.keys(variables).length === 0) {
			items.push(
				new VariableTreeItem(
					'Žádné proměnné',
					'Pozastavte debugger na breakpointu pro zobrazení proměnných',
					vscode.TreeItemCollapsibleState.None
				)
			);
		} else {
			// Seřaď proměnné podle názvu
			const sortedVars = Object.keys(variables).sort();
			
			for (const varName of sortedVars) {
				const varValue = variables[varName];
				items.push(new VariableTreeItem(varName, varValue));
			}
		}

		return Promise.resolve(items);
	}
}

/**
 * Registruje debugger variables panel v sidebaru
 */
export function registerDebugVariablesPanel(
	context: vscode.ExtensionContext,
	faDebugger: SimpleDebugger
): void {
	const treeProvider = new DebugVariablesProvider();
	treeProvider.setDebugger(faDebugger);

	const treeView = vscode.window.createTreeView('faBridgeDebugVariables', {
		treeDataProvider: treeProvider,
		showCollapseAll: false,
	});

	// Refresh při změně stavu debuggeru
	const refreshCommand = vscode.commands.registerCommand('faBridge.debugVariables.refresh', () => {
		treeProvider.refresh();
	});

	context.subscriptions.push(treeView, refreshCommand);
}

