# Change Log

All notable changes to the "fa-bridge" extension will be documented in this file.

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