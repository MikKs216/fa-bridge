# FA Bridge Extension

Propojení **Cursor/VS Code** s editorem **FormAsistent (FA)** pomocí FA Bridge.

## Rychlý přehled

FA Bridge Extension poskytuje:

- **Komunikaci s FormAsistent** přes příkazy do souboru `.fsbridge/facmd.txt`
- **Pascal Syntax Highlighting** s podporou FA vlastních funkcí a formulářových odkazů
- **IntelliSense podporu** (Completion + Hover) pro Pascal soubory
- **Msg Watch panel** pro zobrazení zpráv z běžícího skriptu
- **Historie souborů** s možností porovnání verzí

## Instalace

### Z VSIX souboru

1. Stáhni VSIX soubor (např. `fa-bridge-0.5.93.vsix`)
2. V Cursor/VS Code: Ctrl+Shift+P → "Extensions: Install from VSIX..."
3. Vyber stažený VSIX soubor

Nebo z příkazové řádky:

```bash
code --install-extension fa-bridge-0.5.93.vsix
```

### Z vývojového repozitáře

1. Klonuj tento repo
2. Spusť `npm install` v kořenovém adresáři
3. Spusť `npm run compile` pro kompilaci TypeScriptu
4. Vytvoř VSIX: `npx @vscode/vsce package`
5. Nainstaluj VSIX soubor

## Dokumentace

- **[USER_GUIDE.md](USER_GUIDE.md)** - Uživatelská příručka (pro koncové uživatele)
- **[DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md)** - Technická dokumentace (pro vývojáře a AI asistenty)

## Základní použití

1. Otevři workspace s FA scripty
2. Panel FA Bridge se automaticky otevře v levém sidebaru
3. Používej příkazy z panelu nebo klávesové zkratky:
   - **F2** - Uložit soubor
   - **F1, Alt+Q / Ctrl+Q** - Přepnout do FA
   - **Alt+X** - Vložit název údaje
   - ... a další (viz [USER_GUIDE.md](USER_GUIDE.md))

## Verze

**Aktuální verze:** 0.10.9

---

**Vytvořeno:** Říjen 2025 | **Status:** Funkční ✓
