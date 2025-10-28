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
- `Aktivovat_formular` - ~~Aktivuje formulář~~ **Již není používáno** (Alt+Q nyní volá Save)
- `Zkompilovat_script` - ~~Zkompiluje script~~ **Odstraněno ve v0.1.7**
- `Vlozit_nazev_udaje` - Vloží název aktuálních údajů (Shift+Alt+V)
- `Najit_udaj` - Najde údaj ve formuláři (Shift+Alt+L)
- **Sidebar Panel:** Ikona v levém panelu s tlačítky pro všechny příkazy (Shift+Alt+F)

## Požadavky na Extension

### Příkazy (Commands):
1. `faBridge.aktivovatFormular` - Send "Aktivovat_formular" to FA
2. ~~`faBridge.zkompilovatScript`~~ - **Odstraněno ve v0.1.7**
3. `faBridge.vlozitNazevUdaje` - Read fafield.txt and insert at cursor
4. `faBridge.kopirovatNazevUdaje` - Read fafield.txt and copy to clipboard
5. `faBridge.najitUdaj` - Write word under cursor to fafield.txt and send "Najit_udaj" to FA

### UI:
- **Sidebar Panel:** Vlastní panel v Activity Bar s ikonou "file-code"
- **TreeView:** Seznam příkazů s ikonami a klávesovými zkratkami
- Kliknutí na položku v panelu spustí příslušný příkaz

### Keybindings:
- `Shift+Alt+F` → Otevřít FA Bridge sidebar
- `Alt+Q` → Uložit soubor (Save = Ctrl+S)
- `Shift+Alt+V` → Vložit název
- `Shift+Alt+C` → Kopírovat název do schránky
- `Shift+Alt+L` → Najít údaj ve formuláři

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
│ │ └── sendCommand.ts # Všechny příkazy
│ ├── utils/
│ │ └── fsBridge.ts # Komunikace s FA
│ └── views/
│   └── FABridgePanel.ts # Sidebar TreeView
├── package.json
├── tsconfig.json
├── README.md
└── .vscodeignore


## Implementace

### extension.ts
- Export `activate()` a `deactivate()`
- Registrace všech příkazů z `sendCommand.ts`
- Registrace sidebar panelu z `FABridgePanel.ts`

### sendCommand.ts
- 4 příkazy pro komunikaci s FA
- Volání `writeFACommand(commandString)`
- Info message po úspěšném odeslání

### FABridgePanel.ts
- TreeView provider pro sidebar panel
- Zobrazení příkazů s ikonami a klávesovými zkratkami
- Kliknutelné položky volají příslušné příkazy

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

## Vývoj a Testování

### Spuštění Extension v Development Mode

**Nejjednodušší způsob - PowerShell script:**
```powershell
.\launch-vscode-dev.ps1
```

Tento script:
1. Zkompiluje TypeScript (`npm run compile`)
2. Otevře VS Code s extension development mode
3. Vytvoří Dev Host okno kde můžeš testovat extension

**Ruční spuštění:**
```powershell
# Zkompiluj
npm run compile

# Spusť VS Code dev mode
code --extensionDevelopmentPath=. .
```

### Workflow při vývoji

1. **Edituj kód v Cursoru** (např. `src/commands/sendCommand.ts`)
2. **Testuj změny:**
   ```powershell
   .\launch-vscode-dev.ps1
   ```
3. **V Dev Host okně testuj příkazy:**
   - Klikni na ikonu FA Bridge v levém panelu
   - Klikni na příkazy v sidebaru
   - `Ctrl+Alt+1,2,V,9` → Jednotlivé příkazy pomocí zkratek

4. **Po změnách restartuj Dev Host:**
   - Zavři Dev Host okno
   - Znova spusť `.\launch-vscode-dev.ps1`

### Vytvoření VSIX instalátoru

**Jednoduchý příkaz:**
```powershell
npm run compile && npx @vscode/vsce package
```

**Postup krok za krokem:**
```powershell
# 1. Zkompiluj TypeScript
npm run compile

# 2. Vytvoř VSIX balíček
npx @vscode/vsce package
```

Vytvoří se soubor: `fa-bridge-0.0.1.vsix` (nebo aktuální verze)

**Před vytvořením nové verze:**
1. Změň `version` v `package.json` (např. `0.0.2`, `0.1.0`, `1.0.0`)
2. Zkompiluj a otestuj
3. Vytvoř VSIX

### Instalace VSIX

**V Cursoru/VS Code:**
1. `Ctrl+Shift+P`
2. Zadej: `Extensions: Install from VSIX...`
3. Vyber: `fa-bridge-0.0.1.vsix`

**Z příkazové řádky:**
```powershell
code --install-extension fa-bridge-0.0.1.vsix
```

### Změna klávesových zkratek

Edituj `package.json` v sekci `"keybindings"`:

