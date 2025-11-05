// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
import * as vscode from 'vscode';
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
import { writeFACommand } from './utils/fsBridge';
import { registerFABridgePanel } from './views/FABridgePanel';
import { registerSnippetProvider } from './providers/SnippetProvider';
import { registerMsgWatchPanel } from './debugger/msgWatch';

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

	];

	context.subscriptions.push(...commands);
}

export function deactivate() {
	console.log('[FA Bridge] Extension deaktivována');
}
