# Change Log

All notable changes to the "fa-bridge" extension will be documented in this file.

## [0.5.11] - 2025-01-XX

### Changed
- **Vložit název údaje (Alt+X)**: Funkce nyní nahrazuje označený text místo vložení na kurzor
  - Pokud je text označen (selekce), nahradí ho obsahem z `fafield.txt`
  - Pokud není selekce, vloží text na pozici kurzoru (původní chování)
  - Užitečné pro rychlé nahrazování existujícího textu názvem údaje

### Fixed
- **Toggle field (Alt+A)**: Kurzor se nyní posouvá o 3 znaky doleva po změně formátu
  - Umožňuje pokračovat v editaci bez nutnosti ručního posunu kurzoru zpět do slova

### Documentation
- Aktualizována dokumentace v README.md a CHANGELOG.md podle všech změn od verze 0.4.9

## [0.5.10] - 2025-01-XX

### Changed
- **Vložit název údaje (Alt+X)**: Funkce nyní nahrazuje označený text místo vložení na kurzor
  - Pokud je text označen (selekce), nahradí ho obsahem z `fafield.txt`
  - Pokud není selekce, vloží text na pozici kurzoru (původní chování)
  - Užitečné pro rychlé nahrazování existujícího textu názvem údaje

### Fixed
- **Toggle field (Alt+A)**: Kurzor se nyní posouvá o 3 znaky doleva po změně formátu
  - Umožňuje pokračovat v editaci bez nutnosti ručního posunu kurzoru zpět do slova

## [0.5.9] - 2025-01-XX

### Changed
- **Hotkey změny pro lepší ergonomii**:
  - Toggle field: `Alt+B` → `Alt+A`
  - Vložit název údaje: `Alt+V` → `Alt+X`

## [0.5.8] - 2025-01-XX

### Added
- **Toggle field (Alt+A)**: Nová funkce pro cyklické měnění formátu slova pod kurzorem
  - `'slovo'` → `[:slovo:]` → `[.slovo.]` → `'slovo'` → ...
  - Pokud je kurzor na slově bez formátu, přidá apostrofy: `slovo` → `'slovo'`
  - Automaticky rozpoznává existující formát a přepne na další v cyklu

### Changed
- **Toggle msgv (Alt+F9)**: Vylepšená logika vkládání
  - Pokud je aktuální řádek prázdný, vloží `msgv('');` na tento řádek
  - Pokud řádek není prázdný, vloží `msgv('');` na nový řádek před aktuální řádek

## [0.5.7] - 2025-01-XX

### Added
- **Toggle msgv (Alt+F9)**: Nová funkce pro vkládání/smazání `msgv` debug příkazů
  - Vloží `msgv('');` před aktuální řádek (nebo na aktuální řádek pokud je prázdný)
  - Smaže celý řádek pokud začíná `msgv(` (s případnými bílými znaky)
  - Kurzor se automaticky umístí mezi apostrofy pro rychlé vyplnění

## [0.5.6] - 2025-01-XX

### Changed
- **msg/msgv dialogy**: Dialogové okna se nyní zobrazují uprostřed hlavního okna FA místo monitoru
  - Používá `GfaMain.Left` a `GfaMain.Top` pro výpočet pozice
  - Lepší UX při práci s více monitory

### Fixed
- **msgv export proměnných**: Funkce `msgv` nyní exportuje aktuální proměnné a fieldy do Cursoru stejně jako `msg`
  - Přidáno volání `GfaMain.OnMsgCalled(VarToStr(AMessage))` v `Msgv` proceduře

## [0.5.5] - 2025-01-XX

### Removed
- **Sekce "Návrh Příkazy"**: Odstraněna celá sekce včetně všech příkazů:
  - Provést Init (Shift+Alt+I)
  - Provést Calculate (Shift+Alt+E)
  - Provést Enable (Shift+Alt+N)
  - Zobrazit Info (Shift+Alt+B)
  - Zobrazit Platební informace (Shift+Alt+P)
  - Zobrazit Period (Shift+Alt+R)
