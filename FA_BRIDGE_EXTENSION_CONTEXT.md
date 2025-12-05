# FA Bridge Extension - Kontext pro AI

## Projekt
- **Jméno:** fa-bridge (Cursor Extension)
- **Účel:** Propojení Cursor/VS Code s editorem FormStudio (FA)
- **Technologie:** TypeScript, VS Code Extension API
- **Aktuální verze:** 0.5.83

## Funkčnost (co má dělat)

### Současný stav (z PowerShell tasků):
FA Bridge komunikuje s FormStudio přes soubor `.fsbridge/facmd.txt`:
1. Cursor zapíše příkaz do `.fsbridge/facmd.txt`
2. FA sleduje změny tohoto souboru
3. FA přečte příkaz a provede akci

### Příkazy:
- `Aktivovat_formular` - Aktivuje formulář po uložení souboru
- `Vlozit_nazev_udaje` - Vloží název aktuálních údajů (Alt+X, Ctrl+Shift+V)
- `Najit_udaj` - Najde údaj ve formuláři (Shift+Alt+L)
- **Sidebar Panel:** Ikona v levém panelu s tlačítky pro všechny příkazy (Shift+Alt+F)
- **Panel obsahuje 4 sekce:** Příkazy, Msg Watch, HISTORIE, NÁPOVĚDA

## Požadavky na Extension

### Příkazy (Commands):
1. `faBridge.ulozitSoubor` - Save file and activate FA (Ctrl+S, Alt+Q)
2. `faBridge.vlozitNazevUdaje` - Read fafield.txt and insert at cursor (Alt+X, Ctrl+Shift+V)
3. `faBridge.kopirovatNazevUdaje` - Read fafield.txt and copy to clipboard (Shift+Alt+C)
4. `faBridge.najitUdaj` - Write word under cursor to fafield.txt and send "Najit_udaj" to FA (Shift+Alt+L)
5. `faBridge.hledatPodleAktUdaje` - Open Find dialog with current field name (Shift+Alt+F)
6. `faBridge.hledatOdZacatku` - Open Find dialog, move cursor to start, reopen Find (Alt+L)
7. `faBridge.toggleMsgv` - Insert/delete msgv('') debug statement (Alt+F9)
8. `faBridge.toggleField` - Toggle field format: 'slovo' → [:slovo:] → [.slovo.] → 'slovo' (Alt+A)
9. `faBridge.vlozitUdajSBody` - Insert field in format [.udaj.] (Shift+Ctrl+[)
10. `faBridge.vlozitUdajSDvojteckami` - Insert field in format [:udaj:] (Shift+Ctrl+])
11. `faBridge.compareWithPrevious` - Compare current file with previous version from history
12. `faBridge.showHistoryVersions` - Show list of all file versions in history
13. `faHistory.showDiff` - Show diff between historical version and current file
14. `faHistory.restoreFile` - Restore file to selected historical version
15. `faHistory.compareWithPrevious` - Compare two historical versions with each other
16. `faHistory.refresh` - Refresh history panel
17. `faBridge.setLightTheme` - Switch to FA Pascal Light theme
18. `faBridge.setDarkTheme` - Switch to FA Pascal Dark theme
19. `faBridge.showIntelliSenseStats` - Show IntelliSense parsing statistics

### UI:
- **Sidebar Panel:** Vlastní panel v Activity Bar s ikonou "file-code"
- **TreeView:** Seznam příkazů s ikonami a klávesovými zkratkami
- Kliknutí na položku v panelu spustí příslušný příkaz

### Keybindings:
- `Shift+Alt+F` → Otevřít FA Bridge sidebar / Hledat podle akt. údaje (podle kontextu)
- `Ctrl+S`, `Alt+Q` → Uložit soubor
- `Alt+X`, `Ctrl+Shift+V` → Vložit název údaje
- `Shift+Alt+C` / `Shift+Ctrl+C` → Kopírovat název do schránky (podle nastavení)
- `Shift+Alt+L` → Najít údaj ve formuláři
- `Alt+L` → Hledat od začátku
- `Alt+F9` → Toggle msgv
- `Alt+A` → Toggle field format
- `Shift+Ctrl+[` → Vložit [.udaj.]
- `Shift+Ctrl+]` → Vložit [:udaj:]

### Formát komunikace:
- **Soubor:** `.fsbridge/facmd.txt` (relativně k workspace root)
- **Kódování:** UTF-8 s BOM
- **Formát:** Bez trailing newline
- **Proces:** Atomický (tmp → rename)

