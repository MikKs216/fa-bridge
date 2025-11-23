# Řešení pro více instancí FA

## Problém

Když jsou otevřené více oken (instancí) FA, každá má svou instanci Cursoru. Všechny instance používají stejné komunikační soubory:
- `{fsbridgePath}/facmd.txt` (Cursor → FA)
- `{workspace}/.fsbridge/fafield.txt` (FA ↔ Cursor)

To způsobuje, že se komunikace mezi instancemi míchá.

## Navrhované řešení: Instance ID v názvu souboru

### Koncept

1. **FA při otevření Cursoru:**
   - Zapíše svůj PID do `.fsbridge/fa_instance.txt`
   - Formát: `{PID}` (např. `12345`)

2. **Cursor při startu:**
   - Načte instance ID z `.fsbridge/fa_instance.txt`
   - Pokud soubor neexistuje → fallback na starý způsob (kompatibilita)
   - Pokud existuje → použije instance-specific cesty

3. **Komunikační cesty:**
   - **Cursor → FA**: `{fsbridgePath}/facmd_{instanceId}.txt`
   - **FA → Cursor**: `{workspace}/.fsbridge/fafield_{instanceId}.txt`
   - **Cursor → FA**: `{workspace}/.fsbridge/fafield_{instanceId}.txt`

### Výhody

- ✅ Jednoduchá implementace
- ✅ Minimální změny v kódu
- ✅ Zpětně kompatibilní (fallback na starý způsob)
- ✅ Automatická detekce instance

### Nevýhody

- ⚠️ Více souborů v `.fsbridge/` složce (ale není to problém)
- ⚠️ Potřeba cleanup starých souborů
- ⚠️ Potřeba detekce živé instance

## Edge Cases

### 1. Cursor zavřený a znovu otevřený z téže instance FA

**Scénář:**
- FA má PID 12345
- Otevře Cursor → zapíše `fa_instance.txt` s PID 12345
- Cursor zavře uživatel křížkem
- Znovu otevře Cursor z téže instance FA → zapíše stejný PID

**Řešení:**
- ✅ Funguje automaticky - FA zapíše stejný PID, Cursor načte stejný PID

### 2. FA spadne, Cursor zůstane otevřený

**Scénář:**
- FA má PID 12345
- Otevře Cursor → zapíše `fa_instance.txt` s PID 12345
- FA spadne (crash)
- Cursor zůstane otevřený a snaží se komunikovat s mrtvou instancí

**Řešení:**
- Při startu Cursoru zkontrolovat, jestli proces s daným PID existuje
- Pokud ne → smazat `fa_instance.txt` a použít fallback (starý způsob)
- Pravidelně kontrolovat při komunikaci (volitelné)

## Implementace

### 1. Nová funkce v `src/utils/fsBridge.ts`

```typescript
/**
 * Načte instance ID z .fsbridge/fa_instance.txt
 * Pokud soubor neexistuje, vrátí null (fallback na starý způsob)
 */
function getFAInstanceId(workspaceRoot: string): string | null {
  const instanceFile = path.join(workspaceRoot, '.fsbridge', 'fa_instance.txt');
  if (fs.existsSync(instanceFile)) {
    const content = fs.readFileSync(instanceFile, 'utf-8').trim();
    return content || null;
  }
  return null;
}

/**
 * Zkontroluje, jestli proces s daným PID existuje (Windows)
 */
function isProcessAlive(pid: number): boolean {
  try {
    const { execSync } = require('child_process');
    const result = execSync(`tasklist /FI "PID eq ${pid}" /NH`, { encoding: 'utf-8' });
    return result.trim().length > 0;
  } catch {
    return false;
  }
}
```

### 2. Úprava `writeFACommand()` v `src/utils/fsBridge.ts`

```typescript
export async function writeFACommand(command: string): Promise<void> {
  // ... existující kód ...
  
  // Zkontroluj, jestli existuje instance ID
  const workspaceRoot = vscode.workspace.workspaceFolders?.[0]?.uri.fsPath;
  let instanceId: string | null = null;
  
  if (workspaceRoot) {
    instanceId = getFAInstanceId(workspaceRoot);
    
    // Pokud instance ID existuje, zkontroluj jestli proces žije
    if (instanceId) {
      const pid = parseInt(instanceId, 10);
      if (!isNaN(pid) && !isProcessAlive(pid)) {
        // Proces je mrtvý - smaž instance soubory a použij fallback
        const instanceFile = path.join(workspaceRoot, '.fsbridge', 'fa_instance.txt');
        if (fs.existsSync(instanceFile)) {
          fs.unlinkSync(instanceFile);
        }
        instanceId = null; // Fallback na starý způsob
      }
    }
  }
  
  // Použij instance-specific cestu nebo fallback
  const facmdFileName = instanceId ? `facmd_${instanceId}.txt` : 'facmd.txt';
  const facmdPath = path.join(fsbridgeDir, facmdFileName);
  
  // ... zbytek kódu ...
}
```

