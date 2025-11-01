# Verzování FA Bridge integrace

## Přehled

Projekt FA Bridge se skládá ze dvou částí, které musí být navzájem kompatibilní:

1. **FA Bridge Extension** (`package.json`) - VS Code/Cursor extension
2. **FA Aplikace** (`uCursorBridge.pas` + `Main.pas`) - Integrace v Delphi aplikaci

## Formát verzování

Verze používají formát **semantického verzování** (Semantic Versioning):

```
X.Y.Z-FA
```

- **X.Y.Z** - Verze FA Bridge extension (z `package.json`)
- **-FA** - Suffix označující verzi pro FA aplikaci

### Příklad

- Extension verze: `0.4.0`
- FA verze: `0.4.0-FA`

## Kde jsou verze definovány

### 1. FA Bridge Extension

**Soubor:** `package.json`

```json
{
  "version": "0.4.0"
}
```

### 2. uCursorBridge.pas

**Soubor:** `FAdelphi/uCursorBridge.pas`

```pascal
const
  CURSOR_BRIDGE_VERSION = '0.4.0-FA';
  CURSOR_BRIDGE_VERSION_DATE = '2025-01-30';
```

### 3. Main.pas (UCURSOR integrace)

**Soubor:** `FAdelphi/Main.pas`

```pascal
{$IFDEF UCURSOR}
const
  FA_BRIDGE_INTEGRATION_VERSION = '0.4.0-FA';
  FA_BRIDGE_INTEGRATION_VERSION_DATE = '2025-01-30';
```

## Pravidla verzování

### Kdy aktualizovat verzi

**Při každé změně** v následujících souborech musí být verze aktualizována:

1. **`package.json`** - změna verze extension
   - Aktualizovat: `uCursorBridge.pas` a `Main.pas` na stejnou verzi s `-FA` suffixem

2. **`uCursorBridge.pas`** - změna v komunikaci/protokolu
   - Aktualizovat: `CURSOR_BRIDGE_VERSION` a `CURSOR_BRIDGE_VERSION_DATE`
   - **DŮLEŽITÉ:** Pokud se změní protokol komunikace, musí být aktualizována i verze extension!

3. **`Main.pas`** - změna v `{$IFDEF UCURSOR}` bloku
   - Aktualizovat: `FA_BRIDGE_INTEGRATION_VERSION` a `FA_BRIDGE_INTEGRATION_VERSION_DATE`

### Typy změn a jejich vliv na verzi

#### Major Version (X.0.0)

- **Breaking changes** v protokolu komunikace
- Nezabezpečená změna formátu souborů (`.fsbridge/facmd.txt`, `fadebug.txt`, `fadebugstate.json`)
- Změna struktury JSON v `fadebugstate.json`

#### Minor Version (0.Y.0)

- Přidání nových funkcí (např. nový debugger příkaz)
- Změna v interní implementaci bez změny protokolu
- Nové volitelné parametry v JSON

#### Patch Version (0.0.Z)

- Opravy chyb
- Vylepšení výkonu
- Aktualizace komentářů
- Refaktoring bez změny funkčnosti

## Postup při změně

### 1. Změna v Extension (`package.json`)

```bash
# 1. Aktualizuj verzi v package.json
# 2. Aktualizuj verzi v uCursorBridge.pas na stejnou verzi s -FA
# 3. Aktualizuj verzi v Main.pas na stejnou verzi s -FA
# 4. Zkontroluj kompatibilitu protokolu
# 5. Commit s popisem změn
```

### 2. Změna v uCursorBridge.pas

```pascal
// Před změnou:
CURSOR_BRIDGE_VERSION = '0.4.0-FA';
CURSOR_BRIDGE_VERSION_DATE = '2025-01-30';

// Po změně:
CURSOR_BRIDGE_VERSION = '0.4.1-FA';  // nebo vyšší podle typu změny
CURSOR_BRIDGE_VERSION_DATE = '2025-01-31';

// DŮLEŽITÉ: Pokud se změnil protokol, musí být aktualizována i verze extension!
```

### 3. Změna v Main.pas

```pascal
// Před změnou:
FA_BRIDGE_INTEGRATION_VERSION = '0.4.0-FA';
FA_BRIDGE_INTEGRATION_VERSION_DATE = '2025-01-30';

// Po změně:
FA_BRIDGE_INTEGRATION_VERSION = '0.4.0-FA';  // nebo vyšší podle typu změny
FA_BRIDGE_INTEGRATION_VERSION_DATE = '2025-01-31';
```

## Kontrola kompatibility

### Automatická kontrola (doporučeno)

Při startu FA aplikace lze kontrolovat verzi nainstalované extension:

```pascal
// Příklad kontroly (do budoucna)
procedure CheckExtensionVersion;
var
  VersionFile: string;
begin
  VersionFile := IncludeTrailingPathDelimiter(EffectiveExportFolder) + 
                 '.fsbridge' + PathDelim + 'version.txt';
  // Čtení verze z extension a porovnání s CURSOR_BRIDGE_VERSION
end;
```

### Manuální kontrola

Před každým commitem zkontroluj:

1. ✅ Je verze v `package.json` správná?
2. ✅ Je verze v `uCursorBridge.pas` kompatibilní?
3. ✅ Je verze v `Main.pas` kompatibilní?
4. ✅ Je `VERSION_DATE` aktualizovaný?
5. ✅ Je změna dokumentována v `CHANGELOG.md`?

## Historie verzí

Aktuální verze:
- **Extension:** `0.4.0`
- **uCursorBridge.pas:** `0.4.0-FA` (2025-01-30)
- **Main.pas:** `0.4.0-FA` (2025-01-30)

## Kompatibilita

### Kompatibilní verze

Verze jsou kompatibilní, pokud:
- Major verze je stejná
- Minor verze je stejná nebo vyšší v extension
- Patch verze může být různá

### Příklad kompatibility

- Extension `0.4.0` ↔ FA `0.4.0-FA` ✅ **Kompatibilní**
- Extension `0.4.1` ↔ FA `0.4.0-FA` ✅ **Kompatibilní** (extension má novější patch)
- Extension `0.4.0` ↔ FA `0.4.1-FA` ❌ **Možná nekompatibilní** (nutno ověřit)
- Extension `0.5.0` ↔ FA `0.4.0-FA` ❌ **Nekompatibilní** (jiná minor verze)

## Důležité poznámky

1. **Vždy aktualizuj verzi při změně** - I malá změna může mít vliv na kompatibilitu
2. **Synchronizuj datum** - `VERSION_DATE` musí odpovídat datu změny
3. **Dokumentuj změny** - Přidej do `CHANGELOG.md` popis změn
4. **Testuj kompatibilitu** - Před commitem vždy otestuj komunikaci mezi extension a FA
5. **Breaking changes** - Pokud měníš protokol, zvýš Major verzi a upozorni uživatele

## Reference

- [Semantic Versioning](https://semver.org/)
- [FA Bridge Extension README](README.md)
- [Debugger Dokumentace](DEBUGGER_DOCS.md)




























