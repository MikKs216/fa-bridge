import * as vscode from 'vscode';
import { writeFACommand } from '../utils/fsBridge';

/**
 * Aktivuje formulář (Ctrl+Alt+1)
 */
export async function aktivovatFormular(): Promise<void> {
	try {
		await writeFACommand('Aktivovat_formular');
		vscode.window.showInformationMessage('✓ Formulář aktivován');
	} catch {
		vscode.window.showErrorMessage('✗ Chyba při aktivaci formuláře');
	}
}

/**
 * Zkompiluje script (Ctrl+Alt+2)
 */
export async function zkompilovatScript(): Promise<void> {
	try {
		await writeFACommand('Zkompilovat_script');
		vscode.window.showInformationMessage('✓ Script kompilován');
	} catch {
		vscode.window.showErrorMessage('✗ Chyba při kompilaci scriptu');
	}
}

/**
 * Vloží název aktuálních údajů (Ctrl+Alt+3)
 */
export async function vlozitNazevUdaje(): Promise<void> {
	try {
		await writeFACommand('Vlozit_nazev_udaje');
		vscode.window.showInformationMessage('✓ Název údajů vložen');
	} catch {
		vscode.window.showErrorMessage('✗ Chyba při vložení názvu');
	}
}

/**
 * Speciální c999 příkaz (Ctrl+Alt+9)
 */
export async function sendC999(): Promise<void> {
	try {
		await writeFACommand('c999');
		vscode.window.showInformationMessage('✓ c999 odeslán');
	} catch {
		vscode.window.showErrorMessage('✗ Chyba při odesílání c999');
	}
}

/**
 * Quick Pick menu (Ctrl+Alt+F)
 */
export async function showMenu(): Promise<void> {
	const items: vscode.QuickPickItem[] = [
		{
			label: '$(file-code) Aktivovat formulář',
			description: 'Ctrl+Alt+1',
			detail: 'Aktivuje aktuální formulář',
		},
		{
			label: '$(play) Zkompilovat script',
			description: 'Ctrl+Alt+2',
			detail: 'Zkompiluje aktuální script',
		},
		{
			label: '$(pencil) Vložit název údajů',
			description: 'Ctrl+Alt+3',
			detail: 'Vloží název aktuálních údajů na kurzor',
		},
		{
			label: '$(settings-gear) c999',
			description: 'Ctrl+Alt+9',
			detail: 'Speciální příkaz',
		},
	];

	const selected = await vscode.window.showQuickPick(items, {
		placeHolder: 'Vyber příkaz pro FormStudio...',
	});

	if (!selected) {
		return;
	}

	switch (selected.label) {
		case '$(file-code) Aktivovat formulář':
			await aktivovatFormular();
			break;
		case '$(play) Zkompilovat script':
			await zkompilovatScript();
			break;
		case '$(pencil) Vložit název údajů':
			await vlozitNazevUdaje();
			break;
		case '$(settings-gear) c999':
			await sendC999();
			break;
	}
}
