import * as vscode from 'vscode';

interface FunctionDefinition {
	name: string;
	range: vscode.Range;
	line: number;
}

/**
 * CodeLens provider pro zobrazení počtu referencí u deklarací funkcí
 */
export class PascalCodeLensProvider implements vscode.CodeLensProvider {
	private outputChannel: vscode.OutputChannel;

	constructor(outputChannel: vscode.OutputChannel) {
		this.outputChannel = outputChannel;
	}

	/**
	 * Poskytne CodeLenses pro soubor
	 */
	public provideCodeLenses(
		document: vscode.TextDocument,
		token: vscode.CancellationToken
	): vscode.CodeLens[] | Thenable<vscode.CodeLens[]> {
		if (document.languageId !== 'pascal') {
			return [];
		}

		const codeLenses: vscode.CodeLens[] = [];
		const functions = this.findAllFunctions(document);

		for (const func of functions) {
			const references = this.findReferences(document, func.name, func.line);
			const count = references.length;

			// Vytvoř CodeLens nad deklarací
			let codeLens: vscode.CodeLens;
			
			if (count === 0) {
				// Bez command pro 0 referencí
				codeLens = new vscode.CodeLens(func.range, {
					title: 'žádné reference',
					command: ''
				});
			} else {
				// S commandem pro zobrazení referencí
				codeLens = new vscode.CodeLens(func.range, {
					title: count === 1 ? '1 reference' : `${count} referencí`,
					command: 'faBridge.showReferences',
					arguments: [document.uri, func.range.start, references]
				});
			}

			codeLenses.push(codeLens);
		}

		this.outputChannel.appendLine(`[Pascal CodeLens] Nalezeno ${functions.length} funkcí v ${document.fileName}`);
		return codeLenses;
	}

	/**
	 * Najde všechny funkce a procedury v dokumentu
	 */
	private findAllFunctions(document: vscode.TextDocument): FunctionDefinition[] {
		const functions: FunctionDefinition[] = [];
		const text = document.getText();
		const lines = text.split(/\r?\n/);

		// Regex pro function/procedure deklarace
		const functionRegex = /^\s*(function|procedure)\s+(\w+)/i;

		for (let i = 0; i < lines.length; i++) {
			const line = lines[i];
			const match = line.match(functionRegex);
			
			if (match) {
				const funcName = match[2];
				const funcNameIndex = line.indexOf(funcName);
				
				if (funcNameIndex >= 0) {
					const startPos = new vscode.Position(i, 0);
					const endPos = new vscode.Position(i, line.length);
					const range = new vscode.Range(startPos, endPos);
					
					functions.push({
						name: funcName,
						range: range,
						line: i
					});
				}
			}
		}

		return functions;
	}

	/**
	 * Najde všechny reference na funkci v dokumentu
	 * Přeskočí řádek s deklarací
	 */
	private findReferences(document: vscode.TextDocument, functionName: string, declarationLine: number): vscode.Location[] {
		const references: vscode.Location[] = [];
		const text = document.getText();
		const lines = text.split(/\r?\n/);

		// Regex pro volání funkce
		const callRegex = new RegExp(`\\b${functionName}\\b`, 'gi');

		for (let i = 0; i < lines.length; i++) {
			// Přeskoč řádek s deklarací
			if (i === declarationLine) {
				continue;
			}

			const line = lines[i];

			// Přeskoč řádky s deklarací (function/procedure)
			if (/^\s*(function|procedure)\s+/i.test(line)) {
				continue;
			}

			// Hledej všechny výskyty na řádku
			let match;
			while ((match = callRegex.exec(line)) !== null) {
				const startPos = new vscode.Position(i, match.index);
				const endPos = new vscode.Position(i, match.index + functionName.length);
				const range = new vscode.Range(startPos, endPos);
				
				references.push(new vscode.Location(document.uri, range));
			}
		}

		return references;
	}
}

/**
 * Zaregistruje CodeLens provider
 */
export function registerCodeLensProvider(
	context: vscode.ExtensionContext,
	outputChannel: vscode.OutputChannel
): vscode.Disposable {
	const provider = new PascalCodeLensProvider(outputChannel);
	
	outputChannel.appendLine('[Pascal CodeLens] Provider registrován');
	
	return vscode.languages.registerCodeLensProvider(
		{ language: 'pascal', scheme: 'file' },
		provider
	);
}
