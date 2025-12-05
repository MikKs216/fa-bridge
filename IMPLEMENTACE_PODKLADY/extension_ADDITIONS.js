"use strict";
// ============================================================================
// PŘIDAT DO src/extension.ts
// ============================================================================
Object.defineProperty(exports, "__esModule", { value: true });
// 1. NA ZAČÁTKU SOUBORU - přidat importy:
const historyPanel_1 = require("./historyPanel");
const historyProvider_1 = require("./historyProvider");
// 2. DO FUNKCE activate() - přidat následující kód:
// ============================================================================
// KÓD PRO PANEL HISTORIE - začátek
// ============================================================================
// Zkontroluj, zda je historie zapnutá
const config = vscode.workspace.getConfiguration();
const historyEnabled = config.get('local-history.enabled', true);
// Sleduj změny nastavení a aktualizuj panel
const updatePanelVisibility = () => {
    const enabled = config.get('local-history.enabled', true);
    if (!enabled && historyPanel_1.HistoryPanel.currentPanel) {
        historyPanel_1.HistoryPanel.currentPanel.dispose();
    }
};
if (!historyEnabled) {
    // Přesto zaregistruj listener pro případné zapnutí později
    context.subscriptions.push(vscode.workspace.onDidChangeConfiguration(e => {
        if (e.affectsConfiguration('local-history.enabled')) {
            updatePanelVisibility();
        }
    }));
    // Pokračuj v aktivaci ostatních částí extensionu
}
else {
    // Vytvoř provider pro historii
    const historyProvider = new historyProvider_1.HistoryProvider(context);
    // Registruj příkazy
    const showDiffCommand = vscode.commands.registerCommand('faHistory.showDiff', async (filePath, commitIndex, patchIndex) => {
        historyPanel_1.HistoryPanel.createOrShow(context.extensionUri, historyProvider);
        if (historyPanel_1.HistoryPanel.currentPanel) {
            await historyPanel_1.HistoryPanel.currentPanel.showDiff(filePath, commitIndex, patchIndex);
        }
    });
    const restoreFileCommand = vscode.commands.registerCommand('faHistory.restoreFile', async (filePath, commitIndex, patchIndex) => {
        historyPanel_1.HistoryPanel.createOrShow(context.extensionUri, historyProvider);
        if (historyPanel_1.HistoryPanel.currentPanel) {
            await historyPanel_1.HistoryPanel.currentPanel.restoreFile(filePath, commitIndex, patchIndex);
        }
    });
    const refreshCommand = vscode.commands.registerCommand('faHistory.refresh', () => {
        historyProvider.refresh();
    });
    // Vytvoř TreeView pro historii
    const historyTreeView = vscode.window.createTreeView('faHistoryPanel', {
        treeDataProvider: historyProvider,
        showCollapseAll: true
    });
    // Aktualizuj panel při změně aktivního editoru
    const editorChangeWatcher = vscode.window.onDidChangeActiveTextEditor(() => {
        historyProvider.refresh();
    });
    // Aktualizuj panel při změně nastavení
    const configWatcher = vscode.workspace.onDidChangeConfiguration(e => {
        if (e.affectsConfiguration('local-history.enabled')) {
            updatePanelVisibility();
            const enabled = vscode.workspace.getConfiguration().get('local-history.enabled', true);
            if (!enabled) {
                historyTreeView.dispose();
            }
            else {
                // Pokud je historie zapnutá a panel neexistuje, vytvoř ho
                if (!historyTreeView) {
                    const newTreeView = vscode.window.createTreeView('faHistoryPanel', {
                        treeDataProvider: historyProvider,
                        showCollapseAll: true
                    });
                    context.subscriptions.push(newTreeView);
                }
            }
        }
    });
    context.subscriptions.push(showDiffCommand, restoreFileCommand, refreshCommand, historyTreeView, configWatcher, editorChangeWatcher);
}
// ============================================================================
// KÓD PRO PANEL HISTORIE - konec
// ============================================================================
//# sourceMappingURL=extension_ADDITIONS.js.map