- **Panel "Stav komunikace"**: Odstraněn debug panel pro sledování stavu komunikace s FA
  - Odstraněny všechny související příkazy a komponenty
  - Vyčištěn kód od pomocného ladícího řešení

## [0.4.9] - 2025-10-31

### Fixed
- **✅ OPRAVENO: Problémy s trasováním - F5/F10 nereagují a řádky se označují špatně**
  - **Problém:** 
    - F5/F10 klávesy často nereagovaly
    - Řádky se označovaly zmateně nebo na špatných pozicích
    - Decorations mizely při přepnutí tabu
    - Race conditions při rychlých změnách stavu
  - **Řešení:**
    - **Přidán debouncing pro `updateState()`** - 150ms delay zabraňuje race conditions
    - **Přidán listener pro změnu editoru** - `onDidChangeActiveTextEditor` aktualizuje decorations při přepnutí tabu
    - **Nová metoda `refreshDecorations()`** - zajišťuje správné zobrazení při změně editoru
    - **Debouncing pro resynchronizaci breakpointů** - 500ms delay pro lepší stabilitu
    - **Přidáno logování** - všechny debugger metody logují svoje volání pro snadnější debugging
    - **Přidány kontroly v extension.ts** - příkazy kontrolují jestli je debugger inicializován a zobrazují hlášky
    - **Zlepšena kontrola editoru** - `updateBreakpoints()` kontroluje jestli je aktivní Pascal soubor
    - **Zlepšena `highlightCurrentLine()`** - vymaže decoration před nastavením nového
    - **Cleanup timerů** - všechny timery se správně ruší při dispose()
  - **Výsledek:** Debugger je nyní stabilnější, F5/F10 fungují spolehlivě, decorations se správně aktualizují ✅

- **✅ OPRAVENO: Off-by-one error v číslu aktuálního řádku**
  - **Problém:** Zvýrazněný řádek byl o jeden řádek výše než skutečný aktuální řádek
  - **Příklad:** Debugger zastavený na řádku 31 (`ini('OdesPSC',...)`) zvýrazňoval řádek 30 (prázdný)
  - **Řešení:** FA posílá **0-based čísla řádků** (stejně jako VS Code), odstraněna zbytečná konverze `-1`
  - Nyní žluté pozadí přesně označuje správný řádek, na kterém je debugger zastavený 🎯

- **✅ OPRAVENO: F10 (Step Over) nefungovala nebo fungovala jen občas**
  - **Problém:** F10 je ve Windows a VS Code zachycována pro aktivaci menu baru
  - **Řešení:** Přidána podmínka `editorTextFocus` ke všem debugger klávesovým zkratkám (F5, F9, F10, Shift+F5)
  - Nyní mají debugger příkazy **vyšší prioritu** než systémové zkratky
  - F10 by nyní měla fungovat spolehlivě při krokování kódu 🎯

- **✅ OPRAVENO: Breakpointy se posunuly po vložení/smazání řádků a uložení**
  - **Problém:** 
    1. Nastavíš breakpoint na řádku 10
    2. Vložíš 3 řádky nad něj (breakpoint by měl být nyní na řádku 13)
    3. Uložíš soubor (což spustí překlad v FA)
    4. Přidáš další breakpoint → všechny breakpointy se posunou o 3 řádky dolů (chyba!)
  - **Řešení:**
    - Extension nyní **sleduje změny v dokumentu** (`onDidChangeTextDocument`) a automaticky přepočítává pozice breakpointů
    - Po **uložení souboru** (`onDidSaveTextDocument`) extension **resynchronizuje** všechny breakpointy s FA
    - FA nyní podporuje příkaz `DEBUG_CLEAR_ALL_BREAKPOINTS` pro hromadné vyčištění
    - Breakpointy se nyní drží na **správných řádcích kódu**, ne na pevných číslech řádků 🎯

