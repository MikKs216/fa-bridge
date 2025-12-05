import * as vscode from 'vscode';
import * as path from 'path';
import * as fs from 'fs';
import { HistoryProvider } from './historyProvider';

export class HistoryPanel {
    public static currentPanel: HistoryPanel | undefined;
    public static readonly viewType = 'faHistoryPanel';
    private readonly _panel: vscode.WebviewPanel;
    private _disposables: vscode.Disposable[] = [];

    public static createOrShow(extensionUri: vscode.Uri, historyProvider: HistoryProvider) {
        const column = vscode.window.activeTextEditor
            ? vscode.window.activeTextEditor.viewColumn
            : undefined;

        if (HistoryPanel.currentPanel) {
            HistoryPanel.currentPanel._panel.reveal(column);
            return;
        }

        const panel = vscode.window.createWebviewPanel(
            HistoryPanel.viewType,
            'Historie souboru',
            column || vscode.ViewColumn.One,
            {
                enableScripts: true,
                localResourceRoots: [vscode.Uri.joinPath(extensionUri, 'media')],
                retainContextWhenHidden: true
            }
        );

        HistoryPanel.currentPanel = new HistoryPanel(panel, extensionUri, historyProvider);
    }

    private constructor(
        panel: vscode.WebviewPanel,
        extensionUri: vscode.Uri,
        private historyProvider: HistoryProvider
    ) {
        this._panel = panel;
        this._panel.onDidDispose(() => this.dispose(), null, this._disposables);
        this._panel.webview.html = this._getHtmlForWebview(this._panel.webview, extensionUri);
        this._setWebviewMessageListener(this._panel.webview);
    }

    public async showDiff(filePath: string, commitIndex: number, patchIndex: number) {
        // filePath je cesta k souboru v .history složce
        if (!fs.existsSync(filePath)) {
            vscode.window.showErrorMessage('Soubor historie neexistuje');
            return;
        }

        // Získej cestu k původnímu souboru
        const historyDir = path.dirname(filePath);
        const sourceFile = path.join(path.dirname(historyDir), path.basename(filePath).replace(/-\d{8}-\d{6}\./, '.'));

        if (!fs.existsSync(sourceFile)) {
            vscode.window.showErrorMessage(`Soubor ${sourceFile} neexistuje`);
            return;
        }

        // Vytvoř URI pro oba soubory
        const currentUri = vscode.Uri.file(sourceFile);
        const historyUri = vscode.Uri.file(filePath);

        // Získej timestamp z názvu souboru pro zobrazení
        const historyFileName = path.basename(filePath);
        const timestampMatch = historyFileName.match(/-(\d{8})-(\d{6})\./);
        let timestamp = historyFileName;
        if (timestampMatch) {
            const dateStr = timestampMatch[1];
            const timeStr = timestampMatch[2];
            timestamp = `${dateStr.substring(0, 4)}-${dateStr.substring(4, 6)}-${dateStr.substring(6, 8)} ${timeStr.substring(0, 2)}:${timeStr.substring(2, 4)}:${timeStr.substring(4, 6)}`;
        }

        // Otevři VS Code diff editor (má synchronizované scrollování a inline diff view)
        await vscode.commands.executeCommand('vscode.diff', 
            historyUri,  // vlevo - historická verze
            currentUri,  // vpravo - aktuální soubor
            `${historyFileName} ↔ ${path.basename(sourceFile)}`
        );
    }

    public static async showDiffStatic(historyFilePath: string, sourceFilePath: string): Promise<void> {
        if (!fs.existsSync(historyFilePath)) {
            vscode.window.showErrorMessage('Soubor historie neexistuje');
            return;
        }

        if (!fs.existsSync(sourceFilePath)) {
            vscode.window.showErrorMessage(`Soubor ${sourceFilePath} neexistuje`);
            return;
        }

        // Vytvoř URI pro oba soubory
        const currentUri = vscode.Uri.file(sourceFilePath);
        const historyUri = vscode.Uri.file(historyFilePath);

        // Získej timestamp z názvu souboru pro zobrazení
        const historyFileName = path.basename(historyFilePath);
        const timestampMatch = historyFileName.match(/-(\d{8})-(\d{6})\./);
        let timestamp = historyFileName;
        if (timestampMatch) {
            const dateStr = timestampMatch[1];
            const timeStr = timestampMatch[2];
            timestamp = `${dateStr.substring(0, 4)}-${dateStr.substring(4, 6)}-${dateStr.substring(6, 8)} ${timeStr.substring(0, 2)}:${timeStr.substring(2, 4)}:${timeStr.substring(4, 6)}`;
        }

        // Otevři VS Code diff editor
        await vscode.commands.executeCommand('vscode.diff', 
            historyUri,  // vlevo - historická verze
            currentUri,  // vpravo - aktuální soubor
            `${historyFileName} ↔ ${path.basename(sourceFilePath)}`
        );
    }

