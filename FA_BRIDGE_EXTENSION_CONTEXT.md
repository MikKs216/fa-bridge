# FA Bridge Extension - Kontext pro AI

## Projekt
- **Jméno:** fa-bridge (Cursor Extension)
- **Účel:** Propojení Cursor/VS Code s editorem FormStudio (FA)
- **Technologie:** TypeScript, VS Code Extension API

## Funkčnost (co má dělat)

### Současný stav (z PowerShell tasků):
FA Bridge komunikuje s FormStudio přes soubor `.fsbridge/facmd.txt`:
1. Cursor zapíše příkaz do `.fsbridge/facmd.txt`
2. FA sleduje změny tohoto souboru
3. FA přečte příkaz a provede akci

### Příkazy:
- `Aktivovat_formular` - Aktivuje formulář (Ctrl+Alt+1)
- `Zkompilovat_script` - Zkompiluje script (Ctrl+Alt+2)
- `Vlozit_nazev_udaje` - Vloží název aktuálních údajů (Ctrl+Alt+3)
- `c999` - Speciální příkaz (Ctrl+Alt+9)
- **Menu:** Ctrl+Alt+F - Quick pick s výběrem příkazů

## Požadavky na Extension

### Příkazy (Commands):
1. `faBridge.aktivovatFormular` - Send "Aktivovat_formular" to FA
2. `faBridge.zkompilovatScript` - Send "Zkompilovat_script" to FA
3. `faBridge.vlozitNazevUdaje` - Send "Vlozit_nazev_udaje" to FA
4. `faBridge.sendC999` - Send "c999" to FA
5. `faBridge.menu` - Quick pick menu s výběrem

### Keybindings:
- `Ctrl+Alt+F` → Menu (Quick pick)
- `Ctrl+Alt+1` → Aktivovat formulář
- `Ctrl+Alt+2` → Zkompilovat script
- `Ctrl+Alt+3` → Vložit název
- `Ctrl+Alt+9` → Send c999

### Formát komunikace:
- **Soubor:** `.fsbridge/facmd.txt` (relativně k workspace root)
- **Kódování:** UTF-8 s BOM
- **Formát:** Bez trailing newline
- **Proces:** Atomický (tmp → rename)

## Struktura Projektu
fa-bridge/
├── src/
│ ├── extension.ts # Hlavní soubor (aktivace)
│ ├── commands/
│ │ └── sendCommand.ts # Všechny príkazy
│ └── utils/
│ └── fsBridge.ts # Komunikace s FA
├── package.json
├── tsconfig.json
├── README.md
└── .vscodeignore


## Implementace

### extension.ts
- Export `activate()` a `deactivate()`
- Registrace všech příkazů z `sendCommand.ts`

### sendCommand.ts
- 5 příkazů (4x konkrétní + 1x menu s Quick Pick)
- Volání `writeFACommand(commandString)`
- Info message po úspěšném odeslání

### fsBridge.ts
- `writeFACommand(command: string)` - Hlavní funkce
  - Vytvořit `.fsbridge` složku (pokud neexistuje)
  - Atomický zápis do `.fsbridge/facmd.txt`
  - Použít UTF-8 s BOM
  - Bez trailing newline

## Budoucí Rozšíření

Tyto funkce přidáme později:
- Čtení dat z souborů a vložení na kurzor
- Dialogy pro výběr souborů
- Preview obsahu
- Transformace textu

## Reference

- Originální řešení: PowerShell tasky v `.vscode/tasks.json`
- Dokumentace: `FS_BRIDGE_README.md` (v původním projektu)
- Keybindings: `reports/keybind.json`

## Poznámky pro AI

Když AI začne pracovat na extension:
1. Vygeneruj strukturu pomocí `yo code`
2. Nahraď `.ts` soubory podle návrhu
3. Aktualizuj `package.json` s příkazy a keybindings
4. Otestuj funkčnost
5. Zajisti aby všechny příkazy psaly do `.fsbridge/facmd.txt`

---

**Vytvořeno:** Říjen 2025
**Status:** Připraveno k implementaci v novém projektu