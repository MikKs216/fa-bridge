import * as fs from 'fs';
import * as path from 'path';
import * as vscode from 'vscode';

/**
 * Zapíše příkaz do .fsbridge/facmd.txt s UTF-8 BOM
 * Atomicky (tmp → rename) aby se FA nezbláznila
 */
export async function writeFACommand(command: string): Promise<void> {
	try {
		const workspaceRoot = vscode.workspace.workspaceFolders?.[0]?.uri.fsPath;
		if (!workspaceRoot) {
			throw new Error('Žádný workspace otevřen');
		}

		const fsbridgeDir = path.join(workspaceRoot, '.fsbridge');
		const facmdPath = path.join(fsbridgeDir, 'facmd.txt');

		// Vytvoř .fsbridge složku pokud neexistuje
		if (!fs.existsSync(fsbridgeDir)) {
			fs.mkdirSync(fsbridgeDir, { recursive: true });
		}

		// UTF-8 s BOM (EF BB BF)
		const bom = Buffer.from([0xef, 0xbb, 0xbf]);
		const commandBuffer = Buffer.from(command, 'utf-8');
		const content = Buffer.concat([bom, commandBuffer]);

		// Atomický zápis: tmp → rename
		const tmpPath = facmdPath + '.tmp';
		fs.writeFileSync(tmpPath, content);
		fs.renameSync(tmpPath, facmdPath);

		console.log(`[FA Bridge] Odeslán příkaz: ${command}`);
	} catch (error) {
		const msg = error instanceof Error ? error.message : String(error);
		console.error(`[FA Bridge] Chyba: ${msg}`);
		throw error;
	}
}
