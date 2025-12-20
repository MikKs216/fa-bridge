import * as vscode from 'vscode';
import * as fs from 'fs';
import * as path from 'path';
import { PascalDocParser, FunctionDoc } from './PascalDocParser';

/**
 * IntelliSense provider pro Pascal - poskytuje Completion a Hover
 * Go To Definition je dostupné pouze přes F12 a pouze v rámci editovaného souboru
 */
export class PascalIntelliSenseProvider implements vscode.CompletionItemProvider, vscode.HoverProvider {
	private functions: Map<string, FunctionDoc> = new Map();
	private isParsing: boolean = false;
	private parsePromise: Promise<void> | null = null;
	private docFiles: Map<string, string> = new Map(); // Dokumentační soubory (LibFADoc) - název -> cesta
	private implFiles: Map<string, string> = new Map(); // Implementační soubory (FAdelphi) - název -> cesta
	private parser: PascalDocParser;
	private outputChannel: vscode.OutputChannel;

	constructor(private context: vscode.ExtensionContext, outputChannel: vscode.OutputChannel) {
		this.parser = new PascalDocParser();
		this.outputChannel = outputChannel;
		this.findLibraryFiles();
		this.parseAsync();
	}

	/**
	 * Vyhledá dokumentační soubory (LibFADoc) a implementační soubory (_source) v workspace
	 */
	private findLibraryFiles(): void {
		const workspaceFolders = vscode.workspace.workspaceFolders;
		if (!workspaceFolders || workspaceFolders.length === 0) {
			return;
		}

		// Soubory pro dokumentaci (LibFADoc v extension) a implementaci (_source v workspace)
		const docFilesToFind = ['FsUtils.pas', 'FScriptUtils.pas', 'FCommonUtils.pas'];
		const implFilesToFind = ['FScriptUtils.pas', 'FCommonUtils.pas'];

		// 1. Hledej dokumentační soubory v LibFADoc (v extension path)
		const extensionPath = this.context.extensionPath;
		const libFADocPath = path.join(extensionPath, 'LibFADoc');
		
		for (const filename of docFilesToFind) {
			const docFilePath = path.join(libFADocPath, filename);
			if (fs.existsSync(docFilePath)) {
				this.docFiles.set(filename, docFilePath);
				this.outputChannel.appendLine(`[Pascal IntelliSense] Found doc file: ${filename} at ${docFilePath}`);
				console.log(`[Pascal IntelliSense] Found doc file: ${filename} at ${docFilePath}`);
			}
		}

		// 2. Hledej implementační soubory ve _source (v workspace)
		for (const folder of workspaceFolders) {
			const sourcePath = path.join(folder.uri.fsPath, '_source');
			if (fs.existsSync(sourcePath)) {
				for (const filename of implFilesToFind) {
					if (this.implFiles.has(filename)) {
						continue; // Už nalezeno
					}
					const implFilePath = path.join(sourcePath, filename);
					if (fs.existsSync(implFilePath)) {
						this.implFiles.set(filename, implFilePath);
						this.outputChannel.appendLine(`[Pascal IntelliSense] Found impl file: ${filename} at ${implFilePath}`);
						console.log(`[Pascal IntelliSense] Found impl file: ${filename} at ${implFilePath}`);
					}
				}
			}
		}

		if (this.docFiles.size === 0) {
			this.outputChannel.appendLine('[Pascal IntelliSense] WARNING: No documentation files found in LibFADoc');
			console.warn('[Pascal IntelliSense] WARNING: No documentation files found');
		}

		if (this.implFiles.size === 0) {
			this.outputChannel.appendLine('[Pascal IntelliSense] WARNING: No implementation files found in _source');
			console.warn('[Pascal IntelliSense] WARNING: No implementation files found');
		}
	}

