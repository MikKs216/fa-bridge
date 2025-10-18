# FA Bridge Extension

Propojení **Cursor/VS Code** s editorem **FormStudio (FA)** pomocí FA Bridge.

## Funkčnost

Tato extension umožňuje komunikovat s FormStudio přes příkazy, které se zapisují do souboru `.fsbridge/facmd.txt`.

### Dostupné příkazy

| Příkaz | Klávesová zkratka | Popis |
|--------|-------------------|-------|
| **Aktivovat formulář** | <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>1</kbd> | Aktivuje aktuální formulář v FA |
| **Zkompilovat script** | <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>2</kbd> | Zkompiluje aktuální script |
| **Vložit název údajů** | <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>3</kbd> | Vloží název aktuálních údajů na kurzor |
| **c999** | <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>9</kbd> | Speciální příkaz |
| **FA Menu** | <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>F</kbd> | Zobrazí Quick Pick menu se všemi příkazy |

> **Tip na macOS:** Nahraď <kbd>Ctrl</kbd> za <kbd>Cmd</kbd>

## Instalace

1. Klonuj tento repo
2. Spusť `npm install` v kořenovém adresáři
3. Spusť `npm run compile` pro kompilaci TypeScriptu
4. V Cursoru/VS Code stiskni <kbd>F5</kbd> pro spuštění extension v debug modu

## Vývoj

### Struktura projektu

```
src/
├── extension.ts          # Hlavní soubor (aktivace, registrace příkazů)
├── commands/
│   └── sendCommand.ts    # Implementace všech 5 příkazů
└── utils/
    └── fsBridge.ts       # Komunikace s FA (zápis do .fsbridge/facmd.txt)
```

### Kompilace

```bash
npm run compile      # Jednorázová kompilace
npm run watch        # Watch mode
npm run lint         # ESLint check
```

## Jak to funguje

1. **Uživatel stiskne zkratku** (např. <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>1</kbd>)
2. **Extension napíše příkaz** do souboru `.fsbridge/facmd.txt` (UTF-8 s BOM, bez trailing newline)
3. **FA sleduje tento soubor** a automaticky provede příslušnou akci
4. **Uživateli se zobrazí potvrzující zpráva** v notifikaci

### Atomické zápisy

Příkazy se zapisují atomicky (`tmp → rename`) aby se FA nezbláznila, když čte soubor v průběhu zápisu.

## Testování

Vytvoř si workspace s nějakými soubory a:

```bash
npm run test
```

## Release Notes

### 0.0.1

- Implementace všech 5 základních příkazů
- Quick Pick menu
- Atomické zápisy do `.fsbridge/facmd.txt`
- UTF-8 s BOM

---

**Vytvořeno:** Říjen 2025 | **Status:** Funkční ✓