    private async getHistoryVersions(historyDir: string, sourceFile: string): Promise<string[]> {
        const fileName = path.basename(sourceFile);
        const baseName = path.basename(fileName, path.extname(fileName));
        const ext = path.extname(fileName);

        const entries = fs.readdirSync(historyDir);
        const versions = entries
            .filter(entry => {
                const pattern = new RegExp(`^${baseName.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}-\\d{8}-\\d{6}${ext.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}$`);
                return pattern.test(entry);
            })
            .map(entry => path.join(historyDir, entry))
            .sort((a, b) => {
                const statA = fs.statSync(a);
                const statB = fs.statSync(b);
                return statB.mtimeMs - statA.mtimeMs;
            });

        return versions;
    }

    private createSimpleDiff(contentBefore: string, contentAfter: string): string {
        const linesBefore = contentBefore.split('\n');
        const linesAfter = contentAfter.split('\n');
        const diff: string[] = [];
        
        diff.push('--- Předchozí verze');
        diff.push('+++ Aktuální verze');
        diff.push('@@ -1,1 +1,1 @@');
        
        // Jednoduchý line-by-line diff
        const maxLines = Math.max(linesBefore.length, linesAfter.length);
        for (let i = 0; i < maxLines; i++) {
            const lineBefore = i < linesBefore.length ? linesBefore[i] : '';
            const lineAfter = i < linesAfter.length ? linesAfter[i] : '';
            
            if (lineBefore === lineAfter) {
                diff.push(' ' + lineBefore);
            } else {
                if (lineBefore) {
                    diff.push('-' + lineBefore);
                }
                if (lineAfter) {
                    diff.push('+' + lineAfter);
                }
            }
        }
        
        return diff.join('\n');
    }

