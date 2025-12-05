"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.HistoryProvider = exports.HistoryItem = void 0;
const vscode = __importStar(require("vscode"));
const path = __importStar(require("path"));
const fs = __importStar(require("fs"));
class HistoryItem extends vscode.TreeItem {
    label;
    collapsibleState;
    filePath;
    commitIndex;
    patchIndex;
    isFile;
    constructor(label, collapsibleState, filePath, commitIndex, patchIndex, isFile) {
        super(label, collapsibleState);
        this.label = label;
        this.collapsibleState = collapsibleState;
        this.filePath = filePath;
        this.commitIndex = commitIndex;
        this.patchIndex = patchIndex;
        this.isFile = isFile;
        if (this.isFile) {
            this.contextValue = 'historyFile';
        }
        else if (this.patchIndex !== undefined) {
            this.contextValue = 'historyPatch';
        }
        else {
            this.contextValue = 'historyCommit';
        }
    }
}
exports.HistoryItem = HistoryItem;
class HistoryProvider {
    context;
    _onDidChangeTreeData = new vscode.EventEmitter();
    onDidChangeTreeData = this._onDidChangeTreeData.event;
    workspaceRoot;
    currentHistoryFile = null;
    constructor(context) {
        this.context = context;
        const workspaceFolders = vscode.workspace.workspaceFolders;
        this.workspaceRoot = workspaceFolders ? workspaceFolders[0].uri.fsPath : '';
        // Sleduj změny aktivního editoru
        vscode.window.onDidChangeActiveTextEditor((editor) => {
            this.updateCurrentFile(editor);
        });
        // Inicializuj pro aktuální editor
        this.updateCurrentFile(vscode.window.activeTextEditor);
    }
    updateCurrentFile(editor) {
        if (!editor || !this.workspaceRoot) {
            this.currentHistoryFile = null;
            this.refresh();
            return;
        }
        const activeFile = editor.document.uri.fsPath;
        const relativePath = path.relative(this.workspaceRoot, activeFile);
        // Najdi odpovídající historii v .lh adresáři
        // Struktura: .lh/np_03Obalka/script_np_03Obalka.pas.json pro soubor np_03Obalka/script_np_03Obalka.pas
        const historyPath = this.findHistoryFile(relativePath);
        this.currentHistoryFile = historyPath;
        this.refresh();
    }
    findHistoryFile(relativeFilePath) {
        const historyDir = path.join(this.workspaceRoot, '.lh');
        if (!fs.existsSync(historyDir)) {
            return null;
        }
        // Normalizuj cestu (zajisti konzistentní separátory)
        const normalizedPath = relativeFilePath.replace(/\\/g, '/');
        const dirName = path.dirname(normalizedPath);
        const fileName = path.basename(normalizedPath);
        // Zkus najít přesnou cestu: .lh/np_03Obalka/script_np_03Obalka.pas.json
        const exactPath = path.join(historyDir, normalizedPath + '.json');
        if (fs.existsSync(exactPath)) {
            return exactPath;
        }
        // Zkus najít v podsložkách (např. .lh/np_03Obalka/script_np_03Obalka.pas.json)
        if (dirName && dirName !== '.' && dirName !== '/') {
            const dirPath = path.join(historyDir, dirName);
            if (fs.existsSync(dirPath)) {
                const filePath = path.join(dirPath, fileName + '.json');
                if (fs.existsSync(filePath)) {
                    return filePath;
                }
            }
        }
        // Zkus najít přímo v .lh (pro soubory v kořeni)
        const rootPath = path.join(historyDir, fileName + '.json');
        if (fs.existsSync(rootPath)) {
            return rootPath;
        }
        // Zkus najít rekurzivně podle názvu souboru
        const foundFile = this.findFileRecursively(historyDir, fileName + '.json');
        if (foundFile) {
            return foundFile;
        }
        return null;
    }
    findFileRecursively(dir, fileName) {
        try {
            const entries = fs.readdirSync(dir, { withFileTypes: true });
            for (const entry of entries) {
                const fullPath = path.join(dir, entry.name);
                if (entry.isDirectory()) {
                    const found = this.findFileRecursively(fullPath, fileName);
                    if (found) {
                        return found;
                    }
                }
                else if (entry.isFile() && entry.name === fileName) {
                    return fullPath;
                }
            }
        }
        catch (error) {
            // Ignoruj chyby při čtení adresáře
        }
        return null;
    }
    refresh() {
        this._onDidChangeTreeData.fire();
    }
    getTreeItem(element) {
        return element;
    }
    getChildren(element) {
        if (!this.workspaceRoot) {
            return Promise.resolve([]);
        }
        if (!element) {
            // Kořenová úroveň - zobraz commity pro aktuální soubor
            return this.getCommitsForCurrentFile();
        }
        else {
            // Zobraz patche pro commit
            return this.getPatchesForCommit(element.filePath, element.commitIndex);
        }
    }
    async getCommitsForCurrentFile() {
        const activeEditor = vscode.window.activeTextEditor;
        if (!activeEditor) {
            const noFileItem = new HistoryItem('Žádný otevřený soubor', vscode.TreeItemCollapsibleState.None);
            noFileItem.iconPath = vscode.ThemeIcon.Info;
            return [noFileItem];
        }
        const fileName = path.basename(activeEditor.document.fileName);
        const relativePath = path.relative(this.workspaceRoot, activeEditor.document.fileName);
        if (!this.currentHistoryFile || !fs.existsSync(this.currentHistoryFile)) {
            // Zobraz informaci s názvem souboru
            const noHistoryItem = new HistoryItem(`📄 ${fileName}`, vscode.TreeItemCollapsibleState.None);
            noHistoryItem.iconPath = vscode.ThemeIcon.File;
            noHistoryItem.tooltip = `Pro soubor ${relativePath} nebyla nalezena historie v .lh adresáři`;
            return [noHistoryItem];
        }
        // Přidej hlavičku s názvem souboru jako informativní položku
        const headerItem = new HistoryItem(`📄 ${fileName}`, vscode.TreeItemCollapsibleState.None);
        headerItem.iconPath = vscode.ThemeIcon.File;
        headerItem.tooltip = `Historie pro: ${relativePath}`;
        headerItem.contextValue = 'historyHeader';
        const commits = await this.getCommitsForFile(this.currentHistoryFile);
        return [headerItem, ...commits];
    }
    async getCommitsForFile(filePath) {
        try {
            const content = fs.readFileSync(filePath, 'utf8');
            const history = JSON.parse(content);
            const items = [];
            for (let i = 0; i < history.commits.length; i++) {
                const commit = history.commits[i];
                const date = new Date(commit.date);
                const dateStr = date.toLocaleString('cs-CZ');
                const commitName = commit.name || `Commit ${i}`;
                const item = new HistoryItem(`${commitName} - ${dateStr}`, vscode.TreeItemCollapsibleState.Collapsed, filePath, i, undefined, false);
                item.iconPath = vscode.ThemeIcon.Folder;
                item.tooltip = `Commit: ${commitName}\nDatum: ${dateStr}`;
                items.push(item);
            }
            return items.reverse(); // Nejnovější první
        }
        catch (error) {
            console.error('Chyba při načítání commits:', error);
            return [];
        }
    }
    async getPatchesForCommit(filePath, commitIndex) {
        try {
            const content = fs.readFileSync(filePath, 'utf8');
            const history = JSON.parse(content);
            if (commitIndex >= history.commits.length) {
                return [];
            }
            const commit = history.commits[commitIndex];
            const items = [];
            for (let i = 0; i < commit.patches.length; i++) {
                const patch = commit.patches[i];
                const date = new Date(patch.date);
                const dateStr = date.toLocaleString('cs-CZ');
                const item = new HistoryItem(`Patch ${i + 1} - ${dateStr}`, vscode.TreeItemCollapsibleState.None, filePath, commitIndex, i, false);
                item.iconPath = vscode.ThemeIcon.Diff;
                item.tooltip = `Patch ${i + 1}\nDatum: ${dateStr}`;
                item.command = {
                    command: 'faHistory.showDiff',
                    title: 'Zobrazit rozdíly',
                    arguments: [filePath, commitIndex, i]
                };
                items.push(item);
            }
            return items.reverse(); // Nejnovější první
        }
        catch (error) {
            console.error('Chyba při načítání patches:', error);
            return [];
        }
    }
    async getHistoryData(filePath) {
        try {
            const content = fs.readFileSync(filePath, 'utf8');
            return JSON.parse(content);
        }
        catch (error) {
            console.error('Chyba při načítání historie:', error);
            return null;
        }
    }
    async getFileContent(filePath, commitIndex, patchIndex) {
        const history = await this.getHistoryData(filePath);
        if (!history || commitIndex >= history.commits.length) {
            return '';
        }
        const commit = history.commits[commitIndex];
        if (patchIndex >= commit.patches.length) {
            return commit.content || '';
        }
        // Rekonstruuj obsah aplikováním všech patchů až do požadovaného indexu
        let content = '';
        for (let i = 0; i <= patchIndex; i++) {
            const patch = commit.patches[i];
            content = this.applyPatch(content, patch.content);
        }
        return content || commit.content || '';
    }
    applyPatch(original, patchContent) {
        // Vylepšená implementace aplikování unified diff
        if (!patchContent || patchContent.trim() === '') {
            return original;
        }
        const lines = original.split('\n');
        const patchLines = patchContent.split('\n');
        const result = [];
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
            }
            else if (line.startsWith('+') && !line.startsWith('+++')) {
                // Přidat řádek
                result.push(line.substring(1));
                patchLineIndex++;
            }
            else if (line.startsWith('-') && !line.startsWith('---')) {
                // Odstranit řádek - přeskoč ho v originálu
                if (i < lines.length) {
                    i++; // Přeskoč tento řádek v originálu
                }
                patchLineIndex++;
            }
            else if (line.startsWith(' ')) {
                // Zachovat řádek
                if (i < lines.length) {
                    result.push(lines[i]);
                }
                i++;
                patchLineIndex++;
            }
            else {
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
exports.HistoryProvider = HistoryProvider;
//# sourceMappingURL=historyProvider.js.map