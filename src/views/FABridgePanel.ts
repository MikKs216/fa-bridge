import * as vscode from 'vscode';

/**
 * TreeItem pro příkaz v sidebaru
 */
class CommandTreeItem extends vscode.TreeItem {
	constructor(
		public readonly label: string,
		public readonly command: vscode.Command,
		public readonly iconPath: vscode.ThemeIcon,
		public readonly tooltip: string
	) {
		super(label, vscode.TreeItemCollapsibleState.None);
		this.command = command;
		this.iconPath = iconPath;
		this.tooltip = tooltip;
	}
}

/**
 * Provider pro TreeView s příkazy FA Bridge
 */
export class FABridgeTreeProvider implements vscode.TreeDataProvider<CommandTreeItem> {
	private _onDidChangeTreeData: vscode.EventEmitter<CommandTreeItem | undefined | null | void> = 
		new vscode.EventEmitter<CommandTreeItem | undefined | null | void>();
	readonly onDidChangeTreeData: vscode.Event<CommandTreeItem | undefined | null | void> = 
		this._onDidChangeTreeData.event;

	refresh(): void {
		this._onDidChangeTreeData.fire();
	}

	getTreeItem(element: CommandTreeItem): vscode.TreeItem {
		return element;
	}

	getChildren(element?: CommandTreeItem): Thenable<CommandTreeItem[]> {
		if (element) {
			return Promise.resolve([]);
		}

		// Hlavní příkazy
		const commands: CommandTreeItem[] = [
			new CommandTreeItem(
				'Uložit soubor (Ctrl+S)',
				{
					command: 'workbench.action.files.save',
					title: 'Uložit soubor',
				},
				new vscode.ThemeIcon('save'),
				'Uloží aktuální soubor'
			),
		new CommandTreeItem(
			'Aktivovat FA (Alt+Q)',
			{
				command: 'workbench.action.files.save',
				title: 'Uložit soubor',
			},
			new vscode.ThemeIcon('save'),
			'Uloží aktuální soubor (jako Ctrl+S)'
		),
		new CommandTreeItem(
				'Vložit název údaje (Shift+Alt+V)',
				{
					command: 'faBridge.vlozitNazevUdaje',
					title: 'Vložit název údaje',
				},
				new vscode.ThemeIcon('pencil'),
				'Vloží název aktuálního údaje na pozici kurzoru'
			),
			new CommandTreeItem(
				'Název údaje do clibboardu (Shift+Alt+C)',
				{
					command: 'faBridge.kopirovatNazevUdaje',
					title: 'Kopírovat název údaje',
				},
				new vscode.ThemeIcon('clippy'),
				'Zkopíruje název údaje do schránky'
			),
			new CommandTreeItem(
				'Najít údaj ve formuláři (Shift+Alt+L)',
				{
					command: 'faBridge.najitUdaj',
					title: 'Najít údaj ve formuláři',
				},
				new vscode.ThemeIcon('search'),
				'Najde údaj podle slova pod kurzorem'
			),
		];

		return Promise.resolve(commands);
	}
}

/**
 * Registruje FA Bridge panel v sidebaru
 */
export function registerFABridgePanel(context: vscode.ExtensionContext): void {
	const treeProvider = new FABridgeTreeProvider();
	
	const treeView = vscode.window.createTreeView('faBridgePanel', {
		treeDataProvider: treeProvider,
		showCollapseAll: false,
	});

	context.subscriptions.push(treeView);
}

