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

		// Načti konfiguraci pro FA kompatibilní hotkeys
		const config = vscode.workspace.getConfiguration('faBridge');
		const faCompatibleHotkeys = config.get<boolean>('faCompatibleHotkeys', false);

		// Urči správné zkratky podle nastavení
		const activateFAShortcut = faCompatibleHotkeys ? 'Ctrl+Q' : 'Alt+Q';
		const copyShortcut = faCompatibleHotkeys ? 'Shift+Ctrl+C' : 'Shift+Alt+C';
		const findShortcut = 'Shift+Alt+L'; // Vždy Shift+Alt+L (bez ohledu na nastavení)
		const searchShortcut = faCompatibleHotkeys ? 'Shift+Ctrl+F' : 'Shift+Alt+F';

		// Root level - vrať kategorie
		const faCommands: CommandTreeItem[] = [
			new CommandTreeItem(
				'Uložit soubor (F2)',
				{
					command: 'faBridge.ulozitSoubor',
					title: 'Uložit soubor',
				},
				new vscode.ThemeIcon('save'),
				'Uloží aktuální soubor (triggeruje Local History)'
			),
			new CommandTreeItem(
				`Přepnout do FA (F1, ${activateFAShortcut})`,
				{
					command: 'faBridge.faDoPopredi',
					title: 'Přepnout do FA',
				},
				new vscode.ThemeIcon('window'),
				'Aktivuje okno FORM asistenta'
			),
		new CommandTreeItem(
				'Vložit název údaje (Alt+X, Ctrl+Shift+V)',
				{
					command: 'faBridge.vlozitNazevUdaje',
					title: 'Vložit název údaje',
				},
				new vscode.ThemeIcon('pencil'),
				'Vloží název aktuálního údaje na pozici kurzoru'
			),
			new CommandTreeItem(
				`Název údaje do clibboardu (${copyShortcut})`,
				{
					command: 'faBridge.kopirovatNazevUdaje',
					title: 'Kopírovat název údaje',
				},
				new vscode.ThemeIcon('clippy'),
				'Zkopíruje název údaje do schránky'
			),
			new CommandTreeItem(
				`Najít údaj ve formuláři (${findShortcut})`,
				{
					command: 'faBridge.najitUdaj',
					title: 'Najít údaj ve formuláři',
				},
				new vscode.ThemeIcon('search'),
				'Najde údaj podle slova pod kurzorem'
			),
			new CommandTreeItem(
				`Hledat podle akt. údaje (${searchShortcut})`,
				{
					command: 'faBridge.hledatPodleAktUdaje',
					title: 'Hledat podle akt. údaje',
				},
				new vscode.ThemeIcon('search'),
				'Otevře Find dialog s názvem aktuálního údaje z FA'
			),
			new CommandTreeItem(
				'Hledat od začátku (Alt+L)',
				{
					command: 'faBridge.hledatOdZacatku',
					title: 'Hledat od začátku',
				},
				new vscode.ThemeIcon('search'),
				'Otevře Find dialog, přesune kurzor na začátek dokumentu a znovu otevře Find dialog'
			),
			new CommandTreeItem(
				'Toggle msgv (Alt+F9)',
				{
					command: 'faBridge.toggleMsgv',
					title: 'Toggle msgv',
				},
				new vscode.ThemeIcon('bookmark'),
				'Vloží msgv(\'\') nebo smaže řádek s msgv('
			),
			new CommandTreeItem(
				'Toggle field (Alt+A)',
				{
					command: 'faBridge.toggleField',
					title: 'Toggle field',
				},
				new vscode.ThemeIcon('git-compare'),
				'Mění formát: \'slovo\' → [:slovo:] → [.slovo.] → \'slovo\''
			),
			new CommandTreeItem(
				'Vložit [.udaj.] (Shift+Ctrl+[)',
				{
					command: 'faBridge.vlozitUdajSBody',
					title: 'Vložit [.udaj.]',
				},
				new vscode.ThemeIcon('symbol-array'),
				'Vloží údaj z FA ve formátu [.názevÚdaje.]'
			),
			new CommandTreeItem(
				'Vložit [:udaj:] (Shift+Ctrl+])',
				{
					command: 'faBridge.vlozitUdajSDvojteckami',
					title: 'Vložit [:udaj:]',
				},
				new vscode.ThemeIcon('symbol-array'),
				'Vloží údaj z FA ve formátu [:názevÚdaje:]'
			),
		];

		// Vytvoř kategorie
		const categories = [
			new CategoryTreeItem('FA Příkazy', 'Příkazy pro práci s FA', faCommands),
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

	// Aktualizuj panel při prvním načtení (pro zajištění správného zobrazení hotkeys)
	treeProvider.refresh();

	// Sleduj změny konfigurace a aktualizuj panel
	const configDisposable = vscode.workspace.onDidChangeConfiguration((e) => {
		if (e.affectsConfiguration('faBridge.faCompatibleHotkeys')) {
			treeProvider.refresh();
		}
	});

	context.subscriptions.push(treeView, configDisposable);
}

