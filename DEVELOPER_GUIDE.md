# FA Bridge Extension - Technická dokumentace

Technická dokumentace pro vývojáře a AI asistenty.

## Obsah

1. [Přehled projektu](#přehled-projektu)
2. [Architektura a komunikace](#architektura-a-komunikace)
3. [Implementace](#implementace)
4. [Debugger](#debugger)
5. [Vývoj a testování](#vývoj-a-testování)
6. [Reference](#reference)

---

## Přehled projektu

### Základní informace

- **Jméno:** fa-bridge (Cursor Extension)
- **Účel:** Propojení Cursor/VS Code s editorem FormStudio (FA)
- **Technologie:** TypeScript, VS Code Extension API
- **Aktuální verze:** 0.5.93

### Funkčnost

FA Bridge komunikuje s FormStudio přes soubor `.fsbridge/facmd.txt`:
1. Cursor zapíše příkaz do `.fsbridge/facmd.txt`
2. FA sleduje změny tohoto souboru
3. FA přečte příkaz a provede akci

### Příkazy

- `Aktivovat_formular` - Aktivuje formulář po uložení souboru
- `Vlozit_nazev_udaje` - Vloží název aktuálních údajů (Alt+X, Ctrl+Shift+V)
- `Najit_udaj` - Najde údaj ve formuláři (Shift+Alt+L)
- **Sidebar Panel:** Ikona v levém panelu s tlačítky pro všechny příkazy (Shift+Alt+F)
- **Panel obsahuje 4 sekce:** Příkazy, Msg Watch, HISTORIE, NÁPOVĚDA

---

## Architektura a komunikace

### Struktura projektu

```
fa-bridge/
├── src/
│ ├── extension.ts              # Hlavní soubor (aktivace, registrace příkazů)
│ ├── commands/
│ │   └── sendCommand.ts        # Implementace všech příkazů
│ ├── utils/
│ │   ├── fsBridge.ts           # Komunikace s FA (zápis do .fsbridge/facmd.txt)
│ │   ├── fileHistory.ts        # Historie souborů a porovnání verzí
│ │   └── commandWatcher.ts     # Sledování příkazů z FA
│ ├── views/
│ │   ├── FABridgePanel.ts      # Sidebar TreeView panel (Příkazy)
│ │   └── HelpPanel.ts          # Help panel (NÁPOVĚDA)
│ ├── providers/
│ │   ├── PascalIntelliSenseProvider.ts  # IntelliSense (Completion + Hover)
│ │   ├── SnippetProvider.ts             # Pascal snippety
│ │   └── BeginEndMatcher.ts             # Zvýrazňování begin/end bloků
│ └── debugger/
│     └── msgWatch.ts           # Msg Watch panel
├── snippets/
│   └── pascal-snippets.json    # Pascal code snippety
├── syntaxes/
│   └── pascal.tmLanguage       # Pascal grammar (TextMate)
├── themes/
│   ├── fa-pascal-light.json   # Světlý color theme
│   └── fa-pascal-dark.json    # Tmavý color theme
├── language-configuration.json # Pascal language config
├── package.json
├── tsconfig.json
└── .vscodeignore
```

### Formát komunikace

- **Soubor:** `.fsbridge/facmd.txt` (relativně k workspace root)
- **Kódování:** UTF-8 s BOM
- **Formát:** Bez trailing newline
- **Proces:** Atomický (tmp → rename)

### Podpora více instancí FA

#### Koncept: Jeden společný workspace, záložky

Všechny FA instance sdílejí **jeden společný workspace** `fa_scripts.code-workspace`.
Scripty se otevírají jako **záložky** v jednom okně Cursoru.

**Výhody:**
- ✅ **Trvalá historie AI chatu** (jeden workspace = jedna historie)
- ✅ **Žádné problémy s "ukradnutím" okna**
- ✅ **Jednodušší logika**
- ✅ **Všechny scripty viditelné** v jednom Cursoru

#### Struktura souborů

```
.fsbridge/
  fa_scripts.code-workspace        # JEDEN společný workspace pro všechny FA
  {FA_PID}/                         # Složka pro každou FA instanci
    fa_instance.txt                 # PID FA
    current_form.txt                # Aktuální FormId této FA instance
    cursor_instance.txt             # PID Cursor procesu
    facmd.txt                       # Příkazy z Cursoru pro FA
    fafield.txt                     # Data pole
    fadebug.txt                     # Debugger příkazy
```

#### Logika Alt+Q z FA → Cursor

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

#### Logika Alt+Q z Cursoru → FA

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

#### Scénáře

1. **První FA otevře script**
   - FA vytvoří workspace soubor `fa_scripts.code-workspace` (pokud neexistuje)
   - FA zapíše FormId do `current_form.txt`
   - Cursor otevře nové okno s workspace souborem

2. **Druhá FA otevře jiný script**
   - FA zapíše svůj FormId do své složky `current_form.txt`
   - Cursor otevře script jako záložku v existujícím okně (`-r`)

3. **Alt+Q z FA aktivuje záložku**
   - FA aktivuje okno Cursoru
   - Cursor otevře odpovídající záložku

4. **Alt+Q z Cursoru aktivuje správné FA**
   - Cursor extension zjistí FormId z aktivní záložky
   - Najde FA instanci s odpovídajícím `current_form.txt`
   - Aktivuje správné okno FA

5. **Zavření a znovuotevření FA**
   - Script se otevře v existujícím okně jako záložka
   - Historie AI chatu se zachová (stejný workspace)

---

## Implementace

### extension.ts

- Export `activate()` a `deactivate()`
- Kontrola existence `.fsbridge` složky v workspace (extension se aktivuje pouze pokud existuje)
- Registrace všech příkazů z `sendCommand.ts`
- Registrace sidebar panelu z `FABridgePanel.ts`
- Registrace Help panelu z `HelpPanel.ts`
- Registrace IntelliSense provideru
- Registrace Begin/End matcheru
- Registrace Command Watcheru pro zpracování příkazů z FA
- Registrace Msg Watch panelu
- Automatické otevírání panelu při startu (pokud je povoleno v nastavení)
- Automatické mazání `famsgstate.json` při startu a při uložení souboru

### sendCommand.ts

- 10+ příkazů pro komunikaci s FA
- `ulozitSoubor()` - Save file, save history, activate FA
- `vlozitNazevUdaje()` - Read fafield.txt and insert/replace at cursor
- `kopirovatNazevUdaje()` - Read fafield.txt and copy to clipboard
- `najitUdaj()` - Write word under cursor to fafield.txt and send command
- `hledatPodleAktUdaje()` - Open Find dialog with current field name
- `hledatOdZacatku()` - Open Find dialog, move to start, reopen Find
- `toggleMsgv()` - Insert/delete msgv('') debug statement
- `toggleField()` - Toggle field format: 'slovo' → [:slovo:] → [.slovo.] → 'slovo'
- `vlozitUdajSBody()` - Insert field in format [.udaj.]
- `vlozitUdajSDvojteckami()` - Insert field in format [:udaj:]
- Volání `writeFACommand(commandString)` pro komunikaci s FA
- Podpora více instancí FA (používá instance-specific cesty)
- Info message po úspěšném odeslání

### FABridgePanel.ts

- TreeView provider pro sidebar panel (sekce "Příkazy")
- Zobrazení příkazů s ikonami a klávesovými zkratkami
- Kliknutelné položky volají příslušné příkazy
- Podpora FA kompatibilních hotkeys (dynamické zobrazení zkratek podle nastavení)

### HelpPanel.ts

- TreeView provider pro Help panel (sekce "NÁPOVĚDA")
- Načítá obsah z `_source/fa-bridge-help.txt` ve workspace
- Zobrazuje obsah jako seznam řádků v TreeView
- Automatické načítání při změně workspace

### fileHistory.ts

- `saveFileHistory()` - Ukládá kopii souboru do `.history` složky při uložení
- `getFileHistoryVersions()` - Vrací seznam verzí souboru v historii
- `compareWithPreviousVersion()` - Porovná aktuální soubor s předchozí verzí
- `showHistoryVersions()` - Zobrazí seznam verzí a umožní výběr k porovnání
- Podporuje pouze FA script soubory (`script_*.pas` a `u_*.pas`)
- Formát názvu: `script_test-20250115-143022.pas` (název-timestamp.pas)

### historyProvider.ts

- `HistoryProvider` - TreeDataProvider pro panel HISTORIE v sidebaru
- `getCommitsForCurrentFile()` - Získá seznam verzí pro aktuálně otevřený soubor
- `getHistoryVersions()` - Načte všechny verze souboru ze složky `.history`
- Automaticky aktualizuje panel při změně aktivního editoru
- Zobrazuje verze seřazené od nejnovější po nejstarší

### historyPanel.ts

- `HistoryPanel.showDiffStatic()` - Otevře VS Code diff editor pro porovnání historické verze s aktuálním souborem
- `HistoryPanel.restoreFileStatic()` - Vrátí soubor do stavu vybrané historické verze (s automatickou zálohou)
- `HistoryPanel.compareWithPreviousStatic()` - Porovná dvě historické verze mezi sebou
- Používá vestavěný VS Code diff editor s synchronizovaným scrollováním
- **Navigace v diff editoru:** F7 (další rozdíl), Shift+F7 (předchozí rozdíl)
- **Tip:** Klávesa F7 také přepíná mezi zobrazením všech řádků a pouze rozdílů

### fsBridge.ts

- `writeFACommand(command: string)` - Hlavní funkce pro komunikaci s FA
  - Vytvořit `.fsbridge` složku (pokud neexistuje)
  - Atomický zápis do `.fsbridge/facmd.txt` (podporuje více instancí FA)
  - Použít UTF-8 s BOM
  - Bez trailing newline
- `getFsBridgeWorkspaceRoot()` - Najde workspace obsahující `.fsbridge` složku
- `getValidInstanceId()` - Získá validní instance ID pro více-instanční podporu
- `getFafieldPath()` - Vrací cestu k `fafield.txt` pro aktuální instanci FA
- Podpora více instancí FA pomocí instance-specific složek (`.fsbridge/{instanceId}/`)

### Pascal Podpora

#### Syntax Highlighting

- **Soubor:** `syntaxes/pascal.tmLanguage` (TextMate Grammar)
- **Původ:** Převzato z `alefragnani.pascal-9.9.0` extension
- **Vlastní úpravy:**
  - FA Form Field References: `[.field.]` a `[:field:]`
  - 408 FA vlastních funkcí (CheckRodneCislo, NactiAdresuZARES, ini, chk, lst, atd.)

#### Language Configuration

- **Soubor:** `language-configuration.json`
- **Funkce:** Auto-closing závorek, komentářů, region folding
- **Podporované soubory:** .pas, .dpr, .dfm, .fmx, .lfm, .lpr

#### Color Themes

- **FA Pascal Light:** Světlý theme podle FA editoru
  - Klíčová slova: #000080 (tmavě modrá)
  - FA funkce: #C000C0 (červenofialová)
  - Fieldy: #008000 (zelená)
  - Řetězce: #0000FF (modrá)
- **FA Pascal Dark:** Tmavý theme pro pohodlí
  - Klíčová slova: #5C9EFF (světle modrá)
  - FA funkce: #D896FF (tmavší fialová)
  - Fieldy: #00C000 (zelená)
  - Řetězce: #6699FF (modrá)

#### Pascal Snippety

- **Soubor:** `snippets/pascal-snippets.json`
- **Počet:** 11 snippetů
- **Příklady:** function, procedure, if, for, try, trye, repeat, while, case, var, begin
- **Použití:** Napiš zkratku (např. `function`) a stiskni Tab

#### Commands pro Themes

- `faBridge.setLightTheme` - Přepne na FA Pascal Light
- `faBridge.setDarkTheme` - Přepne na FA Pascal Dark
- **Použití:** Ctrl+Shift+P → "FA Bridge: Přepnout na světlý/tmavý motiv"

### IntelliSense Provider

- Completion a Hover podpora pro Pascal soubory
- Parsování dokumentace z `FsUtils.pas` (XML dokumentace)
- Asynchronní parsování v pozadí

### Command Watcher

- Sledování příkazů z FA (např. `check_unsaved_and_close`)
- Zpracování příkazů z `facmd_from_fa.txt`

### Nastavení

- `faBridge.autoOpenPanel` - Automatické otevírání panelu při startu
- `faBridge.enableSnippets` - Zapnutí/vypnutí snippetů
- `faBridge.faCompatibleHotkeys` - FA kompatibilní hotkeys
- `local-history.enabled` - Historie souborů (zapnutí/vypnutí panelu HISTORIE)
- `faHistory.maxFiles` - Maximální počet souborů zobrazených v panelu historie (výchozí: 50)
- `faHistory.showDates` - Zobrazovat datumy u verzí v panelu historie (výchozí: true)

---

## Debugger

### Přehled

FA Bridge Debugger umožňuje ladit Pascal skripty v TMS Scripter přímo z Cursor/VS Code pomocí jednoduchého file-based protokolu.

### Architektura

Komunikace probíhá přes soubory v .fsbridge/ složce:

- fadebug.txt - Příkazy z Cursor do FA (UTF-8 s BOM)
- fadebugstate.json - Stav debuggeru z FA do Cursor (JSON)

### Funkce

#### Základní ovládání

- F5 - Pokračovat v běhu (Continue)
- F10 - Krok přes (Step Over)
- Shift+F5 - Pozastavit (Pause)
- F9 - Přepnout breakpoint na aktuálním řádku

#### Status bar

V levém dolním rohu Cursor/VS Code se zobrazuje status debuggeru.

#### Debug Proměnné panel

V sidebaru FA Bridge je nový panel "Debug Proměnné", který zobrazuje aktuální proměnné při zastavení na breakpointu.

### Implementace v FA (Delphi)

#### Příklad integrace

Nastav callback pro debugger příkazy:

```pascal
Bridge.OnDebuggerCommand := ProcessDebugCommand;
```

#### Zpracování příkazů

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

#### Aktualizace stavu

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

### Formát příkazů

#### Příkazy z Cursor do FA (fadebug.txt)

- DEBUG_CONTINUE - Pokračovat v běhu
- DEBUG_PAUSE - Pozastavit běh
- DEBUG_STEP_OVER - Krok přes
- DEBUG_STOP - Zastavit debugování
- DEBUG_SET_BREAKPOINT:42 - Nastavit breakpoint na řádku 42
- DEBUG_CLEAR_BREAKPOINT:42 - Zrušit breakpoint na řádku 42
- DEBUG_GET_VARIABLES - Získat seznam proměnných

#### Stav z FA do Cursor (fadebugstate.json)

```json
{
  "status": "paused",
  "currentLine": 42,
  "breakpoints": [12, 25, 38],
  "variables": {}
}
```

### TMS Scripter API

- atPascalScripter.Running - Indikuje, zda je skript spuštěn
- atPascalScripter.Paused - Určuje, zda je skript pozastaven
- atPascalScripter.DebugExecutionLine - Aktuální řádek při debugování
- atPascalScripter.DebugStepOverLine - Provede aktuální řádek
- atPascalScripter.DebugToggleBreakLine(Line) - Přepne breakpoint
- atPascalScripter.Resume - Pokračovat v běhu
- atPascalScripter.Pause - Pozastavit
- atPascalScripter.Stop - Zastavit debugování
- atPascalScripter.OnDebugHook - Událost při každém kroku

### Trasování komunikace

#### Jak funguje celý systém

**1. Nastavení breakpointu v Cursor (F9)**

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

**2. FA čte příkaz**

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

**3. FA posílá stav zpět**

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

**4. Extension čte stav**

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

### Problém: Breakpoint mizí

#### Co se děje:

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

#### Řešení

Nastavit breakpoint v FA můžeš pouze pokud je skript načten. Ale extension musí mít breakpointy uložené i když skript není načten.

**Možnost 1:** Posílat stav i když není skript načten (s prázdným seznamem breakpointů z FA, ale zachovat lokální breakpointy v extension)

**Možnost 2:** Nedovolit extension vymazat breakpointy pokud soubor neexistuje nebo je prázdný - pouze pokud je explicitně poslán prázdný seznam.

**Možnost 3:** FA by měla posílat stav i když není skript načten, ale s prázdným seznamem breakpointů. Extension pak ponechá lokální breakpointy.

### Jak trasovat komunikaci

#### 1. Logování v FA (Delphi)

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

#### 2. Kontrola souborů

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

#### 3. Kontrola v Cursor/VS Code

**Developer Console:**
- Otevři: `Help` → `Toggle Developer Tools`
- Console tab → hledej zprávy začínající `[FA Debugger]`

**Co sledovat:**
- `[FA Debugger] Received command: DEBUG_SET_BREAKPOINT:42`
- `[FA Debugger] Chyba při čtení stavu`
- `[FA Debugger] updateState called`

#### 4. Checklist trasování

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

### Nejčastější problémy

#### Problém 1: Breakpoint mizí ihned

**Příčina:** `fadebugstate.json` neexistuje nebo je prázdný, extension volá `clearBreakpoints()`.

**Kontrola:**
- Existuje `.fsbridge/fadebugstate.json`?
- Obsahuje nějaký obsah?
- Je JSON validní?

**Řešení:** Upravit `UpdateDebugState` aby posílal stav i když není skript načten.

#### Problém 2: Breakpoint se nenastaví v FA

**Příčina:** `ProcessDebugCommand` není volán nebo `ScripterT.CurrentScript` není přiřazen.

**Kontrola:**
- Je `ProcessDebugFile` volán z `PollTick`?
- Je `FOnDebuggerCommand` nastaven?
- Je `ScripterT.CurrentScript` přiřazen?

**Řešení:** Zajistit že `ProcessDebugFile` je volán pravidelně a že skript je načten.

#### Problém 3: Stav se neaktualizuje

**Příčina:** `UpdateDebugState` předčasně končí (`Exit`).

**Kontrola:**
- Je `fmScriptEditor.IsDebugMode` True? (původní debugger aktivní)
- Je `ScripterT.CurrentScript` přiřazen?
- Je `FBridge` nebo `ScripterT` nil?

**Řešení:** Přidat logování do `UpdateDebugState` aby bylo vidět proč končí.

### Diagnostické nástroje

#### 1. OutputDebugString v Delphi

```pascal
procedure TfaMain.ProcessDebugCommand(const Command: string);
begin
  OutputDebugString(PChar('[DEBUG] Command: ' + Command));
  // ... zbytek kódu ...
end;
```

Sleduj pomocí `DebugView` (freeware nástroj od Microsoft).

#### 2. Console.log v extension

```typescript
private updateState(): void {
  console.log('[FA Debugger] Reading state from:', statePath);
  // ... zbytek kódu ...
}
```

Sleduj v Developer Tools → Console.

#### 3. Manuální kontrola souborů

- Otevři `.fsbridge/` složku
- Sleduj změny v `fadebug.txt` a `fadebugstate.json`
- Ověř obsah a formát

#### 4. Breakpointy v kódu

Nastav breakpointy v kritických místech:
- `ProcessDebugFile` - začátek metody
- `ProcessDebugCommand` - začátek metody
- `UpdateDebugState` - před každým `Exit`
- `updateState()` v extension - začátek metody

### Doporučené úpravy pro řešení problému

#### Úprava 1: UpdateDebugState - posílat stav i když není skript načten

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

#### Úprava 2: updateState - nevolat clearBreakpoints pokud soubor neexistuje poprvé

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

### Poznámky

- Všechny soubory v .fsbridge/ používají UTF-8 kódování s BOM
- Soubor fadebug.txt se maže ihned po přečtení
- Metoda PollTick by měla být volána pravidelně z Timeru

---

## Vývoj a testování

### Struktura projektu

```
src/
├── extension.ts              # Hlavní soubor (aktivace, registrace příkazů)
├── commands/
│   └── sendCommand.ts       # Implementace všech příkazů
├── utils/
│   ├── fsBridge.ts          # Komunikace s FA (zápis do .fsbridge/facmd.txt)
│   ├── fileHistory.ts       # Historie souborů a porovnání verzí
│   └── commandWatcher.ts    # Sledování příkazů z FA
├── views/
│   ├── FABridgePanel.ts     # Sidebar TreeView panel (Příkazy)
│   └── HelpPanel.ts         # Help panel (NÁPOVĚDA)
├── providers/
│   ├── PascalIntelliSenseProvider.ts  # IntelliSense (Completion + Hover)
│   ├── SnippetProvider.ts             # Pascal snippety
│   └── BeginEndMatcher.ts              # Zvýrazňování begin/end bloků
└── debugger/
    └── msgWatch.ts          # Msg Watch panel
```

### Kompilace

```bash
npm run compile      # Jednorázová kompilace
npm run watch        # Watch mode
npm run lint         # ESLint check
```

### Spuštění Extension v Development Mode

**Nejjednodušší způsob - PowerShell script:**
```powershell
.\launch-vscode-dev.ps1
```

Tento script:
1. Zkompiluje TypeScript (`npm run compile`)
2. Otevře VS Code s extension development mode
3. Vytvoří Dev Host okno kde můžeš testovat extension

**Ruční spuštění:**
```powershell
# Zkompiluj
npm run compile

# Spusť VS Code dev mode
code --extensionDevelopmentPath=. .
```

### Workflow při vývoji

1. **Edituj kód v Cursoru** (např. `src/commands/sendCommand.ts`)
2. **Testuj změny:**
   ```powershell
   .\launch-vscode-dev.ps1
   ```
3. **V Dev Host okně testuj příkazy:**
   - Klikni na ikonu FA Bridge v levém panelu
   - Klikni na příkazy v sidebaru
   - `Ctrl+Alt+1,2,V,9` → Jednotlivé příkazy pomocí zkratek

4. **Po změnách restartuj Dev Host:**
   - Zavři Dev Host okno
   - Znova spusť `.\launch-vscode-dev.ps1`

### Vytvoření VSIX instalátoru

**Jednoduchý příkaz:**
```powershell
npm run compile && npx @vscode/vsce package
```

**Postup krok za krokem:**
```powershell
# 1. Zkompiluj TypeScript
npm run compile

# 2. Vytvoř VSIX balíček
npx @vscode/vsce package
```

Vytvoří se soubor: `fa-bridge-0.5.93.vsix` (nebo aktuální verze)

**Před vytvořením nové verze:**
1. Změň `version` v `package.json` (např. `0.0.2`, `0.1.0`, `1.0.0`)
2. Zkompiluj a otestuj
3. Vytvoř VSIX

### Instalace VSIX

**V Cursoru/VS Code:**
1. `Ctrl+Shift+P`
2. Zadej: `Extensions: Install from VSIX...`
3. Vyber: `fa-bridge-0.5.93.vsix`

**Z příkazové řádky:**
```powershell
code --install-extension fa-bridge-0.5.93.vsix
```

### Změna klávesových zkratek

Edituj `package.json` v sekci `"keybindings"`:

```json
{
  "command": "faBridge.vlozitNazevUdaje",
  "key": "ctrl+alt+v",
  "mac": "cmd+alt+v"
}
```

Po změně: zkompiluj (`npm run compile`) a restartuj Dev Host.

### Historie příkazů v terminálu

- `↑` / `↓` - Procházet historii
- `F8` - Hledat v historii (napiš začátek příkazu)
- `Ctrl+R` - Reverse search
- `Tab` - Autocomplete

Rychlý příkaz: napiš `.\la` a stiskni `Tab` → doplní `.\launch-vscode-dev.ps1`

### Testování

Vytvoř si workspace s nějakými soubory a:

```bash
npm run test
```

---

## Reference

### Požadavky na Extension

#### Příkazy (Commands):

1. `faBridge.ulozitSoubor` - Save file and activate FA (F2)
2. `faBridge.faDoPopredi` - Activate FA window (F1, Alt+Q / Ctrl+Q)
3. `faBridge.vlozitNazevUdaje` - Read fafield.txt and insert at cursor (Alt+X, Ctrl+Shift+V)
4. `faBridge.kopirovatNazevUdaje` - Read fafield.txt and copy to clipboard (Shift+Alt+C)
5. `faBridge.najitUdaj` - Write word under cursor to fafield.txt and send "Najit_udaj" to FA (Shift+Alt+L)
6. `faBridge.hledatPodleAktUdaje` - Open Find dialog with current field name (Shift+Alt+F)
7. `faBridge.hledatOdZacatku` - Open Find dialog, move cursor to start, reopen Find (Alt+L)
8. `faBridge.toggleMsgv` - Insert/delete msgv('') debug statement (Alt+F9)
9. `faBridge.toggleField` - Toggle field format: 'slovo' → [:slovo:] → [.slovo.] → 'slovo' (Alt+A)
10. `faBridge.vlozitUdajSBody` - Insert field in format [.udaj.] (Shift+Ctrl+[)
11. `faBridge.vlozitUdajSDvojteckami` - Insert field in format [:udaj:] (Shift+Ctrl+])
12. `faBridge.compareWithPrevious` - Compare current file with previous version from history
13. `faBridge.showHistoryVersions` - Show list of all file versions in history
14. `faHistory.showDiff` - Show diff between historical version and current file
15. `faHistory.restoreFile` - Restore file to selected historical version
16. `faHistory.compareWithPrevious` - Compare two historical versions with each other
17. `faHistory.refresh` - Refresh history panel
18. `faBridge.setLightTheme` - Switch to FA Pascal Light theme
19. `faBridge.setDarkTheme` - Switch to FA Pascal Dark theme
20. `faBridge.showIntelliSenseStats` - Show IntelliSense parsing statistics

#### UI:

- **Sidebar Panel:** Vlastní panel v Activity Bar s ikonou "file-code"
- **TreeView:** Seznam příkazů s ikonami a klávesovými zkratkami
- Kliknutí na položku v panelu spustí příslušný příkaz

#### Keybindings:

- `F1`, `Alt+Q` / `Ctrl+Q` → Přepnout do FA
- `F2` → Uložit soubor
- `Shift+Alt+F` → Otevřít FA Bridge sidebar / Hledat podle akt. údaje (podle kontextu)
- `Alt+X`, `Ctrl+Shift+V` → Vložit název údaje
- `Shift+Alt+C` / `Shift+Ctrl+C` → Kopírovat název do schránky (podle nastavení)
- `Shift+Alt+L` → Najít údaj ve formuláři
- `Alt+L` → Hledat od začátku
- `Alt+F9` → Toggle msgv
- `Alt+A` → Toggle field format
- `Shift+Ctrl+[` → Vložit [.udaj.]
- `Shift+Ctrl+]` → Vložit [:udaj:]

### Poznámky pro AI

Když AI začne pracovat na extension:
1. Vygeneruj strukturu pomocí `yo code`
2. Nahraď `.ts` soubory podle návrhu
3. Aktualizuj `package.json` s příkazy a keybindings
4. Otestuj funkčnost pomocí `.\launch-vscode-dev.ps1`
5. Zajisti aby všechny příkazy psaly do `.fsbridge/facmd.txt`

### Budoucí Rozšíření

Tyto funkce přidáme později:
- Dialogy pro výběr souborů
- Preview obsahu
- Transformace textu

### Reference

- Originální řešení: PowerShell tasky v `.vscode/tasks.json`
- Dokumentace: `FS_BRIDGE_README.md` (v původním projektu)
- Keybindings: `reports/keybind.json`

---

**Vytvořeno:** Říjen 2025  
**Status:** ✅ Implementováno a funkční  
**Verze:** 0.5.93

📖 **Další dokumentace:**
- [USER_GUIDE.md](USER_GUIDE.md) - Uživatelská příručka

