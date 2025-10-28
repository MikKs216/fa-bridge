// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
import * as vscode from 'vscode';
import {
	aktivovatFormular,
	vlozitNazevUdaje,
	kopirovatNazevUdaje,
	najitUdaj,
} from './commands/sendCommand';
import { registerFABridgePanel } from './views/FABridgePanel';

export function activate(context: vscode.ExtensionContext) {
	console.log('[FA Bridge] Extension aktivována');

	// Registruj sidebar panel
	registerFABridgePanel(context);

	// Registruj všechny příkazy
	const commands = [
		vscode.commands.registerCommand('faBridge.aktivovatFormular', aktivovatFormular),
		vscode.commands.registerCommand('faBridge.vlozitNazevUdaje', vlozitNazevUdaje),
		vscode.commands.registerCommand('faBridge.kopirovatNazevUdaje', kopirovatNazevUdaje),
		vscode.commands.registerCommand('faBridge.najitUdaj', najitUdaj),
	];

	context.subscriptions.push(...commands);
}

export function deactivate() {
	console.log('[FA Bridge] Extension deaktivována');
}
