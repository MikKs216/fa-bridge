# FA Bridge Debugger - Trasování komunikace

## Jak funguje celý systém

### 1. Nastavení breakpointu v Cursor (F9)

```
[Uživatel stiskne F9 na řádku 42]
    ↓
Extension: toggleBreakpoint(42)
    ↓
Extension: writeDebugCommand('DEBUG_SET_BREAKPOINT:42')
    ↓
Zápis do: .fsbridge/fadebug.txt
    Obsah: "DEBUG_SET_BREAKPOINT:42" (UTF-8 s BOM)
    ↓
Extension: OKAMŽITĚ aktualizuje lokální stav
    currentState.breakpoints.push(42)
    updateBreakpoints() → zobrazí červenou tečku
```

**Důležité:** Extension zobrazí breakpoint OKAMŽITĚ bez čekání na odpověď z FA.

### 2. FA čte příkaz

```
[KAŽDOU SEKUNDU] TimerPollTimer → FBridge.PollTick
    ↓
PollTick → ProcessDebugFile
    ↓
ProcessDebugFile:
  1. Čte .fsbridge/fadebug.txt
  2. ZMAŽE soubor (před voláním callbacku!)
  3. Volá FOnDebuggerCommand(Command)
    ↓
FOnDebuggerCommand = ProcessDebugCommand (z Main.pas)
    ↓
ProcessDebugCommand:
  1. Kontrola: Pokud je EScriptEditor.IsDebugMode → Exit
  2. Parsuje příkaz: "DEBUG_SET_BREAKPOINT:42"
  3. Zavolá: ScripterT.DebugToggleBreakLine(42)
  4. Zavolá: UpdateDebugState
```

**Důležité:** `ProcessDebugFile` musí být volán pravidelně z `PollTick`!

### 3. FA posílá stav zpět

```
[KAŽDOU SEKUNDU] TimerPollTimer → UpdateDebugState
    ↓
UpdateDebugState:
  1. Kontrola: Pokud je EScriptEditor.IsDebugMode → Exit
  2. Kontrola: Pokud není ScripterT.CurrentScript → Exit (PROBLÉM!)
  3. Zjišťuje stav z ScripterT:
     - status: "running"/"paused"/"stopped"
     - currentLine: DebugExecutionLine
     - breakpoints: CurrentScript.Breaks[i].Line
  4. Vytvoří JSON:
     {
       "status": "stopped",
       "currentLine": 0,
       "breakpoints": [42]
     }
  5. Volá: FBridge.WriteDebugState(StateJson)
    ↓
WriteDebugState:
  1. Zapisuje do: .fsbridge/fadebugstate.json.tmp
  2. Atomicky přejmenuje na fadebugstate.json
```

**PROBLÉM:** Pokud není `ScripterT.CurrentScript` přiřazen, `UpdateDebugState` **neposílá vůbec žádný stav** (`Exit` na řádku 27014).

### 4. Extension čte stav

```
[KAŽDOU SEKUNDU nebo při změně souboru] fs.watch → updateState
    ↓
updateState:
  1. Čte .fsbridge/fadebugstate.json
  2. Pokud soubor neexistuje:
     → clearBreakpoints() → VYMAŽE VŠECHNY BREAKPOINTY!
  3. Pokud soubor je prázdný:
     → clearBreakpoints() → VYMAŽE VŠECHNY BREAKPOINTY!
  4. Parse JSON
  5. Aktualizuje currentState.breakpoints
  6. Volá updateBreakpoints() → zobrazí breakpointy podle stavu z FA
```

**PROBLÉM:** Pokud `fadebugstate.json` neexistuje nebo je prázdný, extension **vymaže všechny breakpointy**!

## Problém: Breakpoint mizí

### Co se děje:

1. Uživatel nastaví breakpoint v Cursor (F9)
   - Extension zobrazí červenou tečku OKAMŽITĚ
   - Extension zapíše příkaz do `fadebug.txt`

2. FA zatím nemá načtený skript (`ScripterT.CurrentScript = nil`)

3. FA volá `UpdateDebugState` každou sekundu
   - Kontrola: `if not Assigned(ScripterT.CurrentScript) then Exit`
   - **Výsledek:** Nezapisuje se žádný stav do `fadebugstate.json`

4. Extension pravidelně čte `fadebugstate.json`
   - Pokud soubor neexistuje nebo je prázdný:
     - `clearBreakpoints()` → **VYMAŽE všechny breakpointy!**

### Řešení

Nastavit breakpoint v FA můžeš pouze pokud je skript načten. Ale extension musí mít breakpointy uložené i když skript není načten.

