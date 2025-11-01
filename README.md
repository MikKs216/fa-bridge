# FA Bridge Extension

Propojení **Cursor/VS Code** s editorem **FormStudio (FA)** pomocí FA Bridge.

## Funkčnost

Tato extension poskytuje:
1. **Komunikaci s FormStudio** přes příkazy do souboru `.fsbridge/facmd.txt`
2. **Pascal Syntax Highlighting** s podporou FA vlastních funkcí a formulářových odkazů

### 🎯 Sidebar Panel

Extension přidává vlastní panel do Activity Bar (levý panel). Kliknutím na ikonu FA Bridge zobrazíš seznam všech dostupných příkazů.

### Dostupné příkazy

| Příkaz | Klávesová zkratka | Popis |
|--------|-------------------|-------|
| **Uložit soubor** | <kbd>Ctrl</kbd>+<kbd>S</kbd> | Uloží aktuální soubor |
| **Aktivovat FA** | <kbd>Alt</kbd>+<kbd>Q</kbd> | Uloží aktuální soubor (jako Ctrl+S) |
| **Otevřít FA Bridge** | <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>F</kbd> | Otevře/zavře sidebar panel |
| **Vložit název údaje** | <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>V</kbd> | Vloží název aktuálního údaje na kurzor |
| **Název údaje do clipboardu** | <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>C</kbd> | Zkopíruje název údaje do schránky |
| **Najít údaj ve formuláři** | <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>L</kbd> | Najde údaj podle slova pod kurzorem |

> **Tip na macOS:** Nahraď <kbd>Ctrl</kbd> za <kbd>Cmd</kbd>

### 🐛 Debugování TMS Scripter

Extension poskytuje integrovaný debugger pro TMS Scripter v FA aplikaci. Debugger funguje automaticky - sleduje stav běžícího skriptu v FA a zobrazuje ho v Cursoru.

#### Jak spustit debugování

1. **Otevři Pascal soubor** v Cursoru (např. `.pas` soubor se skriptem)
2. **Nastav breakpointy** kliknutím na levý okraj editoru nebo stiskem <kbd>F9</kbd>
3. **Spusť skript v FA** - běžným způsobem (např. vyplnění formuláře, které spustí skript)
4. **Debugger se automaticky aktivuje** - když skript dorazí na breakpoint nebo se pozastaví

#### Debugger příkazy

| Příkaz | Klávesová zkratka | Popis |
|--------|-------------------|-------|
| **Pokračovat** | <kbd>F5</kbd> | Pokračuje v běhu skriptu (nebo spustí skript pokud je zastaven) |
| **Krok přes** | <kbd>F10</kbd> | Provede aktuální řádek a pozastaví na dalším |
| **Pozastavit/Zastavit** | <kbd>Shift</kbd>+<kbd>F5</kbd> | Pozastaví běžící skript nebo zastaví debugování |
| **Přepnout breakpoint** | <kbd>F9</kbd> | Nastaví/zruší breakpoint na aktuálním řádku |

> **Poznámka:** Všechny klávesové zkratky fungují pouze když je otevřený Pascal soubor (`.pas`).

#### Debugger rozhraní

**Status Bar:**
- V dolní části Cursoru vidíš stav debuggeru:
  - `Debug: běží` - skript běží
  - `Debug: pozastaveno (řádek X)` - skript je pozastaven na řádku X
  - `Debug: zastaveno` - skript není spuštěn

**Zvýraznění aktuálního řádku:**
- Když je skript pozastaven, aktuální řádek je zvýrazněn v editoru
- Editor automaticky přejede na pozastavený řádek

**Debug Proměnné panel:**
- V sidebaru FA Bridge → "Debug Proměnné" vidíš aktuální proměnné při debugování
- Panel se automaticky aktualizuje při změně stavu

#### Workflow debugování

1. **Připrav skript v FA:**
   - Otevři formulář v FA
   - Nastav breakpointy v Cursoru (F9) nebo v FA

2. **Spusť skript v FA:**
   - Proveď akci, která spustí skript (např. změna hodnoty pole)
   - Skript se automaticky pozastaví na prvním breakpointu

