import * as vscode from 'vscode';
import * as fs from 'fs';
import * as path from 'path';

interface SnippetDefinition {
    prefix: string | string[];
    body: string | string[];
    description?: string;
}

interface SnippetsFile {
    [key: string]: SnippetDefinition;
}

export class PascalSnippetProvider implements vscode.CompletionItemProvider {
    private snippets: vscode.CompletionItem[] = [];

    constructor(private context: vscode.ExtensionContext) {
        this.loadSnippets();
    }

    private loadSnippets(): void {
        try {
            const snippetsPath = path.join(this.context.extensionPath, 'snippets', 'pascal-snippets.json');
            
            if (!fs.existsSync(snippetsPath)) {
                console.warn('Pascal snippets file not found:', snippetsPath);
                return;
            }

            const snippetsContent = fs.readFileSync(snippetsPath, 'utf-8');
            const snippetsData: SnippetsFile = JSON.parse(snippetsContent);

            this.snippets = Object.entries(snippetsData).map(([name, snippet]) => {
                const item = new vscode.CompletionItem(
                    Array.isArray(snippet.prefix) ? snippet.prefix[0] : snippet.prefix,
                    vscode.CompletionItemKind.Snippet
                );

                // Sestavení body
                const body = Array.isArray(snippet.body) 
                    ? snippet.body.join('\n') 
                    : snippet.body;

                item.insertText = new vscode.SnippetString(body);
                item.detail = name;
                item.documentation = new vscode.MarkdownString(snippet.description || '');
                
                // Pokud má snippet více prefixů, vytvoř pro každý alias
                if (Array.isArray(snippet.prefix)) {
                    item.filterText = snippet.prefix.join(' ');
                }

                return item;
            });

            console.log(`Loaded ${this.snippets.length} Pascal snippets`);
        } catch (error) {
            console.error('Error loading Pascal snippets:', error);
        }
    }

    provideCompletionItems(
        document: vscode.TextDocument,
        position: vscode.Position,
        token: vscode.CancellationToken,
        context: vscode.CompletionContext
    ): vscode.ProviderResult<vscode.CompletionItem[] | vscode.CompletionList> {
        // Kontrola nastavení
        const config = vscode.workspace.getConfiguration('faBridge');
        const snippetsEnabled = config.get<boolean>('enableSnippets', true);

        if (!snippetsEnabled) {
            return [];
        }

        return this.snippets;
    }
}

export function registerSnippetProvider(context: vscode.ExtensionContext): vscode.Disposable {
    const provider = new PascalSnippetProvider(context);
    
    return vscode.languages.registerCompletionItemProvider(
        { language: 'pascal', scheme: 'file' },
        provider,
        // Trigger characters (můžeš přidat další pokud chceš)
        ...['']
    );
}