- **✅ OPRAVENO: Číslování řádků bylo nekonzistentní v celém systému**
  - **Problém:** 
    - FA posílá `currentLine = 32`, ale v editoru se zvýrazňoval řádek 32 (měl by být 33)
    - Status bar zobrazoval "řádek 33" když FA posílal 32
    - Nekonzistence mezi `highlightCurrentLine()`, `updateStatusBar()` a `updateBreakpoints()`
  - **Příčina:** 
    - **FA používá 1-based indexování** (Delphi/TMS Scripter tradice)
    - **VS Code používá 0-based indexování** (JavaScript/TypeScript standard)
    - Kód předpokládal různé indexování na různých místech:
      - `highlightCurrentLine()` používal `currentLine` přímo (jako 0-based) ❌
      - `updateStatusBar()` přidával `+1` k už 1-based číslu ❌
      - `updateBreakpoints()` správně odečítal `-1` (1-based → 0-based) ✅
      - `extension.ts` správně přidával `+1` při posílání breakpointů (0-based → 1-based) ✅
  - **Řešení:**
    - **Jednotná konvence:** FA posílá 1-based čísla, extension je ukládá jako 1-based
    - **Převod při zobrazení:**
      - `highlightCurrentLine()`: `line - 1` (1-based → 0-based pro VS Code) ✅
      - `updateStatusBar()`: zobrazuje přímo `line` (1-based z FA) ✅
      - `updateBreakpoints()`: `line - 1` (1-based → 0-based pro VS Code) ✅
    - **Převod při odesílání:**
      - `extension.ts`: `line + 1` (0-based VS Code → 1-based FA) ✅
    - Všechna místa jsou nyní **konzistentní** a správně převádějí mezi 0-based a 1-based ✅
  - **Problém:** 
    1. Nastavíš breakpoint na řádku 10
    2. Spustíš debug
    3. Smažeš breakpoint (F9) - červená tečka zmizí
    4. Nastavíš jiný breakpoint na řádku 20
    5. Někdy se stalo, že kód se zastavil na starém smazaném breakpointu (řádek 10)
  - **Příčina:** 
    - Extension smazal breakpoint z lokálního stavu a zobrazování
    - Ale pokud FA ještě nezpracovala `DEBUG_CLEAR_BREAKPOINT`, breakpoint zůstal v FA
    - Při `updateState()` extension přepsal lokální stav breakpointy z FA (včetně starého)
  - **Řešení:**
    - **Extension je nyní "master"** - lokální stav breakpointů má přednost
    - **Resynchronizace po každé změně breakpointu** - po 300ms se všechny breakpointy resynchronizují
    - **Resynchronizace při uložení** - vždy smaže všechny breakpointy v FA a pošle lokální
    - **Detekce nesouladu** - když FA pošle breakpointy které se liší od lokálních, automaticky resynchronizuje
    - Breakpointy jsou nyní **synchronizované v obou směrech** a staré smazané breakpointy se už neaktivují ✅

### Added
- **✨ NOVÉ: Příkaz "Smazat všechny breakpointy"**
  - Dostupný v FA Bridge panelu v sekci "Debug Příkazy"
  - Ikona koše (trash) pro snadné rozpoznání
  - Smaže všechny nastavené breakpointy jedním kliknutím
  - Užitečné při změně strategie debugování nebo po úpravách kódu 🗑️

### Changed
- **⚡ Zvýšena rychlost reakce FA na příkazy z Cursor**
  - **TimerPoll interval snížen z 1000 ms na 500 ms**
  - FA nyní kontroluje příkazy z Cursor **2× za sekundu** (místo 1× za sekundu)
  - Rychlejší odezva při ukladání souborů, nastavování breakpointů a debugování
  - Plynulejší práce s FA Bridge extension ⚡

### Removed
- **🗑️ ODSTRANĚNO: Context menu pro breakpointy v gutteru**
  - **Důvod:** Context menu nefungovalo správně - editor nebyl nalezen při kliknutí
  - Pro přepínání breakpointů použij stávající klávesové zkratky:
    - `F9` - přepnout breakpoint na aktuálním řádku (kde je kurzor)
    - `Alt+F9` - alternativní zkratka

