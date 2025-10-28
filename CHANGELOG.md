# Change Log

All notable changes to the "fa-bridge" extension will be documented in this file.

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