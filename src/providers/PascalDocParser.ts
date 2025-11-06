import * as fs from 'fs';
import * as path from 'path';

export interface FunctionDoc {
	name: string;                    // Název funkce/procedury
	signature: string;                // Plná signatura (včetně parametrů)
	summary: string;                  // <summary> obsah
	parameters: Array<{               // <param> tagy
		name: string;
		description: string;
	}>;
	returns?: string;                 // <returns> obsah (pouze pro funkce)
	isFunction: boolean;              // true = function, false = procedure
}

/**
 * Parser pro extrakci dokumentace z FsUtils.pas
 */
export class PascalDocParser {
	/**
	 * Asynchronně parsuje FsUtils.pas a extrahuje dokumentované funkce/procedury
	 */
	async parseAsync(filePath: string): Promise<FunctionDoc[]> {
		return new Promise<FunctionDoc[]>((resolve, reject) => {
			try {
				if (!fs.existsSync(filePath)) {
					resolve([]);
					return;
				}

				const content = fs.readFileSync(filePath, 'utf-8');
				const functions = this.parseContent(content);
				resolve(functions);
			} catch (error) {
				reject(error);
			}
		});
	}

	/**
	 * Parsuje obsah souboru a extrahuje dokumentované funkce/procedury
	 */
	private parseContent(content: string): FunctionDoc[] {
		const functions: FunctionDoc[] = [];
		const lines = content.split(/\r?\n/);

		let i = 0;
		while (i < lines.length) {
			// Hledej /// komentáře
			if (lines[i].trim().startsWith('///')) {
				const docStart = i;
				const docLines: string[] = [];

				// Shromáždi všechny /// komentáře
				while (i < lines.length && lines[i].trim().startsWith('///')) {
					docLines.push(lines[i]);
					i++;
				}

				// Přeskoč prázdné řádky a jednoduché komentáře
				while (i < lines.length) {
					const trimmed = lines[i].trim();
					if (trimmed === '' || trimmed.startsWith('//') && !trimmed.startsWith('///')) {
						i++;
					} else {
						break;
					}
				}

				// Zkontroluj, jestli následuje function nebo procedure
				if (i < lines.length) {
					const declLine = lines[i];
					const funcMatch = declLine.match(/^(function|procedure)\s+(\w+)/i);
					
					if (funcMatch) {
						const funcType = funcMatch[1].toLowerCase();
						const funcName = funcMatch[2];
						
						// Parsuj dokumentaci
						const doc = this.parseDocumentation(docLines);
						
						// Parsuj signaturu (může být na více řádcích)
						const signature = this.parseSignature(lines, i);
						
						if (doc) {
							functions.push({
								name: funcName,
								signature: signature,
								summary: doc.summary,
								parameters: doc.parameters,
								returns: doc.returns,
								isFunction: funcType === 'function'
							});
						}

						// Přeskoč na konec deklarace (hledej středník nebo začátek další funkce)
						while (i < lines.length && !lines[i].includes(';') && !lines[i].match(/^(function|procedure)\s+\w+/i)) {
							i++;
						}
						if (i < lines.length && lines[i].includes(';')) {
							i++;
						}
						continue;
					}
				}
			}
			i++;
		}

		return functions;
	}