3. **Ovládej debugování v Cursoru:**
   - Použij F5 (pokračovat), F10 (krok přes), F9 (přepnout breakpoint)
   - Sleduj stav v status baru a aktuální řádek v editoru

4. **Sleduj proměnné:**
   - Otevři panel "Debug Proměnné" v sidebaru FA Bridge
   - Proměnné se automaticky aktualizují při změně stavu

#### Důležité poznámky

- **Debugger je aktivní pouze když není otevřen původní debugger v EScriptEditor**
  - Pokud máš otevřený původní editor skriptu v debug módu, použije se jeho debugger
  - Jinak se použije debugger z Cursor extension

- **Komunikace probíhá přes soubory:**
  - Příkazy z Cursoru → `.fsbridge/fadebug.txt`
  - Stav z FA → `.fsbridge/fadebugstate.json`
  - Aktualizace probíhá každou sekundu automaticky

- **Breakpointy:**
  - Breakpointy nastavené v Cursoru se synchronizují s FA
  - Breakpointy nastavené v FA se zobrazují v Cursoru

### 🎨 Pascal Syntax Highlighting

Extension poskytuje **plnou podporu Pascal/Delphi** s vlastními vylepšeními pro FA:

#### Podporované soubory
- `.pas` - Pascal source files
- `.dpr` - Delphi project files
- `.dfm` - Delphi form files
- `.fmx` - FireMonkey form files
- `.lfm` - Lazarus form files
- `.lpr` - Lazarus project files

#### FA Vlastní funkce
Extension zvýrazňuje **200+ FA vlastních funkcí**:
- Kontroly: `CheckRodneCislo`, `CheckICO`, `CheckDIC`, `CheckIBAN`
- Web integrace: `NactiAdresuZARES`, `CheckVAT`, `SendEmail`
- Data: `GetFormField`, `SetFormData`, `LoadStringFromFile`
- UI: `MsgBoxAsk`, `ShowMessage`, `AskStr`, `DisplayCheck`
- ...a mnoho dalších

#### Formulářové odkazy
Speciální zvýraznění pro odkazy na pole formuláře:
- `[.nazevUdaje.]` - reference na údaj s tečkami
- `[:nazevUdaje:]` - reference na údaj s dvojtečkami

#### Barevná schémata
Extension obsahuje 2 optimalizovaná témata:

| Téma | Popis | Aktivace |
|------|-------|----------|
| **FA Pascal Light** | Světlé téma podle FA editoru | <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>P</kbd> → "FA Bridge: Přepnout na světlý motiv" |
| **FA Pascal Dark** | Tmavé téma pro pohodlí | <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>P</kbd> → "FA Bridge: Přepnout na tmavý motiv" |

Nebo použij standardní výběr themes: <kbd>Ctrl</kbd>+<kbd>K</kbd> <kbd>Ctrl</kbd>+<kbd>T</kbd> → "FA Pascal Light/Dark"

> **Tip:** Témata lze aplikovat jen na Pascal soubory nebo nastavit jako globální téma pro celý editor.

### ⚡ Pascal Snippety

Extension obsahuje **11 užitečných snippetů** pro rychlejší psaní kódu:

| Zkratka | Co vytvoří | Popis |
|---------|-----------|-------|
| `function` | Funkce | Funkce vracející hodnotu s Result |
| `procedure` | Procedura | Základní procedura |
| `if` | If-then-begin | If podmínka s begin-end blokem |
| `for` | For cyklus | For cyklus s begin-end |
| `try` | Try-finally | Try-finally blok pro cleanup |
| `trye` | Try-except | Try-except s error handlingem |
| `repeat` | Repeat-until | Repeat-until cyklus |
| `while` | While cyklus | While cyklus s begin-end |
| `case` | Case of | Case of struktura s else |
| `var` | TStringList | TStringList s try-finally a for cyklem |
| `begin` | Begin-end | Jednoduchý begin-end blok |

**Použití:** Napiš zkratku (např. `function`) a stiskni <kbd>Tab</kbd> nebo <kbd>Enter</kbd>. Kurzor se automaticky přesune na místa, která je potřeba vyplnit.

#### Vypnutí snippetů