## [0.4.8] - 2025-10-30 (STABILNÍ VERZE)

### Fixed
- **⚠️ VRÁCENO NA STABILNÍ STAV: Odstraněna žlutá šipka v gutteru**
  - **Důvod:** Žlutá šipka zůstávala zobrazená i po ukončení debugování a objevovala se v jiných projektech
  - **Řešení:** Vráceno na jednoduché **žluté pozadí aktuálního řádku** (bez šipky v gutteru)
  - Decoration se nyní správně čistí po ukončení debugování
  - Červené tečky breakpointů zůstávají zachovány a fungují správně 🔴
  - Verze 0.5.1 byla **ZRUŠENA** kvůli problému s persistentní žlutou šipkou

## [0.5.1] - 2025-10-30 (ZRUŠENO - mělo problém s persistentní šipkou)

**⚠️ DŮLEŽITÉ:** Verze 0.4.9 a 0.5.0 byly **VRÁCENY ZPĚT** na 0.4.8 z důvodu nefunkčních změn.

**Problém:**
- Žlutá šipka a žlutá tečka pro indikaci aktuálního řádku nefungovaly správně
- Indexování řádků nebylo správné (označení bylo o řádek výše než mělo být)
- Kombinované zobrazení breakpointů a aktuálního řádku způsobovalo problémy

**Aktuální stav (0.4.8):**
- ✅ Základní debugování funguje (Continue, Pause, Step Over, Stop)
- ✅ Breakpointy se zobrazují červenými tečkami v gutteru
- ✅ Aktuální řádek má jemné žluté pozadí (bez ikony v gutteru)
- ✅ Návrh Příkazy fungují s hotkeys
- ✅ Automatické zastavení debuggeru při zavírání FA

---

## ~~[0.5.0]~~ - 2025-10-30 (ZRUŠENO)

### Fixed
- **KRITICKÁ OPRAVA: Indexování řádků**: Označení aktuálního řádku nyní ukazuje na správný řádek (ne o jeden řádek výše)
  - Odstraněna konverze `line - 1` - FA posílá 0-based čísla řádků (z `LineNumberFromInstruction`)
  - VS Code `.lineAt()` také používá 0-based indexy, takže se číslo řádku použije přímo
  - Aktualizovány komentáře: breakpointy a currentLine jsou 0-based (ne 1-based)
  - Opraveno v `highlightCurrentLine()` i `updateBreakpoints()`
  - Žlutá šipka/tečka nyní správně označuje aktuální řádek při debugování

## ~~[0.4.9]~~ - 2025-10-30 (ZRUŠENO)

### Fixed
- **Oprava zvýrazňování aktuálního řádku**: Žlutá šipka se nyní správně přesouvá a nezdvojuje
  - `highlightCurrentLine()` nejdříve maže předchozí decoration před nastavením nové
  - Opraveno indexování: FA posílá 1-based čísla řádků, VS Code používá 0-based (konverze `line - 1`)
  - Přidána validace čísla řádku před aplikací decoration
- **Žlutá tečka na breakpointu**: Když je debugger zastaven na breakpointu, zobrazuje se žlutá tečka místo červené
  - `combinedDecorationType` změněn z kombinované ikony na jednoduchou žlutou tečku
  - `updateBreakpoints()` přeskakuje aktuální řádek (nezobrazuje červenou tečku tam, kde je žlutá tečka)
  - Po krokování se žlutá tečka vrací na červenou a žlutá šipka se zobrazí na novém aktuálním řádku

## [0.4.8] - 2025-10-30

