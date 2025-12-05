import * as vscode from 'vscode';
import * as path from 'path';
import * as fs from 'fs';

interface HistoryFile {
    sourceFile: string;
    activeCommit: number;
    commits: Commit[];
}

interface Commit {
    activePatchIndex: number;
    patches: Patch[];
    date: number;
    name: string;
    content: string;
}

interface Patch {
    date: number;
    content: string;
}

export class HistoryItem extends vscode.TreeItem {
    constructor(
        public readonly label: string,
        public readonly collapsibleState: vscode.TreeItemCollapsibleState,
        public readonly filePath?: string,
        public readonly commitIndex?: number,
        public readonly patchIndex?: number,
        public readonly isFile?: boolean
    ) {
        super(label, collapsibleState);
        
        if (this.isFile) {
            this.contextValue = 'historyFile';
        } else if (this.patchIndex !== undefined) {
            this.contextValue = 'historyPatch';
        } else {
            this.contextValue = 'historyCommit';
        }
    }
}

export class HistoryProvider implements vscode.TreeDataProvider<HistoryItem> {
    private _onDidChangeTreeData: vscode.EventEmitter<HistoryItem | undefined | null | void> = new vscode.EventEmitter<HistoryItem | undefined | null | void>();
    readonly onDidChangeTreeData: vscode.Event<HistoryItem | undefined | null | void> = this._onDidChangeTreeData.event;

    private workspaceRoot: string;
    private currentSourceFile: string | null = null;
    private currentHistoryDir: string | null = null;

    constructor(private context: vscode.ExtensionContext) {
        const workspaceFolders = vscode.workspace.workspaceFolders;
        this.workspaceRoot = workspaceFolders ? workspaceFolders[0].uri.fsPath : '';
        
        // Sleduj změny aktivního editoru
        vscode.window.onDidChangeActiveTextEditor((editor) => {
            this.updateCurrentFile(editor);
        });
        
        // Inicializuj pro aktuální editor
        this.updateCurrentFile(vscode.window.activeTextEditor);
    }

    private updateCurrentFile(editor: vscode.TextEditor | undefined) {
        if (!editor || !this.workspaceRoot) {
            this.currentSourceFile = null;
            this.currentHistoryDir = null;
            this.refresh();
            return;
        }

        const activeFile = editor.document.uri.fsPath;
        this.currentSourceFile = activeFile;
        
        // Najdi .history složku vedle aktuálního souboru
        const fileDir = path.dirname(activeFile);
        const historyDir = path.join(fileDir, '.history');
        
        if (fs.existsSync(historyDir)) {
            this.currentHistoryDir = historyDir;
        } else {
            this.currentHistoryDir = null;
        }
        
        this.refresh();
    }

    refresh(): void {
        this._onDidChangeTreeData.fire();
    }

    getTreeItem(element: HistoryItem): vscode.TreeItem {
        return element;
    }

    getChildren(element?: HistoryItem): Thenable<HistoryItem[]> {
        if (!this.workspaceRoot) {
            return Promise.resolve([]);
        }

        if (!element) {
            // Kořenová úroveň - zobraz verze pro aktuální soubor
            return this.getCommitsForCurrentFile();
        } else {
            // Pro .history systém nejsou vnořené úrovně
            return Promise.resolve([]);
        }
    }

    private async getCommitsForCurrentFile(): Promise<HistoryItem[]> {
        const activeEditor = vscode.window.activeTextEditor;
        if (!activeEditor) {
            const noFileItem = new HistoryItem(
                'Žádný otevřený soubor',
                vscode.TreeItemCollapsibleState.None
            );
            noFileItem.iconPath = new vscode.ThemeIcon('info');
            return [noFileItem];
        }

        const fileName = path.basename(activeEditor.document.fileName);
        const relativePath = path.relative(this.workspaceRoot, activeEditor.document.fileName);

        if (!this.currentHistoryDir || !fs.existsSync(this.currentHistoryDir)) {
            // Zobraz informaci s názvem souboru
            const noHistoryItem = new HistoryItem(
                `📄 ${fileName}`,
                vscode.TreeItemCollapsibleState.None
            );
            noHistoryItem.iconPath = vscode.ThemeIcon.File;
            noHistoryItem.tooltip = `Pro soubor ${relativePath} nebyla nalezena historie v .history složce`;
            return [noHistoryItem];
        }

        // Vrať pouze verze historie (bez hlavičky s názvem souboru)
        const versions = await this.getHistoryVersions();
        return versions;
    }