**Možnost 1:** Posílat stav i když není skript načten (s prázdným seznamem breakpointů z FA, ale zachovat lokální breakpointy v extension)

**Možnost 2:** Nedovolit extension vymazat breakpointy pokud soubor neexistuje nebo je prázdný - pouze pokud je explicitně poslán prázdný seznam.

**Možnost 3:** FA by měla posílat stav i když není skript načten, ale s prázdným seznamem breakpointů. Extension pak ponechá lokální breakpointy.

## Jak trasovat komunikaci

### 1. Logování v FA (Delphi)

Přidej do `Main.pas`:

```pascal
procedure TfaMain.ProcessDebugCommand(const Command: string);
var
  Line: Integer;
  CommandName: string;
  ColonPos: Integer;
begin
  // TRASOVÁNÍ: Zapiš do logu
  OutputDebugString(PChar('[FA Debugger] Received command: ' + Command));
  
  // Kontrola: pokud je původní debugger aktivní, ignoruj příkaz
  if (fmScriptEditor <> nil) and fmScriptEditor.IsDebugMode then
  begin
    OutputDebugString(PChar('[FA Debugger] Original debugger active, ignoring'));
    Exit;
  end;
  
  // ... zbytek kódu ...
end;

procedure TfaMain.UpdateDebugState;
var
  // ... proměnné ...
begin
  // TRASOVÁNÍ: Zapiš do logu
  OutputDebugString(PChar('[FA Debugger] UpdateDebugState called'));
  
  // Kontrola dostupnosti FBridge a ScripterT
  if not Assigned(FBridge) or not Assigned(ScripterT) then
  begin
    OutputDebugString(PChar('[FA Debugger] FBridge or ScripterT not assigned'));
    Exit;
  end;
  
  // Kontrola: pokud je původní debugger aktivní
  if (fmScriptEditor <> nil) and fmScriptEditor.IsDebugMode then
  begin
    OutputDebugString(PChar('[FA Debugger] Original debugger active, skipping'));
    Exit;
  end;
  
  // Kontrola CurrentScript
  if not Assigned(ScripterT.CurrentScript) then
  begin
    OutputDebugString(PChar('[FA Debugger] CurrentScript not assigned, skipping state update'));
    Exit; // ← TOTO JE PROBLÉM!
  end;
  
  // ... zbytek kódu ...
  
  // TRASOVÁNÍ: Zapiš co se posílá
  OutputDebugString(PChar('[FA Debugger] Sending state: ' + StateJson));
end;
```

**Sledování:** Použij `DebugView` nebo `OutputDebugString` viewer v Delphi.

### 2. Kontrola souborů

**Soubory ke sledování:**

1. `.fsbridge/fadebug.txt` - Příkazy z Cursor do FA
   - **Jak sledovat:** Zkontroluj jestli se vytváří když stiskneš F9
   - **Co očekávat:** `DEBUG_SET_BREAKPOINT:42` (UTF-8 s BOM)
   - **Kdy zmizí:** Okamžitě po přečtení v `ProcessDebugFile`

2. `.fsbridge/fadebugstate.json` - Stav debuggeru z FA do Cursor
   - **Jak sledovat:** Zkontroluj jestli se vytváří a aktualizuje každou sekundu
   - **Co očekávat:** 
     ```json
     {
       "status": "stopped",
       "currentLine": 0,
       "breakpoints": [42]
     }
     ```
   - **Kdy se aktualizuje:** Každou sekundu z `UpdateDebugState`

### 3. Kontrola v Cursor/VS Code

**Developer Console:**
- Otevři: `Help` → `Toggle Developer Tools`
- Console tab → hledej zprávy začínající `[FA Debugger]`

**Co sledovat:**
- `[FA Debugger] Received command: DEBUG_SET_BREAKPOINT:42`
- `[FA Debugger] Chyba při čtení stavu`
- `[FA Debugger] updateState called`

### 4. Checklist trasování

**Krok 1: Nastavení breakpointu**
- [ ] Stiskni F9 v Cursor
- [ ] Zobrazí se červená tečka?
- [ ] Vytvoří se `.fsbridge/fadebug.txt`?
- [ ] Obsahuje `DEBUG_SET_BREAKPOINT:42`?

**Krok 2: FA čte příkaz**
- [ ] Je `ProcessDebugFile` volán z `PollTick`?
- [ ] Je `FOnDebuggerCommand` nastaven na `ProcessDebugCommand`?
- [ ] Je `ProcessDebugCommand` volán?
- [ ] Je `ScripterT.CurrentScript` přiřazen?
- [ ] Je `ScripterT.DebugToggleBreakLine(42)` volán?

