import * as vscode from 'vscode';

/**
 * TreeItem pro kategorii příkazů (rozbalitelná sekce)
 */
class CategoryTreeItem extends vscode.TreeItem {
	constructor(
		public readonly label: string,
		public readonly tooltip: string,
		public readonly children: CommandTreeItem[]
	) {
		super(label, vscode.TreeItemCollapsibleState.Expanded);
		this.tooltip = tooltip;
		this.iconPath = new vscode.ThemeIcon('folder');
	}
}

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
export class FABridgeTreeProvider implements vscode.TreeDataProvider<CategoryTreeItem | CommandTreeItem> {
	private _onDidChangeTreeData: vscode.EventEmitter<CategoryTreeItem | CommandTreeItem | undefined | null | void> = 
		new vscode.EventEmitter<CategoryTreeItem | CommandTreeItem | undefined | null | void>();
	readonly onDidChangeTreeData: vscode.Event<CategoryTreeItem | CommandTreeItem | undefined | null | void> = 
		this._onDidChangeTreeData.event;

	refresh(): void {
		this._onDidChangeTreeData.fire();
	}

	getTreeItem(element: CategoryTreeItem | CommandTreeItem): vscode.TreeItem {
		return element;
	}

	getChildren(element?: CategoryTreeItem | CommandTreeItem): Thenable<(CategoryTreeItem | CommandTreeItem)[]> {
		// Pokud je element kategorie, vrať její děti
		if (element instanceof CategoryTreeItem) {
			return Promise.resolve(element.children);
		}
		
		// Pokud je element příkaz, nemá děti
		if (element instanceof CommandTreeItem) {
			return Promise.resolve([]);
		}

		// Root level - vrať kategorie
		const faCommands: CommandTreeItem[] = [
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

		// Návrh příkazy
		const navrhCommands: CommandTreeItem[] = [
			new CommandTreeItem(
				'Provést Init (Shift+Alt+I)',
				{
					command: 'faBridge.provestInit',
					title: 'Provést Init',
				},
				new vscode.ThemeIcon('symbol-method'),
				'Spustí funkci Init v návrhu formuláře'
			),
			new CommandTreeItem(
				'Provést Calculate (Shift+Alt+E)',
				{
					command: 'faBridge.provestCalculate',
					title: 'Provést Calculate',
				},
				new vscode.ThemeIcon('refresh'),
				'Spustí funkci Calculate v návrhu formuláře'
			),
			new CommandTreeItem(
				'Provést Enable (Shift+Alt+N)',
				{
					command: 'faBridge.provestEnable',
					title: 'Provést Enable',
				},
				new vscode.ThemeIcon('check'),
				'Spustí funkci Enable v návrhu formuláře'
			),
			new CommandTreeItem(
				'Zobrazit Info (Shift+Alt+B)',
				{
					command: 'faBridge.zobrazitInfo',
					title: 'Zobrazit Info',
				},
				new vscode.ThemeIcon('info'),
				'Zobrazí informace o formuláři'
			),
			new CommandTreeItem(
				'Zobrazit Platební informace (Shift+Alt+P)',
				{
					command: 'faBridge.zobrazitPlatebniInformace',
					title: 'Zobrazit Platební informace',
				},
				new vscode.ThemeIcon('credit-card'),
				'Zobrazí platební informace'
			),
			new CommandTreeItem(
				'Zobrazit Period (Shift+Alt+R)',
				{
					command: 'faBridge.zobrazitPeriod',
					title: 'Zobrazit Period',
				},
				new vscode.ThemeIcon('calendar'),
				'Zobrazí aktuální období'
			),
		];

		// Vytvoř kategorie
		const categories = [
			new CategoryTreeItem('FA Příkazy', 'Příkazy pro práci s FA', faCommands),
			new CategoryTreeItem('Návrh Příkazy', 'Příkazy pro testování návrhu formuláře', navrhCommands),
		];

		return Promise.resolve(categories);
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