## Struktura Projektu
fa-bridge/
├── src/
│ ├── extension.ts              # Hlavní soubor (aktivace, registrace příkazů)
│ ├── commands/
│ │   └── sendCommand.ts        # Implementace všech příkazů
│ ├── utils/
│ │   ├── fsBridge.ts           # Komunikace s FA (zápis do .fsbridge/facmd.txt)
│ │   ├── fileHistory.ts        # Historie souborů a porovnání verzí
│ │   └── commandWatcher.ts     # Sledování příkazů z FA
│ ├── views/
│ │   ├── FABridgePanel.ts      # Sidebar TreeView panel (Příkazy)
│ │   └── HelpPanel.ts          # Help panel (NÁPOVĚDA)
│ ├── providers/
│ │   ├── PascalIntelliSenseProvider.ts  # IntelliSense (Completion + Hover)
│ │   ├── SnippetProvider.ts             # Pascal snippety
│ │   └── BeginEndMatcher.ts             # Zvýrazňování begin/end bloků
│ └── debugger/
│     └── msgWatch.ts           # Msg Watch panel
├── snippets/
│   └── pascal-snippets.json    # Pascal code snippety
├── syntaxes/
│   └── pascal.tmLanguage       # Pascal grammar (TextMate)
├── themes/
│   ├── fa-pascal-light.json   # Světlý color theme
│   └── fa-pascal-dark.json    # Tmavý color theme
├── language-configuration.json # Pascal language config
├── package.json
├── tsconfig.json
├── README.md
└── .vscodeignore


## Implementace

### extension.ts
- Export `activate()` a `deactivate()`
- Kontrola existence `.fsbridge` složky v workspace (extension se aktivuje pouze pokud existuje)
- Registrace všech příkazů z `sendCommand.ts`
- Registrace sidebar panelu z `FABridgePanel.ts`
- Registrace Help panelu z `HelpPanel.ts`
- Registrace IntelliSense provideru
- Registrace Begin/End matcheru
- Registrace Command Watcheru pro zpracování příkazů z FA
- Registrace Msg Watch panelu
- Automatické otevírání panelu při startu (pokud je povoleno v nastavení)
- Automatické mazání `famsgstate.json` při startu a při uložení souboru

### sendCommand.ts
- 10+ příkazů pro komunikaci s FA
- `ulozitSoubor()` - Save file, save history, activate FA
- `vlozitNazevUdaje()` - Read fafield.txt and insert/replace at cursor
- `kopirovatNazevUdaje()` - Read fafield.txt and copy to clipboard
- `najitUdaj()` - Write word under cursor to fafield.txt and send command
- `hledatPodleAktUdaje()` - Open Find dialog with current field name
- `hledatOdZacatku()` - Open Find dialog, move to start, reopen Find
- `toggleMsgv()` - Insert/delete msgv('') debug statement
- `toggleField()` - Toggle field format: 'slovo' → [:slovo:] → [.slovo.] → 'slovo'
- `vlozitUdajSBody()` - Insert field in format [.udaj.]
- `vlozitUdajSDvojteckami()` - Insert field in format [:udaj:]
- Volání `writeFACommand(commandString)` pro komunikaci s FA
- Podpora více instancí FA (používá instance-specific cesty)
- Info message po úspěšném odeslání

### FABridgePanel.ts
- TreeView provider pro sidebar panel (sekce "Příkazy")
- Zobrazení příkazů s ikonami a klávesovými zkratkami
- Kliknutelné položky volají příslušné příkazy
- Podpora FA kompatibilních hotkeys (dynamické zobrazení zkratek podle nastavení)

### HelpPanel.ts
- TreeView provider pro Help panel (sekce "NÁPOVĚDA")
- Načítá obsah z `_source/fa-bridge-help.txt` ve workspace
- Zobrazuje obsah jako seznam řádků v TreeView
- Automatické načítání při změně workspace

### fileHistory.ts
- `saveFileHistory()` - Ukládá kopii souboru do `.history` složky při uložení
- `getFileHistoryVersions()` - Vrací seznam verzí souboru v historii
- `compareWithPreviousVersion()` - Porovná aktuální soubor s předchozí verzí
- `showHistoryVersions()` - Zobrazí seznam verzí a umožní výběr k porovnání
- Podporuje pouze FA script soubory (`script_*.pas` a `u_*.pas`)
- Formát názvu: `script_test-20250115-143022.pas` (název-timestamp.pas)

