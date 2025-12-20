import * as vscode from 'vscode';

/**
 * Provider pro zvýrazňování odpovídajících begin/end bloků v Pascal kódu
 * Zvýrazňuje nejbližší pár begin/end, který obklopuje aktuální pozici kurzoru
 */
export class BeginEndMatcher {
	private decorationType: vscode.TextEditorDecorationType;
	private activeEditor: vscode.TextEditor | undefined;
	private disposables: vscode.Disposable[] = [];

	constructor() {
		// Vytvoř decoration type pro zvýraznění begin/end páru (zelená barva)
		this.decorationType = vscode.window.createTextEditorDecorationType({
			backgroundColor: new vscode.ThemeColor('editorBracketMatch.background'),
			borderColor: new vscode.ThemeColor('editorBracketMatch.border'),
			borderWidth: '1px',
			borderStyle: 'solid',
			overviewRulerColor: new vscode.ThemeColor('editorBracketMatch.border'),
			overviewRulerLane: vscode.OverviewRulerLane.Center
		});

		// Sleduj změny aktivního editoru
		this.activeEditor = vscode.window.activeTextEditor;
		if (this.activeEditor) {
			this.updateHighlight();
		}

		// Sleduj změny pozice kurzoru
		const cursorChangeDisposable = vscode.window.onDidChangeTextEditorSelection(() => {
			this.updateHighlight();
		});
		this.disposables.push(cursorChangeDisposable);

		// Sleduj změny dokumentu
		const documentChangeDisposable = vscode.workspace.onDidChangeTextDocument(() => {
			this.updateHighlight();
		});
		this.disposables.push(documentChangeDisposable);

		// Sleduj změny aktivního editoru
		const editorChangeDisposable = vscode.window.onDidChangeActiveTextEditor(() => {
			this.activeEditor = vscode.window.activeTextEditor;
			this.updateHighlight();
		});
		this.disposables.push(editorChangeDisposable);
	}

	/**
	 * Najde všechny begin a end pozice v dokumentu
	 */
	private findAllBeginEnd(document: vscode.TextDocument): {
		begins: Array<{ offset: number; line: number; column: number }>;
		ends: Array<{ offset: number; line: number; column: number }>;
	} {
		const text = document.getText();
		
		// Regex pro begin a end (case-insensitive, musí být samostatné slovo)
		const beginRegex = /\b(?i:begin)\b/g;
		const endRegex = /\b(?i:end)\b/g;

		const begins: Array<{ offset: number; line: number; column: number }> = [];
		const ends: Array<{ offset: number; line: number; column: number }> = [];

		let match;
		while ((match = beginRegex.exec(text)) !== null) {
			const pos = document.positionAt(match.index);
			begins.push({
				offset: match.index,
				line: pos.line,
				column: pos.character
			});
		}

		while ((match = endRegex.exec(text)) !== null) {
			const pos = document.positionAt(match.index);
			ends.push({
				offset: match.index,
				line: pos.line,
				column: pos.character
			});
		}

		return { begins, ends };
	}

	/**
	 * Najde odpovídající end pro daný begin offset
	 */
	private findMatchingEnd(
		document: vscode.TextDocument,
		beginOffset: number,
		begins: Array<{ offset: number }>,
		ends: Array<{ offset: number }>
	): { offset: number; line: number; column: number } | null {
		// Najdi všechny begin a end mezi beginOffset a koncem souboru
		const relevantBegins = begins.filter(b => b.offset > beginOffset);
		const relevantEnds = ends.filter(e => e.offset > beginOffset);

		// Seřaď podle pozice
		relevantBegins.sort((a, b) => a.offset - b.offset);
		relevantEnds.sort((a, b) => a.offset - b.offset);

		// Najdi první end, který není "překrytý" beginem
		let depth = 1; // Začínáme s hloubkou 1 (máme začátek)
		let beginIndex = 0;
		let endIndex = 0;

		while (endIndex < relevantEnds.length) {
			// Pokud je další begin před dalším endem, zvýš hloubku
			if (beginIndex < relevantBegins.length && 
				relevantBegins[beginIndex].offset < relevantEnds[endIndex].offset) {
				depth++;
				beginIndex++;
			} else {
				depth--;
				if (depth === 0) {
					// Našli jsme odpovídající end
					const matchingEnd = relevantEnds[endIndex];
					const pos = document.positionAt(matchingEnd.offset);
					return {
						offset: matchingEnd.offset,
						line: pos.line,
						column: pos.character
					};
				}
				endIndex++;
			}
		}

		return null;
	}

