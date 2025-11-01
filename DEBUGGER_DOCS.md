# FA Bridge Debugger - Dokumentace

## Přehled

FA Bridge Debugger umožňuje ladit Pascal skripty v TMS Scripter přímo z Cursor/VS Code pomocí jednoduchého file-based protokolu.

## Architektura

Komunikace probíhá přes soubory v .fsbridge/ složce:

- fadebug.txt - Příkazy z Cursor do FA (UTF-8 s BOM)
- fadebugstate.json - Stav debuggeru z FA do Cursor (JSON)

## Funkce

### Základní ovládání

- F5 - Pokračovat v běhu (Continue)
- F10 - Krok přes (Step Over)
- Shift+F5 - Pozastavit (Pause)
- F9 - Přepnout breakpoint na aktuálním řádku

### Status bar

V levém dolním rohu Cursor/VS Code se zobrazuje status debuggeru.

### Debug Proměnné panel

V sidebaru FA Bridge je nový panel "Debug Proměnné", který zobrazuje aktuální proměnné při zastavení na breakpointu.

## Implementace v FA (Delphi)

### Příklad integrace

Nastav callback pro debugger příkazy:

```pascal
Bridge.OnDebuggerCommand := ProcessDebugCommand;
```

Zpracování příkazů:

```pascal
procedure TMyForm.ProcessDebugCommand(const Command: string);
var
  Parts: TStringList;
  Line: Integer;
begin
  Parts := TStringList.Create;
  try
    ExtractStrings([':'], [], PChar(Command), Parts);
    
    if Parts.Count = 0 then Exit;
    
    if Parts[0] = 'DEBUG_CONTINUE' then
      atPascalScripter.Resume
    else if Parts[0] = 'DEBUG_PAUSE' then
      atPascalScripter.Pause
    else if Parts[0] = 'DEBUG_STEP_OVER' then
      atPascalScripter.DebugStepOverLine
    else if Parts[0] = 'DEBUG_STOP' then
    begin
      atPascalScripter.Stop;
      atPascalScripter.Running := False;
    end
    else if Parts[0] = 'DEBUG_SET_BREAKPOINT' then
    begin
      if Parts.Count > 1 then
      begin
        Line := StrToIntDef(Parts[1], 0);
        if Line > 0 then
          atPascalScripter.DebugToggleBreakLine(Line);
      end;
    end;
    
    UpdateDebugState;
  finally
    Parts.Free;
  end;
end;
```

Aktualizace stavu:

```pascal
procedure TMyForm.UpdateDebugState;
var
  State: TStringList;
  i: Integer;
  StateJson: string;
begin
  State := TStringList.Create;
  try
    State.Add('{');
    
    if atPascalScripter.Running then
      State.Add('  "status": "running",')
    else if atPascalScripter.Paused then
      State.Add('  "status": "paused",')
    else
      State.Add('  "status": "stopped",');
    
    State.Add(Format('  "currentLine": %d,', [atPascalScripter.DebugExecutionLine]));
    
    State.Add('  "breakpoints": [');
    for i := 0 to atPascalScripter.BreakPoints.Count - 1 do
    begin
      State.Add(Format('    %d%s', [
        atPascalScripter.BreakPoints[i].LineNumber,
        IfThen(i < atPascalScripter.BreakPoints.Count - 1, ',', '')
      ]));
    end;
    State.Add('  ],');
    State.Add('  "variables": {}');
    State.Add('}');
    
    Bridge.WriteDebugState(State.Text);
  finally
    State.Free;
  end;
end;
```

## Formát příkazů

### Příkazy z Cursor do FA (fadebug.txt)

- DEBUG_CONTINUE - Pokračovat v běhu
- DEBUG_PAUSE - Pozastavit běh
- DEBUG_STEP_OVER - Krok přes
- DEBUG_STOP - Zastavit debugování
- DEBUG_SET_BREAKPOINT:42 - Nastavit breakpoint na řádku 42
- DEBUG_CLEAR_BREAKPOINT:42 - Zrušit breakpoint na řádku 42
- DEBUG_GET_VARIABLES - Získat seznam proměnných

### Stav z FA do Cursor (fadebugstate.json)

```json
{
  "status": "paused",
  "currentLine": 42,
  "breakpoints": [12, 25, 38],
  "variables": {}
}
```

## TMS Scripter API

- atPascalScripter.Running - Indikuje, zda je skript spuštěn
- atPascalScripter.Paused - Určuje, zda je skript pozastaven
- atPascalScripter.DebugExecutionLine - Aktuální řádek při debugování
- atPascalScripter.DebugStepOverLine - Provede aktuální řádek
- atPascalScripter.DebugToggleBreakLine(Line) - Přepne breakpoint
- atPascalScripter.Resume - Pokračovat v běhu
- atPascalScripter.Pause - Pozastavit
- atPascalScripter.Stop - Zastavit debugování
- atPascalScripter.OnDebugHook - Událost při každém kroku

## Poznámky

- Všechny soubory v .fsbridge/ používají UTF-8 kódování s BOM
- Soubor fadebug.txt se maže ihned po přečtení
- Metoda PollTick by měla být volána pravidelně z Timeru