Pokud preferuješ vlastní snippety nebo jiné rozšíření, můžeš naše snippety vypnout:

1. Otevři nastavení: <kbd>Ctrl</kbd>+<kbd>,</kbd> (nebo File > Preferences > Settings)
2. Vyhledej: `FA Bridge`
3. Odškrtni: **Enable Snippets**

Nebo přímo v `settings.json`:
```json
{
  "faBridge.enableSnippets": false
}
```

## ⚙️ Nastavení

### Cesta k `.fsbridge` složce

**DŮLEŽITÉ:** Extension komunikuje s FA přes `.fsbridge` složku. Tato cesta **MUSÍ** být nastavena správně, aby debugger a ostatní funkce fungovali i pro soubory otevřené **MIMO workspace** (např. soubory otevřené přímo z FA).

#### Jak nastavit cestu:

1. Otevři nastavení: <kbd>Ctrl</kbd>+<kbd>,</kbd> (nebo File > Preferences > Settings)
2. Vyhledej: `faBridge.fsbridgePath`
3. Nastav cestu k `.fsbridge` složce (výchozí: `D:\FA DESIGN\DataPrg\Scripts\.fsbridge`)

Nebo přímo v `settings.json`:
```json
{
  "faBridge.fsbridgePath": "D:\\FA DESIGN\\DataPrg\\Scripts\\.fsbridge"
}
```

**Poznámka:** Cesta **MUSÍ** odpovídat cestě nastavené v FA aplikaci (`FBridge.ExportFolder`). Pokud máš FA v jiném adresáři, uprav cestu odpovídajícím způsobem.

#### Jak zjistit správnou cestu?

Ve FA aplikaci je nastaveno:
```pascal
FBridge.ExportFolder := 'DataPrg\Scripts';
```

To znamená že `.fsbridge` složka je:
```
<adresář_kde_běží_FA.exe>\DataPrg\Scripts\.fsbridge\
```

Např. pokud je FA v `D:\FA DESIGN\`, pak cesta je:
```
D:\FA DESIGN\DataPrg\Scripts\.fsbridge
```

## Instalace

1. Klonuj tento repo
2. Spusť `npm install` v kořenovém adresáři
3. Spusť `npm run compile` pro kompilaci TypeScriptu

## Spuštění Extension (Development)

### ⚡ Nejjednodušší způsob - klikni na script:

**Windows:**
- Dvaklikni: `dev-run.bat`
- Nebo v PowerShell: `.\dev-run.ps1`

Tohle spustí **VS Code s extension development mode** - vytvoří se 2 okna:
1. **Originální VS Code** - kde vidíš zdrojový kód
2. **Dev Host okno** - kde testíš extension

### 🖥️ Ruční spuštění:

V PowerShell z projektu:
```powershell
& 'C:\Users\Kastner\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd' --extensionDevelopmentPath='.' '.'
```

## Vývoj

### Struktura projektu

```
src/
├── extension.ts          # Hlavní soubor (aktivace, registrace příkazů)
├── commands/
│   └── sendCommand.ts    # Implementace všech příkazů
├── utils/
│   └── fsBridge.ts       # Komunikace s FA (zápis do .fsbridge/facmd.txt)
└── views/
    └── FABridgePanel.ts  # Sidebar TreeView panel
```

### Kompilace

```bash
npm run compile      # Jednorázová kompilace
npm run watch        # Watch mode
npm run lint         # ESLint check
```

### Vytvoření VSIX balíčku

Pro vytvoření instalačního balíčku:

```bash
# 1. Zkompiluj TypeScript
npm run compile