	/**
	 * Rekurzivně hledá soubor v adresáři
	 */
	private findFileInDirectory(dir: string, filename: string): string | null {
		try {
			const files = fs.readdirSync(dir);
			
			for (const file of files) {
				const fullPath = path.join(dir, file);
				const stat = fs.statSync(fullPath);
				
				if (stat.isDirectory()) {
					const found = this.findFileInDirectory(fullPath, filename);
					if (found) {
						return found;
					}
				} else if (file === filename) {
					return fullPath;
				}
			}
		} catch (error) {
			// Ignoruj chyby (např. permission denied)
		}
		
		return null;
	}

	/**
	 * Asynchronně parsuje dokumentační a implementační soubory (neblokuje)
	 */
	private parseAsync(): void {
		if (this.docFiles.size === 0 && this.implFiles.size === 0) {
			return;
		}

		if (this.isParsing) {
			return; // Už probíhá parsování
		}

		this.isParsing = true;
		
		// FÁZE 1: Parsuj dokumentační soubory (LibFADoc)
		const docParsePromises: Promise<void>[] = [];
		
		for (const [filename, filePath] of this.docFiles.entries()) {
			this.outputChannel.appendLine(`[Pascal IntelliSense] Parsing doc file: ${filePath}`);
			const promise = this.parser.parseAsync(filePath)
				.then((functions) => {
					let addedCount = 0;
					for (const func of functions) {
						const key = func.name.toLowerCase();
						this.functions.set(key, func);
						addedCount++;
						// Debug: zobraz prvních 5 funkcí
						if (addedCount <= 5) {
							this.outputChannel.appendLine(`[Pascal IntelliSense] Added doc: ${func.name} from ${filename} at line ${func.lineNumber + 1}`);
						}
					}
					this.outputChannel.appendLine(`[Pascal IntelliSense] ✓ Parsed ${functions.length} functions from doc ${filename} (added ${addedCount})`);
				})
				.catch((error) => {
					const errorMsg = error instanceof Error ? error.message : String(error);
					this.outputChannel.appendLine(`[Pascal IntelliSense] ✗ Parse error for doc ${filename}: ${errorMsg}`);
				});
			docParsePromises.push(promise);
		}

		// FÁZE 2: Po dokončení parsování dokumentace, parsuj implementační soubory
		this.parsePromise = Promise.all(docParsePromises)
			.then(() => {
				this.outputChannel.appendLine(`[Pascal IntelliSense] ✓ Documentation parsed, now parsing implementations...`);
				
				const implParsePromises: Promise<void>[] = [];
				
				for (const [filename, filePath] of this.implFiles.entries()) {
					this.outputChannel.appendLine(`[Pascal IntelliSense] Parsing impl file: ${filePath}`);
					const promise = this.parser.parseAsync(filePath)
						.then((functions) => {
							let matchedCount = 0;
							for (const implFunc of functions) {
								const key = implFunc.name.toLowerCase();
								const existingFunc = this.functions.get(key);
								
								if (existingFunc) {
									// Spáruj implementaci s dokumentací
									existingFunc.implFilePath = implFunc.filePath;
									existingFunc.implLineNumber = implFunc.lineNumber;
									matchedCount++;
									// Debug: zobraz prvních 5 spárování
									if (matchedCount <= 5) {
										this.outputChannel.appendLine(`[Pascal IntelliSense] Matched impl: ${implFunc.name} at ${filename}:${implFunc.lineNumber + 1}`);
									}
								} else {
									// Funkce není v dokumentaci - přidej ji pouze s implementací
									this.functions.set(key, {
										...implFunc,
										implFilePath: implFunc.filePath,
										implLineNumber: implFunc.lineNumber
									});
								}
							}
							this.outputChannel.appendLine(`[Pascal IntelliSense] ✓ Parsed ${functions.length} functions from impl ${filename} (matched ${matchedCount})`);
						})
						.catch((error) => {
							const errorMsg = error instanceof Error ? error.message : String(error);
							this.outputChannel.appendLine(`[Pascal IntelliSense] ✗ Parse error for impl ${filename}: ${errorMsg}`);
						});
					implParsePromises.push(promise);
				}
				
				return Promise.all(implParsePromises);
			})
			.then(() => {
				this.outputChannel.appendLine(`[Pascal IntelliSense] ✓ Total parsed ${this.functions.size} functions`);
				console.log(`[Pascal IntelliSense] Total parsed ${this.functions.size} functions`);
				this.isParsing = false;
			})
			.catch((error) => {
				const errorMsg = error instanceof Error ? error.message : String(error);
				this.outputChannel.appendLine(`[Pascal IntelliSense] ✗ Parse error: ${errorMsg}`);
				console.error('[Pascal IntelliSense] Parse error:', error);
				this.isParsing = false;
			});
	}

