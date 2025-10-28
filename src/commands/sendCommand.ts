import * as vscode from 'vscode';
import * as fs from 'fs';
import * as path from 'path';
import { writeFACommand } from '../utils/fsBridge';

/**
 * Aktivuje formulář (Ctrl+Alt+1)
 */
export async function aktivovatFormular(): Promise<void> {
	try {
		await writeFACommand('Aktivovat_formular');
		vscode.window.showInformationMessage('✓ Formulář aktivován');
	} catch (error) {
		const msg = error instanceof Error ? error.message : String(error);
		vscode.window.showErrorMessage(`✗ Chyba při aktivaci formuláře: ${msg}`);
	}
}

/**
 * Vloží obsah z .fsbridge/fafield.txt na pozici kurzoru
 * (FA sám aktualizuje fafield.txt na pozadí)
 */
export async function vlozitNazevUdaje(): Promise<void> {
	try {
		const editor = vscode.window.activeTextEditor;
		if (!editor) {
			vscode.window.showErrorMessage('✗ Žádný editor otevřen');
			return;
		}

		// Přečti obsah z fafield.txt
		const workspaceRoot = vscode.workspace.workspaceFolders?.[0]?.uri.fsPath;
		if (!workspaceRoot) {
			throw new Error('Žádný workspace otevřen');
		}

		const faFieldPath = path.join(workspaceRoot, '.fsbridge', 'fafield.txt');

		if (!fs.existsSync(faFieldPath)) {
			vscode.window.showErrorMessage('✗ Soubor .fsbridge/fafield.txt neexistuje');
			return;
		}

		// Přečti obsah
		let content = fs.readFileSync(faFieldPath, 'utf-8');
		
		// Odstraň BOM pokud existuje
		if (content.charCodeAt(0) === 0xFEFF) {
			content = content.slice(1);
		}
		
		// Odstraň trailing whitespace
		content = content.trim();

		if (!content) {
			vscode.window.showErrorMessage('✗ Obsah .fsbridge/fafield.txt je prázdný');
			return;
		}

		// Vlož obsah na pozici kurzoru
		await editor.edit(editBuilder => {
			const position = editor.selection.active;
			editBuilder.insert(position, content);
		});

		vscode.window.showInformationMessage(`✓ Vloženo: "${content}"`);
	} catch (error) {
		const msg = error instanceof Error ? error.message : String(error);
		vscode.window.showErrorMessage(`✗ Chyba: ${msg}`);
	}
}

/**
 * Kopíruje název údaje z fafield.txt do schránky (Shift+Alt+C)
 */
export async function kopirovatNazevUdaje(): Promise<void> {
	try {
		// Přečti obsah z fafield.txt
		const workspaceRoot = vscode.workspace.workspaceFolders?.[0]?.uri.fsPath;
		if (!workspaceRoot) {
			throw new Error('Žádný workspace otevřen');
		}

		const faFieldPath = path.join(workspaceRoot, '.fsbridge', 'fafield.txt');

		if (!fs.existsSync(faFieldPath)) {
			vscode.window.showErrorMessage('✗ Soubor .fsbridge/fafield.txt neexistuje');
			return;
		}

		// Přečti obsah
		let content = fs.readFileSync(faFieldPath, 'utf-8');
		
		// Odstraň BOM pokud existuje
		if (content.charCodeAt(0) === 0xFEFF) {
			content = content.slice(1);
		}
		
		// Odstraň trailing whitespace
		content = content.trim();

		if (!content) {
			vscode.window.showErrorMessage('✗ Obsah .fsbridge/fafield.txt je prázdný');
			return;
		}

		// Zkopíruj do schránky
		await vscode.env.clipboard.writeText(content);

		vscode.window.showInformationMessage(`✓ Zkopírováno do schránky: "${content}"`);
	} catch (error) {
		const msg = error instanceof Error ? error.message : String(error);
		vscode.window.showErrorMessage(`✗ Chyba: ${msg}`);
	}
}

/**
 * Najde údaj ve formuláři - vezme slovo pod kurzorem, zapíše do fafield.txt a pošle příkaz (Shift+Alt+L)
 */
export async function najitUdaj(): Promise<void> {
	try {
		const editor = vscode.window.activeTextEditor;
		if (!editor) {
			vscode.window.showErrorMessage('✗ Žádný editor otevřen');
			return;
		}

		// Získej slovo pod kurzorem
		const position = editor.selection.active;
		const wordRange = editor.document.getWordRangeAtPosition(position);
		
		if (!wordRange) {
			vscode.window.showErrorMessage('✗ Kurzor není na žádném slově');
			return;
		}

		const word = editor.document.getText(wordRange);

		// Přečti workspace
		const workspaceRoot = vscode.workspace.workspaceFolders?.[0]?.uri.fsPath;
		if (!workspaceRoot) {
			throw new Error('Žádný workspace otevřen');
		}

		const fsBridgeDir = path.join(workspaceRoot, '.fsbridge');
		const faFieldPath = path.join(fsBridgeDir, 'fafield.txt');

		// Zajisti že .fsbridge složka existuje
		if (!fs.existsSync(fsBridgeDir)) {
			fs.mkdirSync(fsBridgeDir, { recursive: true });
		}

		// UTF-8 s BOM (EF BB BF)
		const bom = Buffer.from([0xef, 0xbb, 0xbf]);
		const wordBuffer = Buffer.from(word, 'utf-8');
		const content = Buffer.concat([bom, wordBuffer]);

		// Zapiš slovo do fafield.txt
		fs.writeFileSync(faFieldPath, content);

		// Pošli příkaz do FA
		await writeFACommand('Najit_udaj');

		vscode.window.showInformationMessage(`✓ Hledám údaj: "${word}"`);
	} catch (error) {
		const msg = error instanceof Error ? error.message : String(error);
		vscode.window.showErrorMessage(`✗ Chyba: ${msg}`);
	}
}