### historyProvider.ts
- `HistoryProvider` - TreeDataProvider pro panel HISTORIE v sidebaru
- `getCommitsForCurrentFile()` - Získá seznam verzí pro aktuálně otevřený soubor
- `getHistoryVersions()` - Načte všechny verze souboru ze složky `.history`
- Automaticky aktualizuje panel při změně aktivního editoru
- Zobrazuje verze seřazené od nejnovější po nejstarší

### historyPanel.ts
- `HistoryPanel.showDiffStatic()` - Otevře VS Code diff editor pro porovnání historické verze s aktuálním souborem
- `HistoryPanel.restoreFileStatic()` - Vrátí soubor do stavu vybrané historické verze (s automatickou zálohou)
- `HistoryPanel.compareWithPreviousStatic()` - Porovná dvě historické verze mezi sebou
- Používá vestavěný VS Code diff editor s synchronizovaným scrollováním
- **Navigace v diff editoru:** F7 (další rozdíl), Shift+F7 (předchozí rozdíl)
- **Tip:** Klávesa F7 také přepíná mezi zobrazením všech řádků a pouze rozdílů

### fsBridge.ts
- `writeFACommand(command: string)` - Hlavní funkce pro komunikaci s FA
  - Vytvořit `.fsbridge` složku (pokud neexistuje)
  - Atomický zápis do `.fsbridge/facmd.txt` (podporuje více instancí FA)
  - Použít UTF-8 s BOM
  - Bez trailing newline
- `getFsBridgeWorkspaceRoot()` - Najde workspace obsahující `.fsbridge` složku
- `getValidInstanceId()` - Získá validní instance ID pro více-instanční podporu
- `getFafieldPath()` - Vrací cestu k `fafield.txt` pro aktuální instanci FA
- Podpora více instancí FA pomocí instance-specific složek (`.fsbridge/{instanceId}/`)

## Pascal Podpora (v0.2.0 a výš)

### Syntax Highlighting
- **Soubor:** `syntaxes/pascal.tmLanguage` (TextMate Grammar)
- **Původ:** Převzato z `alefragnani.pascal-9.9.0` extension
- **Vlastní úpravy:**
  - FA Form Field References: `[.field.]` a `[:field:]`
  - 408 FA vlastních funkcí (CheckRodneCislo, NactiAdresuZARES, ini, chk, lst, atd.)

### Language Configuration
- **Soubor:** `language-configuration.json`
- **Funkce:** Auto-closing závorek, komentářů, region folding
- **Podporované soubory:** .pas, .dpr, .dfm, .fmx, .lfm, .lpr

### Color Themes
- **FA Pascal Light:** Světlý theme podle FA editoru
  - Klíčová slova: #000080 (tmavě modrá)
  - FA funkce: #C000C0 (červenofialová)
  - Fieldy: #008000 (zelená)
  - Řetězce: #0000FF (modrá)
- **FA Pascal Dark:** Tmavý theme pro pohodlí
  - Klíčová slova: #5C9EFF (světle modrá)
  - FA funkce: #D896FF (tmavší fialová)
  - Fieldy: #00C000 (zelená)
  - Řetězce: #6699FF (modrá)

### Pascal Snippety (v0.3.1)
- **Soubor:** `snippets/pascal-snippets.json`
- **Počet:** 11 snippetů
- **Příklady:** function, procedure, if, for, try, trye, repeat, while, case, var, begin
- **Použití:** Napiš zkratku (např. `function`) a stiskni Tab

### Commands pro Themes (v0.3.1)
- `faBridge.setLightTheme` - Přepne na FA Pascal Light
- `faBridge.setDarkTheme` - Přepne na FA Pascal Dark
- **Použití:** Ctrl+Shift+P → "FA Bridge: Přepnout na světlý/tmavý motiv"

## Nové Funkce (v0.5.83)

### Historie souborů
- Automatické ukládání verzí souborů do `.history` složky při každém uložení
- Panel **HISTORIE** v sidebaru zobrazuje všechny verze aktuálně otevřeného souboru
- Porovnání s aktuálním souborem: kliknutí na verzi v panelu
- Porovnání s předchozí verzí: pravý klik → "Porovnat s předchozí verzí"
- Vrácení souboru do předchozího stavu: pravý klik → "Vrátit stav souboru do tohoto bodu"
- Používá vestavěný VS Code diff editor s navigací pomocí F7/Shift+F7
- **Tip:** Klávesa F7 přepíná mezi zobrazením všech řádků a pouze rozdílů
- Podporuje pouze FA script soubory (`script_*.pas` a `u_*.pas`)

