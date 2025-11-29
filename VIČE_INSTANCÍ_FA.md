# Řešení pro více instancí FA - NOVÝ KONCEPT

## Koncept: Jeden společný workspace, záložky

Všechny FA instance sdílejí **jeden společný workspace** `fa_scripts.code-workspace`.
Scripty se otevírají jako **záložky** v jednom okně Cursoru.

### Výhody:
- ✅ **Trvalá historie AI chatu** (jeden workspace = jedna historie)
- ✅ **Žádné problémy s "ukradnutím" okna**
- ✅ **Jednodušší logika**
- ✅ **Všechny scripty viditelné** v jednom Cursoru

## Struktura souborů

```
.fsbridge/
  fa_scripts.code-workspace        # JEDEN společný workspace pro všechny FA
  {FA_PID}/                         # Složka pro každou FA instanci
    fa_instance.txt                 # PID FA
    current_form.txt                # NOVÉ: Aktuální FormId této FA instance
    cursor_instance.txt             # PID Cursor procesu
    facmd.txt                       # Příkazy z Cursoru pro FA
    fafield.txt                     # Data pole
    fadebug.txt                     # Debugger příkazy
```

## Logika Alt+Q z FA → Cursor

1. FA ví, který FormId edituje
2. Zapíše FormId do `current_form.txt` (v `.fsbridge/{FA_PID}/`)
3. Hledá okno Cursoru s `fa_scripts` v titulku
4. **Pokud existuje:** `cursor -r -g "script_FormId.pas:line"` → aktivuje záložku
5. **Pokud neexistuje:** `cursor --new-window "fa_scripts.code-workspace" "script_FormId.pas"` → nové okno

```pascal
if IsCursorProcessAlive then
begin
  // Okno Cursoru existuje - otevři script jako záložku
  Params := '-r ' + FolderArg + FileArg;
end
else
begin
  // Žádné okno - otevři nové
  Params := '--new-window ' + FolderArg + FileArg;
end;
```

## Logika Alt+Q z Cursoru → FA

1. Cursor extension zjistí aktivní soubor (`script_dz_15DPFO5252_2.pas`)
2. Extrahuje FormId: `dz_15DPFO5252_2`
3. Projde všechny `.fsbridge/{PID}/current_form.txt`
4. Najde tu, kde `current_form.txt == FormId`
5. Aktivuje odpovídající FA instanci (PID z názvu složky)

```typescript
// Extrahuj FormId z názvu souboru
const formId = extractFormIdFromFileName(activeFileName);

// Najdi FA instanci, která edituje tento FormId
for (const dir of instanceDirs) {
  const currentFormFile = path.join(dir, 'current_form.txt');
  const instanceFormId = fs.readFileSync(currentFormFile, 'utf-8').trim();
  
  if (instanceFormId === formId) {
    // Našli jsme správnou FA instanci
    return dir;
  }
}
```

## Scénáře

### 1. První FA otevře script
- FA vytvoří workspace soubor `fa_scripts.code-workspace` (pokud neexistuje)
- FA zapíše FormId do `current_form.txt`
- Cursor otevře nové okno s workspace souborem

### 2. Druhá FA otevře jiný script
- FA zapíše svůj FormId do své složky `current_form.txt`
- Cursor otevře script jako záložku v existujícím okně (`-r`)

### 3. Alt+Q z FA aktivuje záložku
- FA aktivuje okno Cursoru
- Cursor otevře odpovídající záložku

### 4. Alt+Q z Cursoru aktivuje správné FA
- Cursor extension zjistí FormId z aktivní záložky
- Najde FA instanci s odpovídajícím `current_form.txt`
- Aktivuje správné okno FA

### 5. Zavření a znovuotevření FA
- Script se otevře v existujícím okně jako záložka
- Historie AI chatu se zachová (stejný workspace)

## Nové metody v uCursorBridge.pas

```pascal
// Cesta k current_form.txt
function GetCurrentFormFilePath: string;
begin
  Result := GetInstanceDir + 'current_form.txt';
end;

// Zápis aktuálního FormId
procedure WriteCurrentForm(const FormId: string);

// IsCursorProcessAlive hledá okno podle "fa_scripts" v titulku
function IsCursorProcessAlive: Boolean;
begin
  H := FindWindowByWorkspaceFile('fa_scripts');
  Result := (H <> 0);
end;
```

## Nové funkce v fsBridge.ts

```typescript
// Extrahuje FormId z názvu souboru
function extractFormIdFromFileName(fileName: string): string | null;

// Najde FA instanci podle current_form.txt
function getFAInstanceDir(workspaceRoot: string): string | null;
```

## Testování

1. **Otevři FA1, spusť script** → nové okno Cursoru
2. **Otevři FA2, spusť jiný script** → záložka ve stejném okně
3. **Alt+Q z FA1** → aktivuje záložku FA1
4. **Alt+Q z Cursoru (záložka FA1)** → aktivuje FA1
5. **Alt+Q z Cursoru (záložka FA2)** → aktivuje FA2
6. **Zavři FA1, otevři znovu** → script se otevře jako záložka (historie zachována)