    private async getHistoryVersions(): Promise<HistoryItem[]> {
        try {
            if (!this.currentSourceFile || !this.currentHistoryDir) {
                return [];
            }

            const fileName = path.basename(this.currentSourceFile);
            const baseName = path.basename(fileName, path.extname(fileName));
            const ext = path.extname(fileName);

            // Najdi všechny soubory v historii, které odpovídají tomuto souboru
            const entries = fs.readdirSync(this.currentHistoryDir);
            const versions = entries
                .filter(entry => {
                    // Formát: baseName-YYYYMMDD-HHMMSS.ext
                    const pattern = new RegExp(`^${baseName.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}-\\d{8}-\\d{6}${ext.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}$`);
                    return pattern.test(entry);
                })
                .map(entry => path.join(this.currentHistoryDir!, entry))
                .sort((a, b) => {
                    // Seřaď podle času modifikace (nejnovější první)
                    const statA = fs.statSync(a);
                    const statB = fs.statSync(b);
                    return statB.mtimeMs - statA.mtimeMs;
                });

            const items: HistoryItem[] = [];
            
            for (let i = 0; i < versions.length; i++) {
                const versionPath = versions[i];
                const versionFileName = path.basename(versionPath);
                
                // Extrahuj timestamp z názvu souboru
                const timestampMatch = versionFileName.match(/-(\d{8})-(\d{6})\./);
                let dateStr = versionFileName;
                if (timestampMatch) {
                    // Formát: YYYYMMDD-HHMMSS -> YYYY-MM-DD HH:MM:SS
                    const dateStr_part = timestampMatch[1];
                    const timeStr_part = timestampMatch[2];
                    dateStr = `${dateStr_part.substring(0, 4)}-${dateStr_part.substring(4, 6)}-${dateStr_part.substring(6, 8)} ${timeStr_part.substring(0, 2)}:${timeStr_part.substring(2, 4)}:${timeStr_part.substring(4, 6)}`;
                }
                
                const stat = fs.statSync(versionPath);
                const date = new Date(stat.mtime);
                const formattedDate = date.toLocaleString('cs-CZ');
                
                const item = new HistoryItem(
                    `${formattedDate}`,
                    vscode.TreeItemCollapsibleState.None,
                    versionPath,
                    i,
                    0,  // patchIndex: 0 - aby měl contextValue 'historyPatch' pro context menu
                    false
                );
                item.iconPath = new vscode.ThemeIcon('file');
                item.tooltip = `Verze z ${formattedDate}\nSoubor: ${versionFileName}`;
                // Kliknutí na verzi automaticky zobrazí diff (bez command)
                item.command = {
                    command: 'faHistory.showDiff',
                    title: 'Zobrazit rozdíly',
                    arguments: [versionPath, i, 0]
                };
                items.push(item);
            }
            
            return items; // Už jsou seřazené od nejnovější
        } catch (error) {
            console.error('Chyba při načítání verzí:', error);
            return [];
        }
    }

    private async getPatchesForCommit(filePath: string, commitIndex: number): Promise<HistoryItem[]> {
        // Pro .history systém nejsou patche, pouze jednotlivé verze
        return [];
    }

    public async getHistoryData(filePath: string): Promise<HistoryFile | null> {
        // Pro .history systém není potřeba JSON struktura
        return null;
    }

    public async getFileContent(filePath: string, commitIndex: number, patchIndex: number): Promise<string> {
        try {
            // filePath je cesta k souboru v .history složce
            if (fs.existsSync(filePath)) {
                return fs.readFileSync(filePath, 'utf8');
            }
            return '';
        } catch (error) {
            console.error('Chyba při načítání obsahu souboru:', error);
            return '';
        }
    }

    private applyPatch(original: string, patchContent: string): string {
        // Vylepšená implementace aplikování unified diff
        if (!patchContent || patchContent.trim() === '') {
            return original;
        }

        const lines = original.split('\n');
        const patchLines = patchContent.split('\n');
        const result: string[] = [];
        let i = 0;
        let patchLineIndex = 0;
        let hunkStart = 0;
        let hunkOldLines = 0;
        let hunkNewLines = 0;

        while (patchLineIndex < patchLines.length) {
            const line = patchLines[patchLineIndex];
            
            if (line.startsWith('@@')) {
                // Parsuj hunk header: @@ -start,oldLines +start,newLines @@
                const match = line.match(/@@\s*-(\d+)(?:,(\d+))?\s*\+(\d+)(?:,(\d+))?\s*@@/);
                if (match) {
                    hunkStart = parseInt(match[1]) - 1; // -1 protože indexování začíná od 1
                    hunkOldLines = match[2] ? parseInt(match[2]) : 1;
                    hunkNewLines = match[4] ? parseInt(match[4]) : 1;
                    i = Math.max(0, hunkStart);
                }
                patchLineIndex++;
                continue;
            } else if (line.startsWith('+') && !line.startsWith('+++')) {
                // Přidat řádek
                result.push(line.substring(1));
                patchLineIndex++;
            } else if (line.startsWith('-') && !line.startsWith('---')) {
                // Odstranit řádek - přeskoč ho v originálu
                if (i < lines.length) {
                    i++; // Přeskoč tento řádek v originálu
                }
                patchLineIndex++;
            } else if (line.startsWith(' ')) {
                // Zachovat řádek
                if (i < lines.length) {
                    result.push(lines[i]);
                }
                i++;
                patchLineIndex++;
            } else {
                patchLineIndex++;
            }
        }

        // Přidej zbývající řádky z originálu
        while (i < lines.length) {
            result.push(lines[i]);
            i++;
        }

        return result.join('\n');
    }
}