### 3. Úprava všech funkcí čtoucích `fafield.txt` v `src/commands/sendCommand.ts`

Pro každou funkci, která čte `fafield.txt`:
- `vlozitNazevUdaje()`
- `kopirovatNazevUdaje()`
- `hledatPodleAktUdaje()`
- `vlozitUdajSBody()`
- `vlozitUdajSDvojteckami()`

```typescript
// Místo:
const faFieldPath = path.join(workspaceRoot, '.fsbridge', 'fafield.txt');

// Použít:
const instanceId = getFAInstanceId(workspaceRoot);
const faFieldFileName = instanceId ? `fafield_${instanceId}.txt` : 'fafield.txt';
const faFieldPath = path.join(workspaceRoot, '.fsbridge', faFieldFileName);
```

### 4. Úprava `najitUdaj()` v `src/commands/sendCommand.ts`

```typescript
// Při zápisu do fafield.txt použít instance-specific název
const instanceId = getFAInstanceId(workspaceRoot);
const faFieldFileName = instanceId ? `fafield_${instanceId}.txt` : 'fafield.txt';
const faFieldPath = path.join(fsBridgeDir, faFieldFileName);
```

### 5. Úprava `extension.ts` - kontrola při startu

```typescript
// Při aktivaci doplňku zkontrolovat instance ID
const workspaceRoot = vscode.workspace.workspaceFolders?.[0]?.uri.fsPath;
if (workspaceRoot) {
  const instanceId = getFAInstanceId(workspaceRoot);
  if (instanceId) {
    const pid = parseInt(instanceId, 10);
    if (!isNaN(pid) && !isProcessAlive(pid)) {
      // Proces je mrtvý - smaž instance soubory
      const instanceFile = path.join(workspaceRoot, '.fsbridge', 'fa_instance.txt');
      if (fs.existsSync(instanceFile)) {
        fs.unlinkSync(instanceFile);
      }
      // Cleanup instance-specific souborů (volitelné)
      // ...
    }
  }
}
```

## Implementace v FA (Delphi)

FA musí při otevření Cursoru:

1. **Zjistit svůj PID:**
```pascal
function GetFAProcessId: Integer;
begin
  Result := GetCurrentProcessId;
end;
```

2. **Zapsat do `.fsbridge/fa_instance.txt`:**
```pascal
procedure WriteFAInstanceId(const WorkspacePath: string);
var
  InstanceFile: string;
  PID: Integer;
begin
  PID := GetCurrentProcessId;
  InstanceFile := IncludeTrailingPathDelimiter(WorkspacePath) + '.fsbridge\fa_instance.txt';
  // Zapiš PID jako text
  // ...
end;
```

3. **Používat instance-specific cesty:**
```pascal
function GetCommandFilePath: string;
var
  InstanceId: string;
begin
  InstanceId := ReadFAInstanceId; // Načti z fa_instance.txt
  if InstanceId <> '' then
    Result := IncludeTrailingPathDelimiter(EffectiveExportFolder)
            + '.fsbridge' + PathDelim
            + 'facmd_' + InstanceId + '.txt'
  else
    Result := IncludeTrailingPathDelimiter(EffectiveExportFolder)
            + '.fsbridge' + PathDelim
            + 'facmd.txt';
end;
```

## Cleanup starých souborů (volitelné)

Při detekci mrtvé instance můžeme smazat:
- `fa_instance.txt`
- `facmd_{instanceId}.txt`
- `fafield_{instanceId}.txt`
- `famsgstate.json` (pokud existuje v instance-specific složce)

## Testování

1. **Otevři dvě instance FA**
2. **Z každé otevři Cursor**
3. **Zkontroluj, že každá instance má svůj `fa_instance.txt`**
4. **Otestuj komunikaci - měla by být izolovaná**
5. **Zavři jednu instanci FA**
6. **Zkontroluj, že Cursor detekuje mrtvou instanci a použije fallback**

## Poznámky

- Fallback na starý způsob zajišťuje zpětnou kompatibilitu
- Detekce mrtvých procesů je důležitá pro robustnost
- Cleanup starých souborů je volitelný, ale doporučený