### Fixed
- **Kombinovaná ikona pro breakpoint + aktuální řádek**: Když je aktuální řádek při debugování na řádku s breakpointem, zobrazuje se kombinovaná ikona s červenou tečkou (breakpoint) a žlutou šipkou (aktuální řádek), aby bylo vidět obě indikace najednou
- Přidán nový decoration type `combinedDecorationType` pro zobrazení obou ikon současně
- Upravena logika `highlightCurrentLine()` pro detekci breakpointu na aktuálním řádku

## [0.4.7] - 2025-10-30

### Changed
- **Ukazatel aktuálního řádku**: Žlutá šipka v gutteru označující aktuální řádek při debugování je nyní otočená o 180° (šipka směřuje opačným směrem)

## [0.4.6] - 2025-10-30

### Added
- **Příkazy pro testování návrhu formuláře**: Přidána nová kategorie "Návrh Příkazy" v FA Bridge panelu
  - Provést Init (Shift+Alt+I) - spustí funkci DoInit v návrhu formuláře
  - Provést Calculate (Shift+Alt+E) - spustí funkci DoCalculate v návrhu formuláře
  - Provést Enable (Shift+Alt+N) - spustí funkci DoEnable v návrhu formuláře
  - Zobrazit Info (Shift+Alt+B) - zobrazí informace o formuláři
  - Zobrazit Platební informace (Shift+Alt+P) - zobrazí platební informace
  - Zobrazit Period (Shift+Alt+R) - zobrazí aktuální období
- Všechny příkazy mají odpovídající ikony, tooltips a hotkeys
- Příkazy jsou zpracovávány v FA jak přes facmd.txt (ProcessFACommand) tak přes fadebug.txt (ProcessDebugCommand)

### Changed
- `writeFACommand` nyní používá konfigurovanou cestu `faBridge.fsbridgePath` místo workspace root

## [0.4.5] - 2025-10-30

### Added
- **Debug příkazy v FA Bridge panelu**: Přidány debugger příkazy do sidebaru panelu FA Bridge
  - Panel nyní obsahuje dvě kategorie: "FA Příkazy" a "Debug Příkazy"
  - Debug příkazy: Pokračovat (F5), Krokovat (F10), Přepnout breakpoint (F9), Zastavit debug
  - Každý příkaz má odpovídající ikonu a tooltip
  - F11 (Step Into) a Shift+F11 (Step Out) nejsou zatím implementovány v FA - debugování se provádí pomocí breakpointů

### Fixed
- **Oprava označení aktuálního řádku**: Žlutá šipka nyní ukazuje na správný řádek (opravena konverze čísla řádku)

## [0.4.4] - 2025-10-30

### Fixed
- **Oprava zvýraznění aktuálního řádku**: Nyní se zvýrazní pouze jeden řádek (ne dva)
  - Range pro decoration nyní používá `lineAt().range` místo `translate(1, 0)`
  - Žlutá šipka a pozadí se zobrazí přesně na aktuálním řádku

## [0.4.3] - 2025-10-30

### Added
- **Výrazná žlutá šipka v gutteru pro aktuální řádek**: Při pozastavení debuggeru na breakpointu se nyní zobrazí výrazná žlutá šipka vlevo v gutteru
  - Žlutá šipka ukazuje přesný řádek, kde je script pozastavený
  - Jemné žluté pozadí pro lepší viditelnost
  - Žlutý indikátor v overview ruleru pro snadnou navigaci

### Fixed
- **FA lze nyní zavřít i když je pozastavená na breakpointu**: Při zavírání FA se automaticky zastaví debugger, takže aplikace nejde zamrznout
  - Přidána automatická kontrola v `FormCloseQuery`
  - Není už potřeba ukončovat FA přes Task Manager

### Changed
- **Verzování**: Aktualizována verze na `0.4.3-FA` v `Main.pas` a `uCursorBridge.pas`

## [0.4.2] - 2025-10-30

### Fixed
- **Breakpointy nyní zůstávají viditelné při přepnutí záložky**: Extension nyní sleduje změnu aktivního editoru a automaticky obnovuje zobrazení breakpointů a zvýraznění aktuálního řádku
  - Přidán listener `onDidChangeActiveTextEditor` který volá `refreshDecorations()`
  - Breakpointy již nemizí při přepnutí mezi záložkami v Cursoru