	/**
	 * Reload dokumentace při změně souboru
	 */
	public reload(): void {
		this.functions.clear();
		this.parseAsync();
	}

	/**
	 * Najde dokumentaci pro funkci
	 */
	private findFunctionDoc(name: string): FunctionDoc | undefined {
		return this.functions.get(name.toLowerCase());
	}

	/**
	 * Completion Provider - poskytuje autocomplete
	 */
	provideCompletionItems(
		document: vscode.TextDocument,
		position: vscode.Position,
		token: vscode.CancellationToken,
		context: vscode.CompletionContext
	): vscode.ProviderResult<vscode.CompletionItem[] | vscode.CompletionList> {
		// Pokud probíhá parsování, vrať prázdné výsledky (nečekej)
		if (this.isParsing) {
			return [];
		}

		const items: vscode.CompletionItem[] = [];

		for (const [name, func] of this.functions.entries()) {
			const item = new vscode.CompletionItem(
				func.name,
				func.isFunction ? vscode.CompletionItemKind.Function : vscode.CompletionItemKind.Method
			);

			item.detail = func.signature;
			item.documentation = this.buildMarkdownDocumentation(func);
			item.insertText = func.name;

			items.push(item);
		}

		return items;
	}

	/**
	 * Hover Provider - zobrazuje dokumentaci při hoveru
	 */
	provideHover(
		document: vscode.TextDocument,
		position: vscode.Position,
		token: vscode.CancellationToken
	): vscode.ProviderResult<vscode.Hover> {
		// Pokud probíhá parsování, vrať undefined (nečekej)
		if (this.isParsing) {
			this.outputChannel.appendLine(`[Pascal IntelliSense] Hover: Parsování probíhá, čekám...`);
			return undefined;
		}

		// Získej slovo pod kurzorem
		const wordRange = document.getWordRangeAtPosition(position);
		if (!wordRange) {
			return undefined;
		}

		const word = document.getText(wordRange);
		const funcDoc = this.findFunctionDoc(word);

		if (!funcDoc) {
			// Debug: zkontroluj, jestli je slovo v mapě
			const wordLower = word.toLowerCase();
			const hasWord = this.functions.has(wordLower);
			this.outputChannel.appendLine(`[Pascal IntelliSense] Hover: Slovo "${word}" (${wordLower}) ${hasWord ? 'NALEZENO' : 'nenalezeno'} v ${this.functions.size} funkcích`);
			return undefined;
		}

		this.outputChannel.appendLine(`[Pascal IntelliSense] Hover: Zobrazení dokumentace pro "${word}"`);

		const markdown = new vscode.MarkdownString();
		markdown.isTrusted = true;

		// Záhlaví s názvem funkce
		const typeStr = funcDoc.isFunction ? 'function' : 'procedure';
		markdown.appendMarkdown(`**${typeStr}** \`${funcDoc.name}\`\n\n`);

		// Pokud má funkce dokumentaci, zobraz ji
		if (funcDoc.summary) {
			markdown.appendMarkdown(`${funcDoc.summary}\n\n`);
		}

		// Pokud nemá dokumentaci, ale má signaturu, zobraz signaturu
		if (!funcDoc.summary && funcDoc.signature) {
			markdown.appendCodeblock(funcDoc.signature, 'pascal');
			markdown.appendMarkdown('\n');
		}

		// Parameters
		if (funcDoc.parameters.length > 0) {
			markdown.appendMarkdown('**Parameters:**\n');
			for (const param of funcDoc.parameters) {
				markdown.appendMarkdown(`- \`${param.name}\`: ${param.description}\n`);
			}
			markdown.appendMarkdown('\n');
		}

		// Returns (pouze pro funkce)
		if (funcDoc.isFunction && funcDoc.returns) {
			markdown.appendMarkdown(`**Returns:** ${funcDoc.returns}\n`);
		}

		return new vscode.Hover(markdown, wordRange);
	}

