// ============================================================================
// PŘIDAT DO src/extension.ts
// ============================================================================

// 1. NA ZAČÁTKU SOUBORU - přidat importy:
import { HistoryPanel } from './historyPanel';
import { HistoryProvider } from './historyProvider';

// 2. DO FUNKCE activate() - přidat následující kód:

// ============================================================================
// KÓD PRO PANEL HISTORIE - začátek
// ============================================================================

// Zkontroluj, zda je historie zapnutá
const config = vscode.workspace.getConfiguration();
const historyEnabled = config.get<boolean>('local-history.enabled', true);

// Sleduj změny nastavení a aktualizuj panel
const updatePanelVisibility = () => {
    const enabled = config.get<boolean>('local-history.enabled', true);
    if (!enabled && HistoryPanel.currentPanel) {
        HistoryPanel.currentPanel.dispose();
    }
};

if (!historyEnabled) {
    // Přesto zaregistruj listener pro případné zapnutí později
    context.subscriptions.push(
        vscode.workspace.onDidChangeConfiguration(e => {
            if (e.affectsConfiguration('local-history.enabled')) {
                updatePanelVisibility();
            }
        })
    );
    // Pokračuj v aktivaci ostatních částí extensionu
} else {
    // Vytvoř provider pro historii
    const historyProvider = new HistoryProvider(context);

    // Registruj příkazy
    const showDiffCommand = vscode.commands.registerCommand('faHistory.showDiff', 
        async (filePath: string, commitIndex: number, patchIndex: number) => {
            HistoryPanel.createOrShow(context.extensionUri, historyProvider);
            if (HistoryPanel.currentPanel) {
                await HistoryPanel.currentPanel.showDiff(filePath, commitIndex, patchIndex);
            }
        }
    );

    const restoreFileCommand = vscode.commands.registerCommand('faHistory.restoreFile',
        async (filePath: string, commitIndex: number, patchIndex: number) => {
            HistoryPanel.createOrShow(context.extensionUri, historyProvider);
            if (HistoryPanel.currentPanel) {
                await HistoryPanel.currentPanel.restoreFile(filePath, commitIndex, patchIndex);
            }
        }
    );

    const refreshCommand = vscode.commands.registerCommand('faHistory.refresh',
        () => {
            historyProvider.refresh();
        }
    );

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
            const enabled = vscode.workspace.getConfiguration().get<boolean>('local-history.enabled', true);
            if (!enabled) {
                historyTreeView.dispose();
            } else {
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

    context.subscriptions.push(
        showDiffCommand,
        restoreFileCommand,
        refreshCommand,
        historyTreeView,
        configWatcher,
        editorChangeWatcher
    );
}

// ============================================================================
// KÓD PRO PANEL HISTORIE - konec
// ============================================================================

