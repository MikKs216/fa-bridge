# Řešení pro více instancí FA

## Problém

Když jsou otevřené více oken (instancí) FA, každá potřebuje komunikovat se "svou" instancí Cursoru:
- Alt+Q z FA musí aktivovat konkrétní okno Cursoru, které tato instance otevřela
- Alt+Q z Cursoru musí aktivovat konkrétní okno FA, ze kterého byl cursor otevřen
- Komunikační soubory musí být oddělené pro každou dvojici FA-Cursor

## Implementované řešení

### Koncept - složky podle FA PID

Každá instance FA má svou vlastní složku pojmenovanou podle svého PID.
Všechny komunikační soubory jsou uvnitř této složky.

**Důležité:** `process.pid` v Node.js (Cursor extension) ≠ PID Cursor aplikace z `CreateProcess`!
Proto používáme FA PID (který je konzistentní) místo nespolehlivého Cursor PID.

### Soubory v `.fsbridge/`

```
.fsbridge/
  workspace_{FormId}_FA_{PID}.code-workspace  # Multi-root workspace pro každou FA instanci
  {FA_PID}/                        # Složka pro každou instanci FA
    fa_instance.txt                # PID instance FA (pro Cursor - Alt+Q)
    cursor_instance.txt            # PID instance Cursoru (pro FA - Alt+Q)
    facmd.txt                      # Příkazy z Cursoru pro FA
    fafield.txt                    # Data pole
    fadebug.txt                    # Debugger příkazy
```

**Jak Cursor najde správnou složku:**
1. Extrahuje FA PID z názvu workspace souboru: `workspace_xxx_FA_12345.code-workspace` → `12345`
2. Nebo prohledá všechny číselné složky a najde tu s běžícím FA procesem

### Chování při spouštění Cursoru z FA

```pascal
function TCursorBridge.RunCursorReuse(...): Boolean;
begin
  // 1. Zkontroluj, jestli MÁ TATO INSTANCE FA běžící cursor
  if IsCursorProcessAlive then
  begin
    // Cursor této instance běží - AKTIVUJ okno a použij -r
    H := FindWindowByPID(FCursorPID);
    if H <> 0 then
    begin
      SetForegroundWindow(H);  // Aktivuj okno
      ShowWindow(H, SW_RESTORE); // Obnov pokud minimalizované
      Sleep(100); // Zpoždění pro aktivaci
    end;
    Params := '-r ' + FolderArg + FileArg; // -r použije AKTIVNÍ okno
  end
  else
  begin
    // Cursor neběží - spustit NOVÝ cursor s -n (new-window)
    // -n zajistí NOVÉ okno i když běží jiné instance Cursoru
    Params := '-n ' + FolderArg + FileArg;
    FCursorPID := 0; // Vynuluj starý PID
  end;
  
  // 2. Spusť cursor pomocí CreateProcess (abychom získali PID)
  Result := CreateProcess(..., PI);
  
  // 3. Pokud jsme spustili nový cursor, ulož jeho PID
  if Result and (not UseReuse) then
  begin
    FCursorPID := PI.dwProcessId;
    WriteCursorInstanceId;  // Uloží cursor PID
    WriteInstanceId;        // Uloží FA PID
  end;
end;
```

### Chování Alt+Q z FA

```pascal
procedure TCursorBridge.ActivateCursorWindow;
begin
  // 1. Najdi okno podle uloženého PID cursoru
  PID := ReadCursorInstanceId;
  if PID <> 0 then
  begin
    H := FindWindowByPID(PID);
    if H <> 0 then
    begin
      SetForegroundWindow(H);
      Exit;
    end;
  end;
  
  // 2. Fallback: hledej podle názvu procesu (starý způsob)
  H := FindMainWindowOfProcess('Cursor.exe');
  ...
end;
```

### Funkce FindWindowByPID

```pascal
function TCursorBridge.FindWindowByPID(PID: DWORD): HWND;
begin
  // Enumeruje všechna okna a najde hlavní okno procesu s daným PID
  EnumWindows(@EnumCallback, ...);
end;
```

