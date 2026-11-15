# FA Bridge Extension - Uživatelská příručka

Propojení **Cursor/VS Code** s editorem **FormAsistent (FA)** pomocí FA Bridge.

## Funkčnost

Tato extension poskytuje:

1. **Komunikaci s FormAsistent** přes příkazy do souboru `.fsbridge/facmd.txt`
2. **Pascal Syntax Highlighting** s podporou FA vlastních funkcí a formulářových odkazů
3. **IntelliSense podporu** (Completion + Hover) pro Pascal soubory s dokumentací z `FsUtils.pas`
4. **Msg Watch panel** pro zobrazení zpráv z běžícího skriptu

### 🎯 Sidebar Panel

Extension přidává vlastní panel do Activity Bar (levý panel). Panel se automaticky otevře při každém startu Cursoru/VS Code. Kliknutím na ikonu FA Bridge zobrazíš seznam všech dostupných příkazů.

Panel obsahuje čtyři sekce:
- **Příkazy** - Seznam všech dostupných příkazů s klávesovými zkratkami
- **Msg Watch** - Zobrazuje zprávy z běžícího skriptu (viditelné pouze když skript běží)
- **HISTORIE** - Zobrazuje historii verzí aktuálně otevřeného souboru (viditelné pouze když je historie zapnutá)
- **NÁPOVĚDA** - Zobrazuje obsah z `_source/fa-bridge-help.txt`

### Dostupné příkazy

| Příkaz                              | Klávesová zkratka                                                  | Popis                                                                             |
| ------------------------------------- | -------------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| **Uložit soubor**              | F2                         | Uloží aktuální soubor (triggeruje Local History)                                                         |
| **Přepnout do FA**         | F1, Alt+Q / Ctrl+Q* | Aktivuje okno FORM asistenta                                                      |
| **Vložit název údaje**       | Alt+X, Ctrl+Shift+V                          | Vloží název aktuálního údaje na kurzor (nebo nahradí označený text)      |
| **Název údaje do clipboardu** | Shift+Alt+C / Shift+Ctrl+C* | Zkopíruje název údaje do schránky                                             |
| **Najít údaj ve formuláři** | Shift+Alt+L | Najde údaj podle slova pod kurzorem                                              |
| **Hledar podle akt. údaje** | Shift+Alt+F / Shift+Ctrl+F* | Otevře Find dialog s názvem aktuálního údaje z FA |
| **Hledat od začátku** | Alt+L | Otevře Find dialog, přesune kurzor na začátek dokumentu a znovu otevře Find dialog |
| **Toggle msgv**                 | Alt+F9                         | Vloží `msgv('')` před aktuální řádek nebo smaže řádek s `msgv(`     |
| **Toggle field**                | Alt+A                          | Mění formát slova:`'slovo'` → `[:slovo:]` → `[.slovo.]` → `'slovo'` |
| **Vložit [.udaj.]** | Shift+Ctrl+[ | Vloží údaj z FA ve formátu [.názevÚdaje.] |
| **Vložit [:udaj:]** | Shift+Ctrl+] | Vloží údaj z FA ve formátu [:názevÚdaje:] |
| **Otevřít FA nápovědu** | Ctrl+Alt+F1 | Otevře FA.chm z `_source` složky |
| **Hledat v dokumentaci** | Ctrl+Shift+F1 | Otevře TextSearch.exe (i bez slova pod kurzorem) |
| **Porovnat s předchozí verzí** | - | Porovná aktuální soubor s předchozí verzí z historie |
| **Zobrazit historii verzí** | - | Zobrazí seznam všech verzí souboru v historii |

\* *Hotkeys se mění podle nastavení `faBridge.faCompatibleHotkeys`*

> **Rozsah:** Horké klávesy fungují jen ve fokusovaném Pascal editoru. Panel FA Bridge se otevírá z Activity Bar (ikona), ne zkratkou Shift+Alt+F.

> **Tip na macOS:** Nahraď Ctrl za Cmd

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

| Téma                     | Popis                           | Aktivace                                                                                                          |
| ------------------------- | ------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| **FA Pascal Light** | Světlé téma podle FA editoru | Ctrl+Shift+P → "FA Bridge: Přepnout na světlý motiv" |
| **FA Pascal Dark**  | Tmavé téma pro pohodlí       | Ctrl+Shift+P → "FA Bridge: Přepnout na tmavý motiv"   |