	/**
	 * Najde odpovídající begin pro daný end offset
	 */
	private findMatchingBegin(
		document: vscode.TextDocument,
		endOffset: number,
		begins: Array<{ offset: number }>,
		ends: Array<{ offset: number }>
	): { offset: number; line: number; column: number } | null {
		// Najdi všechny begin a end před endOffset
		const relevantBegins = begins.filter(b => b.offset < endOffset);
		const relevantEnds = ends.filter(e => e.offset < endOffset);

		// Seřaď podle pozice (odzadu)
		relevantBegins.sort((a, b) => b.offset - a.offset);
		relevantEnds.sort((a, b) => b.offset - a.offset);

		// Najdi první begin, který není "překrytý" endem
		let depth = 1; // Začínáme s hloubkou 1 (máme konec)
		let beginIndex = 0;
		let endIndex = 0;

		while (beginIndex < relevantBegins.length) {
			// Pokud je další end před dalším beginem, zvýš hloubku
			if (endIndex < relevantEnds.length && 
				relevantEnds[endIndex].offset > relevantBegins[beginIndex].offset) {
				depth++;
				endIndex++;
			} else {
				depth--;
				if (depth === 0) {
					// Našli jsme odpovídající begin
					const matchingBegin = relevantBegins[beginIndex];
					const pos = document.positionAt(matchingBegin.offset);
					return {
						offset: matchingBegin.offset,
						line: pos.line,
						column: pos.character
					};
				}
				beginIndex++;
			}
		}

		return null;
	}

	/**
	 * Najde nejbližší begin/end pár, který obklopuje pozici kurzoru
	 */
	private findEnclosingBeginEnd(
		document: vscode.TextDocument,
		cursorOffset: number,
		begins: Array<{ offset: number; line: number; column: number }>,
		ends: Array<{ offset: number; line: number; column: number }>
	): {
		begin: vscode.Range | null;
		end: vscode.Range | null;
	} {
		// Najdi všechny begin před kurzorem nebo na pozici kurzoru
		const beginsBeforeCursor = begins.filter(b => b.offset <= cursorOffset);
		
		if (beginsBeforeCursor.length === 0) {
			return { begin: null, end: null };
		}

		// Seřaď podle pozice (odzadu - nejbližší begin k kurzoru)
		beginsBeforeCursor.sort((a, b) => b.offset - a.offset);

		// Zkus najít nejbližší begin, který má odpovídající end za kurzorem
		for (const begin of beginsBeforeCursor) {
			const matchingEnd = this.findMatchingEnd(document, begin.offset, begins, ends);
			
			if (matchingEnd && matchingEnd.offset >= cursorOffset) {
				// Našli jsme pár, který obklopuje kurzor
				const beginPos = document.positionAt(begin.offset);
				const endPos = document.positionAt(matchingEnd.offset);
				
				const beginRange = new vscode.Range(
					beginPos,
					new vscode.Position(beginPos.line, beginPos.character + 5) // "begin" má 5 znaků
				);
				
				const endRange = new vscode.Range(
					endPos,
					new vscode.Position(endPos.line, endPos.character + 3) // "end" má 3 znaky
				);
				
				return { begin: beginRange, end: endRange };
			}
		}

		// Pokud kurzor není v žádném páru, zkus najít nejbližší end za kurzorem
		const endsAfterCursor = ends.filter(e => e.offset >= cursorOffset);
		if (endsAfterCursor.length > 0) {
			endsAfterCursor.sort((a, b) => a.offset - b.offset);
			const nearestEnd = endsAfterCursor[0];
			const matchingBegin = this.findMatchingBegin(document, nearestEnd.offset, begins, ends);
			
			if (matchingBegin) {
				const beginPos = document.positionAt(matchingBegin.offset);
				const endPos = document.positionAt(nearestEnd.offset);
				
				const beginRange = new vscode.Range(
					beginPos,
					new vscode.Position(beginPos.line, beginPos.character + 5)
				);
				
				const endRange = new vscode.Range(
					endPos,
					new vscode.Position(endPos.line, endPos.character + 3)
				);
				
				return { begin: beginRange, end: endRange };
			}
		}

		return { begin: null, end: null };
	}

