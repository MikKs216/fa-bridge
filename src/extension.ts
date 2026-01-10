// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
import * as vscode from 'vscode';
import * as fs from 'fs';
import * as path from 'path';
import {
	ulozitSoubor,
	faDoPopredi,
	vlozitNazevUdaje,
	kopirovatNazevUdaje,
	najitUdaj,
	hledatPodleAktUdaje,
	toggleMsgv,
	toggleField,
	vlozitUdajSBody,
	vlozitUdajSDvojteckami,
	hledatOdZacatku,
	openHelp,
	openTextSearch,
	openFaChm,
} from './commands/sendCommand';
import { getValidInstanceId, getFsBridgeWorkspaceRoot } from './utils/fsBridge';
import { registerFABridgePanel } from './views/FABridgePanel';
import { registerSnippetProvider } from './providers/SnippetProvider';
import { registerMsgWatchPanel } from './debugger/msgWatch';
import { registerHelpPanel } from './views/HelpPanel';
import { registerIntelliSenseProvider, getIntelliSenseProvider } from './providers/PascalIntelliSenseProvider';
import { CommandWatcher } from './utils/commandWatcher';
import { registerBeginEndMatcher } from './providers/BeginEndMatcher';
import { compareWithPreviousVersion, showHistoryVersions, setHistoryRefreshCallback } from './utils/fileHistory';
import { HistoryPanel } from './historyPanel';
import { HistoryProvider, HistoryItem } from './historyProvider';

let outputChannel: vscode.OutputChannel | null = null;

/**
 * Zkontroluje, jestli je cesta worktree složka (Cursor nebo Git)
 */
function isWorktreePath(folderPath: string): boolean {
	return folderPath.includes('.cursor\\worktrees') || 
	       folderPath.includes('.cursor/worktrees') ||
	       folderPath.includes('.git\\worktrees') ||
	       folderPath.includes('.git/worktrees');
}

/**
 * Smaže famsgstate.json pokud existuje
 * Používá vždy .fsbridge složku z workspace, který obsahuje .fsbridge
 */
function deleteFamsgState(outputChannel: vscode.OutputChannel | null): void {
	const workspaceRoot = getFsBridgeWorkspaceRoot();
	if (!workspaceRoot) {
		return;
	}

	const fsbridgeDir = path.join(workspaceRoot, '.fsbridge');
	const statePath = path.join(fsbridgeDir, 'famsgstate.json');
	
	if (fs.existsSync(statePath)) {
		try {
			fs.unlinkSync(statePath);
			if (outputChannel) {
				outputChannel.appendLine(`[FA Bridge] Smazán famsgstate.json: ${statePath}`);
			}
		} catch (error) {
			const msg = error instanceof Error ? error.message : String(error);
			if (outputChannel) {
				outputChannel.appendLine(`[FA Bridge] Chyba při mazání famsgstate.json: ${msg}`);
			}
		}
	}
}

/**
 * Zkontroluje, jestli workspace obsahuje .fsbridge složku nebo soubor
 * DŮLEŽITÉ: Ignoruje worktrees složky
 */
function hasFsBridgeInWorkspace(): boolean {
	const workspaceFolders = vscode.workspace.workspaceFolders;
	if (!workspaceFolders || workspaceFolders.length === 0) {
		return false;
	}

	// Zkontroluj každý workspace folder (ale ignoruj worktrees)
	for (const folder of workspaceFolders) {
		const folderPath = folder.uri.fsPath;
		
		// Ignoruj worktrees složky
		if (isWorktreePath(folderPath)) {
			continue;
		}
		
		const fsbridgePath = path.join(folderPath, '.fsbridge');
		// Zkontroluj jestli existuje jako soubor nebo složka
		if (fs.existsSync(fsbridgePath)) {
			return true;
		}
	}

	return false;
}