	/**
	 * Parsuje XML dokumentační komentáře
	 */
	private parseDocumentation(docLines: string[]): { summary: string; parameters: Array<{ name: string; description: string }>; returns?: string } | null {
		const summaryParts: string[] = [];
		const parameters: Array<{ name: string; description: string }> = [];
		let returns: string | undefined;

		for (const line of docLines) {
			const trimmed = line.trim();
			
			// <summary>
			const summaryMatch = trimmed.match(/^\/\/\/\s*<summary>(.*?)<\/summary>/i);
			if (summaryMatch) {
				summaryParts.push(summaryMatch[1].trim());
				continue;
			}

			// <summary> na více řádcích
			if (trimmed.includes('<summary>')) {
				const start = trimmed.indexOf('<summary>') + 9;
				summaryParts.push(trimmed.substring(start).trim());
				continue;
			}
			if (trimmed.includes('</summary>')) {
				const end = trimmed.indexOf('</summary>');
				summaryParts.push(trimmed.substring(0, end).trim());
				continue;
			}
			if (summaryParts.length > 0 && !trimmed.includes('<param') && !trimmed.includes('<returns') && !trimmed.includes('</summary>')) {
				summaryParts.push(trimmed.replace(/^\/\/\/\s*/, '').trim());
				continue;
			}

			// <param name="...">
			const paramMatch = trimmed.match(/^\/\/\/\s*<param\s+name="([^"]+)"[^>]*>(.*?)<\/param>/i);
			if (paramMatch) {
				parameters.push({
					name: paramMatch[1],
					description: paramMatch[2].trim()
				});
				continue;
			}

			// <param> na více řádcích
			const paramStartMatch = trimmed.match(/^\/\/\/\s*<param\s+name="([^"]+)"[^>]*>/i);
			if (paramStartMatch) {
				const paramName = paramStartMatch[1];
				const rest = trimmed.substring(trimmed.indexOf('>') + 1).trim();
				if (rest) {
					parameters.push({
						name: paramName,
						description: rest
					});
				}
				continue;
			}
			if (parameters.length > 0 && trimmed.includes('</param>')) {
				const end = trimmed.indexOf('</param>');
				const lastParam = parameters[parameters.length - 1];
				lastParam.description += ' ' + trimmed.substring(0, end).replace(/^\/\/\/\s*/, '').trim();
				continue;
			}
			if (parameters.length > 0 && !trimmed.includes('<param') && !trimmed.includes('</param>') && !trimmed.includes('<returns') && !trimmed.includes('</returns>')) {
				const lastParam = parameters[parameters.length - 1];
				lastParam.description += ' ' + trimmed.replace(/^\/\/\/\s*/, '').trim();
				continue;
			}

			// <returns>
			const returnsMatch = trimmed.match(/^\/\/\/\s*<returns>(.*?)<\/returns>/i);
			if (returnsMatch) {
				returns = returnsMatch[1].trim();
				continue;
			}

			// <returns> na více řádcích
			if (trimmed.includes('<returns>')) {
				const start = trimmed.indexOf('<returns>') + 9;
				returns = trimmed.substring(start).trim();
				continue;
			}
			if (trimmed.includes('</returns>')) {
				const end = trimmed.indexOf('</returns>');
				if (returns) {
					returns += ' ' + trimmed.substring(0, end).trim();
				} else {
					returns = trimmed.substring(0, end).trim();
				}
				continue;
			}
			if (returns !== undefined && !trimmed.includes('<param') && !trimmed.includes('</returns>')) {
				returns += ' ' + trimmed.replace(/^\/\/\/\s*/, '').trim();
				continue;
			}
		}

		const summary = summaryParts.join(' ').trim();
		if (!summary) {
			return null; // Ignoruj funkce bez dokumentace
		}

		// Vyčisti description
		parameters.forEach(p => {
			p.description = p.description.trim();
		});
		if (returns) {
			returns = returns.trim();
		}

		return { summary, parameters, returns };
	}

	/**
	 * Parsuje signaturu funkce/procedury (může být na více řádcích)
	 */
	private parseSignature(lines: string[], startIndex: number): string {
		let signature = '';
		let i = startIndex;
		let parenDepth = 0;
		let foundFirst = false;

		while (i < lines.length) {
			const line = lines[i].trim();
			
			// Přeskoč prázdné řádky a komentáře (ale ne ///)
			if (!foundFirst && (line === '' || (line.startsWith('//') && !line.startsWith('///')))) {
				i++;
				continue;
			}
			
			if (!foundFirst && (line.startsWith('function ') || line.startsWith('procedure '))) {
				foundFirst = true;
			}

			if (foundFirst) {
				// Přidej řádek, ale vynech komentáře na konci řádku
				let lineContent = line;
				const commentIndex = lineContent.indexOf('//');
				if (commentIndex >= 0) {
					lineContent = lineContent.substring(0, commentIndex).trim();
				}
				
				if (lineContent) {
					signature += lineContent + ' ';
				}
				
				// Počítej závorky pro detekci konce deklarace
				for (const char of lineContent) {
					if (char === '(') parenDepth++;
					if (char === ')') parenDepth--;
				}

				// Pokud je středník a jsme mimo závorky, konec deklarace
				if (lineContent.includes(';') && parenDepth === 0) {
					break;
				}
				
				// Pokud je overload, pokračuj
				if (lineContent.includes('overload') && !lineContent.includes(';')) {
					i++;
					continue;
				}
			}

			i++;
			
			// Bezpečnostní limit
			if (i - startIndex > 30) {
				break;
			}
		}

		// Normalizuj mezery
		return signature.trim().replace(/\s+/g, ' ').replace(/\s*;\s*$/, '');
	}
}

