// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
import * as vscode from 'vscode';
import {
	aktivovatFormular,
	vlozitNazevUdaje,
	kopirovatNazevUdaje,
	najitUdaj,
} from './commands/sendCommand';
import { writeFACommand } from './utils/fsBridge';
import { registerFABridgePanel } from './views/FABridgePanel';
import { registerSnippetProvider } from './providers/SnippetProvider';
import { registerMsgWatchPanel } from './debugger/msgWatch';
import { registerCommunicationStatusPanel } from './debugger/communicationStatus';

let outputChannel: vscode.OutputChannel | null = null;

export function activate(context: vscode.ExtensionContext) {
	// Vytvoř Output Channel pro logování
	outputChannel = vscode.window.createOutputChannel('FA Bridge');
	context.subscriptions.push(outputChannel);
	
	outputChannel.appendLine('[FA Bridge] Extension aktivována');
	console.log('[FA Bridge] Extension aktivována');

	// Registruj sidebar panel
	registerFABridgePanel(context);

	// Registruj Pascal snippet provider (s nastavením zapnout/vypnout)
	context.subscriptions.push(registerSnippetProvider(context));

	// Output Channel se zobrazí automaticky v dropdownu Output panelu
	// Není potřeba ho explicitně zobrazovat

	// Inicializuj debugger - používá fsbridgePath z konfigurace (ne workspace!)
	const config = vscode.workspace.getConfiguration('faBridge');
	const fsbridgePath = config.get<string>('fsbridgePath');
	
	outputChannel.appendLine(`[FA Bridge] Čtení konfigurace: fsbridgePath = ${fsbridgePath || '(není nastaveno)'}`);
	
	// Registruj Msg Watch panel vždy (nezávislý na debuggeru a fsbridgePath)
	// Pokud není fsbridgePath, panel bude prázdný, ale bude viditelný
	if (fsbridgePath) {
		registerMsgWatchPanel(context, fsbridgePath, outputChannel);
		outputChannel.appendLine(`[FA Bridge] Msg Watch panel registrován s cestou: ${fsbridgePath}`);
	} else {
		// I když není fsbridgePath, zaregistruj panel s prázdnou cestou
		// Panel bude zobrazovat pouze chybovou zprávu
		registerMsgWatchPanel(context, '', outputChannel);
		outputChannel.appendLine('[FA Bridge] WARNING: fsbridgePath není nastaven. Msg Watch panel nebude fungovat.');
		outputChannel.appendLine('[FA Bridge] Nastavte cestu v nastavení: faBridge.fsbridgePath');
	}

	// Registruj Communication Status panel vždy (zobrazuje stav komunikace)
	registerCommunicationStatusPanel(context, fsbridgePath || null, outputChannel);
	outputChannel.appendLine('[FA Bridge] Communication Status panel registrován');

	// Registruj všechny příkazy
	const commands = [
		vscode.commands.registerCommand('faBridge.aktivovatFormular', aktivovatFormular),
		vscode.commands.registerCommand('faBridge.vlozitNazevUdaje', vlozitNazevUdaje),
		vscode.commands.registerCommand('faBridge.kopirovatNazevUdaje', kopirovatNazevUdaje),
		vscode.commands.registerCommand('faBridge.najitUdaj', najitUdaj),
		
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

		// Návrh příkazy
		vscode.commands.registerCommand('faBridge.provestInit', async () => {
			try {
				// Nejdřív aktivovat FA
				await writeFACommand('Aktivovat_formular');
				await new Promise(resolve => setTimeout(resolve, 400)); // Zpoždění pro aktivaci FA
				// Pak spustit Init
				await writeFACommand('DO_INIT');
				vscode.window.showInformationMessage('FA: Provádím Init...');
			} catch (error) {
				vscode.window.showErrorMessage(`Chyba: ${error}`);
			}
		}),
		vscode.commands.registerCommand('faBridge.provestCalculate', async () => {
			try {
				// Nejdřív aktivovat FA
				await writeFACommand('Aktivovat_formular');
				await new Promise(resolve => setTimeout(resolve, 400)); // Zpoždění pro aktivaci FA
				// Pak spustit Calculate
				await writeFACommand('DO_CALCULATE');
				vscode.window.showInformationMessage('FA: Provádím Calculate...');
			} catch (error) {
				vscode.window.showErrorMessage(`Chyba: ${error}`);
			}
		}),
		vscode.commands.registerCommand('faBridge.provestEnable', async () => {
			try {
				// Nejdřív aktivovat FA
				await writeFACommand('Aktivovat_formular');
				await new Promise(resolve => setTimeout(resolve, 400)); // Zpoždění pro aktivaci FA
				// Pak spustit Enable
				await writeFACommand('DO_ENABLE');
				vscode.window.showInformationMessage('FA: Provádím Enable...');
			} catch (error) {
				vscode.window.showErrorMessage(`Chyba: ${error}`);
			}
		}),
		vscode.commands.registerCommand('faBridge.zobrazitInfo', async () => {
			try {
				// Nejdřív aktivovat FA
				await writeFACommand('Aktivovat_formular');
				await new Promise(resolve => setTimeout(resolve, 400)); // Zpoždění pro aktivaci FA
				// Pak zobrazit Info
				await writeFACommand('SHOW_INFO');
				vscode.window.showInformationMessage('FA: Zobrazuji Info...');
			} catch (error) {
				vscode.window.showErrorMessage(`Chyba: ${error}`);
			}
		}),
		vscode.commands.registerCommand('faBridge.zobrazitPlatebniInformace', async () => {
			try {
				// Nejdřív aktivovat FA
				await writeFACommand('Aktivovat_formular');
				await new Promise(resolve => setTimeout(resolve, 400)); // Zpoždění pro aktivaci FA
				// Pak zobrazit Platební informace
				await writeFACommand('SHOW_PAYMENT_INFO');
				vscode.window.showInformationMessage('FA: Zobrazuji platební informace...');
			} catch (error) {
				vscode.window.showErrorMessage(`Chyba: ${error}`);
			}
		}),
		vscode.commands.registerCommand('faBridge.zobrazitPeriod', async () => {
			try {
				// Nejdřív aktivovat FA
				await writeFACommand('Aktivovat_formular');
				await new Promise(resolve => setTimeout(resolve, 400)); // Zpoždění pro aktivaci FA
				// Pak zobrazit Period
				await writeFACommand('SHOW_PERIOD');
				vscode.window.showInformationMessage('FA: Zobrazuji Period...');
			} catch (error) {
				vscode.window.showErrorMessage(`Chyba: ${error}`);
			}
		}),
	];

	context.subscriptions.push(...commands);
}

export function deactivate() {
	console.log('[FA Bridge] Extension deaktivována');
}