	/**
	 * Aktualizuje zvýraznění podle aktuální pozice kurzoru
	 */
	private updateHighlight(): void {
		if (!this.activeEditor || this.activeEditor.document.languageId !== 'pascal') {
			// Zruš zvýraznění pokud není Pascal soubor
			if (this.activeEditor) {
				this.activeEditor.setDecorations(this.decorationType, []);
			}
			return;
		}

		const document = this.activeEditor.document;
		const position = this.activeEditor.selection.active;
		const cursorOffset = document.offsetAt(position);

		const { begins, ends } = this.findAllBeginEnd(document);
		
		// Nejdřív zkontroluj, jestli není kurzor přímo na begin nebo end
		for (const begin of begins) {
			const beginPos = document.positionAt(begin.offset);
			const beginRange = new vscode.Range(
				beginPos,
				new vscode.Position(beginPos.line, beginPos.character + 5)
			);
			
			if (beginRange.contains(position)) {
				const matchingEnd = this.findMatchingEnd(document, begin.offset, begins, ends);
				if (matchingEnd) {
					const endPos = document.positionAt(matchingEnd.offset);
					const endRange = new vscode.Range(
						endPos,
						new vscode.Position(endPos.line, endPos.character + 3)
					);
					this.activeEditor.setDecorations(this.decorationType, [beginRange, endRange]);
					return;
				}
			}
		}

		for (const end of ends) {
			const endPos = document.positionAt(end.offset);
			const endRange = new vscode.Range(
				endPos,
				new vscode.Position(endPos.line, endPos.character + 3)
			);
			
			if (endRange.contains(position)) {
				const matchingBegin = this.findMatchingBegin(document, end.offset, begins, ends);
				if (matchingBegin) {
					const beginPos = document.positionAt(matchingBegin.offset);
					const beginRange = new vscode.Range(
						beginPos,
						new vscode.Position(beginPos.line, beginPos.character + 5)
					);
					this.activeEditor.setDecorations(this.decorationType, [beginRange, endRange]);
					return;
				}
			}
		}

		// Pokud kurzor není přímo na begin/end, najdi obklopující pár
		const { begin, end } = this.findEnclosingBeginEnd(document, cursorOffset, begins, ends);
		
		const decorations: vscode.Range[] = [];
		if (begin) {
			decorations.push(begin);
		}
		if (end) {
			decorations.push(end);
		}

		this.activeEditor.setDecorations(this.decorationType, decorations);
	}

	/**
	 * Uvolní všechny zdroje
	 */
	public dispose(): void {
		this.decorationType.dispose();
		this.disposables.forEach(d => d.dispose());
	}
}

/**
 * Zaregistruje BeginEndMatcher pro Pascal soubory
 */
export function registerBeginEndMatcher(context: vscode.ExtensionContext): vscode.Disposable {
	const matcher = new BeginEndMatcher();
	context.subscriptions.push(matcher);
	return matcher;
}