### Funkce IsCursorProcessAlive

```pascal
function TCursorBridge.IsCursorProcessAlive: Boolean;
begin
  PID := ReadCursorInstanceId;
  if PID = 0 then Exit(False);
  
  H := OpenProcess(PROCESS_QUERY_INFORMATION, False, PID);
  if H <> 0 then
  begin
    GetExitCodeProcess(H, ExitCode);
    Result := (ExitCode = STILL_ACTIVE);
    CloseHandle(H);
  end;
end;
```

## Scénáře

### 1. Cursor není spuštěný

- FA spustí nový Cursor **s `-n` (new-window)**
- Uloží PID Cursoru do `cursor_instance.txt`
- Alt+Q přepíná mezi FA a tímto Cursorem
- Další otevření ze stejné FA použije `-r` (reuse tohoto okna)

### 2. Cursor běží s jiným projektem (mimo FA)

- FA spustí **nový** Cursor **s `-n`** (protože `cursor_instance.txt` neexistuje nebo PID neodpovídá)
- `-n` zajistí nové okno i když jiný Cursor běží
- Uloží PID nového Cursoru
- Alt+Q přepíná mezi FA a novým Cursorem

### 3. Více instancí FA, každá se svým Cursorem

- Každá FA instance má svůj `cursor_instance.txt` ve svém workspace
- Každá FA instance spustí vlastní Cursor **s `-n`** → nové okno
- Alt+Q z každé FA aktivuje její konkrétní Cursor
- Každá FA instance používá `-r` pro další otevření v jejím okně

### 4. Cursor zavřený a znovu otevřený z téže FA

- FA kontroluje `IsCursorProcessAlive`
- Pokud PID neodpovídá běžícímu procesu → spustí nový Cursor s `-n`
- Uloží nový PID

### 5. FA spadne, Cursor zůstane otevřený

- Cursor čte `fa_instance.txt` pro Alt+Q
- Při aktivaci Cursoru zkontroluje, jestli FA s uloženým PID běží
- Pokud ne → fallback (možná warning nebo automatické zavření)

### 6. Opakované otevření ze stejné FA instance

- FA zkontroluje `IsCursorProcessAlive` → TRUE
- Aktivuje existující okno (`SetForegroundWindow`)
- Spustí Cursor s `-r` → otevře soubor v aktivním okně (záložka)
- **Neotevírá** nové okno

## Implementační detaily

### Nové private fieldy v TCursorBridge

```pascal
FCursorPID: DWORD;  // PID spuštěného cursoru pro tuto instanci FA
```

### Nové metody

```pascal
function GetCursorInstanceFilePath: string;
procedure WriteCursorInstanceId;
function ReadCursorInstanceId: DWORD;
function IsCursorProcessAlive: Boolean;
function FindWindowByPID(PID: DWORD): HWND;
```

### Změněné metody

- `RunCursorReuse` - používá CreateProcess místo ShellExecute pro získání PID
- `ActivateCursorWindow` - používá FindWindowByPID místo FindMainWindowOfProcess
- `StartEditing` - načítá uložený cursor PID před spuštěním

## Výhody tohoto řešení

- ✅ Každá FA instance má svůj vlastní Cursor
- ✅ Alt+Q vždy aktivuje správné okno
- ✅ Nový Cursor se otevře jen když je potřeba
- ✅ Zpětně kompatibilní (fallback na starý způsob)
- ✅ Automatická detekce mrtvých procesů

## Testování

1. **Otevři FA, spusť Cursor** → zkontroluj `cursor_instance.txt`
2. **Alt+Q z FA** → aktivuje se konkrétní Cursor
3. **Otevři druhou instanci FA, spusť Cursor** → nové okno Cursoru
4. **Alt+Q z druhé FA** → aktivuje se její Cursor
5. **Zavři Cursor, znovu otevři z FA** → nové okno, nový PID