export function activate(context: vscode.ExtensionContext) {
	// ============================================================================
	// KÓD PRO PANEL HISTORIE - registruje se vždy (nezávisle na .fsbridge)
	// ============================================================================
	
	// Zkontroluj, zda je historie zapnutá
	const historyConfig = vscode.workspace.getConfiguration();
	const historyEnabled = historyConfig.get<boolean>('local-history.enabled', true);

	// Sleduj změny nastavení a aktualizuj panel
	const updatePanelVisibility = () => {
		const enabled = historyConfig.get<boolean>('local-history.enabled', true);
		if (!enabled && HistoryPanel.currentPanel) {
			HistoryPanel.currentPanel.dispose();
		}
	};

	// Globální reference na HistoryProvider pro refresh po uložení historie
	let historyProviderInstance: HistoryProvider | null = null;

	if (historyEnabled) {
		// Vytvoř provider pro historii
		historyProviderInstance = new HistoryProvider(context);
		const historyProvider = historyProviderInstance;

		// Registruj příkazy
		const showDiffCommand = vscode.commands.registerCommand('faHistory.showDiff', 
			async (filePath: string, commitIndex: number, patchIndex: number) => {
				// filePath je cesta k souboru v .history složce
				const historyDir = path.dirname(filePath);
				const sourceFile = path.join(path.dirname(historyDir), path.basename(filePath).replace(/-\d{8}-\d{6}\./, '.'));
				
				await HistoryPanel.showDiffStatic(filePath, sourceFile);
			}
		);

		const restoreFileCommand = vscode.commands.registerCommand('faHistory.restoreFile',
			async (item?: vscode.TreeItem | HistoryItem, ...args: any[]) => {
				// VS Code předává TreeItem jako první argument z context menu
				// Nebo můžeme získat argumenty z TreeItem.command.arguments
				let filePath: string | undefined;
				
				if (item) {
					// Zkus získat z TreeItem
					if (item instanceof HistoryItem) {
						filePath = item.filePath;
					} else if ('filePath' in item && typeof (item as any).filePath === 'string') {
						filePath = (item as any).filePath;
					} else if (item.command && item.command.arguments && item.command.arguments.length > 0) {
						// Zkus získat z command.arguments
						filePath = item.command.arguments[0];
					}
				}
				
				// Pokud máme argumenty přímo
				if (!filePath && args.length > 0 && typeof args[0] === 'string') {
					filePath = args[0];
				}
				
				if (!filePath) {
					vscode.window.showErrorMessage('Nelze získat cestu k souboru historie. Zkuste kliknout přímo na verzi v panelu.');
					return;
				}
				
				await HistoryPanel.restoreFileStatic(filePath, historyProvider);
			}
		);

		const compareWithPreviousCommand = vscode.commands.registerCommand('faHistory.compareWithPrevious',
			async (item?: vscode.TreeItem | HistoryItem, ...args: any[]) => {
				// VS Code předává TreeItem jako první argument z context menu
				let filePath: string | undefined;
				
				if (item) {
					// Zkus získat z TreeItem
					if (item instanceof HistoryItem) {
						filePath = item.filePath;
					} else if ('filePath' in item && typeof (item as any).filePath === 'string') {
						filePath = (item as any).filePath;
					} else if (item.command && item.command.arguments && item.command.arguments.length > 0) {
						// Zkus získat z command.arguments
						filePath = item.command.arguments[0];
					}
				}
				
				// Pokud máme argumenty přímo
				if (!filePath && args.length > 0 && typeof args[0] === 'string') {
					filePath = args[0];
				}
				
				if (!filePath) {
					vscode.window.showErrorMessage('Nelze získat cestu k souboru historie');
					return;
				}
				
				await HistoryPanel.compareWithPreviousStatic(filePath, historyProvider);
			}
		);

		const refreshCommand = vscode.commands.registerCommand('faHistory.refresh',
			() => {
				historyProvider.refresh();
			}
		);

		// Nastav callback pro automatický refresh po uložení historie
		setHistoryRefreshCallback(() => {
			historyProvider.refresh();
		});

		// Vytvoř TreeView pro historii
		const historyTreeView = vscode.window.createTreeView('faHistoryPanel', {
			treeDataProvider: historyProvider,
			showCollapseAll: true
		});

		// Aktualizuj panel při změně aktivního editoru
		const editorChangeWatcher = vscode.window.onDidChangeActiveTextEditor(() => {
			historyProvider.refresh();
		});

		// Aktualizuj panel při změně nastavení
		const configWatcher = vscode.workspace.onDidChangeConfiguration(e => {
			if (e.affectsConfiguration('local-history.enabled')) {
				updatePanelVisibility();
				const enabled = vscode.workspace.getConfiguration().get<boolean>('local-history.enabled', true);
				if (!enabled) {
					historyTreeView.dispose();
				}
			}
		});

		context.subscriptions.push(
			showDiffCommand,
			restoreFileCommand,
			compareWithPreviousCommand,
			refreshCommand,
			historyTreeView,
			configWatcher,
			editorChangeWatcher
		);
	} else {
		// Přesto zaregistruj listener pro případné zapnutí později
		context.subscriptions.push(
			vscode.workspace.onDidChangeConfiguration(e => {
				if (e.affectsConfiguration('local-history.enabled')) {
					updatePanelVisibility();
				}
			})
		);
	}

	// Zkontroluj, jestli workspace obsahuje .fsbridge
	// DŮLEŽITÉ: Ignoruj worktrees složky
	if (!hasFsBridgeInWorkspace()) {
		// Workspace neobsahuje .fsbridge - doplněk se neaktivuje
		// Nastav kontextovou proměnnou na false, aby keybindings nefungovaly
		vscode.commands.executeCommand('setContext', 'faBridge.isActive', false);
		console.log('[FA Bridge] Extension neaktivována - workspace neobsahuje .fsbridge');
		return;
	}

	// DODATEČNÁ KONTROLA: Zkontroluj, jestli není aktivní worktree složka
	const workspaceFolders = vscode.workspace.workspaceFolders;
	if (workspaceFolders && workspaceFolders.length > 0) {
		const activeFolder = workspaceFolders[0];
		const activePath = activeFolder.uri.fsPath;
		if (isWorktreePath(activePath)) {
			vscode.commands.executeCommand('setContext', 'faBridge.isActive', false);
			console.log('[FA Bridge] Extension neaktivována - aktivní workspace je worktree složka');
			return;
		}
	}

	// Nastav kontextovou proměnnou pro keybindings (aby fungovaly jen když je doplněk aktivní)
	vscode.commands.executeCommand('setContext', 'faBridge.isActive', true);

	// Vytvoř Output Channel pro logování
	outputChannel = vscode.window.createOutputChannel('FA Bridge');
	context.subscriptions.push(outputChannel);
	
	outputChannel.appendLine('[FA Bridge] Extension aktivována (.fsbridge nalezen v workspace)');
	console.log('[FA Bridge] Extension aktivována');

	// Použij .fsbridge složku z workspace, který obsahuje .fsbridge (může být v sekundárním workspace)
	const workspaceRoot = getFsBridgeWorkspaceRoot();
	const fsbridgePath = workspaceRoot ? path.join(workspaceRoot, '.fsbridge') : null;
	
	// Zkontroluj instance ID - automaticky cleanup mrtvých instancí
	if (workspaceRoot) {
		const instanceId = getValidInstanceId(workspaceRoot);
		if (instanceId) {
			outputChannel.appendLine(`[FA Bridge] Instance ID: ${instanceId} (FA PID)`);
		} else {
			outputChannel.appendLine('[FA Bridge] Bez instance ID (fallback mód)');
		}
	}
	
	// Smaž famsgstate.json při startu doplnku
	deleteFamsgState(outputChannel);

	// Registruj sidebar panel
	registerFABridgePanel(context);

	// Registruj Help panel
	registerHelpPanel(context, outputChannel);

	// Registruj Pascal snippet provider (s nastavením zapnout/vypnout)
	context.subscriptions.push(registerSnippetProvider(context));

	// Registruj IntelliSense provider (Completion + Hover) - asynchronně parsuje v pozadí
	const intelliSenseDisposables = registerIntelliSenseProvider(context, outputChannel);
	context.subscriptions.push(...intelliSenseDisposables);
	outputChannel.appendLine('[FA Bridge] IntelliSense provider registrován (parsování probíhá v pozadí)');

	// Registruj Begin/End matcher pro zvýrazňování odpovídajících bloků
	registerBeginEndMatcher(context);
	outputChannel.appendLine('[FA Bridge] Begin/End matcher registrován');

	// Output Channel se zobrazí automaticky v dropdownu Output panelu
	// Není potřeba ho explicitně zobrazovat

	outputChannel.appendLine(`[FA Bridge] Používá .fsbridge složku z workspace: ${fsbridgePath || '(není workspace)'}`);
	
	// Registruj Msg Watch panel - používá .fsbridge z workspace
	if (fsbridgePath) {
		registerMsgWatchPanel(context, fsbridgePath, outputChannel);
		outputChannel.appendLine(`[FA Bridge] Msg Watch panel registrován s cestou: ${fsbridgePath}`);
	} else {
		// I když není workspace, zaregistruj panel s prázdnou cestou
		// Panel bude zobrazovat pouze chybovou zprávu
		registerMsgWatchPanel(context, '', outputChannel);
		outputChannel.appendLine('[FA Bridge] WARNING: Workspace není otevřený. Msg Watch panel nebude fungovat.');
	}

	// Registruj Command Watcher pro zpracování příkazů z FA
	const commandWatcher = new CommandWatcher(outputChannel);
	context.subscriptions.push(commandWatcher);
	outputChannel.appendLine('[FA Bridge] Command Watcher registrován');

	// Registruj všechny příkazy
	const commands = [
		vscode.commands.registerCommand('faBridge.ulozitSoubor', ulozitSoubor),
		vscode.commands.registerCommand('faBridge.faDoPopredi', faDoPopredi),
		vscode.commands.registerCommand('faBridge.vlozitNazevUdaje', vlozitNazevUdaje),
		vscode.commands.registerCommand('faBridge.kopirovatNazevUdaje', kopirovatNazevUdaje),
		vscode.commands.registerCommand('faBridge.najitUdaj', najitUdaj),
		vscode.commands.registerCommand('faBridge.hledatPodleAktUdaje', hledatPodleAktUdaje),
		vscode.commands.registerCommand('faBridge.toggleMsgv', toggleMsgv),
		vscode.commands.registerCommand('faBridge.toggleField', toggleField),
		vscode.commands.registerCommand('faBridge.vlozitUdajSBody', vlozitUdajSBody),
		vscode.commands.registerCommand('faBridge.vlozitUdajSDvojteckami', vlozitUdajSDvojteckami),
		vscode.commands.registerCommand('faBridge.hledatOdZacatku', hledatOdZacatku),
		vscode.commands.registerCommand('faBridge.openHelp', openHelp),
		vscode.commands.registerCommand('faBridge.openFaChm', openFaChm),
		vscode.commands.registerCommand('faBridge.openTextSearch', openTextSearch),
		
		// Commands pro historii souborů
		vscode.commands.registerCommand('faBridge.compareWithPrevious', async () => {
			const editor = vscode.window.activeTextEditor;
			if (!editor) {
				vscode.window.showErrorMessage('Žádný editor otevřen');
				return;
			}
			await compareWithPreviousVersion(editor.document.fileName);
		}),
		vscode.commands.registerCommand('faBridge.showHistoryVersions', async () => {
			const editor = vscode.window.activeTextEditor;
			if (!editor) {
				vscode.window.showErrorMessage('Žádný editor otevřen');
				return;
			}
			await showHistoryVersions(editor.document.fileName);
		}),
		
		// Commands pro přepínání color themes
		vscode.commands.registerCommand('faBridge.setLightTheme', () => {
			vscode.workspace.getConfiguration('workbench').update(
				'colorTheme',
				'FA Pascal Light',
				vscode.ConfigurationTarget.Global
			);
			vscode.window.showInformationMessage('Přepnuto na FA Pascal Light theme');
		}),
		vscode.commands.registerCommand('faBridge.setDarkTheme', () => {
			vscode.workspace.getConfiguration('workbench').update(
				'colorTheme',
				'FA Pascal Dark',
				vscode.ConfigurationTarget.Global
			);
			vscode.window.showInformationMessage('Přepnuto na FA Pascal Dark theme');
		}),
		
		// Command pro Go To Definition (F12) - pouze klávesa, ne Ctrl+click, pouze v aktuálním souboru
		vscode.commands.registerCommand('faBridge.goToDefinition', async () => {
			const provider = getIntelliSenseProvider();
			if (!provider) {
				vscode.window.showErrorMessage('IntelliSense provider není dostupný');
				return;
			}
			await provider.goToDefinition();
		}),
		
		// Command pro zobrazení statistik IntelliSense
		vscode.commands.registerCommand('faBridge.showIntelliSenseStats', () => {
			const provider = getIntelliSenseProvider();
			if (!provider) {
				vscode.window.showErrorMessage('IntelliSense provider není dostupný');
				return;
			}
			
			if (!outputChannel) {
				vscode.window.showErrorMessage('Output channel není dostupný');
				return;
			}
			
		const stats = provider.getStats();
		const docFilesStr = stats.docFilePaths.length > 0 
			? stats.docFilePaths.map(p => path.basename(p)).join(', ')
			: '(nenalezeno)';
		const implFilesStr = stats.implFilePaths.length > 0 
			? stats.implFilePaths.map(p => path.basename(p)).join(', ')
			: '(nenalezeno)';
		const message = [
			`📊 IntelliSense statistiky:`,
			`Načteno funkcí: ${stats.loaded}`,
			`Doc soubory: ${docFilesStr}`,
			`Impl soubory: ${implFilesStr}`,
				`Stav parsování: ${stats.isParsing ? 'probíhá...' : 'dokončeno'}`,
				stats.sampleFunctions.length > 0 ? `Ukázkové funkce: ${stats.sampleFunctions.join(', ')}` : ''
			].filter(Boolean).join('\n');
			
			vscode.window.showInformationMessage(message);
			
		// Zobraz také v Output panelu
		outputChannel.appendLine('=== IntelliSense statistiky ===');
		outputChannel.appendLine(`Načteno funkcí: ${stats.loaded}`);
		outputChannel.appendLine(`Doc soubory: ${docFilesStr}`);
		if (stats.docFilePaths.length > 0) {
			for (const filePath of stats.docFilePaths) {
				outputChannel.appendLine(`  Doc: ${filePath}`);
			}
		}
		outputChannel.appendLine(`Impl soubory: ${implFilesStr}`);
		if (stats.implFilePaths.length > 0) {
			for (const filePath of stats.implFilePaths) {
				outputChannel.appendLine(`  Impl: ${filePath}`);
			}
		}
		outputChannel.appendLine(`Stav parsování: ${stats.isParsing ? 'probíhá...' : 'dokončeno'}`);
			if (stats.sampleFunctions.length > 0) {
				outputChannel.appendLine(`Ukázkové funkce: ${stats.sampleFunctions.join(', ')}`);
			}
			outputChannel.appendLine('===============================');
			outputChannel.show(true);
		}),

	];

	context.subscriptions.push(...commands);

	// Sleduj uložení souborů a maž famsgstate.json při uložení
	const saveListener = vscode.workspace.onDidSaveTextDocument(() => {
		deleteFamsgState(outputChannel);
	});
	context.subscriptions.push(saveListener);

	// Sleduj otevření souborů a zajisti focus v editoru při prvním otevření FA scriptu
	const openDocumentListener = vscode.workspace.onDidOpenTextDocument(async (document) => {
		// Zkontroluj, jestli je to FA script soubor
		const fileName = path.basename(document.fileName);
		if (!fileName.match(/^(script_|u_)[a-zA-Z0-9_]+\.pas$/)) {
			return; // Není to FA script
		}

		// Počkej chvíli, aby se dokument stihl otevřít
		await new Promise(resolve => setTimeout(resolve, 100));

		// Zajisti, aby byl editor aktivní a měl focus
		await vscode.window.showTextDocument(document, {
			preview: false,
			preserveFocus: false // Toto zajistí, že editor dostane focus
		});
	});
	context.subscriptions.push(openDocumentListener);



	// Automaticky otevři FA Bridge panel při každém startu (pokud je to povoleno v nastavení)
	const config = vscode.workspace.getConfiguration('faBridge');
	const autoOpenPanel = config.get<boolean>('autoOpenPanel', true);
	if (autoOpenPanel) {
		setTimeout(async () => {
			try {
				await vscode.commands.executeCommand('workbench.view.extension.faBridgeContainer');
				if (outputChannel) {
					outputChannel.appendLine('[FA Bridge] FA Bridge panel automaticky otevřen');
				}
				
				// Po otevření panelu počkej a pokud je otevřený FA script, nastavíme focus zpět na editor
				await new Promise(resolve => setTimeout(resolve, 200));
				const editor = vscode.window.activeTextEditor;
				if (editor) {
					const fileName = path.basename(editor.document.fileName);
					if (fileName.match(/^(script_|u_)[a-zA-Z0-9_]+\.pas$/)) {
						// Je otevřený FA script - nastav focus na editor
						await vscode.window.showTextDocument(editor.document, {
							preview: false,
							preserveFocus: false
						});
						if (outputChannel) {
							outputChannel.appendLine('[FA Bridge] Focus nastaven na FA script editor');
						}
					}
				}
			} catch (error) {
				// Tichá chyba - pokud se nepodaří otevřít, není to kritické
			}
		}, 500); // 500ms zpoždění pro zajištění, že VS Code je plně načten
	}
}

export function deactivate() {
	console.log('[FA Bridge] Extension deaktivována');
}