	/**
	 * Sestaví Markdown dokumentaci pro Completion item
	 */
	private buildMarkdownDocumentation(func: FunctionDoc): vscode.MarkdownString {
		const markdown = new vscode.MarkdownString();
		markdown.isTrusted = true;

		// Pokud má funkce dokumentaci, zobraz ji
		if (func.summary) {
			markdown.appendMarkdown(`${func.summary}\n\n`);
		}

		// Pokud nemá dokumentaci, ale má signaturu, zobraz signaturu
		if (!func.summary && func.signature) {
			markdown.appendCodeblock(func.signature, 'pascal');
			markdown.appendMarkdown('\n');
		}

		if (func.parameters.length > 0) {
			markdown.appendMarkdown('**Parameters:**\n');
			for (const param of func.parameters) {
				markdown.appendMarkdown(`- \`${param.name}\`: ${param.description}\n`);
			}
			markdown.appendMarkdown('\n');
		}

		if (func.isFunction && func.returns) {
			markdown.appendMarkdown(`**Returns:** ${func.returns}\n`);
		}

		return markdown;
	}

	/**
	 * Zkontroluje, jestli je soubor některý z dokumentačních nebo implementačních souborů
	 */
	public isLibraryFile(filePath: string): boolean {
		const normalizedPath = path.normalize(filePath);
		
		// Zkontroluj dokumentační soubory
		for (const docPath of this.docFiles.values()) {
			if (normalizedPath === path.normalize(docPath)) {
				return true;
			}
		}
		
		// Zkontroluj implementační soubory
		for (const implPath of this.implFiles.values()) {
			if (normalizedPath === path.normalize(implPath)) {
				return true;
			}
		}
		
		return false;
	}

	/**
	 * Zkontroluje, jestli funkce s daným názvem existuje v seznamu funkcí
	 */
	public hasFunction(name: string): boolean {
		return this.functions.has(name.toLowerCase());
	}

	/**
	 * Veřejná metoda pro Go To Definition (volaná z commandu F12)
	 * Hledá pouze v aktuálním souboru, ne v library souborech
	 */
	public async goToDefinition(): Promise<void> {
		const editor = vscode.window.activeTextEditor;
		if (!editor) {
			vscode.window.showWarningMessage('Žádný aktivní editor');
			return;
		}

		const document = editor.document;
		if (document.languageId !== 'pascal') {
			vscode.window.showWarningMessage('Go To Definition funguje pouze pro Pascal soubory');
			return;
		}

		const position = editor.selection.active;
		const wordRange = document.getWordRangeAtPosition(position);
		if (!wordRange) {
			this.outputChannel.appendLine(`[Pascal IntelliSense] Go To Definition: Žádné slovo pod kurzorem`);
			vscode.window.showWarningMessage('Žádné slovo pod kurzorem');
			return;
		}

		const word = document.getText(wordRange);
		const wordLower = word.toLowerCase();

		this.outputChannel.appendLine(`[Pascal IntelliSense] Go To Definition (F12): Hledám "${word}" (${wordLower}) v aktuálním souboru`);

		// Hledej pouze v aktuálním souboru
		const localDefinition = this.findDefinitionInDocument(document, word, wordLower);
		if (localDefinition) {
			this.outputChannel.appendLine(`[Pascal IntelliSense] Go To Definition: Nalezeno na řádku ${localDefinition.range.start.line + 1}`);
			// Použij pouze revealRange bez změny selection - to by nemělo způsobit problémy s diff zobrazením
			editor.revealRange(localDefinition.range, vscode.TextEditorRevealType.InCenter);
			// Nastav kurzor na začátek definice (bez změny selection, jen pozice)
			const newPosition = new vscode.Position(localDefinition.range.start.line, localDefinition.range.start.character);
			editor.selection = new vscode.Selection(newPosition, newPosition);
		} else {
			vscode.window.showInformationMessage(`Definice pro "${word}" nebyla nalezena v aktuálním souboru`);
		}
	}

