# FA Bridge Extension

Propojení **Cursor/VS Code** s editorem **FormStudio (FA)** pomocí FA Bridge.

## Funkčnost

Tato extension umožňuje komunikovat s FormStudio přes příkazy, které se zapisují do souboru `.fsbridge/facmd.txt`.

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

**Vytvořeno:** Říjen 2025 | **Status:** Funkční ✓
