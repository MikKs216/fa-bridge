import * as vscode from 'vscode';
import * as fs from 'fs';
import * as path from 'path';
import { writeFACommand } from '../utils/fsBridge';

/**
 * Uloží aktuální soubor pomocí VS Code API (zajišťuje trigger Local History)
 * Pokud soubor nemá změny, jen aktivuje FA do popředí
 */
export async function ulozitSoubor(): Promise<void> {
	try {
		const editor = vscode.window.activeTextEditor;
		if (!editor) {
			vscode.window.showErrorMessage('✗ Žádný editor otevřen');
			return;
		}

		const document = editor.document;
		
		// Pokud je dokument neuložený, použij standardní save dialog
		if (document.isUntitled) {
			await vscode.commands.executeCommand('workbench.action.files.save');
			// Aktivuj FA i po uložení neuloženého souboru
			await writeFACommand('Aktivovat_formular');
			return;
		}

		// Pokud soubor obsahuje změny, ulož ho
		if (document.isDirty) {
			// Použij VS Code WorkspaceEdit API pro uložení - vyvolá standardní save flow včetně onDidSaveTextDocument eventu
			// Local History extension reaguje na tento event
			await document.save();
			// Aktivuj FA po uložení
			await writeFACommand('Aktivovat_formular');
		} else {
			// Soubor nemá změny, jen aktivuj FA
			await writeFACommand('Aktivovat_formular');
		}
	} catch (error) {
		const msg = error instanceof Error ? error.message : String(error);
		vscode.window.showErrorMessage(`✗ Chyba: ${msg}`);
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

		// Zkontroluj, jestli je nějaký text označen (selekce)
		const selection = editor.selection;
		const hasSelection = !selection.isEmpty;
		
		// Vlož nebo nahraď obsah
		await editor.edit(editBuilder => {
			if (hasSelection) {
				// Pokud je označený blok, smaž ho a nahraď obsahem
				editBuilder.replace(selection, content);
			} else {
				// Pokud není označený blok, vlož obsah na pozici kurzoru
				const position = editor.selection.active;
				editBuilder.insert(position, content);
			}
		});

		vscode.window.showInformationMessage(`✓ ${hasSelection ? 'Nahrazeno' : 'Vloženo'}: "${content}"`);
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
 * Hledá v editoru podle názvu aktuálního údaje z FA
 * Otevře Find dialog s předvyplněným textem (Shift+Alt+F)
 */
export async function hledatPodleAktUdaje(): Promise<void> {
	try {
		const editor = vscode.window.activeTextEditor;
		if (!editor) {
			vscode.window.showErrorMessage('✗ Žádný editor otevřen');
			return;
		}

		// Přečti obsah z fafield.txt (stejně jako vlozitNazevUdaje)
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

		// Vyhledej text v dokumentu
		const document = editor.document;
		const documentText = document.getText();
		const searchText = content;
		
		// Escape speciální znaky pro regex (pokud bych použil regex search)
		const escapedSearchText = searchText.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
		
		// Najdi první výskyt textu v dokumentu
		const firstMatch = documentText.indexOf(searchText);
		
		if (firstMatch !== -1) {
			// Vypočítej pozici (řádek a sloupec)
			const textBeforeMatch = documentText.substring(0, firstMatch);
			const lines = textBeforeMatch.split('\n');
			const line = lines.length - 1;
			const column = lines[lines.length - 1].length;
			
			// Vyber nalezený text
			const startPos = new vscode.Position(line, column);
			const endPos = new vscode.Position(line, column + searchText.length);
			editor.selection = new vscode.Selection(startPos, endPos);
			editor.revealRange(new vscode.Range(startPos, endPos));
		}

		// Otevři Find dialog - VS Code automaticky použije vybraný text (pokud je něco vybráno)
		// nebo slovo pod kurzorem
		if (firstMatch !== -1) {
			// Text byl nalezen a vybrán - otevři Find dialog
			await vscode.commands.executeCommand('actions.find');
			vscode.window.showInformationMessage(`✓ Text "${searchText}" vybrán. Find dialog je otevřen.`);
		} else {
			// Text nebyl nalezen - vlož do schránky a otevři Find dialog
			// Uživatel pak může použít Ctrl+V v Find dialogu
			await vscode.env.clipboard.writeText(searchText);
			await vscode.commands.executeCommand('actions.find');
			vscode.window.showInformationMessage(`ℹ Text "${searchText}" nebyl nalezen. Vloženo do schránky - použij Ctrl+V v Find dialogu.`);
		}
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

/**
 * Toggle field - mění formát slova pod kurzorem: 'slovo' → [:slovo:] → [.slovo.] → 'slovo' (Alt+B)
 */
export async function toggleField(): Promise<void> {
	try {
		const editor = vscode.window.activeTextEditor;
		if (!editor) {
			vscode.window.showErrorMessage('✗ Žádný editor otevřen');
			return;
		}

		const position = editor.selection.active;
		const line = editor.document.lineAt(position.line);
		const lineText = line.text;

		// Zkus najít slovo pod kurzorem pomocí getWordRangeAtPosition
		let wordRange = editor.document.getWordRangeAtPosition(position);
		
		if (!wordRange) {
			vscode.window.showErrorMessage('✗ Kurzor není na žádném slově');
			return;
		}

		// Rozšíř vyhledávání - hledej okolo slova i formátovací znaky
		// Zkus najít pattern: 'slovo' nebo [:slovo:] nebo [.slovo.]
		const startPos = wordRange.start.character;
		const endPos = wordRange.end.character;
		const word = editor.document.getText(wordRange);
		
		// Zkus najít širší range, který může obsahovat formátovací znaky
		// Zkus najít pattern začínající před slovem a končící za slovem
		let expandedStart = Math.max(0, startPos - 3); // [: nebo [. nebo '
		let expandedEnd = Math.min(lineText.length, endPos + 3); // :] nebo .] nebo '
		
		// Zkus najít přesný pattern
		let pattern = '';
		let newPattern = '';
		let matchStart = -1;
		let matchEnd = -1;
		
		// Zkus najít pattern 'slovo'
		const apostrophePattern = new RegExp(`'([^']+)'`, 'g');
		let match;
		while ((match = apostrophePattern.exec(lineText)) !== null) {
			const matchStartPos = match.index;
			const matchEndPos = match.index + match[0].length;
			if (position.character >= matchStartPos && position.character <= matchEndPos) {
				pattern = match[0];
				matchStart = matchStartPos;
				matchEnd = matchEndPos;
				newPattern = `[:${match[1]}:]`;
				break;
			}
		}
		
		// Pokud nebyl nalezen apostrof pattern, zkus [:slovo:]
		if (!pattern) {
			const bracketPattern = new RegExp(`\\[:([^:]+):\\]`, 'g');
			while ((match = bracketPattern.exec(lineText)) !== null) {
				const matchStartPos = match.index;
				const matchEndPos = match.index + match[0].length;
				if (position.character >= matchStartPos && position.character <= matchEndPos) {
					pattern = match[0];
					matchStart = matchStartPos;
					matchEnd = matchEndPos;
					newPattern = `[.${match[1]}.]`;
					break;
				}
			}
		}
		
		// Pokud nebyl nalezen bracket pattern, zkus [.slovo.]
		if (!pattern) {
			const dotPattern = new RegExp(`\\[\\.([^\\]]+)\\.\\]`, 'g');
			while ((match = dotPattern.exec(lineText)) !== null) {
				const matchStartPos = match.index;
				const matchEndPos = match.index + match[0].length;
				if (position.character >= matchStartPos && position.character <= matchEndPos) {
					pattern = match[0];
					matchStart = matchStartPos;
					matchEnd = matchEndPos;
					// Z [.slovo.] zpět na 'slovo'
					// Odstraň tečky z match[1] pokud tam jsou
					const innerText = match[1];
					newPattern = `'${innerText}'`;
					break;
				}
			}
		}
		
		// Pokud nebyl nalezen žádný pattern, zkus použít jen slovo a přidat apostrofy
		if (!pattern) {
			// Zkus použít slovo pod kurzorem a přidat apostrofy
			pattern = word;
			matchStart = startPos;
			matchEnd = endPos;
			newPattern = `'${word}'`;
		}
		
		if (matchStart === -1 || matchEnd === -1) {
			vscode.window.showErrorMessage('✗ Nepodařilo se najít formátovaný text');
			return;
		}

		// Vytvoř range pro nahrazení
		const replaceRange = new vscode.Range(
			new vscode.Position(position.line, matchStart),
			new vscode.Position(position.line, matchEnd)
		);

		// Nahraď text
		await editor.edit(editBuilder => {
			editBuilder.replace(replaceRange, newPattern);
		});

		// Umísti kurzor na konec nahrazeného textu a posuň doleva o 3 znaky, aby zůstal ve slově
		const newCursorPos = new vscode.Position(position.line, Math.max(0, matchStart + newPattern.length - 3));
		editor.selection = new vscode.Selection(newCursorPos, newCursorPos);
		editor.revealRange(new vscode.Range(newCursorPos, newCursorPos));

		vscode.window.showInformationMessage(`✓ Změněno: ${pattern} → ${newPattern}`);
	} catch (error) {
		const msg = error instanceof Error ? error.message : String(error);
		vscode.window.showErrorMessage(`✗ Chyba: ${msg}`);
	}
}

/**
 * Vloží údaj z FA ve formátu [.názevÚdaje.] na pozici kurzoru (Shift+Ctrl+[)
 */
export async function vlozitUdajSBody(): Promise<void> {
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

		// Formátuj jako [.názevÚdaje.]
		const formattedContent = `[.${content}.]`;

		// Zkontroluj, jestli je nějaký text označen (selekce) - ulož hodnoty před editací
		const selection = editor.selection;
		const hasSelection = !selection.isEmpty;
		const insertPosition = selection.active;
		const selectionStart = selection.start;
		
		// Vlož nebo nahraď obsah
		await editor.edit(editBuilder => {
			if (hasSelection) {
				// Pokud je označený blok, smaž ho a nahraď obsahem
				editBuilder.replace(selection, formattedContent);
			} else {
				// Pokud není označený blok, vlož obsah na pozici kurzoru
				editBuilder.insert(insertPosition, formattedContent);
			}
		});

		// Umísti kurzor za vložený text
		let newPosition: vscode.Position;
		if (hasSelection) {
			// Po nahrazení selekce je kurzor na začátku nahrazeného textu
			newPosition = new vscode.Position(selectionStart.line, selectionStart.character + formattedContent.length);
		} else {
			// Po vložení je kurzor na původní pozici, musíme přidat délku vloženého textu
			newPosition = new vscode.Position(insertPosition.line, insertPosition.character + formattedContent.length);
		}
		editor.selection = new vscode.Selection(newPosition, newPosition);
		editor.revealRange(new vscode.Range(newPosition, newPosition));

		vscode.window.showInformationMessage(`✓ ${hasSelection ? 'Nahrazeno' : 'Vloženo'}: "${formattedContent}"`);
	} catch (error) {
		const msg = error instanceof Error ? error.message : String(error);
		vscode.window.showErrorMessage(`✗ Chyba: ${msg}`);
	}
}

/**
 * Vloží údaj z FA ve formátu [:názevÚdaje:] na pozici kurzoru (Shift+Ctrl+])
 */
export async function vlozitUdajSDvojteckami(): Promise<void> {
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

		// Formátuj jako [:názevÚdaje:]
		const formattedContent = `[:${content}:]`;

		// Zkontroluj, jestli je nějaký text označen (selekce)
		const selection = editor.selection;
		const hasSelection = !selection.isEmpty;
		
		// Vlož nebo nahraď obsah
		await editor.edit(editBuilder => {
			if (hasSelection) {
				// Pokud je označený blok, smaž ho a nahraď obsahem
				editBuilder.replace(selection, formattedContent);
			} else {
				// Pokud není označený blok, vlož obsah na pozici kurzoru
				const position = editor.selection.active;
				editBuilder.insert(position, formattedContent);
			}
		});

		// Umísti kurzor za vložený text
		let newPosition: vscode.Position;
		if (hasSelection) {
			// Po nahrazení selekce je kurzor na začátku nahrazeného textu
			const startPos = selection.start;
			newPosition = new vscode.Position(startPos.line, startPos.character + formattedContent.length);
		} else {
			// Po vložení je kurzor na původní pozici, musíme přidat délku vloženého textu
			const originalPosition = selection.active;
			newPosition = new vscode.Position(originalPosition.line, originalPosition.character + formattedContent.length);
		}
		editor.selection = new vscode.Selection(newPosition, newPosition);
		editor.revealRange(new vscode.Range(newPosition, newPosition));

		vscode.window.showInformationMessage(`✓ ${hasSelection ? 'Nahrazeno' : 'Vloženo'}: "${formattedContent}"`);
	} catch (error) {
		const msg = error instanceof Error ? error.message : String(error);
		vscode.window.showErrorMessage(`✗ Chyba: ${msg}`);
	}
}

/**
 * Toggle msgv - vloží msgv('') nebo smaže řádek s msgv( (Alt+F9)
 */
export async function toggleMsgv(): Promise<void> {
	try {
		const editor = vscode.window.activeTextEditor;
		if (!editor) {
			vscode.window.showErrorMessage('✗ Žádný editor otevřen');
			return;
		}

		const position = editor.selection.active;
		const line = editor.document.lineAt(position.line);
		const lineText = line.text;
		
		// Zkontroluj, jestli řádek začíná msgv( (s případnými bílými znaky na začátku)
		const trimmed = lineText.trim();
		
		if (trimmed.startsWith('msgv(')) {
			// Smaž celý řádek
			await editor.edit(editBuilder => {
				editBuilder.delete(line.rangeIncludingLineBreak);
			});

			// Pokud je to poslední řádek, umísti kurzor na konec předchozího řádku
			// Jinak umísti kurzor na začátek následujícího řádku
			let newPosition: vscode.Position;
			if (position.line >= editor.document.lineCount - 1) {
				// Byl to poslední řádek
				if (position.line > 0) {
					const prevLine = editor.document.lineAt(position.line - 1);
					newPosition = new vscode.Position(position.line - 1, prevLine.text.length);
				} else {
					// Byl to jediný řádek
					newPosition = new vscode.Position(0, 0);
				}
			} else {
				// Není to poslední řádek, umísti na začátek následujícího řádku
				newPosition = new vscode.Position(position.line, 0);
			}
			
			editor.selection = new vscode.Selection(newPosition, newPosition);
			editor.revealRange(new vscode.Range(newPosition, newPosition));

			vscode.window.showInformationMessage('✓ Řádek s msgv( smazán');
		} else {
			// Zkontroluj, jestli je aktuální řádek prázdný
			const isLineEmpty = trimmed.length === 0;
			
			if (isLineEmpty) {
				// Pokud je řádek prázdný, vlož msgv('') na aktuální řádek
				const insertPosition = new vscode.Position(position.line, 0);
				
				await editor.edit(editBuilder => {
					editBuilder.insert(insertPosition, 'msgv(\'\');');
				});

				// Umísti kurzor mezi apostrofy (po msgv(')
				// msgv(' = 6 znaků, kurzor na pozici 6 (mezi apostrofy)
				const cursorPosition = new vscode.Position(position.line, 6);
				editor.selection = new vscode.Selection(cursorPosition, cursorPosition);
				editor.revealRange(new vscode.Range(cursorPosition, cursorPosition));

				vscode.window.showInformationMessage('✓ Vloženo msgv(\'\')');
			} else {
				// Pokud řádek není prázdný, vlož msgv('') na nový řádek před aktuální řádek
				const insertLine = position.line;
				const insertPosition = new vscode.Position(insertLine, 0);
				
				await editor.edit(editBuilder => {
					editBuilder.insert(insertPosition, 'msgv(\'\');\n');
				});

				// Umísti kurzor mezi apostrofy (po msgv(')
				// msgv(' = 6 znaků, kurzor na pozici 6 (mezi apostrofy)
				const cursorPosition = new vscode.Position(insertLine, 6);
				editor.selection = new vscode.Selection(cursorPosition, cursorPosition);
				editor.revealRange(new vscode.Range(cursorPosition, cursorPosition));

				vscode.window.showInformationMessage('✓ Vloženo msgv(\'\')');
			}
		}
	} catch (error) {
		const msg = error instanceof Error ? error.message : String(error);
		vscode.window.showErrorMessage(`✗ Chyba: ${msg}`);
	}
}

/**
 * Hledat od začátku - otevře Find dialog, přesune kurzor na začátek dokumentu a znovu otevře Find dialog (Alt+Z)
 */
export async function hledatOdZacatku(): Promise<void> {
	try {
		const editor = vscode.window.activeTextEditor;
		if (!editor) {
			vscode.window.showErrorMessage('✗ Žádný editor otevřen');
			return;
		}

		// 1. Otevřít Find dialog (Ctrl+F)
		await vscode.commands.executeCommand('actions.find');
		
		// Malé zpoždění pro jistotu
		await new Promise(resolve => setTimeout(resolve, 50));
		
		// 2. Přesunout kurzor na začátek dokumentu (Ctrl+Home)
		await vscode.commands.executeCommand('cursorTop');
		
		// Malé zpoždění pro jistotu
		await new Promise(resolve => setTimeout(resolve, 50));
		
		// 3. Znovu otevřít Find dialog (Ctrl+F) - hledání začne od začátku
		await vscode.commands.executeCommand('actions.find');
		
	} catch (error) {
		const msg = error instanceof Error ? error.message : String(error);
		vscode.window.showErrorMessage(`✗ Chyba: ${msg}`);
	}
}

