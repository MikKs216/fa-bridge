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
import { SimpleDebugger } from './debugger/simpleDebugger';
import { registerDebugVariablesPanel } from './debugger/debugVariables';

let faDebugger: SimpleDebugger | null = null;

export function activate(context: vscode.ExtensionContext) {
	console.log('[FA Bridge] Extension aktivována');

	// Registruj sidebar panel
	registerFABridgePanel(context);

	// Registruj Pascal snippet provider (s nastavením zapnout/vypnout)
	context.subscriptions.push(registerSnippetProvider(context));

	// Inicializuj debugger - používá fsbridgePath z konfigurace (ne workspace!)
	const config = vscode.workspace.getConfiguration('faBridge');
	const fsbridgePath = config.get<string>('fsbridgePath');
	
	if (fsbridgePath) {
		faDebugger = new SimpleDebugger(fsbridgePath);
		faDebugger.startWatching();

		// Registruj debugger variables panel
		registerDebugVariablesPanel(context, faDebugger);

		// Cleanup při deaktivaci
		context.subscriptions.push({
			dispose: () => {
				faDebugger?.dispose();
				faDebugger = null;
			}
		});
	} else {
		vscode.window.showWarningMessage('FA Bridge: Nastavte cestu k .fsbridge složce v nastavení (faBridge.fsbridgePath)');
	}

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

		// Debugger příkazy
		vscode.commands.registerCommand('faBridge.debugContinue', () => {
			faDebugger?.continue();
		}),
		vscode.commands.registerCommand('faBridge.debugStepOver', () => {
			faDebugger?.stepOver();
		}),
		vscode.commands.registerCommand('faBridge.debugPause', () => {
			faDebugger?.pause();
		}),
		vscode.commands.registerCommand('faBridge.debugStop', () => {
			faDebugger?.stop();
		}),
		vscode.commands.registerCommand('faBridge.debugToggleBreakpoint', () => {
			const editor = vscode.window.activeTextEditor;
			if (editor && faDebugger) {
				const line = editor.selection.active.line + 1; // VS Code používá 0-based, TMS Scripter pravděpodobně 1-based
				faDebugger.toggleBreakpoint(line);
			} else {
				vscode.window.showWarningMessage('Otevřete Pascal soubor pro nastavení breakpointu');
			}
		}),
		// Alias pro panel (toggleBreakpoint → debugToggleBreakpoint)
		vscode.commands.registerCommand('faBridge.toggleBreakpoint', () => {
			vscode.commands.executeCommand('faBridge.debugToggleBreakpoint');
		}),
		vscode.commands.registerCommand('faBridge.debugPanel', () => {
			vscode.commands.executeCommand('workbench.view.extension.faBridgeContainer');
		}),

		// Návrh příkazy
		vscode.commands.registerCommand('faBridge.provestInit', async () => {
			try {
				await writeFACommand('DO_INIT');
				vscode.window.showInformationMessage('FA: Provádím Init...');
			} catch (error) {
				vscode.window.showErrorMessage(`Chyba: ${error}`);
			}
		}),
		vscode.commands.registerCommand('faBridge.provestCalculate', async () => {
			try {
				await writeFACommand('DO_CALCULATE');
				vscode.window.showInformationMessage('FA: Provádím Calculate...');
			} catch (error) {
				vscode.window.showErrorMessage(`Chyba: ${error}`);
			}
		}),
		vscode.commands.registerCommand('faBridge.provestEnable', async () => {
			try {
				await writeFACommand('DO_ENABLE');
				vscode.window.showInformationMessage('FA: Provádím Enable...');
			} catch (error) {
				vscode.window.showErrorMessage(`Chyba: ${error}`);
			}
		}),
		vscode.commands.registerCommand('faBridge.zobrazitInfo', async () => {
			try {
				await writeFACommand('SHOW_INFO');
				vscode.window.showInformationMessage('FA: Zobrazuji Info...');
			} catch (error) {
				vscode.window.showErrorMessage(`Chyba: ${error}`);
			}
		}),
		vscode.commands.registerCommand('faBridge.zobrazitPlatebniInformace', async () => {
			try {
				await writeFACommand('SHOW_PAYMENT_INFO');
				vscode.window.showInformationMessage('FA: Zobrazuji platební informace...');
			} catch (error) {
				vscode.window.showErrorMessage(`Chyba: ${error}`);
			}
		}),
		vscode.commands.registerCommand('faBridge.zobrazitPeriod', async () => {
			try {
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
	if (faDebugger) {
		faDebugger.dispose();
		faDebugger = null;
	}
}