    public async restoreFile(filePath: string, commitIndex: number, patchIndex: number) {
        // filePath je cesta k souboru v .history složce
        if (!fs.existsSync(filePath)) {
            vscode.window.showErrorMessage('Soubor historie neexistuje');
            return;
        }

        // Získej cestu k původnímu souboru
        const historyDir = path.dirname(filePath);
        const sourceFile = path.join(path.dirname(historyDir), path.basename(filePath).replace(/-\d{8}-\d{6}\./, '.'));

        if (!fs.existsSync(sourceFile)) {
            vscode.window.showErrorMessage(`Soubor ${sourceFile} neexistuje`);
            return;
        }

        const result = await vscode.window.showWarningMessage(
            `Opravdu chcete vrátit soubor ${path.basename(sourceFile)} do tohoto bodu historie?`,
            { modal: true },
            'Ano',
            'Ne'
        );

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
            
            vscode.window.showInformationMessage(
                `Soubor byl vrácen do vybraného bodu historie. Záloha byla vytvořena: ${path.basename(backupPath)}`
            );
        } catch (error) {
            vscode.window.showErrorMessage(`Chyba při vracení souboru: ${error}`);
        }
    }

    public static async restoreFileStatic(historyFilePath: string, historyProvider: HistoryProvider): Promise<void> {
        if (!fs.existsSync(historyFilePath)) {
            vscode.window.showErrorMessage('Soubor historie neexistuje');
            return;
        }

        // Získej cestu k původnímu souboru
        const historyDir = path.dirname(historyFilePath);
        const sourceFile = path.join(path.dirname(historyDir), path.basename(historyFilePath).replace(/-\d{8}-\d{6}\./, '.'));

        if (!fs.existsSync(sourceFile)) {
            vscode.window.showErrorMessage(`Soubor ${sourceFile} neexistuje`);
            return;
        }

        const result = await vscode.window.showWarningMessage(
            `Opravdu chcete vrátit soubor ${path.basename(sourceFile)} do tohoto bodu historie?`,
            { modal: true },
            'Ano',
            'Ne'
        );

        if (result !== 'Ano') {
            return;
        }

        try {
            const content = await historyProvider.getFileContent(historyFilePath, 0, 0);
            
            // Vytvoř zálohu současného souboru
            const backupPath = `${sourceFile}.backup.${Date.now()}`;
            fs.copyFileSync(sourceFile, backupPath);
            
            // Zapiš obsah do souboru
            fs.writeFileSync(sourceFile, content, 'utf8');
            
            // Otevři soubor v editoru
            const document = await vscode.workspace.openTextDocument(sourceFile);
            await vscode.window.showTextDocument(document);
            
            vscode.window.showInformationMessage(
                `Soubor byl vrácen do vybraného bodu historie. Záloha byla vytvořena: ${path.basename(backupPath)}`
            );
        } catch (error) {
            vscode.window.showErrorMessage(`Chyba při vracení souboru: ${error}`);
        }
    }

    public static async compareWithPreviousStatic(
        currentHistoryFilePath: string, 
        historyProvider: HistoryProvider
    ): Promise<void> {
        if (!fs.existsSync(currentHistoryFilePath)) {
            vscode.window.showErrorMessage('Soubor historie neexistuje');
            return;
        }

        // Získej všechny verze pro tento soubor
        const historyDir = path.dirname(currentHistoryFilePath);
        const sourceFile = path.join(path.dirname(historyDir), path.basename(currentHistoryFilePath).replace(/-\d{8}-\d{6}\./, '.'));
        
        const fileName = path.basename(sourceFile);
        const baseName = path.basename(fileName, path.extname(fileName));
        const ext = path.extname(fileName);

        // Najdi všechny verze v historii
        const entries = fs.readdirSync(historyDir);
        const versions = entries
            .filter(entry => {
                const pattern = new RegExp(`^${baseName.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}-\\d{8}-\\d{6}${ext.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}$`);
                return pattern.test(entry);
            })
            .map(entry => path.join(historyDir, entry))
            .sort((a, b) => {
                const statA = fs.statSync(a);
                const statB = fs.statSync(b);
                return statB.mtimeMs - statA.mtimeMs; // Nejnovější první
            });

        // Najdi index aktuální verze
        const currentIndex = versions.findIndex(v => v === currentHistoryFilePath);
        
        if (currentIndex === -1) {
            vscode.window.showErrorMessage('Nelze najít aktuální verzi v historii');
            return;
        }

        // Zkontroluj, jestli existuje předchozí verze
        if (currentIndex + 1 >= versions.length) {
            vscode.window.showInformationMessage('Toto je nejstarší verze v historii');
            return;
        }

        const previousVersionPath = versions[currentIndex + 1];
        
        if (!fs.existsSync(previousVersionPath)) {
            vscode.window.showErrorMessage('Předchozí verze neexistuje');
            return;
        }

        // Získej timestampy pro zobrazení
        const currentFileName = path.basename(currentHistoryFilePath);
        const previousFileName = path.basename(previousVersionPath);
        
        const currentTimestampMatch = currentFileName.match(/-(\d{8})-(\d{6})\./);
        const previousTimestampMatch = previousFileName.match(/-(\d{8})-(\d{6})\./);
        
        let currentTimestamp = currentFileName;
        let previousTimestamp = previousFileName;
        
        if (currentTimestampMatch) {
            const dateStr = currentTimestampMatch[1];
            const timeStr = currentTimestampMatch[2];
            currentTimestamp = `${dateStr.substring(0, 4)}-${dateStr.substring(4, 6)}-${dateStr.substring(6, 8)} ${timeStr.substring(0, 2)}:${timeStr.substring(2, 4)}:${timeStr.substring(4, 6)}`;
        }
        
        if (previousTimestampMatch) {
            const dateStr = previousTimestampMatch[1];
            const timeStr = previousTimestampMatch[2];
            previousTimestamp = `${dateStr.substring(0, 4)}-${dateStr.substring(4, 6)}-${dateStr.substring(6, 8)} ${timeStr.substring(0, 2)}:${timeStr.substring(2, 4)}:${timeStr.substring(4, 6)}`;
        }

        // Vytvoř URI pro oba soubory
        const currentUri = vscode.Uri.file(currentHistoryFilePath);
        const previousUri = vscode.Uri.file(previousVersionPath);

        // Otevři VS Code diff editor (starší vlevo, novější vpravo)
        await vscode.commands.executeCommand('vscode.diff', 
            previousUri,  // vlevo - starší verze
            currentUri,    // vpravo - novější verze
            `${previousTimestamp} ↔ ${currentTimestamp}`
        );
    }

    private _setWebviewMessageListener(webview: vscode.Webview) {
        webview.onDidReceiveMessage(
            async (message: any) => {
                const command = message.command;
                
                switch (command) {
                    case 'restoreFile':
                        await this.restoreFile(message.filePath, message.commitIndex, message.patchIndex);
                        break;
                    case 'showDiff':
                        await this.showDiff(message.filePath, message.commitIndex, message.patchIndex);
                        break;
                }
            },
            null,
            this._disposables
        );
    }

    private _getHtmlForWebview(webview: vscode.Webview, extensionUri: vscode.Uri): string {
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

    public dispose() {
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