	/**
	 * Najde definici v aktuálním dokumentu (pouze funkce a procedury)
	 */
	private findDefinitionInDocument(
		document: vscode.TextDocument,
		word: string,
		wordLower: string
	): vscode.Location | undefined {
		const text = document.getText();
		const lines = text.split(/\r?\n/);
		
		this.outputChannel.appendLine(`[Pascal IntelliSense] findDefinitionInDocument: Hledám "${word}" v ${lines.length} řádcích`);

		// Hledej pouze function/procedure deklarace
		// Regex: function|procedure na začátku řádku (nebo po whitespace), pak název funkce
		const functionRegex = /^\s*(function|procedure)\s+(\w+)/i;

		for (let i = 0; i < lines.length; i++) {
			const line = lines[i];
			const lineLower = line.toLowerCase();

			// Hledej funkce/procedury
			const funcMatch = line.match(functionRegex);
			if (funcMatch) {
				const funcName = funcMatch[2];
				if (funcName.toLowerCase() === wordLower) {
					const funcNameIndex = lineLower.indexOf(funcName.toLowerCase());
					if (funcNameIndex >= 0) {
						const startPos = new vscode.Position(i, funcNameIndex);
						const endPos = new vscode.Position(i, funcNameIndex + funcName.length);
						const range = new vscode.Range(startPos, endPos);
						return new vscode.Location(document.uri, range);
					}
				}
			}
		}

		return undefined;
	}