Nebo použij standardní výběr themes: Ctrl+K Ctrl+T → "FA Pascal Light/Dark"

> **Tip:** Témata lze aplikovat jen na Pascal soubory nebo nastavit jako globální téma pro celý editor.

### ⚡ Pascal Snippety

Extension obsahuje **11 užitečných snippetů** pro rychlejší psaní kódu:

| Zkratka       | Co vytvoří  | Popis                                  |
| ------------- | ------------- | -------------------------------------- |
| `function`  | Funkce        | Funkce vracející hodnotu s Result    |
| `procedure` | Procedura     | Základní procedura                   |
| `if`        | If-then-begin | If podmínka s begin-end blokem        |
| `for`       | For cyklus    | For cyklus s begin-end                 |
| `try`       | Try-finally   | Try-finally blok pro cleanup           |
| `trye`      | Try-except    | Try-except s error handlingem          |
| `repeat`    | Repeat-until  | Repeat-until cyklus                    |
| `while`     | While cyklus  | While cyklus s begin-end               |
| `case`      | Case of       | Case of struktura s else               |
| `var`       | TStringList   | TStringList s try-finally a for cyklem |
| `begin`     | Begin-end     | Jednoduchý begin-end blok             |

**Použití:** Napiš zkratku (např. `function`) a stiskni Tab nebo Enter. Kurzor se automaticky přesune na místa, která je potřeba vyplnit.

#### Vypnutí snippetů

Pokud preferuješ vlastní snippety nebo jiné rozšíření, můžeš naše snippety vypnout:

1. Otevři nastavení: Ctrl+, (nebo File > Preferences > Settings)
2. Vyhledej: `FA Bridge`
3. Odškrtni: **Enable Snippets**

Nebo přímo v `settings.json`:

```json
{
  "faBridge.enableSnippets": false
}
```

## ⚙️ Nastavení

Extension poskytuje několik konfigurovatelných nastavení:

### Automatické otevírání panelu

- **Nastavení:** `faBridge.autoOpenPanel` (výchozí: `true`)
- **Popis:** Automaticky otevře FA Bridge panel při každém startu Cursoru/VS Code

### Zapnutí/vypnutí snippetů

- **Nastavení:** `faBridge.enableSnippets` (výchozí: `true`)
- **Popis:** Povolí nebo zakáže Pascal snippety (function, procedure, if, for, try, atd.)

### FA kompatibilní hotkeys

- **Nastavení:** `faBridge.faCompatibleHotkeys` (výchozí: `false`)
- **Popis:** Použije hotkeys kompatibilní s FA (Ctrl+Q místo Alt+Q, Shift+Ctrl+C místo Shift+Alt+C, Shift+Ctrl+F místo Shift+Alt+F)
- **Poznámka:** Pokud je zapnuto, některé zkratky se změní:
  - Přepnout do FA: `Alt+Q` → `Ctrl+Q`
  - Kopírovat název údaje: `Shift+Alt+C` → `Shift+Ctrl+C`
  - Hledat podle akt. údaje: `Shift+Alt+F` → `Shift+Ctrl+F`

### Automatické přepínání barevného schématu

- **Nastavení:** `faBridge.autoSwitchTheme` (výchozí: `false`)
- **Popis:** Automaticky přepíná mezi FA theme a původním theme podle typu projektu
- **Jak to funguje:**
  - Když otevřeš projekt s `.fsbridge` (FA projekt), automaticky se aplikuje FA theme
  - Když přepneš do projektu bez `.fsbridge` (non-FA projekt), automaticky se obnoví původní theme
  - Původní theme se ukládá při první aktivaci FA Bridge
- **Poznámka:** Toto nastavení je užitečné, pokud pracuješ s více projekty (FA i non-FA) a nechceš, aby FA theme bylo aktivní i v non-FA projektech

### Preferované FA barevné schéma

- **Nastavení:** `faBridge.preferredTheme` (výchozí: `"FA Pascal Light"`)
- **Možnosti:** `"FA Pascal Light"` nebo `"FA Pascal Dark"`
- **Popis:** Určuje, které FA theme se automaticky aplikuje v FA projektech (pokud je zapnuto `autoSwitchTheme`)
- **Poznámka:** Toto nastavení se použije pouze pokud je zapnuto automatické přepínání (`autoSwitchTheme: true`)

