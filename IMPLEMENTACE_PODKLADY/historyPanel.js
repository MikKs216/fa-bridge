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
exports.HistoryPanel = void 0;
const vscode = __importStar(require("vscode"));
const path = __importStar(require("path"));
const fs = __importStar(require("fs"));
class HistoryPanel {
    historyProvider;
    static currentPanel;
    static viewType = 'faHistoryPanel';
    _panel;
    _disposables = [];
    static createOrShow(extensionUri, historyProvider) {
        const column = vscode.window.activeTextEditor
            ? vscode.window.activeTextEditor.viewColumn
            : undefined;
        if (HistoryPanel.currentPanel) {
            HistoryPanel.currentPanel._panel.reveal(column);
            return;
        }
        const panel = vscode.window.createWebviewPanel(HistoryPanel.viewType, 'Historie souboru', column || vscode.ViewColumn.One, {
            enableScripts: true,
            localResourceRoots: [vscode.Uri.joinPath(extensionUri, 'media')],
            retainContextWhenHidden: true
        });
        HistoryPanel.currentPanel = new HistoryPanel(panel, extensionUri, historyProvider);
    }
    constructor(panel, extensionUri, historyProvider) {
        this.historyProvider = historyProvider;
        this._panel = panel;
        this._panel.onDidDispose(() => this.dispose(), null, this._disposables);
        this._panel.webview.html = this._getHtmlForWebview(this._panel.webview, extensionUri);
        this._setWebviewMessageListener(this._panel.webview);
    }
    async showDiff(filePath, commitIndex, patchIndex) {
        const history = await this.historyProvider.getHistoryData(filePath);
        if (!history) {
            vscode.window.showErrorMessage('Nepodařilo se načíst historii souboru');
            return;
        }
        const commit = history.commits[commitIndex];
        const patch = commit.patches[patchIndex];
        // Získej obsah před a po patch
        const contentBefore = await this.historyProvider.getFileContent(filePath, commitIndex, patchIndex - 1);
        const contentAfter = await this.historyProvider.getFileContent(filePath, commitIndex, patchIndex);
        const sourceFile = path.join(path.dirname(path.dirname(filePath)), history.sourceFile);
        this._panel.webview.postMessage({
            command: 'showDiff',
            data: {
                filePath: sourceFile,
                patchContent: patch.content,
                contentBefore,
                contentAfter,
                date: new Date(patch.date).toLocaleString('cs-CZ'),
                commitIndex,
                patchIndex
            }
        });
    }
    async restoreFile(filePath, commitIndex, patchIndex) {
        const history = await this.historyProvider.getHistoryData(filePath);
        if (!history) {
            vscode.window.showErrorMessage('Nepodařilo se načíst historii souboru');
            return;
        }
        const sourceFile = path.join(path.dirname(path.dirname(filePath)), history.sourceFile);
        if (!fs.existsSync(sourceFile)) {
            vscode.window.showErrorMessage(`Soubor ${sourceFile} neexistuje`);
            return;
        }
        const result = await vscode.window.showWarningMessage(`Opravdu chcete vrátit soubor ${path.basename(sourceFile)} do tohoto bodu historie?`, { modal: true }, 'Ano', 'Ne');
        if (result !== 'Ano') {
            return;
        }
        try {
            const content = await this.historyProvider.getFileContent(filePath, commitIndex, patchIndex);
            // Vytvoř zálohu současného souboru
            const backupPath = `${sourceFile}.backup.${Date.now()}`;
            fs.copyFileSync(sourceFile, backupPath);
            // Zapiš obsah do souboru
            fs.writeFileSync(sourceFile, content, 'utf8');
            // Otevři soubor v editoru
            const document = await vscode.workspace.openTextDocument(sourceFile);
            await vscode.window.showTextDocument(document);
            vscode.window.showInformationMessage(`Soubor byl vrácen do vybraného bodu historie. Záloha byla vytvořena: ${path.basename(backupPath)}`);
        }
        catch (error) {
            vscode.window.showErrorMessage(`Chyba při vracení souboru: ${error}`);
        }
    }
    _setWebviewMessageListener(webview) {
        webview.onDidReceiveMessage(async (message) => {
            const command = message.command;
            switch (command) {
                case 'restoreFile':
                    await this.restoreFile(message.filePath, message.commitIndex, message.patchIndex);
                    break;
                case 'showDiff':
                    await this.showDiff(message.filePath, message.commitIndex, message.patchIndex);
                    break;
            }
        }, null, this._disposables);
    }
    _getHtmlForWebview(webview, extensionUri) {
        return `<!DOCTYPE html>
<html lang="cs">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historie souboru</title>
    <style>
        body {
            font-family: var(--vscode-font-family);
            font-size: var(--vscode-font-size);
            color: var(--vscode-foreground);
            padding: 20px;
            background-color: var(--vscode-editor-background);
        }
        .diff-container {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .diff-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px;
            background-color: var(--vscode-editor-background);
            border-bottom: 1px solid var(--vscode-panel-border);
        }
        .diff-content {
            display: flex;
            gap: 10px;
            height: calc(100vh - 200px);
        }
        .diff-panel {
            flex: 1;
            border: 1px solid var(--vscode-panel-border);
            overflow: auto;
        }
        .diff-panel-header {
            padding: 8px;
            background-color: var(--vscode-panel-background);
            border-bottom: 1px solid var(--vscode-panel-border);
            font-weight: bold;
        }
        .diff-panel-content {
            padding: 10px;
            font-family: 'Courier New', monospace;
            white-space: pre-wrap;
            word-wrap: break-word;
        }
        .line-added {
            background-color: rgba(0, 255, 0, 0.1);
            color: var(--vscode-diffEditor-insertedTextBackground);
        }
        .line-removed {
            background-color: rgba(255, 0, 0, 0.1);
            color: var(--vscode-diffEditor-removedTextBackground);
        }
        .line-unchanged {
            color: var(--vscode-foreground);
        }
        .button {
            padding: 6px 12px;
            background-color: var(--vscode-button-background);
            color: var(--vscode-button-foreground);
            border: none;
            cursor: pointer;
            margin-left: 10px;
        }
        .button:hover {
            background-color: var(--vscode-button-hoverBackground);
        }
        .button-secondary {
            background-color: var(--vscode-button-secondaryBackground);
            color: var(--vscode-button-secondaryForeground);
        }
        .button-secondary:hover {
            background-color: var(--vscode-button-secondaryHoverBackground);
        }
        .info {
            padding: 10px;
            background-color: var(--vscode-textBlockQuote-background);
            border-left: 3px solid var(--vscode-textBlockQuote-border);
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <div class="info">
        <div id="fileInfo"></div>
        <div id="dateInfo"></div>
    </div>
    <div class="diff-container">
        <div class="diff-header">
            <span>Rozdíly mezi verzemi</span>
            <div>
                <button class="button button-secondary" id="restoreBtn">Vrátit stav souboru do tohoto bodu</button>
            </div>
        </div>
        <div class="diff-content">
            <div class="diff-panel">
                <div class="diff-panel-header">Předchozí verze</div>
                <div class="diff-panel-content" id="contentBefore"></div>
            </div>
            <div class="diff-panel">
                <div class="diff-panel-header">Aktuální verze</div>
                <div class="diff-panel-content" id="contentAfter"></div>
            </div>
        </div>
    </div>
    <script>
        const vscode = acquireVsCodeApi();
        let currentData = null;

        window.addEventListener('message', event => {
            const message = event.data;
            
            switch (message.command) {
                case 'showDiff':
                    currentData = message.data;
                    displayDiff(message.data);
                    break;
            }
        });

        function displayDiff(data) {
            document.getElementById('fileInfo').textContent = 'Soubor: ' + data.filePath;
            document.getElementById('dateInfo').textContent = 'Datum: ' + data.date;
            
            const contentBefore = document.getElementById('contentBefore');
            const contentAfter = document.getElementById('contentAfter');
            
            // Zobraz diff
            const diff = parseDiff(data.patchContent);
            contentBefore.innerHTML = formatDiffContent(diff, 'before');
            contentAfter.innerHTML = formatDiffContent(diff, 'after');
            
            // Nastav handler pro tlačítko
            document.getElementById('restoreBtn').onclick = () => {
                vscode.postMessage({
                    command: 'restoreFile',
                    filePath: currentData.filePath,
                    commitIndex: currentData.commitIndex,
                    patchIndex: currentData.patchIndex
                });
            };
        }

        function parseDiff(patchContent) {
            const lines = patchContent.split('\\n');
            const diff = [];
            let inHunk = false;
            
            for (const line of lines) {
                if (line.startsWith('@@')) {
                    inHunk = true;
                    continue;
                }
                if (inHunk) {
                    if (line.startsWith('+') && !line.startsWith('+++')) {
                        diff.push({ type: 'added', content: line.substring(1) });
                    } else if (line.startsWith('-') && !line.startsWith('---')) {
                        diff.push({ type: 'removed', content: line.substring(1) });
                    } else if (line.startsWith(' ')) {
                        diff.push({ type: 'unchanged', content: line.substring(1) });
                    }
                }
            }
            
            return diff;
        }

        function formatDiffContent(diff, side) {
            return diff.map(item => {
                if (side === 'before' && item.type === 'added') {
                    return '';
                }
                if (side === 'after' && item.type === 'removed') {
                    return '';
                }
                const className = item.type === 'added' ? 'line-added' : 
                                 item.type === 'removed' ? 'line-removed' : 
                                 'line-unchanged';
                return '<div class="' + className + '">' + escapeHtml(item.content) + '</div>';
            }).join('');
        }

        function escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }
    </script>
</body>
</html>`;
    }
    dispose() {
        HistoryPanel.currentPanel = undefined;
        this._panel.dispose();
        while (this._disposables.length) {
            const x = this._disposables.pop();
            if (x) {
                x.dispose();
            }
        }
    }
}
exports.HistoryPanel = HistoryPanel;
//# sourceMappingURL=historyPanel.js.map