# 2. Vytvoř VSIX balíček
npx @vscode/vsce package
```

Vytvoří se soubor např. `fa-bridge-0.3.1.vsix`, který můžeš nainstalovat přes:
- **Cursor/VS Code:** Ctrl+Shift+P → "Extensions: Install from VSIX..."
- **Příkazová řádka:** `code --install-extension fa-bridge-0.3.1.vsix`

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

### 0.3.1

- ⚡ **Pascal Snippety:**
  - Přidáno 11 snippetů pro rychlejší psaní kódu
  - function, procedure, if, for, try, repeat, while, case, var, begin
- 🎨 **Theme přepínání:**
  - Nové příkazy v Command Palette pro rychlé přepnutí mezi FA Pascal Light a Dark
  - "FA Bridge: Přepnout na světlý/tmavý motiv"

### 0.1.7

- ✏️ **Aktualizace názvů:**
  - "Uložit a aktivovat FA" → "Aktivovat FA"
  - "Kopírovat název údaje" → "Název údaje do clipboardu"
- ➖ **Odstraněno:**
  - Funkce "Zkompilovat script" (Shift+Alt+D) - nebyla používána

### 0.1.6

- 🧹 **Zjednodušení UI:**
  - Odstraněna registrace příkazů v Command Palette (Ctrl+Shift+P)
  - Všechny funkce jsou nyní dostupné pouze v sidebaru FA Bridge
  - Čistší uživatelské rozhraní bez duplicitních menu

### 0.1.5

- 🔧 **Změna funkce Alt+Q:**
  - Alt+Q nyní volá Save (Ctrl+S) místo aktivace FA
  - Zachováno pro rychlé uložení jednou rukou
- ➖ **Odstraněno "Uložit vše" (Alt+S):**
  - Alt+S kolidovalo s menu Selection v Cursoru
  - Standardní Ctrl+S zůstává v panelu

### 0.1.4

- 🐛 **Lepší error handling:**
  - Chybové hlášky nyní zobrazují skutečnou příčinu problému
  - Usnadňuje debugování při problémech s komunikací s FA

### 0.1.3

- 🎨 **Vlastní ikona extension:**
  - Vytvořena na základě FScode ikony s písmenem "F"
  - Zobrazuje se v Activity Bar i v seznamu extensions

### 0.1.2

- ➕ **Přidány standardní příkazy do sidebaru:**
  - Uložit soubor (Ctrl+S)
  - Uložit vše (Alt+S)
- 💡 Uživatel má nyní všechny důležité příkazy na jednom místě v FA Bridge panelu

### 0.1.1

- 🔧 **Jednotné zkratky:** Všechny příkazy nyní používají **Shift+Alt** (kromě Alt+Q)
  - Otevřít sidebar: Ctrl+Alt+F → **Shift+Alt+F**
  - Vložit název: Ctrl+Alt+V → **Shift+Alt+V**
- ➖ Odstraněn testovací příkaz `faBridge.test`
- 📝 Oprava: "název údajů" → "název údaje" (gramatika)

### 0.1.0

- ➕ **Nová funkce:** Kopírovat název údajů do schránky (Shift+Alt+C)
- ➕ **Nová funkce:** Najít údaj ve formuláři podle slova pod kurzorem (Shift+Alt+L)
- 🔧 Změna zkratky "Aktivovat formulář" z Ctrl+Alt+1 na **Alt+Q**
- 🔧 Změna zkratky "Zkompilovat script" z Ctrl+Alt+2 na **Shift+Alt+D**
- ➖ Odstraněn testovací příkaz c999

### 0.0.3

- ➕ Klávesová zkratka Ctrl+Alt+F pro otevření sidebaru
- 🔧 Kompatibilita s Cursor (snížena minimální verze na 1.85.0)

### 0.0.2

- ➕ Sidebar panel v Activity Bar s ikonou
- ➕ TreeView s příkazy a klávesovými zkratkami
- ➖ Odstraněno Quick Pick menu
- 🔧 Změna zkratky "Vložit název" z Ctrl+Alt+3 na Ctrl+Alt+V

### 0.0.1

- Implementace všech 4 základních příkazů
- Quick Pick menu (Ctrl+Alt+F)
- Atomické zápisy do `.fsbridge/facmd.txt`
- UTF-8 s BOM

---

## 📋 Dokumentace

- **Verzování FA Bridge integrace** - viz VERZOVÁNÍ.md - Jak verzovat FA Bridge extension a FA aplikaci
- **Debugger dokumentace** - viz DEBUGGER_DOCS.md - Podrobná dokumentace debuggeru TMS Scripter

---

**Vytvořeno:** Říjen 2025 | **Status:** Funkční ✓ | **Verze:** 0.4.5