```json
{
  "command": "faBridge.vlozitNazevUdaje",
  "key": "ctrl+alt+v",
  "mac": "cmd+alt+v"
}
```

Po změně: zkompiluj (`npm run compile`) a restartuj Dev Host.

### Historie příkazů v terminálu

- `↑` / `↓` - Procházet historii
- `F8` - Hledat v historii (napiš začátek příkazu)
- `Ctrl+R` - Reverse search
- `Tab` - Autocomplete

Rychlý příkaz: napiš `.\la` a stiskni `Tab` → doplní `.\launch-vscode-dev.ps1`

## Poznámky pro AI

Když AI začne pracovat na extension:
1. Vygeneruj strukturu pomocí `yo code`
2. Nahraď `.ts` soubory podle návrhu
3. Aktualizuj `package.json` s příkazy a keybindings
4. Otestuj funkčnost pomocí `.\launch-vscode-dev.ps1`
5. Zajisti aby všechny příkazy psaly do `.fsbridge/facmd.txt`

---

**Vytvořeno:** Říjen 2025  
**Status:** ✅ Implementováno a funkční  
**Verze:** 0.1.7

## Changelog

### v0.1.7 (28.10.2025)
- ✏️ **Aktualizace názvů:**
  - "Uložit a aktivovat FA" → "Aktivovat FA"
  - "Kopírovat název údaje" → "Název údaje do clipboardu"
- ➖ **Odstraněno:**
  - Funkce "Zkompilovat script" (Shift+Alt+D) - nebyla používána

### v0.1.6 (28.10.2025)
- 🧹 **Zjednodušení UI:**
  - Odstraněna registrace příkazů v Command Palette (Ctrl+Shift+P)
  - Všechny funkce jsou nyní dostupné pouze v sidebaru FA Bridge
  - Čistší uživatelské rozhraní bez duplicitních menu

### v0.1.5 (28.10.2025)
- 🔧 **Změna funkce Alt+Q:**
  - Alt+Q nyní volá Save (Ctrl+S) místo aktivace FA
  - Zachováno pro rychlé uložení jednou rukou
- ➖ **Odstraněno "Uložit vše" (Alt+S):**
  - Alt+S kolidovalo s menu Selection v Cursoru
  - Standardní Ctrl+S zůstává v panelu

### v0.1.4 (28.10.2025)
- 🐛 **Lepší error handling:**
  - Chybové hlášky nyní zobrazují skutečnou příčinu problému
  - Usnadňuje debugování při problémech s komunikací s FA

### v0.1.3 (28.10.2025)
- 🎨 **Vlastní ikona extension:**
  - Vytvořena na základě FScode ikony s písmenem "F"
  - Automaticky vygenerována pomocí PowerShell scriptu
  - Zobrazuje se v Activity Bar i v seznamu extensions

### v0.1.2 (28.10.2025)
- ➕ **Přidány standardní příkazy do sidebaru:**
  - Uložit soubor (Ctrl+S)
  - Uložit vše (Alt+S)
- 💡 Všechny důležité příkazy nyní na jednom místě v FA Bridge panelu

### v0.1.1 (28.10.2025)
- 🔧 **Jednotné zkratky:** Všechny příkazy nyní používají **Shift+Alt** (kromě Alt+Q)
  - Otevřít sidebar: Ctrl+Alt+F → Shift+Alt+F
  - Vložit název: Ctrl+Alt+V → Shift+Alt+V
- ➖ Odstraněn testovací příkaz `faBridge.test`
- 📝 Oprava: "název údajů" → "název údaje" (gramatika)

### v0.1.0 (28.10.2025)
- ➕ **Nová funkce:** Kopírovat název údajů do schránky (Shift+Alt+C)
- ➕ **Nová funkce:** Najít údaj ve formuláři podle slova pod kurzorem (Shift+Alt+L)
- 🔧 Změna zkratky "Aktivovat formulář" z Ctrl+Alt+1 na Alt+Q
- 🔧 Změna zkratky "Zkompilovat script" z Ctrl+Alt+2 na Shift+Alt+D
- ➖ Odstraněn testovací příkaz c999

### v0.0.3 (28.10.2025)
- ➕ Klávesová zkratka Ctrl+Alt+F pro otevření sidebaru
- 🔧 Kompatibilita s Cursor (snížena minimální verze na 1.85.0)

### v0.0.2 (28.10.2025)
- ➕ Přidán sidebar panel v Activity Bar
- ➕ TreeView s příkazy a klávesovými zkratkami
- ➖ Odstraněno Quick Pick menu
- 🔧 Změna zkratky pro "Vložit název" z Ctrl+Alt+3 na Ctrl+Alt+V

### v0.0.1 (23.10.2025)
- ✅ Základní implementace
- ✅ Příkazy přes Quick Pick menu