## [0.4.1] - 2025-10-30

### Fixed
- **Debugger funguje nyní i pro soubory otevřené MIMO workspace**: Extension se nyní aktivuje i když otevřeš `.pas` soubor přímo z FA (např. `D:\FA DESIGN\DataPrg\Scripts\...`)
  - Přidána konfigurace `faBridge.fsbridgePath` pro nastavení cesty k `.fsbridge` složce
  - Debugger již nevyžaduje otevřený workspace Cursoru
  - Výchozí cesta: `D:\FA DESIGN\DataPrg\Scripts\.fsbridge`

### Changed
- **Extension používá fixní cestu k `.fsbridge` místo relativní cesty k workspace**
  - Umožňuje komunikaci s FA i když otevřeš soubor mimo workspace
  - Cesta je konfigurovatelná v nastavení (`faBridge.fsbridgePath`)

### Added
- **Nová sekce v README**: ⚙️ Nastavení - vysvětlení jak nastavit cestu k `.fsbridge` složce

## [0.4.0] - 2025-10-29

### Added
- **Nastavení pro zapnutí/vypnutí snippetů**: V nastavení rozšíření (File > Preferences > Settings > FA Bridge) je nyní možné vypnout Pascal snippety
  - Nastavení `faBridge.enableSnippets` (výchozí: zapnuto)
  - Snippety jsou nyní poskytovány programově místo statické registrace
  - Umožňuje uživatelům deaktivovat snippety pokud používají vlastní

### Changed
- Snippety jsou nyní poskytovány přes `CompletionItemProvider` místo statické registrace v `package.json`
- To umožňuje dynamické zapínání/vypínání bez nutnosti reinstalace rozšíření

## [0.3.9] - 2025-10-29

