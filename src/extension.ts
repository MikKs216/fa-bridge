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
import { writeFACommand } from './utils/fsBridge';
import { registerFABridgePanel } from './views/FABridgePanel';
import { registerSnippetProvider } from './providers/SnippetProvider';
import { registerMsgWatchPanel } from './debugger/msgWatch';
import { registerIntelliSenseProvider, getIntelliSenseProvider } from './providers/PascalIntelliSenseProvider';

let outputChannel: vscode.OutputChannel | null = null;

/**
 * Smaže famsgstate.json pokud existuje
 */
function deleteFamsgState(fsbridgePath: string | undefined, outputChannel: vscode.OutputChannel | null): void {
	if (!fsbridgePath || fsbridgePath === '') {
		return;
	}

	const statePath = path.join(fsbridgePath, 'famsgstate.json');
	
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

export function activate(context: vscode.ExtensionContext) {
	// Vytvoř Output Channel pro logování
	outputChannel = vscode.window.createOutputChannel('FA Bridge');
	context.subscriptions.push(outputChannel);
	
	outputChannel.appendLine('[FA Bridge] Extension aktivována');
	console.log('[FA Bridge] Extension aktivována');

	// Inicializuj debugger - používá fsbridgePath z konfigurace (ne workspace!)
	const config = vscode.workspace.getConfiguration('faBridge');
	const fsbridgePath = config.get<string>('fsbridgePath');
	
	// Smaž famsgstate.json při startu doplnku
	deleteFamsgState(fsbridgePath, outputChannel);

	// Registruj sidebar panel
	registerFABridgePanel(context);

	// Registruj Pascal snippet provider (s nastavením zapnout/vypnout)
	context.subscriptions.push(registerSnippetProvider(context));

	// Registruj IntelliSense provider (Completion + Hover) - asynchronně parsuje v pozadí
	const intelliSenseDisposables = registerIntelliSenseProvider(context, outputChannel);
	context.subscriptions.push(...intelliSenseDisposables);
	outputChannel.appendLine('[FA Bridge] IntelliSense provider registrován (parsování probíhá v pozadí)');

	// Output Channel se zobrazí automaticky v dropdownu Output panelu
	// Není potřeba ho explicitně zobrazovat

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
		deleteFamsgState(fsbridgePath, outputChannel);
	});
	context.subscriptions.push(saveListener);

	// Automaticky otevři FA Bridge panel při každém startu
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

export function deactivate() {
	console.log('[FA Bridge] Extension deaktivována');
}