### Historie souborů

- **Nastavení:** `local-history.enabled` (výchozí: `true`)
- **Popis:** Ukládá historii změn editovaných souborů do složky `.history`
- **Funkce:** 
  - Automaticky ukládá kopie souborů při každém uložení (pouze pro FA script soubory: `script_*.pas` a `u_*.pas`)
  - Umožňuje porovnání s předchozími verzemi
  - Historie se ukládá do `.history` složky vedle editovaného souboru
  - Formát názvu: `script_test-20250115-143022.pas` (název-timestamp.pas)
  - Panel **HISTORIE** v sidebaru zobrazuje všechny verze aktuálně otevřeného souboru

#### Jak nastavit nastavení:

1. Otevři nastavení: Ctrl+, (nebo File > Preferences > Settings)
2. Vyhledej: `faBridge`
3. Uprav požadované nastavení

Nebo přímo v `settings.json`:

```json
{
  "faBridge.autoOpenPanel": true,
  "faBridge.enableSnippets": true,
  "faBridge.faCompatibleHotkeys": false,
  "faBridge.autoSwitchTheme": false,
  "faBridge.preferredTheme": "FA Pascal Light",
  "local-history.enabled": true,
  "faHistory.maxFiles": 50,
  "faHistory.showDates": true
}
```

## Instalace

### Instalace z VSIX souboru

1. Stáhni VSIX soubor (např. `fa-bridge-0.5.93.vsix`)
2. V Cursor/VS Code: Ctrl+Shift+P → "Extensions: Install from VSIX..."
3. Vyber stažený VSIX soubor

Nebo z příkazové řádky:

```bash
cursor --install-extension fa-bridge-0.5.93.vsix

pro Visual studio Code:
code --install-extension fa-bridge-0.5.93.vsix 
```

## 🧠 IntelliSense pro Pascal

Extension poskytuje **IntelliSense podporu** (Completion + Hover + Go To Definition) pro Pascal soubory:

- **Completion** - Automatické doplňování funkcí a procedur (aktivuje se pomocí Ctrl+Space)
- **Hover** - Zobrazení dokumentace při najetí myší na funkci/proceduru
- **Go To Definition** - Přeskočení na definici funkce/procedury

### Dokumentace

IntelliSense čerpá dokumentaci ze souborů `FScriptUtils.pas` a `FCommonUtils.pas` v workspace. Funkce a procedury s XML dokumentací (`/// <summary>`, `<param>`, `<returns>`) jsou automaticky parsovány a zobrazeny v IntelliSense.

### Go To Definition

**Funkce:** Umožňuje rychle přejít na definici funkce nebo procedury.

**Klávesové zkratky:**
- **`F12`** - Přejít na definici
- **`Ctrl + Click`** (nebo `Alt + Click` podle nastavení) - Přejít na definici při kliknutí

**Jak to funguje:**
1. Umísti kurzor na název funkce/procedury
2. Stiskni `F12` nebo použij `Ctrl + Click` na název
3. Extension automaticky:
   - Nejdřív hledá definici v aktuálním souboru
   - Pokud nenajde, hledá v `FScriptUtils.pas` nebo `FCommonUtils.pas`
   - Otevře správný soubor a přesune kurzor na definici

**Navigace zpět:**
- **`Alt + ←`** (šipka vlevo) nebo **`Ctrl + -`** (minus) - Vrátit se zpět
- **`Alt + →`** (šipka vpravo) nebo **`Ctrl + Shift + -`** - Jít vpřed v historii navigace

**Tip:** Po použití Go To Definition se vytvoří historie navigace. Můžeš se pohybovat mezi všemi navštívenými místy pomocí šipek nebo `Ctrl + -` / `Ctrl + Shift + -`.

### CodeLens - Počet referencí

**Funkce:** Zobrazuje počet referencí (použití) lokálních funkcí a procedur přímo nad jejich deklarací.

**Jak to funguje:**
- Nad každou deklarací funkce/procedury se zobrazí informace o počtu jejích použití v aktuálním souboru
- Kliknutím na počet referencí se zobrazí seznam všech míst, kde je funkce volána
- Umožňuje rychle zjistit, kde všude je funkce použita a zda vůbec nějaké reference existují