**Krok 3: FA posílá stav**
- [ ] Je `UpdateDebugState` volán každou sekundu?
- [ ] Je `ScripterT.CurrentScript` přiřazen?
- [ ] Vytvoří se `.fsbridge/fadebugstate.json`?
- [ ] Obsahuje JSON s breakpointy?

**Krok 4: Extension čte stav**
- [ ] Je `updateState()` volán?
- [ ] Je soubor `.fsbridge/fadebugstate.json` přečten?
- [ ] Je JSON parsován správně?
- [ ] Jsou breakpointy aktualizovány?

## Nejčastější problémy

### Problém 1: Breakpoint mizí ihned

**Příčina:** `fadebugstate.json` neexistuje nebo je prázdný, extension volá `clearBreakpoints()`.

**Kontrola:**
- Existuje `.fsbridge/fadebugstate.json`?
- Obsahuje nějaký obsah?
- Je JSON validní?

**Řešení:** Upravit `UpdateDebugState` aby posílal stav i když není skript načten.

### Problém 2: Breakpoint se nenastaví v FA

**Příčina:** `ProcessDebugCommand` není volán nebo `ScripterT.CurrentScript` není přiřazen.

**Kontrola:**
- Je `ProcessDebugFile` volán z `PollTick`?
- Je `FOnDebuggerCommand` nastaven?
- Je `ScripterT.CurrentScript` přiřazen?

**Řešení:** Zajistit že `ProcessDebugFile` je volán pravidelně a že skript je načten.

### Problém 3: Stav se neaktualizuje

**Příčina:** `UpdateDebugState` předčasně končí (`Exit`).

**Kontrola:**
- Je `fmScriptEditor.IsDebugMode` True? (původní debugger aktivní)
- Je `ScripterT.CurrentScript` přiřazen?
- Je `FBridge` nebo `ScripterT` nil?

**Řešení:** Přidat logování do `UpdateDebugState` aby bylo vidět proč končí.

## Diagnostické nástroje

### 1. OutputDebugString v Delphi

```pascal
procedure TfaMain.ProcessDebugCommand(const Command: string);
begin
  OutputDebugString(PChar('[DEBUG] Command: ' + Command));
  // ... zbytek kódu ...
end;
```

Sleduj pomocí `DebugView` (freeware nástroj od Microsoft).

### 2. Console.log v extension

```typescript
private updateState(): void {
  console.log('[FA Debugger] Reading state from:', statePath);
  // ... zbytek kódu ...
}
```

Sleduj v Developer Tools → Console.

### 3. Manuální kontrola souborů

- Otevři `.fsbridge/` složku
- Sleduj změny v `fadebug.txt` a `fadebugstate.json`
- Ověř obsah a formát

### 4. Breakpointy v kódu

Nastav breakpointy v kritických místech:
- `ProcessDebugFile` - začátek metody
- `ProcessDebugCommand` - začátek metody
- `UpdateDebugState` - před každým `Exit`
- `updateState()` v extension - začátek metody

## Doporučené úpravy pro řešení problému

### Úprava 1: UpdateDebugState - posílat stav i když není skript načten

```pascal
procedure TfaMain.UpdateDebugState;
begin
  // ... kontroly ...
  
  // Pokud není skript načten, pošli prázdný stav (ale NEPOSÍLEJ prázdný seznam breakpointů)
  if not Assigned(ScripterT.CurrentScript) then
  begin
    // Pošli minimální stav aby extension nevolal clearBreakpoints()
    StateJson := '{"status":"stopped","currentLine":0,"breakpoints":[]}';
    FBridge.WriteDebugState(StateJson);
    Exit;
  end;
  
  // ... zbytek kódu ...
end;
```

### Úprava 2: updateState - nevolat clearBreakpoints pokud soubor neexistuje poprvé

```typescript
private updateState(): void {
  const statePath = path.join(this.workspaceRoot, '.fsbridge', 'fadebugstate.json');
  
  if (!fs.existsSync(statePath)) {
    // Pokud soubor neexistuje, ale máme lokální breakpointy, NEVYMAZUJ je
    if (this.currentState?.breakpoints?.length > 0) {
      // Pouze aktualizuj status, ale zachovej breakpointy
      this.currentState.status = 'stopped';
      this.updateStatusBar();
      return;
    }
    
    // Jinak resetuj stav
    this.currentState = { status: 'stopped' };
    this.updateStatusBar();
    this.clearCurrentLineDecoration();
    this.clearBreakpoints();
    return;
  }
  
  // ... zbytek kódu ...
}
```



