	/**
	 * Najde definici v implementačních souborech (FScriptUtils.pas nebo FCommonUtils.pas v FAdelphi)
	 */
	private findDefinitionInLibraryFiles(wordLower: string): vscode.Location | undefined {
		this.outputChannel.appendLine(`[Pascal IntelliSense] Go To Definition: Hledám "${wordLower}" v ${this.functions.size} načtených funkcích`);
		const funcDoc = this.functions.get(wordLower);
		if (!funcDoc) {
			this.outputChannel.appendLine(`[Pascal IntelliSense] Go To Definition: "${wordLower}" nenalezeno`);
			// Debug: zobraz prvních 10 názvů funkcí v mapě
			const sampleFunctions = Array.from(this.functions.keys()).slice(0, 10);
			this.outputChannel.appendLine(`[Pascal IntelliSense] Ukázkové funkce v mapě: ${sampleFunctions.join(', ')}`);
			return undefined;
		}

		// Preferuj implementační soubor pokud existuje, jinak použij dokumentační
		const targetFilePath = funcDoc.implFilePath || funcDoc.filePath;
		const targetLineNumber = funcDoc.implLineNumber !== undefined ? funcDoc.implLineNumber : funcDoc.lineNumber;

		if (!targetFilePath) {
			this.outputChannel.appendLine(`[Pascal IntelliSense] Go To Definition: "${wordLower}" nemá cestu k souboru`);
			return undefined;
		}

		// Vytvoř URI pro soubor
		const fileUri = vscode.Uri.file(targetFilePath);
		
		// Najdi přesnou pozici názvu funkce na řádku
		try {
			const content = fs.readFileSync(targetFilePath, 'utf-8');
			const lines = content.split(/\r?\n/);
			if (targetLineNumber < lines.length) {
				const line = lines[targetLineNumber];
				const funcNameIndex = line.toLowerCase().indexOf(funcDoc.name.toLowerCase());
				if (funcNameIndex >= 0) {
					const startPos = new vscode.Position(targetLineNumber, funcNameIndex);
					const endPos = new vscode.Position(targetLineNumber, funcNameIndex + funcDoc.name.length);
					const range = new vscode.Range(startPos, endPos);
					
					const fileName = path.basename(targetFilePath);
					const fileType = funcDoc.implFilePath ? 'impl' : 'doc';
					this.outputChannel.appendLine(`[Pascal IntelliSense] Go To Definition: Nalezeno v ${fileName} (${fileType}) na řádku ${targetLineNumber + 1}`);
					return new vscode.Location(fileUri, range);
				}
			}
		} catch (error) {
			this.outputChannel.appendLine(`[Pascal IntelliSense] Go To Definition: Chyba při čtení ${targetFilePath}: ${error}`);
		}

		// Fallback: vrať alespoň pozici na začátku řádku
		const position = new vscode.Position(targetLineNumber, 0);
		const range = new vscode.Range(position, position);
		const fileName = path.basename(targetFilePath);
		this.outputChannel.appendLine(`[Pascal IntelliSense] Go To Definition: Nalezeno v ${fileName} na řádku ${targetLineNumber + 1} (fallback)`);
		return new vscode.Location(fileUri, range);
	}

	/**
	 * Vrátí statistiky o načtených funkcích
	 */
	public getStats(): { 
		loaded: number; 
		docFilePaths: string[];
		implFilePaths: string[];
		isParsing: boolean;
		sampleFunctions: string[];
	} {
		const sampleFunctions = Array.from(this.functions.keys()).slice(0, 5);
		return {
			loaded: this.functions.size,
			docFilePaths: Array.from(this.docFiles.values()),
			implFilePaths: Array.from(this.implFiles.values()),
			isParsing: this.isParsing,
			sampleFunctions: sampleFunctions
		};
	}
}

// Globální instance provideru pro přístup z extension.ts
let globalProvider: PascalIntelliSenseProvider | null = null;

/**
 * Zaregistruje IntelliSense providery
 */
export function registerIntelliSenseProvider(context: vscode.ExtensionContext, outputChannel: vscode.OutputChannel): vscode.Disposable[] {
	const provider = new PascalIntelliSenseProvider(context, outputChannel);
	globalProvider = provider;

	const disposables: vscode.Disposable[] = [
		// Completion Provider
		vscode.languages.registerCompletionItemProvider(
			{ language: 'pascal', scheme: 'file' },
			provider
			// Bez trigger characters - completion se otevře jen na Ctrl+Space
		),
		// Hover Provider
		vscode.languages.registerHoverProvider(
			{ language: 'pascal', scheme: 'file' },
			provider
		)
		// Definition Provider není zaregistrován - Go To Definition je dostupné pouze přes F12 (vlastní command)
		// a funguje pouze v rámci editovaného souboru
	];

	// Sleduj změny library souborů pro auto-reload
	const saveDisposable = vscode.workspace.onDidSaveTextDocument((document) => {
		if (provider.isLibraryFile(document.fileName)) {
			console.log('[Pascal IntelliSense] Library file was saved, reloading documentation...');
			provider.reload();
		}
	});

	disposables.push(saveDisposable);

	return disposables;
}

/**
 * Vrátí globální instanci provideru
 */
export function getIntelliSenseProvider(): PascalIntelliSenseProvider | null {
	return globalProvider;
}




