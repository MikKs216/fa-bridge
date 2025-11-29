// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
import * as vscode from 'vscode';
import * as fs from 'fs';
import * as path from 'path';
import {
	ulozitSoubor,
	vlozitNazevUdaje,
	kopirovatNazevUdaje,
	najitUdaj,
	hledatPodleAktUdaje,
	toggleMsgv,
	toggleField,
	vlozitUdajSBody,
	vlozitUdajSDvojteckami,
	hledatOdZacatku,
} from './commands/sendCommand';
import { writeFACommand, getValidInstanceId, getFsBridgeWorkspaceRoot } from './utils/fsBridge';
import { registerFABridgePanel } from './views/FABridgePanel';
import { registerSnippetProvider } from './providers/SnippetProvider';
import { registerMsgWatchPanel } from './debugger/msgWatch';
import { registerHelpPanel } from './views/HelpPanel';
import { registerIntelliSenseProvider, getIntelliSenseProvider } from './providers/PascalIntelliSenseProvider';
import { CommandWatcher } from './utils/commandWatcher';

let outputChannel: vscode.OutputChannel | null = null;

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
 */
function hasFsBridgeInWorkspace(): boolean {
	const workspaceFolders = vscode.workspace.workspaceFolders;
	if (!workspaceFolders || workspaceFolders.length === 0) {
		return false;
	}

	// Zkontroluj každý workspace folder
	for (const folder of workspaceFolders) {
		const fsbridgePath = path.join(folder.uri.fsPath, '.fsbridge');
		// Zkontroluj jestli existuje jako soubor nebo složka
		if (fs.existsSync(fsbridgePath)) {
			return true;
		}
	}

	return false;
}

export function activate(context: vscode.ExtensionContext) {
	// Zkontroluj, jestli workspace obsahuje .fsbridge
	if (!hasFsBridgeInWorkspace()) {
		// Workspace neobsahuje .fsbridge - doplněk se neaktivuje
		// Nastav kontextovou proměnnou na false, aby keybindings nefungovaly
		vscode.commands.executeCommand('setContext', 'faBridge.isActive', false);
		console.log('[FA Bridge] Extension neaktivována - workspace neobsahuje .fsbridge');
		return;
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
		vscode.commands.registerCommand('faBridge.vlozitNazevUdaje', vlozitNazevUdaje),
		vscode.commands.registerCommand('faBridge.kopirovatNazevUdaje', kopirovatNazevUdaje),
		vscode.commands.registerCommand('faBridge.najitUdaj', najitUdaj),
		vscode.commands.registerCommand('faBridge.hledatPodleAktUdaje', hledatPodleAktUdaje),
		vscode.commands.registerCommand('faBridge.toggleMsgv', toggleMsgv),
		vscode.commands.registerCommand('faBridge.toggleField', toggleField),
		vscode.commands.registerCommand('faBridge.vlozitUdajSBody', vlozitUdajSBody),
		vscode.commands.registerCommand('faBridge.vlozitUdajSDvojteckami', vlozitUdajSDvojteckami),
		vscode.commands.registerCommand('faBridge.hledatOdZacatku', hledatOdZacatku),
		
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
			const message = [
				`📊 IntelliSense statistiky:`,
				`Načteno funkcí: ${stats.loaded}`,
				`Cesta k souboru: ${stats.filePath || '(nenalezeno)'}`,
				`Stav parsování: ${stats.isParsing ? 'probíhá...' : 'dokončeno'}`,
				stats.sampleFunctions.length > 0 ? `Ukázkové funkce: ${stats.sampleFunctions.join(', ')}` : ''
			].filter(Boolean).join('\n');
			
			vscode.window.showInformationMessage(message);
			
			// Zobraz také v Output panelu
			outputChannel.appendLine('=== IntelliSense statistiky ===');
			outputChannel.appendLine(`Načteno funkcí: ${stats.loaded}`);
			outputChannel.appendLine(`Cesta k souboru: ${stats.filePath || '(nenalezeno)'}`);
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

	// Sleduj aktivaci okna Cursoru - když se aktivuje myší, aktualizuj aktuální údaj z FA
	const windowStateListener = vscode.window.onDidChangeWindowState((state) => {
		if (state.focused) {
			// Okno získalo focus - zkontroluj/aktualizuj fafield.txt
			// Pošleme příkaz do FA, aby aktualizoval aktuální údaj
			setTimeout(async () => {
				try {
					// Zkontroluj, jestli existuje workspace a .fsbridge složka
					const workspaceRoot = getFsBridgeWorkspaceRoot();
					if (!workspaceRoot) {
						return;
					}

					const fsbridgeDir = path.join(workspaceRoot, '.fsbridge');
					if (!fs.existsSync(fsbridgeDir)) {
						return;
					}

					// DŮLEŽITÉ: Pošli příkaz pouze pokud je otevřený FA script soubor
					// Jinak by se mohlo použít fallback a zapisovat do špatné instance složky
					const activeEditor = vscode.window.activeTextEditor;
					if (!activeEditor) {
						return; // Žádný aktivní editor - nepokračuj
					}

					const activeFileName = activeEditor.document.fileName;
					// Zkontroluj, jestli je to FA script soubor (script_*.pas nebo u_*.pas)
					const isFAScript = /(?:script_|u_)[^\\/]+\.pas$/i.test(activeFileName);
					if (!isFAScript) {
						return; // Není to FA script - nepokračuj
					}

					// Pošli příkaz do FA pro aktualizaci aktuálního údaje
					// FA by mělo aktualizovat fafield.txt když dostane tento příkaz
					await writeFACommand('GetCurrentField');
					if (outputChannel) {
						outputChannel.appendLine('[FA Bridge] Požádáno o aktualizaci aktuálního údaje při aktivaci okna');
					}
				} catch (error) {
					// Tichá chyba - není kritické
					if (outputChannel) {
						const msg = error instanceof Error ? error.message : String(error);
						outputChannel.appendLine(`[FA Bridge] Chyba při aktualizaci údaje: ${msg}`);
					}
				}
			}, 100); // Malé zpoždění pro zajištění, že okno je plně aktivní
		}
	});
	context.subscriptions.push(windowStateListener);

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
			} catch (error) {
				// Tichá chyba - pokud se nepodaří otevřít, není to kritické
			}
		}, 500); // 500ms zpoždění pro zajištění, že VS Code je plně načten
	}
}

export function deactivate() {
	console.log('[FA Bridge] Extension deaktivována');
}
