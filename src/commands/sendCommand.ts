import * as vscode from 'vscode';
import * as fs from 'fs';
import * as path from 'path';
import * as child_process from 'child_process';
import { writeFACommand, getFafieldPath, getFacmdPath, getFsBridgeWorkspaceRoot, getFAInstanceNotFoundMessage } from '../utils/fsBridge';
import { getIntelliSenseProvider } from '../providers/PascalIntelliSenseProvider';

/**
 * Smaže famsgstate.json pokud existuje
 * Používá vždy .fsbridge složku z aktuálního workspace
 */
function deleteFamsgState(): void {
	try {
		const workspaceRoot = getFsBridgeWorkspaceRoot();
		if (!workspaceRoot) {
			return;
		}

		const fsbridgeDir = path.join(workspaceRoot, '.fsbridge');
		const statePath = path.join(fsbridgeDir, 'famsgstate.json');
		
		if (fs.existsSync(statePath)) {
			fs.unlinkSync(statePath);
			console.log(`[FA Bridge] Smazán famsgstate.json: ${statePath}`);
		}
	} catch (error) {
		// Tichá chyba - nechceme rušit uživatele při ukládání
		const msg = error instanceof Error ? error.message : String(error);
		console.log(`[FA Bridge] Chyba při mazání famsgstate.json: ${msg}`);
	}
}

/**
 * Aktivuje FA do popředí bez ukládání souboru nebo buildování
 */
export async function faDoPopredi(): Promise<void> {
	try {
		await writeFACommand('FA_do_popredi');
	} catch (error) {
		const msg = error instanceof Error ? error.message : String(error);
		vscode.window.showErrorMessage(`✗ Chyba: ${msg}`);
	}
}

/**
 * Uloží aktuální soubor pomocí VS Code API (zajišťuje trigger Local History)
 * Pokud soubor nemá změny, jen aktivuje FA do popředí
 * Aktivace FA se provede POUZE pokud soubor odpovídá nějaké běžící FA instanci
 */
