import * as vscode from 'vscode';

/**
 * Struktura try bloku
 */
interface TryBlock {
	tryOffset: number;
	finallyOrExceptOffset: number | null;
	endOffset: number | null;
}

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
	 * Najde všechny try, finally, except pozice a jejich odpovídající end
	 * Vrací Set offsetů end, které patří k try blokům a mapu try bloků
	 */
	private findTryBlocks(document: vscode.TextDocument): {
		tryEnds: Set<number>;
		tryBlocks: Array<TryBlock>;
	} {
		const text = document.getText();
		const tryEnds = new Set<number>();
		const tryBlocks: Array<TryBlock> = [];
		
		// Regex pro try, finally, except (case-insensitive, musí být samostatné slovo)
		const tryRegex = /\b(?i:try)\b/g;
		const finallyRegex = /\b(?i:finally)\b/g;
		const exceptRegex = /\b(?i:except)\b/g;
		const endRegex = /\b(?i:end)\b/g;

		// Najdi všechny try pozice
		const tries: Array<{ offset: number }> = [];
		let match;
		while ((match = tryRegex.exec(text)) !== null) {
			tries.push({ offset: match.index });
		}

		// Najdi všechny finally, except a end pozice
		const finallys: Array<{ offset: number }> = [];
		while ((match = finallyRegex.exec(text)) !== null) {
			finallys.push({ offset: match.index });
		}

		const excepts: Array<{ offset: number }> = [];
		while ((match = exceptRegex.exec(text)) !== null) {
			excepts.push({ offset: match.index });
		}

		const ends: Array<{ offset: number }> = [];
		while ((match = endRegex.exec(text)) !== null) {
			ends.push({ offset: match.index });
		}

		// Pro každý try najdi odpovídající finally/except a end
		for (const tryPos of tries) {
			// Najdi nejbližší finally nebo except po try
			let finallyOrExcept: { offset: number } | null = null;
			
			const finallyAfterTry = finallys.filter(f => f.offset > tryPos.offset)
				.sort((a, b) => a.offset - b.offset)[0];
			const exceptAfterTry = excepts.filter(e => e.offset > tryPos.offset)
				.sort((a, b) => a.offset - b.offset)[0];

			if (finallyAfterTry && exceptAfterTry) {
				finallyOrExcept = finallyAfterTry.offset < exceptAfterTry.offset 
					? finallyAfterTry 
					: exceptAfterTry;
			} else if (finallyAfterTry) {
				finallyOrExcept = finallyAfterTry;
			} else if (exceptAfterTry) {
				finallyOrExcept = exceptAfterTry;
			}

			let endAfterFinally: { offset: number } | null = null;
			if (finallyOrExcept) {
				// Najdi nejbližší end po finally/except
				endAfterFinally = ends.filter(e => e.offset > finallyOrExcept!.offset)
					.sort((a, b) => a.offset - b.offset)[0] || null;
				
				if (endAfterFinally) {
					// Tento end patří k try bloku, přidej ho do Set
					tryEnds.add(endAfterFinally.offset);
				}
			}

			tryBlocks.push({
				tryOffset: tryPos.offset,
				finallyOrExceptOffset: finallyOrExcept?.offset ?? null,
				endOffset: endAfterFinally?.offset ?? null
			});
		}

		return { tryEnds, tryBlocks };
	}

	/**
	 * Najde všechny begin a end pozice v dokumentu
	 */
	private findAllBeginEnd(document: vscode.TextDocument): {
		begins: Array<{ offset: number; line: number; column: number }>;
		ends: Array<{ offset: number; line: number; column: number }>;
		tryEnds: Set<number>;
		tryBlocks: Array<TryBlock>;
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

		// Najdi všechny end, které patří k try blokům
		const { tryEnds, tryBlocks } = this.findTryBlocks(document);

		return { begins, ends, tryEnds, tryBlocks };
	}

	/**
	 * Najde try blok, ve kterém se nachází daný offset
	 */
	private findTryBlockContaining(offset: number, tryBlocks: Array<TryBlock>): TryBlock | null {
		for (const block of tryBlocks) {
			if (block.tryOffset <= offset) {
				if (block.endOffset === null || offset <= block.endOffset) {
					return block;
				}
			}
		}
		return null;
	}

	/**
	 * Najde odpovídající end pro daný begin offset
	 * Ignoruje end, které patří k try...finally...end nebo try...except...end blokům
	 */
	private findMatchingEnd(
		document: vscode.TextDocument,
		beginOffset: number,
		begins: Array<{ offset: number }>,
		ends: Array<{ offset: number }>,
		tryEnds: Set<number>,
		tryBlocks: Array<TryBlock>
	): { offset: number; line: number; column: number } | null {
		// Zjisti, zda je begin uvnitř try bloku
		const containingTryBlock = this.findTryBlockContaining(beginOffset, tryBlocks);
		
		// Najdi všechny begin a end mezi beginOffset a koncem souboru
		let relevantEnds = ends.filter(e => e.offset > beginOffset);
		
		// Pokud je begin uvnitř try bloku a je za finally/except, ignoruj pouze try-end tohoto bloku
		// pokud je try-end za finally/except a před begin (což by nemělo nastat, ale pro jistotu)
		if (containingTryBlock && containingTryBlock.finallyOrExceptOffset !== null && 
			beginOffset > containingTryBlock.finallyOrExceptOffset && 
			containingTryBlock.endOffset !== null &&
			containingTryBlock.endOffset > beginOffset) {
			// Begin je mezi finally/except a try-end, takže try-end je za begin a nemusíme ho ignorovat
			// Ignoruj pouze ostatní try-end (z jiných try bloků)
			relevantEnds = relevantEnds.filter(e => 
				!tryEnds.has(e.offset) || e.offset === containingTryBlock.endOffset
			);
		} else {
			// Jinak ignoruj všechny try-end
			relevantEnds = relevantEnds.filter(e => !tryEnds.has(e.offset));
		}
		
		const relevantBegins = begins.filter(b => b.offset > beginOffset);

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
	 * Ignoruje end, které patří k try...finally...end nebo try...except...end blokům
	 */
	private findMatchingBegin(
		document: vscode.TextDocument,
		endOffset: number,
		begins: Array<{ offset: number }>,
		ends: Array<{ offset: number }>,
		tryEnds: Set<number>,
		tryBlocks: Array<TryBlock>
	): { offset: number; line: number; column: number } | null {
		// Pokud tento end patří k try bloku, vrať null
		if (tryEnds.has(endOffset)) {
			return null;
		}

		// Zjisti, zda je end uvnitř try bloku
		const containingTryBlock = this.findTryBlockContaining(endOffset, tryBlocks);
		
		// Najdi všechny begin a end před endOffset
		let relevantEnds = ends.filter(e => e.offset < endOffset);
		
		// Pokud je end uvnitř try bloku a je za finally/except, ignoruj pouze try-end tohoto bloku před end
		if (containingTryBlock && containingTryBlock.finallyOrExceptOffset !== null && 
			endOffset > containingTryBlock.finallyOrExceptOffset && 
			containingTryBlock.endOffset !== null) {
			// Ignoruj pouze try-end tohoto bloku, pokud je před end
			relevantEnds = relevantEnds.filter(e => 
				!tryEnds.has(e.offset) || e.offset >= endOffset || e.offset !== containingTryBlock.endOffset
			);
		} else {
			// Jinak ignoruj všechny try-end
			relevantEnds = relevantEnds.filter(e => !tryEnds.has(e.offset));
		}
		
		const relevantBegins = begins.filter(b => b.offset < endOffset);

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
		ends: Array<{ offset: number; line: number; column: number }>,
		tryEnds: Set<number>,
		tryBlocks: Array<TryBlock>
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
			const matchingEnd = this.findMatchingEnd(document, begin.offset, begins, ends, tryEnds, tryBlocks);
			
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
		const endsAfterCursor = ends.filter(e => e.offset >= cursorOffset && !tryEnds.has(e.offset));
		if (endsAfterCursor.length > 0) {
			endsAfterCursor.sort((a, b) => a.offset - b.offset);
			const nearestEnd = endsAfterCursor[0];
			const matchingBegin = this.findMatchingBegin(document, nearestEnd.offset, begins, ends, tryEnds, tryBlocks);
			
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

		const { begins, ends, tryEnds, tryBlocks } = this.findAllBeginEnd(document);
		
		// Nejdřív zkontroluj, jestli není kurzor přímo na begin nebo end
		for (const begin of begins) {
			const beginPos = document.positionAt(begin.offset);
			const beginRange = new vscode.Range(
				beginPos,
				new vscode.Position(beginPos.line, beginPos.character + 5)
			);
			
			if (beginRange.contains(position)) {
				const matchingEnd = this.findMatchingEnd(document, begin.offset, begins, ends, tryEnds, tryBlocks);
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
			// Přeskoč end, které patří k try blokům
			if (tryEnds.has(end.offset)) {
				continue;
			}

			const endPos = document.positionAt(end.offset);
			const endRange = new vscode.Range(
				endPos,
				new vscode.Position(endPos.line, endPos.character + 3)
			);
			
			if (endRange.contains(position)) {
				const matchingBegin = this.findMatchingBegin(document, end.offset, begins, ends, tryEnds, tryBlocks);
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
		const { begin, end } = this.findEnclosingBeginEnd(document, cursorOffset, begins, ends, tryEnds, tryBlocks);
		
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