### Help Panel
- Nová sekce v sidebaru zobrazující obsah z `_source/fa-bridge-help.txt`
- Automatické načítání při změně workspace

### Begin/End Matcher
- Automatické zvýrazňování odpovídajících `begin`/`end` bloků
- Umožňuje snadnou identifikaci začátku a konce bloků kódu

### IntelliSense Provider
- Completion a Hover podpora pro Pascal soubory
- Parsování dokumentace z `FsUtils.pas` (XML dokumentace)
- Asynchronní parsování v pozadí

### Command Watcher
- Sledování příkazů z FA (např. `check_unsaved_and_close`)
- Zpracování příkazů z `facmd_from_fa.txt`

### Nastavení
- `faBridge.autoOpenPanel` - Automatické otevírání panelu při startu
- `faBridge.enableSnippets` - Zapnutí/vypnutí snippetů
- `faBridge.faCompatibleHotkeys` - FA kompatibilní hotkeys
- `local-history.enabled` - Historie souborů (zapnutí/vypnutí panelu HISTORIE)
- `faHistory.maxFiles` - Maximální počet souborů zobrazených v panelu historie (výchozí: 50)
- `faHistory.showDates` - Zobrazovat datumy u verzí v panelu historie (výchozí: true)

## Budoucí Rozšíření

Tyto funkce přidáme později:
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
**Verze:** 0.5.83

## Changelog

### v0.5.83 (aktuální)
- ✨ **Porovnání historických verzí:** Nová možnost porovnat dvě historické verze mezi sebou (pravý klik → "Porovnat s předchozí verzí")
- 🔍 **Vylepšený diff editor:** Přidána poznámka o klávese F7 pro navigaci mezi rozdíly a přepnutí zobrazení pouze rozdílů

### v0.5.82
- 🎨 **Panel HISTORIE:** Odstraněn první řádek s názvem souboru z panelu historie (historie je vždy pro aktuální soubor)

### v0.5.81
- ✨ **Context menu:** Opravena volba "Vrátit stav souboru do tohoto bodu" v context menu panelu historie
- 🔧 **Zobrazení historie:** Odstraněna volba "Zobrazit historii" z context menu (kliknutí na verzi automaticky zobrazí diff)

### v0.5.80
- ✨ **Panel HISTORIE:** Nový panel v sidebaru FA Bridge zobrazující historii verzí aktuálně otevřeného souboru
- 🔍 **Diff editor:** Použití vestavěného VS Code diff editoru s synchronizovaným scrollováním a inline diff view
- 📋 **Context menu:** Možnost vrátit soubor do předchozího stavu přímo z panelu historie

### v0.5.76
- ✨ **Historie souborů:** Automatické ukládání verzí souborů do `.history` složky
- 🔍 **Porovnání verzí:** Nové příkazy pro porovnání aktuálního souboru s předchozími verzemi
- 📚 **Help panel:** Nová sekce v sidebaru zobrazující obsah z `_source/fa-bridge-help.txt`
- 🔍 **Begin/End Matcher:** Automatické zvýrazňování odpovídajících `begin`/`end` bloků
- ⚙️ **Nastavení:** Přidána nastavení pro historii souborů a FA kompatibilní hotkeys
- 🧠 **IntelliSense:** Vylepšená podpora pro Pascal soubory s dokumentací z `FsUtils.pas`
- 📊 **Msg Watch:** Panel se automaticky zobrazuje/skrývá podle stavu běžícího skriptu
- 🔧 **Podpora více instancí FA:** Instance-specific cesty pro komunikaci s více instancemi FA současně

### v0.3.1 (28.10.2025)
- ⚡ **Pascal Snippety:** 11 užitečných snippetů pro rychlejší psaní kódu
  - Snippety: function, procedure, if, for, try, trye, repeat, while, case, var, begin
  - Použití: Napiš zkratku a stiskni Tab
  - Soubor: `snippets/pascal-snippets.json`
- 🎨 **Theme přepínání přes Command Palette:**
  - Příkazy: `faBridge.setLightTheme`, `faBridge.setDarkTheme`
  - Command Palette: Ctrl+Shift+P → "FA Bridge: Přepnout na světlý/tmavý motiv"
  - Okamžité přepnutí mezi FA Pascal Light a Dark themes

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