**Příklad:**
```pascal
function CalculateTotal(Amount: Double): Double;  // ← "3 reference" (kliknutelné)
begin
  Result := Amount * 1.21;
end;
```

### Hover Tooltip pro lokální deklarace

**Funkce:** Zobrazuje dokumentaci a informace při najetí myší na lokální funkce a konstanty deklarované ve stejném souboru.

**Podporované formáty dokumentace:**

**XML komentáře (///):**
```pascal
/// <summary>Vypočítá celkovou částku včetně DPH</summary>
/// <param name="Amount">Částka bez DPH</param>
/// <returns>Částka včetně DPH</returns>
function CalculateTotal(Amount: Double): Double;
```

**Blokové komentáře ({ }):**
```pascal
{ 
  Vypočítá celkovou částku včetně DPH
  @param Amount Částka bez DPH
  @returns Částka včetně DPH
}
function CalculateTotal(Amount: Double): Double;
```

**Konstanty:**
```pascal
/// <summary>Výchozí sazba DPH</summary>
const VAT_RATE = 0.21;  // ← Hover zobrazí: "Výchozí sazba DPH. Hodnota: 0.21"
```

**Co se zobrazuje:**
- Pro **funkce**: Popis, parametry, návratová hodnota
- Pro **konstanty**: Popis a **hodnota konstanty**

### Statistiky

Pro zobrazení statistik parsování použij příkaz: Ctrl+Shift+P → "FA Bridge: Zobrazit IntelliSense statistiky"

## 📚 Historie souborů

Extension automaticky ukládá historii změn editovaných souborů:

- **Automatické ukládání:** Při každém uložení souboru (Ctrl+S nebo F2) se vytvoří kopie v `.history` složce
- **Podporované soubory:** Pouze FA script soubory (`script_*.pas` a `u_*.pas`)
- **Formát názvu:** `script_test-20250115-143022.pas` (název-timestamp.pas)
- **Umístění:** Historie se ukládá do `.history` složky vedle editovaného souboru

### Panel HISTORIE

Panel **HISTORIE** se zobrazuje v sidebaru FA Bridge a obsahuje seznam všech verzí aktuálně otevřeného souboru:

- **Automatické zobrazení:** Panel se automaticky aktualizuje při změně aktivního editoru
- **Seznam verzí:** Zobrazuje všechny historické verze seřazené od nejnovější po nejstarší
- **Kliknutí na verzi:** Automaticky otevře diff editor s porovnáním vybrané verze s aktuálním souborem

### Možnosti porovnání

#### 1. Porovnání s aktuálním souborem
- **Kliknutí na verzi:** Kliknutím na verzi v panelu HISTORIE se otevře diff editor
- **Zobrazení:** Vlevo historická verze, vpravo aktuální soubor
- **Navigace mezi rozdíly:** 
  - **F7** - Přesun na další rozdíl
  - **Shift+F7** - Přesun na předchozí rozdíl
  - **Tip:** Klávesa **F7** také přepíná mezi zobrazením všech řádků a pouze rozdílů v diff editoru

#### 2. Porovnání s předchozí verzí
- **Pravý klik na verzi:** V context menu vyber "Porovnat s předchozí verzí"
- **Zobrazení:** Porovnání dvou historických verzí mezi sebou (starší vlevo, novější vpravo)
- **Užitečné pro:** Zjištění, co se změnilo mezi dvěma konkrétními verzemi

#### 3. Vrácení souboru do předchozího stavu
- **Pravý klik na verzi:** V context menu vyber "Vrátit stav souboru do tohoto bodu"
- **Funkce:** Vrátí aktuální soubor do stavu vybrané historické verze
- **Záloha:** Před vrácením se automaticky vytvoří záloha aktuálního souboru

### Nastavení historie

- **Zapnutí/vypnutí:** Nastavení → `local-history.enabled` → `true`/`false`
- **Maximální počet souborů:** `faHistory.maxFiles` (výchozí: 50)
- **Zobrazení datumů:** `faHistory.showDates` (výchozí: `true`)

### Klávesové zkratky v diff editoru

Při zobrazení diff editoru (porovnání verzí) můžete použít:

- **F7** - Přesun na další rozdíl / Přepnutí zobrazení pouze rozdílů
- **Shift+F7** - Přesun na předchozí rozdíl
- **Tip:** F7 přepíná mezi zobrazením všech řádků a pouze rozdílů - užitečné pro rychlé prohlížení změn

## 🔍 Begin/End Matcher

Extension automaticky zvýrazňuje odpovídající `begin` a `end` bloky při pohybu kurzoru:

- **Zvýraznění:** Aktuální `begin`/`end` pár je zvýrazněn při najetí kurzoru na klíčové slovo
- **Navigace:** Umožňuje snadnou identifikaci začátku a konce bloků kódu
- **Podpora try bloků:** Správně zpracovává `try...finally...end` a `try...except...end` bloky - ignoruje `end` patřící k `try` při hledání párového `begin`/`end`

## Jak to funguje

1. **Uživatel stiskne zkratku** (např. F2 pro uložení, F1/Alt+Q/Ctrl+Q pro aktivaci FA nebo Alt+X pro vložení názvu údaje)
2. **Extension napíše příkaz** do souboru `.fsbridge/facmd.txt` (UTF-8 s BOM, bez trailing newline)
3. **FA sleduje tento soubor** a automaticky provede příslušnou akci
4. **Uživateli se zobrazí potvrzující zpráva** v notifikaci

### Atomické zápisy

Příkazy se zapisují atomicky (`tmp → rename`) aby se FA nezbláznila, když čte soubor v průběhu zápisu.

## 📊 Msg Watch Panel

Extension poskytuje panel **Msg Watch**, který zobrazuje zprávy z běžícího skriptu v FA. Panel je automaticky skrytý, když skript neběží, a zobrazí se pouze když skript běží (když existuje soubor `famsgstate.json`).

### Automatické chování

- Panel se zobrazí automaticky, když skript začne běžet
- Panel se skryje automaticky, když skript skončí
- Soubor `famsgstate.json` se automaticky maže při startu extension a při uložení souboru

## Release Notes

### 0.11.29

- 🔧 Horké klávesy FA Bridge fungují jen v Pascal editoru (kolize s doplňkem FsCode v C# souborech); odstraněna duplicitní zkratka Shift+Alt+F pro otevření panelu

### 0.11.27

- 🎨 **Automatické přepínání theme:** Nová funkce pro automatické přepínání mezi FA theme a původním theme podle typu projektu
  - Nastavení `faBridge.autoSwitchTheme` (výchozí: `false`) - zapíná/vypíná automatické přepínání
  - Nastavení `faBridge.preferredTheme` (výchozí: `"FA Pascal Light"`) - určuje preferované FA theme
  - FA theme se automaticky aplikuje pouze v projektech s `.fsbridge`
  - V non-FA projektech se automaticky obnoví původní theme
  - Řeší problém, kdy FA theme bylo aktivní i v non-FA projektech

### 0.10.9

- 📊 **CodeLens:** Zobrazuje počet referencí lokálních funkcí přímo nad jejich deklarací
  - Kliknutím na počet referencí se zobrazí seznam všech použití
  - Usnadňuje navigaci a zjišťování, kde je funkce volána
- 💡 **Hover pro lokální deklarace:** Zobrazuje dokumentaci pro lokální funkce a konstanty
  - Podpora XML komentářů (`///`) i blokových komentářů (`{ }`)
  - U konstant se zobrazuje i jejich hodnota
  - Stejná funkcionalita jako u library funkcí

### 0.10.8

- 📖 **Otevření FA nápovědy:** Nový příkaz `Ctrl+Alt+F1` pro otevření `FA.chm`
- 🔍 **TextSearch bez výběru:** `Ctrl+Shift+F1` nyní otevře TextSearch.exe i když není slovo pod kurzorem

### 0.10.7

- 🔒 **Ochrana vnořených formulářů:** Cursor se už nebude interagovat při práci s nested formuláři v FA
  - Zamezuje nechtěnému zavírání záložek při zavírání vnořených formulářů
  - Kontrola změn ve skriptech funguje pouze u hlavního okna FA

### 0.10.6

- ⚠️ **Ochrana před přepisem:** Při aktivaci/otevření skriptu v Cursoru se nyní kontroluje, zda nebyl skript změněn
  - Pokud je skript na disku jiný než v databázi FA, zobrazí se dotaz na přepsání
  - Zamezuje ztrátě neuložených změn při zavření Cursoru a opětovné aktivaci z FA

### 0.10.5

- 🛡️ **Sjednocené dialogy:** Všechny dialogy týkající se změn skriptu mají jednotný formát a terminologii
  - Přehlednější a konzistentnější uživatelské rozhraní

### 0.10.4

- 🔧 **Oprava Begin/End Matcheru:** Správné zvýrazňování `begin`/`end` bloků uvnitř `try...finally...end` a `try...except...end`
  - Matcher nyní ignoruje `end` patřící k `try` blokům při hledání párového `begin`/`end`
  - Přesnější navigace ve složitějších strukturách kódu

### 0.6.0

- ✨ **Go To Definition:** Nová funkce pro přechod na definici funkcí a procedur
  - Podpora `F12` a `Ctrl+Click` pro přechod na definici
  - Hledání v aktuálním souboru i v `FScriptUtils.pas` a `FCommonUtils.pas`
  - Automatická navigace zpět pomocí `Alt+←` nebo `Ctrl+-`
- 🔄 **IntelliSense vylepšení:** Parsování dokumentace z `FScriptUtils.pas` a `FCommonUtils.pas` místo pouze `FsUtils.pas`

### 0.5.93

- 🧹 **Úklid dokumentace:** Reorganizace dokumentace do USER_GUIDE.md a DEVELOPER_GUIDE.md

### 0.5.92

- 🔧 **Změna hotkeys:**
  - "Uložit soubor" má nyní pouze F2 (odstraněn Alt+Q/Ctrl+Q)
  - Alt+Q / Ctrl+Q nyní aktivuje pouze FA (stejně jako F1), bez uložení scriptu
  - Přidána nová volba "Přepnout do FA" v panelu s hotkeys F1, Alt+Q / Ctrl+Q
- ⚙️ **FA Compatible Hotkeys:**
  - Alt+Q / Ctrl+Q pro přepnutí do FA se mění podle nastavení `faBridge.faCompatibleHotkeys`
  - Aktualizovány texty v panelu pro správné zobrazení hotkeys podle nastavení

### 0.5.76

- ✨ **Historie souborů:** Automatické ukládání verzí souborů do `.history` složky
- 🔍 **Porovnání verzí:** Nové příkazy pro porovnání aktuálního souboru s předchozími verzemi
- 📚 **Help panel:** Nová sekce v sidebaru zobrazující obsah z `_source/fa-bridge-help.txt`
- 🔍 **Begin/End Matcher:** Automatické zvýrazňování odpovídajících `begin`/`end` bloků
- ⚙️ **Nastavení:** Přidána nastavení pro historii souborů a FA kompatibilní hotkeys
- 🧠 **IntelliSense:** Vylepšená podpora pro Pascal soubory s dokumentací z `FsUtils.pas`
- 📊 **Msg Watch:** Panel se automaticky zobrazuje/skrývá podle stavu běžícího skriptu

### 0.5.26

- 🔧 **Změna hotkey:** "Hledat od začátku" změněno z Shift+Alt+Z na Alt+L

### 0.5.25

- ✨ **Automatické otevírání panelu:** Panel FA Bridge se automaticky otevře při každém startu Cursoru/VS Code
- 🧠 **IntelliSense podpora:** Přidána podpora Completion a Hover pro Pascal soubory s dokumentací z `FsUtils.pas`
- 📊 **Msg Watch panel:** Panel se zobrazuje pouze když skript běží, automaticky se skrývá po skončení
- 🗑️ **Automatické mazání:** Soubor `famsgstate.json` se automaticky maže při startu extension a při uložení souboru
- ➕ **Nové příkazy:**
  - Vložit [.udaj.] (Shift+Ctrl+[)
  - Vložit [:udaj:] (Shift+Ctrl+])
  - Hledat od začátku (Alt+L)

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

**Vytvořeno:** Říjen 2025 | **Status:** Funkční ✓ | **Verze:** 0.10.9

---

📖 **Další dokumentace:**
- [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md) - Technická dokumentace pro vývojáře