export async function ulozitSoubor(): Promise<void> {
	try {
		// Smaž famsgstate.json při každém volání (Ctrl+S nebo Alt+Q)
		deleteFamsgState();

		const editor = vscode.window.activeTextEditor;
		if (!editor) {
			vscode.window.showErrorMessage('✗ Žádný editor otevřen');
			return;
		}

		const document = editor.document;
		
		// Pokud je dokument neuložený, použij standardní save dialog (bez aktivace FA)
		if (document.isUntitled) {
			await vscode.commands.executeCommand('workbench.action.files.save');
			return;
	}

	// Zkontroluj, jestli je soubor úplně prázdný (0 bytů) - pokud ano, vlož jeden prázdný řádek
	const fileContent = document.getText();
	if (fileContent === '') {
		// Soubor je prázdný - vlož jeden prázdný řádek na začátek
		await editor.edit(editBuilder => {
			editBuilder.insert(new vscode.Position(0, 0), '\n');
		});
		// Počkej krátce, aby se editace dokončila
		await new Promise(resolve => setTimeout(resolve, 50));
	}

	// Zkontroluj, jestli soubor odpovídá nějaké FA instanci
	const workspaceRoot = getFsBridgeWorkspaceRoot();
	const hasFAInstance = workspaceRoot ? getFacmdPath(workspaceRoot) !== null : false;

		// Pokud soubor obsahuje změny, ulož ho
		if (document.isDirty) {
			// Použij VS Code WorkspaceEdit API pro uložení - vyvolá standardní save flow včetně onDidSaveTextDocument eventu
			// onDidSaveTextDocument listener se automaticky postará o uložení historie pro .pas soubory
			await document.save();
			
			// Aktivuj FA pouze pokud soubor odpovídá FA instanci
			if (hasFAInstance) {
				await writeFACommand('Aktivovat_formular');
			} else {
				vscode.window.showWarningMessage('⚠ Soubor uložen, ale neodpovídá žádné běžící FA instanci - FA nebyla aktivována');
			}
		} else {
			// Soubor nemá změny, aktivuj FA pouze pokud odpovídá FA instanci
			if (hasFAInstance) {
				await writeFACommand('Aktivovat_formular');
			} else {
				vscode.window.showWarningMessage('⚠ Soubor neodpovídá žádné běžící FA instanci - FA nebyla aktivována');
			}
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

		// Přečti obsah z fafield.txt (podporuje více instancí FA)
		const workspaceRoot = getFsBridgeWorkspaceRoot();
		if (!workspaceRoot) {
			throw new Error('Žádný workspace otevřen nebo .fsbridge složka nenalezena');
		}

		const faFieldPath = getFafieldPath(workspaceRoot);
		if (!faFieldPath) {
			vscode.window.showErrorMessage(getFAInstanceNotFoundMessage(workspaceRoot));
			return;
		}

		if (!fs.existsSync(faFieldPath)) {
			vscode.window.showErrorMessage(`✗ Soubor ${path.basename(faFieldPath)} neexistuje`);
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
		// Přečti obsah z fafield.txt (podporuje více instancí FA)
		const workspaceRoot = getFsBridgeWorkspaceRoot();
		if (!workspaceRoot) {
			throw new Error('Žádný workspace otevřen nebo .fsbridge složka nenalezena');
		}

		const faFieldPath = getFafieldPath(workspaceRoot);
		if (!faFieldPath) {
			vscode.window.showErrorMessage(getFAInstanceNotFoundMessage(workspaceRoot));
			return;
		}

		if (!fs.existsSync(faFieldPath)) {
			vscode.window.showErrorMessage(`✗ Soubor ${path.basename(faFieldPath)} neexistuje`);
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
 * Přesune caret na začátek scriptu, najde první výskyt hledaného textu a označí ho v editoru
 * Dialog hledání se po nalezení zavře, focus zůstává v editoru
 * @param facmdPath Cesta k facmd_from_fa.txt souboru pro správnou identifikaci FA instance
 */
export async function hledatPodleAktUdaje(facmdPath?: string): Promise<void> {
	try {
		// Pokud je facmdPath zadaná, použijeme ji pro identifikaci správné instance
		let targetScriptPath = '';
		let instanceDir = '';
		
		if (facmdPath) {
			// Extrahuj instance složku přímo z facmdPath
			instanceDir = path.dirname(facmdPath);
			
			// Přečti current_form.txt z instance složky - obsahuje ABSOLUTNÍ CESTU k souboru
			const currentFormFile = path.join(instanceDir, 'current_form.txt');
			
			if (fs.existsSync(currentFormFile)) {
				try {
					let content = fs.readFileSync(currentFormFile, 'utf-8');
					if (content.charCodeAt(0) === 0xFEFF) {
						content = content.slice(1);
					}
					targetScriptPath = content.trim();
				} catch (error) {
					console.log(`[hledatPodleAktUdaje] Chyba při čtení current_form.txt: ${error}`);
				}
			}
		}
		
	// Najdi správnou záložku podle cesty (pokud známe cestu)
	let targetEditor: vscode.TextEditor | null = null;
	let tabWasSwitched = false;
	
	if (targetScriptPath) {
		// Normalizuj cílovou cestu pro porovnání (Windows: case-insensitive)
		const normalizedTargetPath = path.normalize(targetScriptPath).toLowerCase();
		
		// Najdi záložku s odpovídající cestou a aktivuj ji
		for (const tabGroup of vscode.window.tabGroups.all) {
			for (const tab of tabGroup.tabs) {
				if (tab.input instanceof vscode.TabInputText) {
					const tabInput = tab.input as vscode.TabInputText;
					const tabPath = tabInput.uri.fsPath;
					const normalizedTabPath = path.normalize(tabPath).toLowerCase();
					
				// Porovnej celé cesty (case-insensitive na Windows)
				if (normalizedTabPath === normalizedTargetPath) {
					// Aktivuj tuto záložku
					await vscode.window.showTextDocument(tabInput.uri, {
						preview: false,
						preserveFocus: false
					});
					targetEditor = vscode.window.activeTextEditor || null;
					tabWasSwitched = true;
					break;
				}
				}
			}
			if (targetEditor) break;
		}
	}
	
	// Pokud jsme nenašli správnou záložku, použij aktivní editor (fallback)
	if (!targetEditor) {
		targetEditor = vscode.window.activeTextEditor || null;
	}
	
	if (!targetEditor) {
		vscode.window.showErrorMessage('✗ Žádný editor otevřen');
		return;
	}
	
	// Pokud byla přepnuta záložka, počkej delší dobu než se stabilizuje
	if (tabWasSwitched) {
		await new Promise(resolve => setTimeout(resolve, 300));
	}

		// Přečti obsah z fafield.txt (z příslušné instance)
		const workspaceRoot = getFsBridgeWorkspaceRoot();
		if (!workspaceRoot) {
			throw new Error('Žádný workspace otevřen nebo .fsbridge složka nenalezena');
		}

		let faFieldPath: string | null = null;
		
		if (instanceDir) {
			// Máme instanci, použij fafield.txt z ní
			faFieldPath = path.join(instanceDir, 'fafield.txt');
		} else {
			// Fallback - použij obecnou funkci
			faFieldPath = getFafieldPath(workspaceRoot);
		}
		
		if (!faFieldPath) {
			vscode.window.showErrorMessage(getFAInstanceNotFoundMessage(workspaceRoot));
			return;
		}

		if (!fs.existsSync(faFieldPath)) {
			vscode.window.showErrorMessage(`✗ Soubor ${path.basename(faFieldPath)} neexistuje`);
			return;
		}

		// Přečti obsah
		let content = fs.readFileSync(faFieldPath, 'utf-8');
		
		// Odstraň BOM pokud existuje
		if (content.charCodeAt(0) === 0xFEFF) {
			content = content.slice(1);
		}
		
	// Odstraň trailing whitespace
	const searchText = content.trim();

	if (!searchText) {
		vscode.window.showErrorMessage(`✗ Obsah ${path.basename(faFieldPath)} je prázdný`);
		return;
	}

	// 1. Skočit na konec dokumentu (Find dialog se nepředvyplní slovem)
	await vscode.commands.executeCommand('cursorBottom');
	await new Promise(resolve => setTimeout(resolve, 50));
	
	// 2. Zavřít případný otevřený Find dialog
	await vscode.commands.executeCommand('closeFindWidget');
	await new Promise(resolve => setTimeout(resolve, 50));
	
	// 3. Vložit název aktuálního údaje z FA do clipboardu
	await vscode.env.clipboard.writeText(searchText);
	
	// 4. Otevřít dialog hledání
	await vscode.commands.executeCommand('actions.find');
	await new Promise(resolve => setTimeout(resolve, 150));
	
	// 5. Vložit název údaje do dialogu (Ctrl+V)
	await vscode.commands.executeCommand('editor.action.clipboardPasteAction');
	await new Promise(resolve => setTimeout(resolve, 50));

	// Find dialog automaticky najde první výskyt od začátku (wraparound z konce)
	// Dialog zůstává otevřený pro další navigaci
		
	} catch (error) {
		const msg = error instanceof Error ? error.message : String(error);
		vscode.window.showErrorMessage(`✗ Chyba: ${msg}`);
	}
}

/**
 * Najde údaj ve formuláři - vezme slovo pod kurzorem, zapíše do fafield.txt a pošle příkaz (Ctrl+U)
 */
export async function najitUdaj(): Promise<void> {
	try {
		const editor = vscode.window.activeTextEditor;
		if (!editor) {
			vscode.window.showErrorMessage('✗ Žádný editor otevřen');
			return;
		}

	// Získej slovo pod kurzorem (nebo prázdný řetězec pokud kurzor není na slově)
	const position = editor.selection.active;
	const wordRange = editor.document.getWordRangeAtPosition(position);
	
	const word = wordRange ? editor.document.getText(wordRange) : '';

		// Přečti workspace (podporuje více instancí FA)
		const workspaceRoot = getFsBridgeWorkspaceRoot();
		if (!workspaceRoot) {
			throw new Error('Žádný workspace otevřen nebo .fsbridge složka nenalezena');
		}

		const fsBridgeDir = path.join(workspaceRoot, '.fsbridge');

		// Zajisti že .fsbridge složka existuje
		if (!fs.existsSync(fsBridgeDir)) {
			fs.mkdirSync(fsBridgeDir, { recursive: true });
		}

		// Použij instance-specific cestu
		const faFieldPath = getFafieldPath(workspaceRoot);
		if (!faFieldPath) {
			vscode.window.showErrorMessage(getFAInstanceNotFoundMessage(workspaceRoot));
			return;
		}

		// UTF-8 s BOM (EF BB BF)
		const bom = Buffer.from([0xef, 0xbb, 0xbf]);
		const wordBuffer = Buffer.from(word, 'utf-8');
		const content = Buffer.concat([bom, wordBuffer]);

		// Zapiš slovo do fafield.txt
		fs.writeFileSync(faFieldPath, content);

	// Pošli příkaz do FA
	await writeFACommand('Najit_udaj');

	if (word) {
		vscode.window.showInformationMessage(`✓ Hledám údaj: "${word}"`);
	} else {
		vscode.window.showInformationMessage(`✓ Hledám údaj (prázdný řetězec)`);
	}
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

		// Přečti obsah z fafield.txt (podporuje více instancí FA)
		const workspaceRoot = getFsBridgeWorkspaceRoot();
		if (!workspaceRoot) {
			throw new Error('Žádný workspace otevřen nebo .fsbridge složka nenalezena');
		}

		const faFieldPath = getFafieldPath(workspaceRoot);
		if (!faFieldPath) {
			vscode.window.showErrorMessage(getFAInstanceNotFoundMessage(workspaceRoot));
			return;
		}

		if (!fs.existsSync(faFieldPath)) {
			vscode.window.showErrorMessage(`✗ Soubor ${path.basename(faFieldPath)} neexistuje`);
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

		// Přečti obsah z fafield.txt (podporuje více instancí FA)
		const workspaceRoot = getFsBridgeWorkspaceRoot();
		if (!workspaceRoot) {
			throw new Error('Žádný workspace otevřen nebo .fsbridge složka nenalezena');
		}

		const faFieldPath = getFafieldPath(workspaceRoot);
		if (!faFieldPath) {
			vscode.window.showErrorMessage(getFAInstanceNotFoundMessage(workspaceRoot));
			return;
		}

		if (!fs.existsSync(faFieldPath)) {
			vscode.window.showErrorMessage(`✗ Soubor ${path.basename(faFieldPath)} neexistuje`);
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

// Globální reference na help WebView panel pro reuse
let helpPanel: vscode.WebviewPanel | undefined = undefined;

/**
 * Otevře TextSearch.exe se slovem pod kurzorem (Ctrl+Shift+F1)
 * Pokud kurzor není na slově, otevře TextSearch.exe bez parametru
 */
export async function openTextSearch(): Promise<void> {
	try {
		const editor = vscode.window.activeTextEditor;
		if (!editor) {
			vscode.window.showErrorMessage('✗ Žádný editor otevřen');
			return;
		}

		// Získej slovo pod kurzorem
		const position = editor.selection.active;
		const wordRange = editor.document.getWordRangeAtPosition(position);
		
		let searchWord = '';
		
		if (wordRange) {
			searchWord = editor.document.getText(wordRange);
		}

		// Najdi workspace root
		const workspaceRoot = getFsBridgeWorkspaceRoot();
		if (!workspaceRoot) {
			throw new Error('Žádný workspace otevřen nebo .fsbridge složka nenalezena');
		}

		// Cesta k TextSearch.exe v _source složce
		const textSearchPath = path.join(workspaceRoot, '_source', 'TextSearch.exe');

		if (!fs.existsSync(textSearchPath)) {
			vscode.window.showErrorMessage(`✗ TextSearch.exe nebyl nalezen: ${textSearchPath}`);
			return;
		}

		// Spusť TextSearch.exe s parametrem hledaného slova (pokud existuje)
		// Parametr musí být v uvozovkách pro správné zpracování
		const command = searchWord 
			? `"${textSearchPath}" "${searchWord}"` 
			: `"${textSearchPath}"`;
		
		child_process.exec(command, (error, stdout, stderr) => {
			if (error) {
				console.error(`[TextSearch] Chyba při spuštění: ${error.message}`);
				if (stderr) {
					console.error(`[TextSearch] Stderr: ${stderr}`);
				}
				vscode.window.showErrorMessage(`✗ Chyba při spuštění TextSearch: ${error.message}`);
			} else {
				console.log(`[TextSearch] Spuštěno: ${command}`);
			}
		});
	} catch (error) {
		const msg = error instanceof Error ? error.message : String(error);
		vscode.window.showErrorMessage(`✗ Chyba: ${msg}`);
	}
}

/**
 * Otevře FA.chm soubor pomocí Windows CHM prohlížeče (Ctrl+Alt+F1)
 */
export async function openFaChm(): Promise<void> {
	try {
		// Najdi workspace root
		const workspaceRoot = getFsBridgeWorkspaceRoot();
		if (!workspaceRoot) {
			throw new Error('Žádný workspace otevřen nebo .fsbridge složka nenalezena');
		}

		// Cesta k FA.chm v _source složce
		const faChmPath = path.join(workspaceRoot, '_source', 'FA.chm');

		if (!fs.existsSync(faChmPath)) {
			vscode.window.showErrorMessage(`✗ FA.chm nebyl nalezen: ${faChmPath}`);
			return;
		}

		// Otevři FA.chm pomocí Windows výchozího CHM prohlížeče
		// Použij "start" příkaz pro otevření s výchozím programem
		const command = `start "" "${faChmPath}"`;
		
		child_process.exec(command, { shell: 'cmd.exe' }, (error, stdout, stderr) => {
			if (error) {
				console.error(`[FA.chm] Chyba při otevírání: ${error.message}`);
				if (stderr) {
					console.error(`[FA.chm] Stderr: ${stderr}`);
				}
				vscode.window.showErrorMessage(`✗ Chyba při otevírání FA.chm: ${error.message}`);
			} else {
				console.log(`[FA.chm] Otevřen: ${faChmPath}`);
			}
		});
	} catch (error) {
		const msg = error instanceof Error ? error.message : String(error);
		vscode.window.showErrorMessage(`✗ Chyba: ${msg}`);
	}
}

/**
 * Otevře HTML help soubor s tématem podle slova pod kurzorem (Ctrl+F1)
 * Používá HTML help ze složky _source/fahlp místo FA.chm
 */
export async function openHelp(): Promise<void> {
	try {
		const editor = vscode.window.activeTextEditor;
		if (!editor) {
			vscode.window.showErrorMessage('✗ Žádný editor otevřen');
			return;
		}

		// Získej slovo pod kurzorem
		const position = editor.selection.active;
		const wordRange = editor.document.getWordRangeAtPosition(position);
		
		let searchWord = ''; // Slovo pro vyhledávání v indexu
		
		if (wordRange) {
			searchWord = editor.document.getText(wordRange).toLowerCase();
		}

		// Najdi workspace root
		const workspaceRoot = getFsBridgeWorkspaceRoot();
		if (!workspaceRoot) {
			throw new Error('Žádný workspace otevřen nebo .fsbridge složka nenalezena');
		}

		// Cesta k indexu a HTML help složce
		const helpIndexPath = path.join(workspaceRoot, '_source', 'fahlp', 'fa_help_index.json');
		const helpFolderPath = path.join(workspaceRoot, '_source', 'fahlp');

		if (!fs.existsSync(helpIndexPath)) {
			vscode.window.showErrorMessage(`✗ Help index nebyl nalezen: ${helpIndexPath}`);
			return;
		}

		// Načti index JSON
		let helpIndex: { [key: string]: string } = {};
		try {
			const indexContent = fs.readFileSync(helpIndexPath, 'utf-8');
			helpIndex = JSON.parse(indexContent);
		} catch (error) {
			const msg = error instanceof Error ? error.message : String(error);
			vscode.window.showErrorMessage(`✗ Chyba při načítání help indexu: ${msg}`);
			return;
		}

		// Vyhledej HTML soubor v indexu (case-insensitive)
		let htmlFile = 'hlavni_funkce.htm'; // Výchozí téma
		
		if (searchWord) {
			// Zkus najít přesnou shodu (case-insensitive)
			const lowerIndex: { [key: string]: string } = {};
			for (const [key, value] of Object.entries(helpIndex)) {
				lowerIndex[key.toLowerCase()] = value;
			}
			
			if (lowerIndex[searchWord]) {
				htmlFile = lowerIndex[searchWord];
			} else {
				// Pokud není přesná shoda, použij výchozí
				console.log(`[Help] Slovo "${searchWord}" nebylo nalezeno v indexu, použiji výchozí téma`);
			}
		}

		// Cesta k HTML souboru
		const htmlFilePath = path.join(helpFolderPath, htmlFile);

		if (!fs.existsSync(htmlFilePath)) {
			vscode.window.showErrorMessage(`✗ Help soubor nebyl nalezen: ${htmlFilePath}`);
			return;
		}

		// Načti obsah HTML souboru
		let htmlContent = '';
		try {
			htmlContent = fs.readFileSync(htmlFilePath, 'utf-8');
		} catch (error) {
			const msg = error instanceof Error ? error.message : String(error);
			vscode.window.showErrorMessage(`✗ Chyba při načítání HTML souboru: ${msg}`);
			return;
		}

		// Pokud už existuje panel, aktualizuj ho
		if (helpPanel) {
			helpPanel.title = `FA Help: ${path.basename(htmlFile, '.htm')}`;
			helpPanel.webview.html = getWebviewContent(htmlContent, helpFolderPath, htmlFile);
			helpPanel.reveal(); // Zobraz panel
		} else {
			// Vytvoř nový panel
			helpPanel = vscode.window.createWebviewPanel(
				'faHelp',
				`FA Help: ${path.basename(htmlFile, '.htm')}`,
				vscode.ViewColumn.Beside,
				{
					enableScripts: true,
					localResourceRoots: [vscode.Uri.file(helpFolderPath)]
				}
			);

			helpPanel.webview.html = getWebviewContent(htmlContent, helpFolderPath, htmlFile);

			// Zpracování kliknutí na odkazy v HTML helpu
			helpPanel.webview.onDidReceiveMessage(async (message) => {
				if (message.command === 'openHelp') {
					const targetFile = message.file;
					const targetPath = path.join(helpFolderPath, targetFile);
					
					if (fs.existsSync(targetPath)) {
						try {
							const newHtmlContent = fs.readFileSync(targetPath, 'utf-8');
							if (helpPanel) {
								helpPanel.title = `FA Help: ${path.basename(targetFile, '.htm')}`;
								helpPanel.webview.html = getWebviewContent(newHtmlContent, helpFolderPath, targetFile);
							}
						} catch (error) {
							const msg = error instanceof Error ? error.message : String(error);
							vscode.window.showErrorMessage(`✗ Chyba při načítání help souboru: ${msg}`);
						}
					}
				}
			});

			// Při zavření panelu smaž referenci
			helpPanel.onDidDispose(() => {
				helpPanel = undefined;
			}, null);
		}

		console.log(`[Help] Otevřen help: ${htmlFile}${searchWord ? ` (pro slovo: ${searchWord})` : ''}`);
	} catch (error) {
		const msg = error instanceof Error ? error.message : String(error);
		vscode.window.showErrorMessage(`✗ Chyba: ${msg}`);
	}
}

/**
 * Vytvoří HTML obsah pro WebView s podporou relativních cest
 */
function getWebviewContent(htmlContent: string, helpFolderPath: string, htmlFile: string): string {
	if (!helpPanel) {
		return htmlContent;
	}

	// Funkce pro konverzi relativní cesty na webview URI
	const resourceUri = (relativePath: string): string => {
		const fullPath = path.resolve(helpFolderPath, relativePath);
		const uri = vscode.Uri.file(fullPath);
		return helpPanel!.webview.asWebviewUri(uri).toString();
	};

	// Uprav relativní cesty k obrázkům, CSS a JS souborům
	// Pro obrázky: src="file.png" -> src="vscode-webview-resource://..."
	htmlContent = htmlContent.replace(/src="([^"]+)"/gi, (match, srcPath) => {
		if (srcPath.startsWith('http') || srcPath.startsWith('data:') || srcPath.startsWith('vscode-webview-resource:')) {
			return match; // Nech externí URL, data URI a už konvertované URI
		}
		// Zkus najít soubor relativně k helpFolderPath
		const fullPath = path.resolve(helpFolderPath, srcPath);
		if (fs.existsSync(fullPath)) {
			return `src="${resourceUri(srcPath)}"`;
		}
		return match;
	});

	// Pro CSS: href="file.css" -> href="vscode-webview-resource://..."
	htmlContent = htmlContent.replace(/href="([^"]+\.css)"/gi, (match, hrefPath) => {
		if (hrefPath.startsWith('http') || hrefPath.startsWith('vscode-webview-resource:')) {
			return match; // Nech externí URL a už konvertované URI
		}
		const fullPath = path.resolve(helpFolderPath, hrefPath);
		if (fs.existsSync(fullPath)) {
			return `href="${resourceUri(hrefPath)}"`;
		}
		return match;
	});

	// Pro JS: src="file.js" -> src="vscode-webview-resource://..."
	htmlContent = htmlContent.replace(/<script([^>]*)src="([^"]+\.js)"([^>]*)>/gi, (match, before, srcPath, after) => {
		if (srcPath.startsWith('http') || srcPath.startsWith('vscode-webview-resource:')) {
			return match; // Nech externí URL a už konvertované URI
		}
		const fullPath = path.resolve(helpFolderPath, srcPath);
		if (fs.existsSync(fullPath)) {
			return `<script${before}src="${resourceUri(srcPath)}"${after}>`;
		}
		return match;
	});

	// Uprav odkazy na další HTML stránky - přidej onclick handler pro navigaci
	// Pro odkazy: href="file.htm" -> přidej onclick handler
	htmlContent = htmlContent.replace(/href="([^"]+\.htm)"/gi, (match, hrefPath) => {
		if (hrefPath.startsWith('http') || hrefPath.startsWith('vscode-webview-resource:')) {
			return match; // Nech externí URL a už konvertované URI
		}
		// Přidej onclick handler pro navigaci v rámci webview
		return `href="#" onclick="openHelpFile('${hrefPath}'); return false;"`;
	});

	// Přidej JavaScript pro zpracování kliknutí na odkazy
	if (!htmlContent.includes('function openHelpFile')) {
		const scriptTag = `
<script>
	function openHelpFile(file) {
		const vscode = acquireVsCodeApi();
		vscode.postMessage({
			command: 'openHelp',
			file: file
		});
	}
</script>
`;
		// Vlož script před </body> nebo před </html>
		if (htmlContent.includes('</body>')) {
			htmlContent = htmlContent.replace('</body>', `${scriptTag}</body>`);
		} else if (htmlContent.includes('</html>')) {
			htmlContent = htmlContent.replace('</html>', `${scriptTag}</html>`);
		} else {
			htmlContent += scriptTag;
		}
	}

	return htmlContent;
}