### Changed
- **Syntax Highlighting - barva číselných konstant**: Změněna barva čísel na tmavě modrou
  - Light theme: `#000080` (tmavě modrá, stejná jako klíčová slova)
  - Dark theme: `#5C9EFF` (světle modrá, stejná jako klíčová slova)
  - Předchozí zelená barva (#098658 / #B5CEA8) nahrazena

## [0.3.8] - 2025-10-29

### Changed
- **Syntax Highlighting pro FA Form Field References - finální verze**: Závorky ponechány na standardním chování
  - Hranaté závorky `[` `]` se řídí standardním Bracket Pair Colorization editoru
  - Barevné odlišení vnořených závorek zůstává funkční (je to feature editoru)
  - Barvíme pouze obsah: `.nazevUdaje.` nebo `:nazevUdaje:` zeleně
  - Použit lookbehind/lookahead regex: `(?<=\[)(\.|\:)[A-Za-z_]\w*(\.|\:)(?=\])`
  - Jednoduchý scope: `entity.name.field.fa.pascal`

## [0.3.7] - 2025-10-29

### Fixed
- **Syntax Highlighting pro FA Form Field References - oprava barvení závorek**: Explicitní nastavení barvy závorek
  - Hranaté závorky `[` a `]` mají explicitně nastavenou standardní barvu textu (černá/šedá)
  - Obsah `.nazevUdaje.` nebo `:nazevUdaje:` je zelený
  - Použit begin/end pattern s explicitními captures pro závorky
  - Eliminováno automatické párování barev závorek editorem
  - Light theme: závorky #000000 (černá), obsah #008000 (zelená)
  - Dark theme: závorky #D4D4D4 (šedá), obsah #00C000 (zelená)

## [0.3.6] - 2025-10-29

### Fixed
- **Syntax Highlighting pro FA Form Field References - finální řešení**: Barvení jen obsahu bez závorek
  - Hranaté závorky `[` a `]` zůstávají standardní (černé/podle tématu)
  - Barvíme pouze obsah: `.nazevUdaje.` nebo `:nazevUdaje:` (včetně teček/dvojteček)
  - Použit lookbehind/lookahead regex: `(?<=\[)(\.|\:)[A-Za-z_]\w*(\.|\:)(?=\])`
  - Eliminovány všechny konflikty s párováním závorek a jinými pravidly
  - Jednoduché a spolehlivé řešení

## [0.3.5] - 2025-10-29

### Fixed
- **Syntax Highlighting pro FA Form Field References - návrat k jednoduchému řešení**: Vráceno zpět na jednodušší match pattern
  - Použit jednoduchý regex: `\[(\.|\:)[A-Za-z_]\w*(\.|\:)\]`
  - Zjednodušené theme scope pouze na `entity.name.field.fa.pascal`
  - Eliminovány kolize s normálním array accessem
  - Verze 0.3.2, 0.3.3 a 0.3.4 měly problémy s příliš složitými pravidly

## [0.3.4] - 2025-10-29

### Fixed
- **Syntax Highlighting pro FA Form Field References - scope region s vyšší prioritou**: Změněn přístup z `match` na `begin`/`end`
  - Vytváří scope region, který má vyšší prioritu než jiná pravidla
  - Mělo by eliminovat všechny konflikty s jinými pravidly (stringy, funkce, operátory)
  - Field references budou zelené i uvnitř složitých výrazů a volání funkcí
  - Konstrukce `[:nazevUdaje:]` má pattern: `\[:` ... `:\]`
  - Konstrukce `[.nazevUdaje.]` má pattern: `\[\.` ... `\.\]`

## [0.3.3] - 2025-10-29

### Fixed
- **Syntax Highlighting pro FA Form Field References - oprava konzistence**: Rozděleno pravidlo na dvě samostatná
  - Jedno specifické pravidlo pro `[:nazevUdaje:]` konstrukce
  - Druhé specifické pravidlo pro `[.nazevUdaje.]` konstrukce
  - Eliminovány kolize s normálním array accessem (např. `Fields[15]`)
  - Všechny field references by nyní měly být konzistentně zelené ve všech kontextech

## [0.3.2] - 2025-10-29

### Fixed
- **Syntax Highlighting pro FA Form Field References**: Opraveno zvýrazňování konstrukcí `[:nazevUdaje:]` a `[.nazevUdaje.]`
  - Vylepšený regex pattern pro lepší rozpoznávání
  - Explicitní captures pro všechny části konstrukce (závorky, tečky/dvojtečky, jméno fieldu)
  - Aktualizované color themes pro použití všech nových scope names
  - Všechny field references by nyní měly být konzistentně zelené

## [0.3.1] - 2025-10-28

### Added
- **Pascal Snippety**: 11 užitečných snippetů pro rychlejší psaní Pascal kódu
  - `function` - funkce vracející hodnotu
  - `procedure` - procedura
  - `if` - if-then-begin blok
  - `for` - for cyklus
  - `try` - try-finally blok
  - `trye` - try-except s error handling
  - `repeat` - repeat-until cyklus
  - `while` - while cyklus
  - `case` - case of struktura
  - `var` - TStringList s kompletním try-finally a for cyklem
  - `begin` - begin-end blok
- **Theme přepínání**: Nové příkazy v Command Palette pro přepínání mezi FA Pascal Light a Dark themes
  - "FA Bridge: Přepnout na světlý motiv"
  - "FA Bridge: Přepnout na tmavý motiv"

## [0.3.0] - 2025-10-28

### Added
- **Všechny FA funkce z HTML helpu**: Kompletní seznam 408 funkcí včetně:
  - Helper funkce: `ini`, `chk`, `lst`
  - Variant funkce: `VarToStr`, `VarToDateTime`, `VarToDouble`, `VarToInt`, `VarToBool`, `VarIsNE`
  - String funkce: `StrLeft`, `StrRight`, `StrRepeat`, `StrPadLeft`, `StrPadRight`, `StrNPos`, `StrStrCount`
  - Try funkce: `TryEditValuesRecord`, `TryPostValuesRecord`, `TryEncodeDateTimeEx`, `TryDeleteDirectory`
  - Další: `WriteValue2Form`, `ValidValue`, `YearOf`, `Trunc`, `StringList` a mnoho dalších

### Changed
- Tmavší fialová barva pro FA funkce v dark theme (#D896FF)

## [0.2.0] - 2025-10-28

### Added
- **Pascal Syntax Highlighting**: Plná podpora pro Pascal/Delphi soubory (.pas, .dpr, .dfm, atd.)
- **FA Custom Functions**: Zvýraznění 200+ vlastních FA funkcí (CheckRodneCislo, NactiAdresuZARES, atd.)
- **Form Field References**: Speciální highlighting pro `[.nazevUdaje.]` a `[:nazevUdaje:]` konstrukce
- **Color Themes**: 
  - FA Pascal Light - světlé téma podle FA editoru
  - FA Pascal Dark - tmavé téma pro komfort
- **Language Configuration**: Auto-closing závorek, komentářů, region folding pro Pascal

## [0.1.7] - 2025-10-28

### Changed
- Aktualizovány názvy příkazů v sidebaru
- "Uložit a aktivovat FA" → "Aktivovat FA"
- "Kopírovat název údaje" → "Název údaje do clipboardu"

### Removed
- Odstraněna funkce "Zkompilovat script" (Shift+Alt+D) - nebyla používána

## [0.1.6] - 2025-10-28

### Removed
- Odstraněna registrace příkazů v Command Palette (Ctrl+Shift+P)
- Všechny funkce jsou nyní dostupné pouze v sidebaru FA Bridge pro čistší UI

## [0.1.5] - 2025-10-28

### Changed
- Alt+Q nyní volá Save (Ctrl+S) místo aktivace FA
- Zachováno pro rychlé uložení jednou rukou

### Removed
- Odstraněno "Uložit vše" (Alt+S) - kolidovalo s menu Selection v Cursoru

## [0.1.4] - 2025-10-28

### Fixed
- Lepší error handling - chybové hlášky zobrazují skutečnou příčinu problému

## [0.1.3] - 2025-10-28

### Added
- Vlastní ikona extension vytvořená na základě FScode ikony s písmenem "F"

## [0.1.2] - 2025-10-28

### Added
- Přidány standardní příkazy do sidebaru (Uložit soubor, Uložit vše)

## [0.1.1] - 2025-10-28

### Changed
- Jednotné zkratky - všechny příkazy nyní používají Shift+Alt
- Otevřít sidebar: Ctrl+Alt+F → Shift+Alt+F
- Vložit název: Ctrl+Alt+V → Shift+Alt+V

### Removed
- Odstraněn testovací příkaz `faBridge.test`

## [0.1.0] - 2025-10-28

### Added
- Nová funkce: Kopírovat název údaje do schránky (Shift+Alt+C)
- Nová funkce: Najít údaj ve formuláři podle slova pod kurzorem (Shift+Alt+L)

### Changed
- Změna zkratky "Aktivovat formulář" z Ctrl+Alt+1 na Alt+Q
- Změna zkratky "Zkompilovat script" z Ctrl+Alt+2 na Shift+Alt+D

### Removed
- Odstraněn testovací příkaz c999

## [0.0.3] - 2025-10-28

### Added
- Klávesová zkratka Ctrl+Alt+F pro otevření sidebaru

### Fixed
- Kompatibilita s Cursor (snížena minimální verze na 1.85.0)

## [0.0.2] - 2025-10-28

### Added
- Přidán sidebar panel v Activity Bar
- TreeView s příkazy a klávesovými zkratkami

### Changed
- Změna zkratky pro "Vložit název" z Ctrl+Alt+3 na Ctrl+Alt+V

### Removed
- Odstraněno Quick Pick menu

## [0.0.1] - 2025-10-23

### Added
- Základní implementace
- Příkazy přes Quick Pick menu