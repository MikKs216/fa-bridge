import * as vscode from 'vscode';
import * as fs from 'fs';
import * as path from 'path';
import { PascalDocParser, FunctionDoc } from './PascalDocParser';

/**
 * IntelliSense provider pro Pascal - poskytuje Completion a Hover
 */
export class PascalIntelliSenseProvider implements vscode.CompletionItemProvider, vscode.HoverProvider {
	private functions: Map<string, FunctionDoc> = new Map();
	private isParsing: boolean = false;
	private parsePromise: Promise<void> | null = null;
	private fsUtilsPath: string | null = null;
	private parser: PascalDocParser;
	private outputChannel: vscode.OutputChannel;

	constructor(private context: vscode.ExtensionContext, outputChannel: vscode.OutputChannel) {
		this.parser = new PascalDocParser();
		this.outputChannel = outputChannel;
		this.findFsUtilsFile();
		this.parseAsync();
	}

	/**
	 * Vyhledá FsUtils.pas v workspace
	 */
	private findFsUtilsFile(): void {
		const workspaceFolders = vscode.workspace.workspaceFolders;
		if (!workspaceFolders || workspaceFolders.length === 0) {
			return;
		}

		// Prohledej všechny workspace folders
		for (const folder of workspaceFolders) {
			const fsUtilsPath = this.findFileInDirectory(folder.uri.fsPath, 'FsUtils.pas');
			if (fsUtilsPath) {
				this.fsUtilsPath = fsUtilsPath;
				this.outputChannel.appendLine(`[Pascal IntelliSense] Found FsUtils.pas at: ${fsUtilsPath}`);
				console.log(`[Pascal IntelliSense] Found FsUtils.pas at: ${fsUtilsPath}`);
				return;
			}
		}

		// Pokud není nalezen, zkus relativně k extension path (pro testování)
		const extensionPath = this.context.extensionPath;
		const fallbackPath = path.join(extensionPath, 'LibFADoc', 'FsUtils.pas');
		if (fs.existsSync(fallbackPath)) {
			this.fsUtilsPath = fallbackPath;
			this.outputChannel.appendLine(`[Pascal IntelliSense] Using fallback path: ${fallbackPath}`);
			console.log(`[Pascal IntelliSense] Using fallback path: ${fallbackPath}`);
		} else {
			this.outputChannel.appendLine('[Pascal IntelliSense] WARNING: FsUtils.pas not found in workspace');
			console.warn('[Pascal IntelliSense] FsUtils.pas not found in workspace');
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
	 * Asynchronně parsuje FsUtils.pas (neblokuje)
	 */
	private parseAsync(): void {
		if (!this.fsUtilsPath) {
			return;
		}

		if (this.isParsing) {
			return; // Už probíhá parsování
		}

		this.isParsing = true;
		
		this.outputChannel.appendLine(`[Pascal IntelliSense] Starting to parse: ${this.fsUtilsPath}`);
		this.parsePromise = this.parser.parseAsync(this.fsUtilsPath)
			.then((functions) => {
				this.functions.clear();
				for (const func of functions) {
					this.functions.set(func.name.toLowerCase(), func);
				}
				this.outputChannel.appendLine(`[Pascal IntelliSense] ✓ Parsed ${functions.length} documented functions`);
				console.log(`[Pascal IntelliSense] Parsed ${functions.length} documented functions`);
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

		// Záhlaví
		const typeStr = funcDoc.isFunction ? 'function' : 'procedure';
		markdown.appendMarkdown(`**${typeStr}** \`${funcDoc.name}\`\n\n`);

		// Summary
		markdown.appendMarkdown(`${funcDoc.summary}\n\n`);

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

		markdown.appendMarkdown(`${func.summary}\n\n`);

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
	 * Zkontroluje, jestli je soubor FsUtils.pas
	 */
	public isFsUtilsFile(filePath: string): boolean {
		if (!this.fsUtilsPath) {
			return false;
		}
		return path.normalize(filePath) === path.normalize(this.fsUtilsPath);
	}

	/**
	 * Vrátí statistiky o načtených funkcích
	 */
	public getStats(): { 
		loaded: number; 
		filePath: string | null; 
		isParsing: boolean;
		sampleFunctions: string[];
	} {
		const sampleFunctions = Array.from(this.functions.keys()).slice(0, 5);
		return {
			loaded: this.functions.size,
			filePath: this.fsUtilsPath,
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
	];

	// Sleduj změny FsUtils.pas pro auto-reload
	const saveDisposable = vscode.workspace.onDidSaveTextDocument((document) => {
		if (provider.isFsUtilsFile(document.fileName)) {
			console.log('[Pascal IntelliSense] FsUtils.pas was saved, reloading documentation...');
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




