// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
import * as vscode from 'vscode';
import {
	aktivovatFormular,
	zkompilovatScript,
	vlozitNazevUdaje,
	sendC999,
	showMenu,
} from './commands/sendCommand';

export function activate(context: vscode.ExtensionContext) {
	console.log('[FA Bridge] Extension aktivována');

	// Registruj všechny příkazy
	const commands = [
		vscode.commands.registerCommand('faBridge.aktivovatFormular', aktivovatFormular),
		vscode.commands.registerCommand('faBridge.zkompilovatScript', zkompilovatScript),
		vscode.commands.registerCommand('faBridge.vlozitNazevUdaje', vlozitNazevUdaje),
		vscode.commands.registerCommand('faBridge.sendC999', sendC999),
		vscode.commands.registerCommand('faBridge.menu', showMenu),
	];

	context.subscriptions.push(...commands);
}

export function deactivate() {
	console.log('[FA Bridge] Extension deaktivována');
}
