{ 11.12.2025 12:42:10 (GMT+1:00) > [mik on WIN-48QDB6JAV23] checked in Zmeny - horke klavesy  }
{ 28.10.2025 15:12:45 (GMT+1:00) > [mik on WIN-48QDB6JAV23] checked in Propojeni na Cursor / VS code  }
unit uCursorBridge;
(*
  Delphi 2007 helper for "FA ⇄ Cursor/VS Code" (file-based + polling + reuse-window)

Features:
- Atomické uložení skriptu z FA do pracovní složky (raw AnsiString, bez BOM/konverzí)
- Otevření nebo reuse existujícího okna Cursor/VS Code pro daný workspace
- Skok na soubor:řádek[:sloupec] (-g)
- Aktivace existujícího okna editoru (Cursor.exe / Code.exe)
- Polling pro detekci externích uložených změn (Ctrl+S v editoru) a callback OnExternalSave
- Polling pro čtení příkazů z .fsbridge/facmd.txt a callback OnCommand
- facmd.txt je POUZE pro komunikaci z Cursoru do FA (activate, compile, atd.)
- facmd_from_fa.txt je pro komunikaci z FA do Cursoru (check_unsaved_and_close)
- Soubor facmd.txt se přejmenuje na facmd-x-timestamp.txt po přečtení (pro debug)
- Čtení dat z .fsbridge/fafield.txt pomocí ReadFieldText() (obsah fieldu z Cursor extension)
- Zápis dat do .fsbridge/fafield.txt pomocí WriteFieldText() (atomicky s UTF-8 BOM)

Novinky:
- Workspace se vždy nastavuje na složku ExportFolder (relativní k EXE je podporováno)
- Každý formulář má vlastní podsložku pojmenovanou podle FormId
  (např. ...\DataPrg\Scripts\dz_15DPFO5252_2\script_dz_15DPFO5252_2.pas)
- Spouštění VS Code / Cursor bez blikajícího CMD okna na Win 11 (resolver EXE + ShellExecuteEx bez konzole)
- Zpracování příkazů z Cursor extension přes .fsbridge/facmd.txt

Integrace v aplikaci:
  Bridge.ExportFolder := 'DataPrg\FormsProject'; // relativně k adresáři EXE
  Bridge.CursorCmdOrPath := 'code';              // 'cursor' / 'code' / plná cesta
  Bridge.OnCommand := ProcessFACommand;          // callback pro příkazy
  Bridge.StartEditing(FormId, Code, JumpLine, JumpCol);
  Bridge.PollTick; // z Timeru (kontroluje změny souboru + příkazy + debugger příkazy)
  
  // Komunikace s Cursor extension přes fafield.txt:
  FieldName := Bridge.ReadFieldText;             // načti název fieldu z Cursor extension
  Bridge.WriteFieldText('MyFieldName');          // pošli název fieldu do Cursor extension
  
*)

interface

uses
  Windows, ShellAPI, SysUtils, Classes, TlHelp32, Registry;

const
  DEFAULT_FILE_PREFIX = 'script_';
  
  // Verzování uCursorBridge - musí být kompatibilní s FA Bridge extension
  // Formát: 'X.Y.Z-FA' kde X.Y.Z je verze extension (z package.json)
  // Při každé změně v tomto souboru musí být verze aktualizována!
  CURSOR_BRIDGE_VERSION = '0.4.3-FA';
  CURSOR_BRIDGE_VERSION_DATE = '2025-10-30';

type
  // Předá aktuální text při zjištění externího uložení
  TExternalSaveEvent = procedure(const Text: AnsiString) of object;
  
  // Předá příkaz z Cursor extension
  TCommandEvent = procedure(const Command: string) of object;
  
  
  // Výsledek kontroly a zavření souboru v Cursoru
  TCursorCloseResult = (ccrClosed, ccrUnsaved, ccrNotOpen, ccrError);

  TCursorBridge = class
  private
    FExportFolder: string;       // uživatelsky nastaveno (může být relativní k EXE)
    FCursorCmdOrPath: string;    // 'cursor' | 'code' | plná cesta k EXE

    FCurrentFormId: string;
    FCurrentFile: string;
    FLastWrite: TDateTime;
    FInstanceId: string;         // PID této instance FA pro více-instanční podporu
    FCursorPID: DWORD;           // PID spuštěného cursoru pro tuto instanci FA
    FIsClosingFile: Boolean;     // Flag pro zakázání PollTick během zavírání záložky

    FOnExternalSave: TExternalSaveEvent;
    FOnCommand: TCommandEvent;

    function SettingsFilePath: string;
    function LoadEditorFromSettings: string; // '' = nenačteno / nenalezeno
    function EnsureDir(const Dir: string): Boolean;
    function IsAbsolutePath(const P: string): Boolean;
    function EffectiveExportFolder: string;

    function GetScriptFileName(const FormId: string): string;
    procedure AtomicWriteAllText(const FileName, Text: AnsiString);
    function GetFileWriteTime(const FileName: string): TDateTime;
    function ReadAllText(const FileName: string): AnsiString;

    function RunCursorReuse(const AFolder, AFile: string; ALine, ACol: Integer): Boolean;

    // Nové pomocné metody pro spouštění editoru bez konzole
    function ResolveEditorCommand: string;
    function ShellExecNoConsole(const FileName, Params, WorkDir: string; ShowCmd: Integer): Boolean;
    
    // Zpracování příkazů z Cursor extension
    function GetCommandFilePath: string;
    procedure ProcessCommandFile;
    
    
    // Čtení field.txt ze Cursor extension
    function GetFieldFilePath: string;
    
    // Podpora více instancí FA - složka pro každou instanci
    function GetInstanceDir: string;
    function GetInstanceFilePath: string;
    function RenameCommandFileWithTimestamp(const CmdFilePath: string): Boolean;
    procedure WriteInstanceId;
    function ReadInstanceId: string;
    
    // Podpora párování FA-Cursor instance
    function GetCursorInstanceFilePath: string;
    procedure WriteCursorInstanceId;
    function ReadCursorInstanceId: DWORD;
    function FindWindowByPID(PID: DWORD): HWND;
    function FindWindowByWorkspaceFile(const WorkspaceFileName: string): HWND;
    
    // Podpora mapování FA instance -> aktuální FormId
    function GetCurrentFormFilePath: string;
    procedure WriteCurrentForm(const FormId: string);
    
    // Podpora multi-root workspace souborů
    function GetWorkspaceFilePath(const FormId: string): string;
    function CreateWorkspaceFile(const FormId: string): Boolean;
    function EscapeJsonString(const S: string): string;
    
    // Kontrola neuložených změn a zavření souboru v Cursoru
    function GetResponseFilePath: string;
    function GetFACommandFilePath: string; // Příkazy z FA do Cursoru: facmd_from_fa.txt
    procedure WriteFACommandToFile(const Command: string);
    function ReadCursorResponse(const Command: string; out Response: string): TCursorCloseResult; // Pomocná funkce pro čtení odpovědi z Cursor extension
    
    // Mazání starých složek instance
    function IsFAProcessAlive(PID: DWORD): Boolean;
    function DeleteDirectory(const DirName: string; OnlyChildren: Boolean): Boolean;
    procedure CleanupOldInstanceFolders;
  public
    constructor Create;

    // Konfigurace před použitím
    property ExportFolder: string read FExportFolder write FExportFolder;           // např. 'DataPrg\FormsProject'
    property CursorCmdOrPath: string read FCursorCmdOrPath write FCursorCmdOrPath; // 'code' / 'cursor' / plná cesta

    // Stav
    property CurrentFormId: string read FCurrentFormId;
    property CurrentFile: string read FCurrentFile;
    
    // Kontrola stavu Cursor instance
    function IsCursorProcessAlive: Boolean;

    // Události
    property OnExternalSave: TExternalSaveEvent read FOnExternalSave write FOnExternalSave;
    property OnCommand: TCommandEvent read FOnCommand write FOnCommand;

    // Hlavní API
    function StartEditing(const FormId: string; const Code: AnsiString; JumpLine, JumpCol: Integer): Boolean;
    function BringToCursor(const Code: AnsiString; JumpLine, JumpCol: Integer): Boolean;
    procedure PollTick;
    
    // Čtení a zápis dat z/do Cursor extension
    function ReadFieldText: string; // Přečte obsah fafield.txt
    procedure WriteFieldText(const FieldName: string); // Zapíše název fieldu do fafield.txt
    function ReadScriptFileContent: AnsiString; // Načte obsah aktuálního scriptu z disku
    
    // Debugger podpora
    procedure WriteMsgState(const StateJson: string); // Zapíše stav z Msg do famsgstate.json (UTF-8 s BOM)

    procedure ActivateCursorWindow;
    
    // Kontrola a zavření souboru v Cursoru před zavřením FA
    function CheckAndCloseCursorFile: TCursorCloseResult;
    
    // Pouze kontrola neuložených změn (bez zavírání souboru)
    function CheckUnsavedChanges: TCursorCloseResult;
    
    // Pouze zavření souboru v Cursoru (bez kontroly neuložených změn)
    function CloseCursorFile: TCursorCloseResult;
    
    // Kontrola, jestli je script otevřený v Cursoru
    function IsScriptOpenInCursor: Boolean;
    
    // Vyprázdní FCurrentFile a FCurrentFormId (např. při zavření definice)
    procedure ClearCurrentFile;
    
    // Public metoda pro získání efektivní cesty k export složce (pro debug soubory)
    function GetEffectiveExportFolder: string;
    
    destructor Destroy; override;
  end;

implementation

{ Pomocné funkce (mimo třídu) }

function BaseName(const Path: string): string;
var
  S: string;
begin
  S := ExtractFileName(Path);
  Result := UpperCase(ChangeFileExt(S, ''));
end;

// Najde PIDy všech běžících procesů s daným názvem
function CollectProcessPIDs(const ExeName: string): TList;
var
  Snap: THandle;
  Pe32: TProcessEntry32;
begin
  Result := TList.Create;
  
  Snap := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if Snap = INVALID_HANDLE_VALUE then Exit;
  try
    ZeroMemory(@Pe32, SizeOf(Pe32));
    Pe32.dwSize := SizeOf(Pe32);
    if Process32First(Snap, Pe32) then
    repeat
      if SameText(ExtractFileName(Pe32.szExeFile), ExeName) then
        Result.Add(Pointer(Pe32.th32ProcessID));
    until not Process32Next(Snap, Pe32);
  finally
    CloseHandle(Snap);
  end;
end;

// Najde hlavní okno procesu s daným PIDem (není v seznamu vyloučených PIDů)
function FindMainWindowOfNewProcess(const ExeName: string; ExcludePIDs: TList): HWND;
var
  Snap: THandle;
  Pe32: TProcessEntry32;
  TargetPID: DWORD;

  function EnumWinProc(h: HWND; lParam: LPARAM): BOOL; stdcall;
  var
    PID: DWORD;
  begin
    GetWindowThreadProcessId(h, @PID);
    if (PID = DWORD(lParam)) and IsWindowVisible(h) then
    begin
      Result := False; // stop
      SetLastError(Cardinal(h));
    end
    else
      Result := True; // continue
  end;

begin
  Result := 0;
  TargetPID := 0;

  Snap := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if Snap = INVALID_HANDLE_VALUE then Exit;
  try
    ZeroMemory(@Pe32, SizeOf(Pe32));
    Pe32.dwSize := SizeOf(Pe32);
    if Process32First(Snap, Pe32) then
    repeat
      if SameText(ExtractFileName(Pe32.szExeFile), ExeName) then
      begin
        // Zkontroluj, že PID není v seznamu vyloučených
        if (ExcludePIDs = nil) or (ExcludePIDs.IndexOf(Pointer(Pe32.th32ProcessID)) = -1) then
        begin
          TargetPID := Pe32.th32ProcessID;
          Break;
        end;
      end;
    until not Process32Next(Snap, Pe32);
  finally
    CloseHandle(Snap);
  end;

  if TargetPID <> 0 then
  begin
    EnumWindows(@EnumWinProc, LPARAM(TargetPID));
    Result := HWND(GetLastError);
    SetLastError(0);
  end;
end;

function FindMainWindowOfProcess(const ExeName: string): HWND;
begin
  // Najdi první běžící proces s daným názvem (pro zpětnou kompatibilitu)
  Result := FindMainWindowOfNewProcess(ExeName, nil);
end;

function ExpandEnv(const S: string): string;
var
  Buf: array[0..MAX_PATH * 4] of Char;
  N: DWORD;
begin
  N := ExpandEnvironmentStrings(PChar(S), @Buf[0], Length(Buf));
  if (N > 0) and (N <= DWORD(Length(Buf))) then
    Result := string(Buf)
  else
    Result := S;
end;

function SearchExeOnPath(const BaseName: string): string;
var
  Buf: array[0..MAX_PATH] of Char;
  FilePart: PChar;
  Len: DWORD;
begin
  Result := '';
  Len := SearchPath(nil, PChar(BaseName), '.exe', SizeOf(Buf), Buf, FilePart);
  if Len > 0 then
    Result := string(Buf);
end;

function SearchCmdOnPath(const BaseName: string): string;
var
  Buf: array[0..MAX_PATH] of Char;
  FilePart: PChar;
  Len: DWORD;
begin
  Result := '';
  Len := SearchPath(nil, PChar(BaseName), '.cmd', SizeOf(Buf), Buf, FilePart);
  if Len > 0 then
    Result := string(Buf);
end;

function ReadAppPath(const ExeName: string): string;
var
  R: TRegistry;
begin
  Result := '';
  R := TRegistry.Create(KEY_READ);
  try
    R.RootKey := HKEY_LOCAL_MACHINE;
    if R.OpenKeyReadOnly('\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\' + ExeName) then
    begin
      Result := R.ReadString('');
      Exit;
    end;
    R.CloseKey;
    R.RootKey := HKEY_CURRENT_USER;
    if R.OpenKeyReadOnly('\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\' + ExeName) then
      Result := R.ReadString('');
  finally
    R.Free;
  end;
end;

{ TCursorBridge }

constructor TCursorBridge.Create;
begin
  inherited Create;
  FExportFolder := '';          // default: prázdné → EffectiveExportFolder = adresář EXE
  FCursorCmdOrPath := 'cursor'; // nebo 'code'
  FCurrentFormId := '';
  FCurrentFile := '';
  FLastWrite := 0;
  FCursorPID := 0;              // PID cursoru zatím neznámý
  FIsClosingFile := False;      // Flag pro zakázání PollTick během zavírání záložky
end;

function TCursorBridge.EnsureDir(const Dir: string): Boolean;
begin
  if (Dir <> '') and DirectoryExists(Dir) then
  begin
    Result := True;
    Exit;
  end;
  Result := ForceDirectories(Dir);
end;

function TCursorBridge.IsAbsolutePath(const P: string): Boolean;
begin
  // Windows: "X:\..." nebo "\\server\share..." nebo "\root-relativní"
  if (Length(P) >= 2) and (P[2] = ':') then
    Result := True
  else if (Length(P) >= 2) and (P[1] = '\') and (P[2] = '\') then
    Result := True
  else if (Length(P) >= 1) and (P[1] = '\') then
    Result := True
  else
    Result := False;
end;

function TCursorBridge.EffectiveExportFolder: string;
var
  AppDir: string;
begin
  AppDir := ExtractFilePath(ParamStr(0)); // adresář volající aplikace
  if FExportFolder = '' then
    Result := ExcludeTrailingPathDelimiter(AppDir)
  else if IsAbsolutePath(FExportFolder) then
    Result := ExcludeTrailingPathDelimiter(ExpandFileName(FExportFolder))
  else
    Result := ExcludeTrailingPathDelimiter(
                ExpandFileName(IncludeTrailingPathDelimiter(AppDir) + FExportFolder)
              );
end;

function TCursorBridge.GetScriptFileName(const FormId: string): string;
begin
  // Ukládáme do podsložky pojmenované dle FormId, soubor ponechává původní jméno
  Result := IncludeTrailingPathDelimiter(EffectiveExportFolder)
          + FormId + PathDelim
          + DEFAULT_FILE_PREFIX + FormId + '.pas';
end;

function TCursorBridge.GetInstanceDir: string;
begin
  // Složka pro tuto instanci FA: <workspace>/.fsbridge/{FA_PID}/
  // FInstanceId musí být nastaveno před voláním
  if FInstanceId = '' then
    FInstanceId := IntToStr(GetCurrentProcessId);
    
  Result := IncludeTrailingPathDelimiter(EffectiveExportFolder)
          + '.fsbridge' + PathDelim
          + FInstanceId + PathDelim;
end;

// Pomocná funkce pro přejmenování facmd.txt na facmd-x-timestamp.txt
function TCursorBridge.RenameCommandFileWithTimestamp(const CmdFilePath: string): Boolean;
var
  NewFileName: string;
  TimestampStr: string;
  InstanceDir: string;
begin
  Result := False;
  try
    InstanceDir := ExtractFilePath(CmdFilePath);
    // Formát: facmd-x-YYYYMMDD-HHNNSS-ZZZ.txt (bez dvojteček a dalších neplatných znaků)
    // Použijeme GetTickCount mod 1000 pro milisekundy (jednoduché řešení bez DateUtils)
    TimestampStr := FormatDateTime('yyyymmdd-hhnnss', Now) + '-' + Format('%03d', [GetTickCount mod 1000]);
    NewFileName := InstanceDir + 'facmd-x-' + TimestampStr + '.txt';
    
    if FileExists(CmdFilePath) then
    begin
      RenameFile(CmdFilePath, NewFileName);
      Result := True;
    end;
  except
    Result := False;
  end;
end;

function TCursorBridge.GetInstanceFilePath: string;
begin
  // Instance ID soubor: <workspace>/.fsbridge/{FA_PID}/fa_instance.txt
  Result := GetInstanceDir + 'fa_instance.txt';
end;

procedure TCursorBridge.WriteInstanceId;
var
  InstanceFile: string;
  Content: AnsiString;
  RetryCount: Integer;
  Success: Boolean;
begin
  // Zapíše PID této instance FA do fa_instance.txt (atomicky s retry)
  FInstanceId := IntToStr(GetCurrentProcessId);
  InstanceFile := GetInstanceFilePath;
  
  // Zajisti existenci složky .fsbridge
  EnsureDir(ExtractFilePath(InstanceFile));
  
  // Použij atomický zápis s retry mechanismem
  Content := AnsiString(FInstanceId);
  Success := False;
  RetryCount := 0;
  
  while (not Success) and (RetryCount < 5) do
  begin
    try
      AtomicWriteAllText(InstanceFile, Content);
      Success := True;
    except
      Inc(RetryCount);
      if RetryCount < 5 then
        Sleep(50); // Počkej 50ms před dalším pokusem
      // Pokud se nepodaří ani po 5 pokusech, tiše ignoruj (nechceme blokovat aplikaci)
    end;
  end;
end;

function TCursorBridge.ReadInstanceId: string;
var
  InstanceFile: string;
  SL: TStringList;
begin
  // Přečte instance ID ze souboru (pokud existuje)
  Result := '';
  InstanceFile := GetInstanceFilePath;
  
  if not FileExists(InstanceFile) then
    Exit;
    
  SL := TStringList.Create;
  try
    SL.LoadFromFile(InstanceFile);
    if SL.Count > 0 then
      Result := Trim(SL[0]);
  finally
    SL.Free;
  end;
end;

function TCursorBridge.GetCursorInstanceFilePath: string;
begin
  // PID spuštěného cursoru: <workspace>/.fsbridge/{FA_PID}/cursor_instance.txt
  Result := GetInstanceDir + 'cursor_instance.txt';
end;

procedure TCursorBridge.WriteCursorInstanceId;
var
  InstanceFile: string;
  Content: AnsiString;
  RetryCount: Integer;
  Success: Boolean;
begin
  // Zapíše PID spuštěného cursoru do cursor_instance.txt (atomicky s retry)
  if FCursorPID = 0 then Exit;
  
  InstanceFile := GetCursorInstanceFilePath;
  
  // Zajisti existenci složky .fsbridge
  EnsureDir(ExtractFilePath(InstanceFile));
  
  // Použij atomický zápis s retry mechanismem
  Content := AnsiString(IntToStr(FCursorPID));
  Success := False;
  RetryCount := 0;
  
  while (not Success) and (RetryCount < 5) do
  begin
    try
      AtomicWriteAllText(InstanceFile, Content);
      Success := True;
    except
      Inc(RetryCount);
      if RetryCount < 5 then
        Sleep(50); // Počkej 50ms před dalším pokusem
      // Pokud se nepodaří ani po 5 pokusech, tiše ignoruj
    end;
  end;
end;

function TCursorBridge.ReadCursorInstanceId: DWORD;
var
  InstanceFile: string;
  SL: TStringList;
begin
  // Přečte PID cursoru ze souboru (pokud existuje)
  Result := 0;
  
  // Nejdřív zkus z paměti
  if FCursorPID <> 0 then
  begin
    Result := FCursorPID;
    Exit;
  end;
  
  // Pak ze souboru
  InstanceFile := GetCursorInstanceFilePath;
  
  if not FileExists(InstanceFile) then
    Exit;
    
  SL := TStringList.Create;
  try
    SL.LoadFromFile(InstanceFile);
    if SL.Count > 0 then
      Result := StrToIntDef(Trim(SL[0]), 0);
  finally
    SL.Free;
  end;
  
  // Ulož do paměti pro příště
  FCursorPID := Result;
end;

function TCursorBridge.GetCurrentFormFilePath: string;
begin
  // Aktuální FormId této FA instance: <workspace>/.fsbridge/{FA_PID}/current_form.txt
  Result := GetInstanceDir + 'current_form.txt';
end;

procedure TCursorBridge.WriteCurrentForm(const FormId: string);
var
  FormFile: string;
  Content: AnsiString;
  RetryCount: Integer;
  Success: Boolean;
begin
  // Zapíše aktuální FormId do current_form.txt (atomicky s retry)
  // Cursor extension používá tento soubor pro určení, která FA instance edituje který script
  if FormId = '' then Exit;
  
  FormFile := GetCurrentFormFilePath;
  
  // Zajisti existenci složky .fsbridge/{FA_PID}
  EnsureDir(ExtractFilePath(FormFile));
  
  // Použij atomický zápis s retry mechanismem
  Content := AnsiString(FormId);
  Success := False;
  RetryCount := 0;
  
  while (not Success) and (RetryCount < 5) do
  begin
    try
      AtomicWriteAllText(FormFile, Content);
      Success := True;
    except
      Inc(RetryCount);
      if RetryCount < 5 then
        Sleep(50); // Počkej 50ms před dalším pokusem
      // Pokud se nepodaří ani po 5 pokusech, tiše ignoruj
    end;
  end;
end;

function TCursorBridge.IsCursorProcessAlive: Boolean;
var
  PID: DWORD;
  H: HWND;
  {$IFNDEF FINALBUILD}
  // Debug logování zakomentováno - může blokovat aktivaci FA
  // DebugFile: string;
  // SL: TStringList;
  {$ENDIF}
begin
  Result := False;
  
  {.$IFNDEF FINALBUILD}
  // Debug logování zakomentováno - může blokovat aktivaci FA
  // DebugFile := GetDebugFilePath;
  // SL := TStringList.Create;
  // try
  //   SL.Add('=== IsCursorProcessAlive - START ===');
  //   SL.Add('FCurrentFormId: ' + FCurrentFormId);
  //   SL.Add('FCursorPID: ' + IntToStr(FCursorPID));
  {.$ENDIF}
  
  // Hledej okno podle "fa_scripts" v titulku
  // Všechny FA instance sdílejí jeden workspace fa_scripts.code-workspace
  // Cursor zobrazuje v titulku: "soubor.pas - fa_scripts (Workspace) - Cursor"
  
  {.$IFNDEF FINALBUILD}
  // SL.Add('Looking for fa_scripts in window title...');
  {.$ENDIF}
  
  H := FindWindowByWorkspaceFile('fa_scripts');
  
  {.$IFNDEF FINALBUILD}
  // SL.Add('FindWindowByWorkspaceFile(fa_scripts) result: ' + IntToStr(H));
  {.$ENDIF}
  
  if H <> 0 then
  begin
    // Aktualizuj FCursorPID z nalezeného okna
    GetWindowThreadProcessId(H, @FCursorPID);
    
    {.$IFNDEF FINALBUILD}
    // SL.Add('Updated FCursorPID to: ' + IntToStr(FCursorPID));
    // SL.Add('Result: TRUE (found by workspace file)');
    {.$ENDIF}
    Result := True;
  end
  else
  begin
    // Fallback: zkus najít okno podle PID
    PID := ReadCursorInstanceId;
    
    {.$IFNDEF FINALBUILD}
    // SL.Add('Fallback: ReadCursorInstanceId returned: ' + IntToStr(PID));
    {.$ENDIF}
    
    if PID <> 0 then
    begin
      H := FindWindowByPID(PID);
      
      {.$IFNDEF FINALBUILD}
      // SL.Add('FindWindowByPID(' + IntToStr(PID) + ') returned: ' + IntToStr(H));
      {.$ENDIF}
      
      Result := (H <> 0);
    end;
  end;
  
  {.$IFNDEF FINALBUILD}
  // Debug logování zakomentováno - může blokovat aktivaci FA
  // SL.Add('=== IsCursorProcessAlive - Result: ' + BoolToStr(Result, True) + ' ===');
  // try
  //   SL.SaveToFile(DebugFile);
  // except
  // end;
  // finally
  //   SL.Free;
  // end;
  {.$ENDIF}
end;

// Najde okno Cursor/Code které má v titulku daný workspace název
// POZOR: WorkspaceFileName by měl být BEZ .code-workspace přípony!
// Cursor zobrazuje: "FormName - workspace_FormId_FA_12345 (Workspace) - Cursor"
function TCursorBridge.FindWindowByWorkspaceFile(const WorkspaceFileName: string): HWND;
type
  PEnumData = ^TEnumData;
  TEnumData = record
    SearchTitle: string;
    ResultHandle: HWND;
    {$IFNDEF FINALBUILD}
    DebugList: TStringList;
    {$ENDIF}
  end;
  
  function EnumCallback(H: HWND; lParam: LPARAM): BOOL; stdcall;
  var
    Data: PEnumData;
    Title: array[0..511] of Char;
    TitleStr: string;
  begin
    Result := True; // Pokračovat
    Data := PEnumData(lParam);
    
    // Zkontrolovat, že je to hlavní okno (viditelné, bez rodiče)
    if IsWindowVisible(H) and (GetWindow(H, GW_OWNER) = 0) then
    begin
      // Získej titulek okna
      if GetWindowText(H, @Title[0], Length(Title)) > 0 then
      begin
        TitleStr := string(Title);
        
        {.$IFNDEF FINALBUILD}
        // Debug logování zakomentováno - může blokovat aktivaci FA
        // if Assigned(Data^.DebugList) then
        //   Data^.DebugList.Add('Window: ' + TitleStr);
        {.$ENDIF}
        
        // Cursor/Code zobrazuje workspace v titulku (bez .code-workspace přípony!)
        // např: "FormName - workspace_FormId_FA_12345 (Workspace) - Cursor"
        if Pos(Data^.SearchTitle, TitleStr) > 0 then
        begin
          Data^.ResultHandle := H;
          Result := False; // Zastavit enumeraci
          
          {.$IFNDEF FINALBUILD}
          // Debug logování zakomentováno - může blokovat aktivaci FA
          // if Assigned(Data^.DebugList) then
          //   Data^.DebugList.Add('MATCH FOUND!');
          {.$ENDIF}
        end;
      end;
    end;
  end;

var
  Data: TEnumData;
begin
  Data.SearchTitle := WorkspaceFileName;
  Data.ResultHandle := 0;
  
  {.$IFNDEF FINALBUILD}
  // Debug logování zakomentováno - může blokovat aktivaci FA
  // Data.DebugList := TStringList.Create;
  // try
  //   Data.DebugList.Add('FindWindowByWorkspaceFile: ' + WorkspaceFileName);
  {.$ENDIF}
  
  EnumWindows(@EnumCallback, LPARAM(@Data));
  Result := Data.ResultHandle;
  
  {.$IFNDEF FINALBUILD}
  // Debug logování zakomentováno - může blokovat aktivaci FA
  //   Data.DebugList.Add('Result HWND: ' + IntToStr(Result));
  //   try
  //     Data.DebugList.SaveToFile(GetDebugFilePath + '.windows');
  //   except
  //   end;
  // finally
  //   Data.DebugList.Free;
  // end;
  {.$ENDIF}
end;

function TCursorBridge.FindWindowByPID(PID: DWORD): HWND;
type
  PEnumData = ^TEnumData;
  TEnumData = record
    TargetPID: DWORD;
    ResultHandle: HWND;
  end;
  
  function EnumCallback(H: HWND; lParam: LPARAM): BOOL; stdcall;
  var
    WindowPID: DWORD;
    Data: PEnumData;
  begin
    Result := True; // Pokračovat
    Data := PEnumData(lParam);
    
    GetWindowThreadProcessId(H, @WindowPID);
    if WindowPID = Data^.TargetPID then
    begin
      // Zkontrolovat, že je to hlavní okno (viditelné, bez rodiče)
      if IsWindowVisible(H) and (GetWindow(H, GW_OWNER) = 0) then
      begin
        Data^.ResultHandle := H;
        Result := False; // Zastavit enumeraci
      end;
    end;
  end;

var
  Data: TEnumData;
begin
  Data.TargetPID := PID;
  Data.ResultHandle := 0;
  EnumWindows(@EnumCallback, LPARAM(@Data));
  Result := Data.ResultHandle;
end;

function TCursorBridge.EscapeJsonString(const S: string): string;
var
  I: Integer;
  C: Char;
begin
  Result := '';
  for I := 1 to Length(S) do
  begin
    C := S[I];
    case C of
      '\': Result := Result + '\\';
      '"': Result := Result + '\"';
      #8: Result := Result + '\b';
      #9: Result := Result + '\t';
      #10: Result := Result + '\n';
      #12: Result := Result + '\f';
      #13: Result := Result + '\r';
      else
        if (Ord(C) < 32) or (Ord(C) > 126) then
          Result := Result + Format('\u%.4x', [Ord(C)])
        else
          Result := Result + C;
    end;
  end;
end;

function TCursorBridge.GetWorkspaceFilePath(const FormId: string): string;
begin
  // JEDEN společný workspace soubor pro VŠECHNY FA instance a scripty
  // Scripty se otevírají jako záložky v jednom okně Cursoru
  Result := IncludeTrailingPathDelimiter(EffectiveExportFolder)
          + '.fsbridge' + PathDelim
          + 'fa_scripts.code-workspace';
end;

function TCursorBridge.CreateWorkspaceFile(const FormId: string): Boolean;
var
  WorkspaceFile: string;
  ScriptsFolder: string;
  SL: TStringList;
  JsonContent: string;
begin
  Result := False;
  
  // Zajisti FInstanceId
  if FInstanceId = '' then
    FInstanceId := IntToStr(GetCurrentProcessId);
  
  // Cesta k workspace souboru
  WorkspaceFile := GetWorkspaceFilePath(FormId);
  
  // Pokud workspace soubor už existuje, nemusíme ho znovu vytvářet
  if FileExists(WorkspaceFile) then
  begin
    Result := True;
    Exit;
  end;
  
  // Cesta ke složce Scripts (celá složka jako jeden workspace)
  ScriptsFolder := EffectiveExportFolder;
  
  // Escape cesty pro JSON (obrácená lomítka -> dvojitá obrácená lomítka)
  ScriptsFolder := StringReplace(ScriptsFolder, '\', '\\', [rfReplaceAll]);
  
  // Vytvoř JSON obsah workspace souboru
  // JEDEN společný workspace pro všechny FA instance a scripty
  JsonContent := '{' + #13#10 +
    '  "folders": [' + #13#10 +
    '    {' + #13#10 +
    '      "path": "' + ScriptsFolder + '",' + #13#10 +
    '      "name": "FA Scripts"' + #13#10 +
    '    }' + #13#10 +
    '  ],' + #13#10 +
    '  "settings": {}' + #13#10 +
    '}';
  
  // Zajisti existenci složky .fsbridge
  EnsureDir(ExtractFilePath(WorkspaceFile));
  
  // Zapiš workspace soubor
  SL := TStringList.Create;
  try
    SL.Text := JsonContent;
    try
      SL.SaveToFile(WorkspaceFile);
      Result := True;
    except
      Result := False;
    end;
  finally
    SL.Free;
  end;
end;

function TCursorBridge.GetCommandFilePath: string;
begin
  // Příkazy z Cursor extension do FA: <workspace>/.fsbridge/{FA_PID}/facmd.txt
  // Tento soubor je POUZE pro komunikaci z Cursoru do FA (activate, compile, atd.)
  // Pro komunikaci z FA do Cursoru použij GetFACommandFilePath (facmd_from_fa.txt)
  Result := GetInstanceDir + 'facmd.txt';
end;

function TCursorBridge.GetFieldFilePath: string;
begin
  // Field data z Cursor extension: <workspace>/.fsbridge/{FA_PID}/fafield.txt
  Result := GetInstanceDir + 'fafield.txt';
end;


procedure TCursorBridge.AtomicWriteAllText(const FileName: string; const Text: AnsiString);
var
  Tmp: string;
  FS: TFileStream;
  Len: Integer;
begin
  // Zajistit cílovou složku (včetně podsložky s FormId)
  EnsureDir(ExtractFilePath(FileName));

  Tmp := FileName + '.tmp';
  FS := TFileStream.Create(Tmp, fmCreate or fmShareDenyWrite);
  try
    Len := Length(Text);
    if Len > 0 then
      FS.WriteBuffer(Text[1], Len);
  finally
    FS.Free;
  end;

  // Atomická výměna
  MoveFileEx(PChar(Tmp), PChar(FileName), MOVEFILE_REPLACE_EXISTING or MOVEFILE_WRITE_THROUGH);
end;

function TCursorBridge.GetFileWriteTime(const FileName: string): TDateTime;
var
  SR: TSearchRec;
begin
  Result := 0;
  if FindFirst(FileName, faAnyFile, SR) = 0 then
  try
    Result := FileDateToDateTime(SR.Time); // lokální čas
  finally
    FindClose(SR);
  end;
end;

function TCursorBridge.ReadAllText(const FileName: string): AnsiString;
var
  FS: TFileStream;
  Len: Integer;
begin
  Result := '';
  FS := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    Len := FS.Size;
    if Len > 0 then
    begin
      SetLength(Result, Len);
      FS.ReadBuffer(Result[1], Len);
    end;
  finally
    FS.Free;
  end;
end;

function TCursorBridge.ReadScriptFileContent: AnsiString;
begin
  Result := '';
  // DEBUG: Zobraz informaci o stavu
  if FCurrentFile = '' then
  begin
    // Použijeme ShowMessage protože MsgBoxInfo není dostupná v uCursorBridge
    // Výpis přes raise exception nebo jiný mechanismus
    Exit; // FCurrentFile je prázdný
  end;
  
  try
    Result := ReadAllText(FCurrentFile);
  except
    // best-effort (soubor může být krátce zamčený)
    Result := '';
  end;
end;

procedure TCursorBridge.ProcessCommandFile;
var
  CmdFilePath: string;
  Commands: TStringList;
  Command: string;
  BOM: array[0..2] of Byte;
  FS: TFileStream;
  HasBOM: Boolean;
  DebugFile: string;
  DebugFS: TFileStream;
  DebugMsg: AnsiString;
begin
  CmdFilePath := GetCommandFilePath;
  
  // Pokud soubor neexistuje, nic nedělej
  if not FileExists(CmdFilePath) then
    Exit;
    
  Commands := TStringList.Create;
  try
    try
      // Krátký sleep pro případ že právě probíhá zápis
      Sleep(10);
      
      // Načti příkaz(y) - kontrola BOM
      FS := TFileStream.Create(CmdFilePath, fmOpenRead or fmShareDenyNone);
      try
        HasBOM := False;
        if FS.Size >= 3 then
        begin
          FS.Read(BOM, 3);
          HasBOM := (BOM[0] = $EF) and (BOM[1] = $BB) and (BOM[2] = $BF);
          
          // Pokud nemá BOM, vrať se na začátek
          if not HasBOM then
            FS.Position := 0;
        end;
        
        Commands.LoadFromStream(FS);
      finally
        FS.Free;
      end;
      
      if Commands.Count > 0 then
      begin
        Command := Trim(Commands[0]); // První řádek = příkaz
        
        // Debug: zapiš načtený příkaz - ZAKOMENTOVÁNO
        {try
          DebugFile := GetInstanceDir + 'facmd-debug.txt';
          DebugMsg := FormatDateTime('hh:nn:ss.zzz', Now) + ' [ProcessCommandFile] Načten příkaz: [' + AnsiString(Command) + ']' + #13#10;
          DebugFS := TFileStream.Create(DebugFile, fmOpenWrite or fmShareDenyNone);
          try
            DebugFS.Seek(0, soEnd);
            DebugFS.WriteBuffer(DebugMsg[1], Length(DebugMsg));
          finally
            DebugFS.Free;
          end;
        except
          // Ignoruj chyby debug zápisu
        end;}
        
        // Pokud je příkaz prázdný, přejmenuj soubor s timestampem
        if Command = '' then
        begin
          RenameCommandFileWithTimestamp(CmdFilePath);
          Exit;
        end;
        
        // NEJDŘÍV přejmenuj soubor s timestampem (před voláním callbacku!)
        RenameCommandFileWithTimestamp(CmdFilePath);
        
        // Debug: zapiš před voláním callbacku - ZAKOMENTOVÁNO
        {try
          DebugFile := GetInstanceDir + 'facmd-debug.txt';
          DebugMsg := FormatDateTime('hh:nn:ss.zzz', Now) + ' [ProcessCommandFile] Před voláním callback, Assigned(FOnCommand)=' + BoolToStr(Assigned(FOnCommand), True) + #13#10;
          DebugFS := TFileStream.Create(DebugFile, fmOpenWrite or fmShareDenyNone);
          try
            DebugFS.Seek(0, soEnd);
            DebugFS.WriteBuffer(DebugMsg[1], Length(DebugMsg));
          finally
            DebugFS.Free;
          end;
        except
          // Ignoruj chyby debug zápisu
        end;}
        
        // PAK teprve zavolej callback pro zpracování příkazu
        if Assigned(FOnCommand) then
        begin
          try
            FOnCommand(Command);
            
            // Debug: zapiš po volání callbacku - ZAKOMENTOVÁNO
            {try
              DebugFile := GetInstanceDir + 'facmd-debug.txt';
              DebugMsg := FormatDateTime('hh:nn:ss.zzz', Now) + ' [ProcessCommandFile] Po volání callback' + #13#10;
              DebugFS := TFileStream.Create(DebugFile, fmOpenWrite or fmShareDenyNone);
              try
                DebugFS.Seek(0, soEnd);
                DebugFS.WriteBuffer(DebugMsg[1], Length(DebugMsg));
              finally
                DebugFS.Free;
              end;
            except
              // Ignoruj chyby debug zápisu
            end;}
          except
            on E: Exception do
            begin
              // Debug: zapiš chybu při volání callbacku - ZAKOMENTOVÁNO
              {try
                DebugFile := GetInstanceDir + 'facmd-debug.txt';
                DebugMsg := FormatDateTime('hh:nn:ss.zzz', Now) + ' [ProcessCommandFile] CHYBA při volání callback: ' + AnsiString(E.Message) + #13#10;
                DebugFS := TFileStream.Create(DebugFile, fmOpenWrite or fmShareDenyNone);
                try
                  DebugFS.Seek(0, soEnd);
                  DebugFS.WriteBuffer(DebugMsg[1], Length(DebugMsg));
                finally
                  DebugFS.Free;
                end;
              except
                // Ignoruj chyby debug zápisu
              end;}
            end;
          end;
        end
        else
        begin
          // Debug: callback není nastaven - ZAKOMENTOVÁNO
          {try
            DebugFile := GetInstanceDir + 'facmd-debug.txt';
            DebugMsg := FormatDateTime('hh:nn:ss.zzz', Now) + ' [ProcessCommandFile] CHYBA: FOnCommand není nastaven!' + #13#10;
            DebugFS := TFileStream.Create(DebugFile, fmOpenWrite or fmShareDenyNone);
            try
              DebugFS.Seek(0, soEnd);
              DebugFS.WriteBuffer(DebugMsg[1], Length(DebugMsg));
            finally
              DebugFS.Free;
            end;
          except
            // Ignoruj chyby debug zápisu
          end;}
        end;
      end
      else
      begin
        // Pokud není žádný příkaz, přejmenuj prázdný soubor s timestampem
        RenameCommandFileWithTimestamp(CmdFilePath);
      end;
      
    except
      on E: Exception do
      begin
        // Debug: zapiš chybu - ZAKOMENTOVÁNO
        {try
          DebugFile := GetInstanceDir + 'facmd-debug.txt';
          DebugMsg := FormatDateTime('hh:nn:ss.zzz', Now) + ' [ProcessCommandFile] VÝJIMKA: ' + AnsiString(E.Message) + #13#10;
          DebugFS := TFileStream.Create(DebugFile, fmOpenWrite or fmShareDenyNone);
          try
            DebugFS.Seek(0, soEnd);
            DebugFS.WriteBuffer(DebugMsg[1], Length(DebugMsg));
          finally
            DebugFS.Free;
          end;
        except
          // Ignoruj chyby debug zápisu
        end;}
        
        // Při chybě zkus soubor přejmenovat s timestampem, aby se neblokoval
        try
          RenameCommandFileWithTimestamp(CmdFilePath);
        except
          // Tiše ignoruj chybu při přejmenování
        end;
      end;
    end;
    
  finally
    Commands.Free;
  end;
end;


function TCursorBridge.SettingsFilePath: string;
begin
  // ...\<ExportFolder>\Scripts\_settings.json
  Result := IncludeTrailingPathDelimiter(EffectiveExportFolder)
          + '_settings.json';
end;

// Velmi jednoduché "parser" – stačí najít klíč "editor" a vyčíst hodnotu v uvozovkách.
function TCursorBridge.LoadEditorFromSettings: string;
var
  Pth: string;
  S: AnsiString;
  L, i, j, k: Integer;
  LowS: AnsiString;

  function SkipWs(const T: AnsiString; var Idx: Integer): Boolean;
  begin
    while (Idx <= Length(T)) and (T[Idx] in [#9, #10, #13, ' ']) do Inc(Idx);
    Result := Idx <= Length(T);
  end;

  function NextQuoted(const T: AnsiString; var Idx: Integer): AnsiString;
  var
    q: AnsiChar;
    b: Integer;
  begin
    Result := '';
    if (Idx > Length(T)) or (T[Idx] <> '"') then Exit;
    q := '"';
    Inc(Idx);
    b := Idx;
    while (Idx <= Length(T)) and (T[Idx] <> q) do Inc(Idx);
    if Idx <= Length(T) then
      Result := Copy(T, b, Idx - b)
    else
      Result := '';
  end;

begin
  Result := '';
  Pth := SettingsFilePath;
  if not FileExists(Pth) then Exit;

  // čteme raw (ANSI/UTF-8 bez BOM – necháváme na DB vrstvě/Editoru)
  S := ReadAllText(Pth);
  if S = '' then Exit;

  // case-insensitive hledání klíče "editor"
  LowS := AnsiLowerCase(S);
  i := Pos('"editor"', LowS);
  if i = 0 then Exit;

  // posuň se na dvojtečku
  j := i + Length('"editor"');
  if not SkipWs(LowS, j) then Exit;
  if (j > Length(LowS)) or (LowS[j] <> ':') then Exit;
  Inc(j);
  if not SkipWs(LowS, j) then Exit;

  // očekáváme hodnotu v uvozovkách
  if (j > Length(S)) or (S[j] <> '"') then Exit;

  // přečti quoted hodnotu (z originálního S kvůli zachování velikosti písmen)
  k := j;
  Result := Trim(string(NextQuoted(S, k)));

  // ošetři prázdnou hodnotu
  if Result = '' then Exit;

  // přípustné: 'code', 'cursor', 'code.exe', 'cursor.exe', plná cesta
  // nic dalšího zde nekontrolujeme; ResolveEditorCommand to vyřeší
end;

function TCursorBridge.ResolveEditorCommand: string;
var
  Cmd, NameOnly, Candidate, P, LocalApp, ProgFiles: string;
begin
  // 0) Preferuj hodnotu ze _settings.json, pokud existuje
  Cmd := LoadEditorFromSettings;
  if Cmd = '' then
    Cmd := Trim(FCursorCmdOrPath);  // fallback na property

  // 1) Pokud je zadaná cesta (obsahuje \ nebo :), expanduj proměnné a vrať
  if (Pos('\', Cmd) > 0) or (Pos(':', Cmd) > 0) then
  begin
    Result := ExpandEnv(Cmd);
    Exit;
  end;

  // 2) Základní jméno (bez cesty)
  NameOnly := Cmd;

  // 2a) Pokus o App Paths (preferujeme .exe)
  Candidate := ReadAppPath(NameOnly + '.exe');
  if (Candidate <> '') and FileExists(Candidate) then
  begin
    Result := Candidate;
    Exit;
  end;

  // 2b) PATH – .exe
  Candidate := SearchExeOnPath(NameOnly);
  if (Candidate <> '') and FileExists(Candidate) then
  begin
    Result := Candidate;
    Exit;
  end;

  // 2c) Známé cesty
  LocalApp  := ExpandEnv('%LocalAppData%');
  ProgFiles := ExpandEnv('%ProgramFiles%');

  if SameText(NameOnly, 'code') then
  begin
    P := IncludeTrailingPathDelimiter(LocalApp)  + 'Programs\Microsoft VS Code\Code.exe';
    if FileExists(P) then begin Result := P; Exit; end;
    P := IncludeTrailingPathDelimiter(ProgFiles) + 'Microsoft VS Code\Code.exe';
    if FileExists(P) then begin Result := P; Exit; end;
  end
  else if SameText(NameOnly, 'cursor') then
  begin
    P := IncludeTrailingPathDelimiter(LocalApp) + 'Programs\Cursor\Cursor.exe';
    if FileExists(P) then begin Result := P; Exit; end;
  end;

  // 2d) PATH – .cmd (např. code.cmd)
  Candidate := SearchCmdOnPath(NameOnly);
  if (Candidate <> '') and FileExists(Candidate) then
  begin
    Result := Candidate; // .cmd varianta
    Exit;
  end;

  // 3) Fallback – vrať, ať ShellExecuteEx rozhodne (může být alias)
  Result := NameOnly;
end;

function TCursorBridge.ShellExecNoConsole(const FileName, Params, WorkDir: string; ShowCmd: Integer): Boolean;
var
  SEI: TShellExecuteInfo;
begin
  ZeroMemory(@SEI, SizeOf(SEI));
  SEI.cbSize := SizeOf(SEI);
  SEI.fMask  := SEE_MASK_NO_CONSOLE or SEE_MASK_FLAG_NO_UI;
  SEI.Wnd    := 0;
  SEI.lpVerb := 'open';
  SEI.lpFile := PChar(FileName);
  SEI.lpParameters := PChar(Params);
  SEI.lpDirectory  := PChar(WorkDir);
  SEI.nShow := ShowCmd;
  Result := ShellExecuteEx(@SEI);
end;

function TCursorBridge.RunCursorReuse(const AFolder, AFile: string; ALine, ACol: Integer): Boolean;
var
  Params, FolderArg, FileArg, WS, Cmd, CmdLine, WorkspaceFile: string;
  Ext: string;
  H: HWND;
  UseReuse: Boolean;
  SI: TStartupInfo;
  PI: TProcessInformation;
  FormId: string;
  PreferredEditor: string;
  I: Integer;
  ExistingPIDs: TList;  // Seznam existujících Cursor PIDů (před spuštěním nového)
  PID: DWORD;  // PID okna pro kontrolu, jestli patří novému procesu
begin
  Result := False;
  
  // Zajisti, že máme nastavené instance ID FA (pro instance-specific soubory)
  if FInstanceId = '' then
    FInstanceId := IntToStr(GetCurrentProcessId);
  
  // Získej FormId z FCurrentFormId (nastaveno v StartEditing)
  FormId := FCurrentFormId;
  if FormId = '' then
  begin
    // Fallback: zkus získat FormId z cesty k souboru
    // AFile je např. "dz_15DPFO5252_2\u_dz_15DPFO5252_2.pas"
    WS := ExtractFilePath(AFile);
    WS := ExcludeTrailingPathDelimiter(WS);
    FormId := ExtractFileName(WS);
  end;
  
  // Vytvoř workspace soubor (pokud ještě neexistuje)
  // JEDEN společný workspace pro všechny FA instance
  CreateWorkspaceFile(FormId);
  WorkspaceFile := GetWorkspaceFilePath(FormId);
  FolderArg := '"' + WorkspaceFile + '"';
  
  // Zapiš aktuální FormId do current_form.txt
  // Cursor extension používá tento soubor pro určení, která FA edituje který script
  WriteCurrentForm(FormId);
  
  // FileArg - absolutní cesta k souboru
  if (ALine > 0) and (ACol > 0) then
    FileArg := Format(' -g "%s:%d:%d"', [AFile, ALine, ACol])
  else if (ALine > 0) then
    FileArg := Format(' -g "%s:%d"', [AFile, ALine])
  else
    FileArg := Format(' "%s"', [AFile]);
  
  // Zkontroluj, jestli existuje okno Cursoru s fa_scripts workspace
  UseReuse := IsCursorProcessAlive;
  
  if UseReuse then
  begin
    // Okno Cursoru s fa_scripts existuje - otevři script jako záložku
    H := FindWindowByWorkspaceFile('fa_scripts');
    
    if H <> 0 then
    begin
      // Aktivuj okno
      SetForegroundWindow(H);
      ShowWindow(H, SW_RESTORE);
      Sleep(100);
      
      // Aktualizuj FCursorPID
      GetWindowThreadProcessId(H, @FCursorPID);
      
      // DŮLEŽITÉ: Zapiš identifikační soubory pro TUTO FA instanci!
      // Bez toho Cursor neví o této FA instanci a nemůže ji aktivovat.
      WriteCursorInstanceId;
      WriteInstanceId;
    end;
    
    // -r otevře soubor jako záložku v existujícím okně
    Params := Format('-r %s%s', [FolderArg, FileArg]);
  end
  else
  begin
    // Žádné okno Cursoru s fa_scripts neexistuje - otevři nové okno
    // DŮLEŽITÉ: Zapiš fa_instance.txt PŘED spuštěním Cursoru!
    // Cursor extension potřebuje tento soubor hned při startu, aby věděl o FA instanci.
    WriteInstanceId;
    
    Params := Format('--new-window %s%s', [FolderArg, FileArg]);
    FCursorPID := 0;
  end;

  // Working directory musí být vždy složka, ne workspace soubor
  WS := EffectiveExportFolder;
  
  // Najdi skutečný spustitelný soubor (EXE), případně CMD na PATH
  Cmd := ResolveEditorCommand;
  Ext := LowerCase(ExtractFileExt(Cmd));

  // Před spuštěním nového Cursoru si zapamatuj existující Cursor PIDy
  // aby jsme v aktivním čekání hledali jen nové okno
  ExistingPIDs := nil;
  if not UseReuse then
  begin
    // Spouštíme nový Cursor - načti existující PIDy
    PreferredEditor := UpperCase(BaseName(FCursorCmdOrPath));
    if Pos('CODE', PreferredEditor) > 0 then
    begin
      ExistingPIDs := CollectProcessPIDs('Code.exe');
      if (ExistingPIDs = nil) or (ExistingPIDs.Count = 0) then
      begin
        if Assigned(ExistingPIDs) then ExistingPIDs.Free;
        ExistingPIDs := CollectProcessPIDs('Cursor.exe');
      end;
    end
    else
    begin
      ExistingPIDs := CollectProcessPIDs('Cursor.exe');
      if (ExistingPIDs = nil) or (ExistingPIDs.Count = 0) then
      begin
        if Assigned(ExistingPIDs) then ExistingPIDs.Free;
        ExistingPIDs := CollectProcessPIDs('Code.exe');
      end;
    end;
  end;

  if (Ext = '.cmd') or (Ext = '.bat') then
  begin
    // Pro .cmd/.bat použij ShellExecute (nezískáme PID, ale je to fallback)
    // fa_instance.txt už je vytvořený výše před spuštěním (když UseReuse = false)
    Result := ShellExecNoConsole(Cmd, Params, WS, SW_HIDE);
    // Uvolni seznam existujících PIDů (není potřeba pro .cmd/.bat)
    if Assigned(ExistingPIDs) then
      ExistingPIDs.Free;
  end
  else
  begin
    // EXE – použij CreateProcess aby jsme získali PID
    CmdLine := Format('"%s" %s', [Cmd, Params]);
    
    ZeroMemory(@SI, SizeOf(SI));
    SI.cb := SizeOf(SI);
    SI.dwFlags := STARTF_USESHOWWINDOW;
    SI.wShowWindow := SW_SHOWNORMAL;
    ZeroMemory(@PI, SizeOf(PI));
    
    // Pro nové okno použij CREATE_NEW_CONSOLE + CREATE_NEW_PROCESS_GROUP
    // aby se vytvořil nový proces místo použití existujícího
    Result := CreateProcess(
      nil,                      // lpApplicationName
      PChar(CmdLine),           // lpCommandLine
      nil,                      // lpProcessAttributes
      nil,                      // lpThreadAttributes
      False,                    // bInheritHandles
      CREATE_NEW_CONSOLE or CREATE_NEW_PROCESS_GROUP,  // dwCreationFlags - nový proces group
      nil,                      // lpEnvironment
      PChar(WS),                // lpCurrentDirectory (vždy složka)
      SI,                       // lpStartupInfo
      PI                        // lpProcessInformation
    );
    
    if Result and (not UseReuse) then
    begin
      // Nový cursor spuštěn - PI.dwProcessId je PID launcher procesu
      // který se může rychle ukončit. Musíme najít skutečné okno Cursoru
      // a získat jeho PID.
      
      // Zavři handles launcher procesu
      if PI.hProcess <> 0 then CloseHandle(PI.hProcess);
      if PI.hThread <> 0 then CloseHandle(PI.hThread);
      
      // Aktivní čekání - zkusíme najít NOVÉ okno max 10× po 200ms (max 2s)
      // Většinou stačí 2-4 pokusy (400-800ms)
      H := 0;
      // PreferredEditor už je inicializován před načtením ExistingPIDs
      
      for I := 1 to 10 do
      begin
        Sleep(200);  // 200ms mezi pokusy
        
        // Najdi okno podle workspace souboru v titulku - SPOLEHLIVÉ!
        // Cursor zobrazuje workspace v titulku, např:
        // "FormName - workspace_FormId_FA_12345 (Workspace) - Cursor"
        // (POZOR: Cursor nezobrazuje .code-workspace příponu!)
        if WorkspaceFile <> '' then
        begin
          // Odstraň .code-workspace příponu
          H := FindWindowByWorkspaceFile(ChangeFileExt(ExtractFileName(WorkspaceFile), ''));
          
          // DŮLEŽITÉ: Ověř, že toto okno patří NOVÉMU procesu, ne existujícímu!
          // Pokud Cursor použil existující okno místo vytvoření nového, musíme to detekovat.
          if H <> 0 then
          begin
            // Získej PID okna
            GetWindowThreadProcessId(H, @PID);
            
            // Zkontroluj, jestli tento PID není v seznamu existujících PIDů
            // Pokud je, pak Cursor použil existující okno místo vytvoření nového!
            if Assigned(ExistingPIDs) and (ExistingPIDs.IndexOf(Pointer(PID)) >= 0) then
            begin
              // Cursor použil existující okno - to je problém!
              // Musíme počkat déle nebo zkusit jiný přístup
              H := 0; // Resetuj H, pokračujme v hledání
              Continue;
            end;
          end;
        end
        else
        begin
          // Fallback: hledej podle procesu (starý způsob)
          if Pos('CODE', PreferredEditor) > 0 then
          begin
            H := FindMainWindowOfNewProcess('Code.exe', ExistingPIDs);
            if H = 0 then H := FindMainWindowOfNewProcess('Cursor.exe', ExistingPIDs);
          end
          else
          begin
            H := FindMainWindowOfNewProcess('Cursor.exe', ExistingPIDs);
            if H = 0 then H := FindMainWindowOfNewProcess('Code.exe', ExistingPIDs);
          end;
        end;
        
        if H <> 0 then
          Break;  // Našli jsme okno, končíme čekání!
      end;
      
      // Uvolni seznam existujících PIDů
      if Assigned(ExistingPIDs) then
        ExistingPIDs.Free;
      
      if H <> 0 then
      begin
        // Získej PID skutečného okna
        GetWindowThreadProcessId(H, @FCursorPID);
        WriteCursorInstanceId;
        // Zapiš FA PID do fa_instance.txt (aby Cursor věděl, kam posílat příkazy)
        WriteInstanceId;
      end
      else
      begin
        // Okno nenalezeno ani po 2s - použij PID z launcher procesu (fallback)
        FCursorPID := PI.dwProcessId;
        WriteCursorInstanceId;
        WriteInstanceId;
      end;
    end
    else
    begin
      // UseReuse = True, zavři handles
      if PI.hProcess <> 0 then CloseHandle(PI.hProcess);
      if PI.hThread <> 0 then CloseHandle(PI.hThread);
      // ExistingPIDs by mělo být nil když UseReuse = True, ale pro jistotu uvolníme
      if Assigned(ExistingPIDs) then
        ExistingPIDs.Free;
    end;
  end;
end;

procedure TCursorBridge.ActivateCursorWindow;
var
  H: HWND;
  Preferred: string;
begin
  // Hledej okno podle "fa_scripts" v titulku (společný workspace)
  H := FindWindowByWorkspaceFile('fa_scripts');
  
  if H <> 0 then
  begin
    if IsIconic(H) then
      ShowWindow(H, SW_RESTORE);
    SetForegroundWindow(H);
    
    // Aktualizuj FCursorPID
    GetWindowThreadProcessId(H, @FCursorPID);
    Exit;
  end;
  
  // Fallback: hledej podle názvu procesu
  Preferred := BaseName(FCursorCmdOrPath);

  if Pos('CODE', Preferred) > 0 then
  begin
    H := FindMainWindowOfProcess('Code.exe');
    if H = 0 then H := FindMainWindowOfProcess('Cursor.exe');
  end
  else
  begin
    H := FindMainWindowOfProcess('Cursor.exe');
    if H = 0 then H := FindMainWindowOfProcess('Code.exe');
  end;

  if H <> 0 then
  begin
    if IsIconic(H) then
      ShowWindow(H, SW_RESTORE);
    SetForegroundWindow(H);
  end;
end;

function TCursorBridge.StartEditing(const FormId: string; const Code: AnsiString; JumpLine, JumpCol: Integer): Boolean;
begin
  Result := False;
  if (FormId = '') then Exit;

  // Nastav kontext a cílový soubor
  FCurrentFormId := FormId;
  FCurrentFile   := GetScriptFileName(FormId);

  // Ulož kód na disk (atomicky) a ulož baseline timestamp
  AtomicWriteAllText(FCurrentFile, Code);
  FLastWrite := GetFileWriteTime(FCurrentFile);

  // Zajisti, že máme nastavené instance ID FA (pro instance-specific soubory)
  if FInstanceId = '' then
    FInstanceId := IntToStr(GetCurrentProcessId);
  
  // Načti uložený PID cursoru (pokud existuje) pro detekci běžící instance
  ReadCursorInstanceId;
  
  // Pokud máme běžící Cursor, zapiš FA PID do fa_instance_{CURSOR_PID}.txt
  // (pokud Cursor ještě neběží, zapíše se po jeho spuštění v RunCursorReuse)
  if FCursorPID <> 0 then
    WriteInstanceId;

  // Otevři/reuse editor ve workspace a aktivuj okno
  // RunCursorReuse automaticky:
  // - Pokud cursor této FA instance běží → použije -r pro reuse
  // - Pokud neběží → spustí nový cursor a uloží jeho PID
  Result := RunCursorReuse(EffectiveExportFolder, FCurrentFile, JumpLine, JumpCol);
  ActivateCursorWindow;
end;

function TCursorBridge.BringToCursor(const Code: AnsiString; JumpLine, JumpCol: Integer): Boolean;
begin
  Result := False;
  if (FCurrentFormId = '') or (FCurrentFile = '') then Exit;

  // Přepiš obsah na disku aktuálním kódem a posuň baseline
  AtomicWriteAllText(FCurrentFile, Code);
  FLastWrite := GetFileWriteTime(FCurrentFile);

  // Přepni fokus do existujícího okna, skok na pozici
  Result := RunCursorReuse(EffectiveExportFolder, FCurrentFile, JumpLine, JumpCol);
  ActivateCursorWindow;
end;

procedure TCursorBridge.PollTick;
var
  T: TDateTime;
  Txt: AnsiString;
begin
  // Pokud nemáme otevřený soubor v Cursoru, přeskoč kontrolu
  if FCurrentFile = '' then
    Exit;
    
  // Pokud právě zavíráme záložku, přeskoč kontrolu změn souboru
  // (aby se předešlo falešné detekci změny způsobené zavřením záložky)
  if FIsClosingFile then
    Exit;
  
  // Kontrola změn v editovaném souboru (Ctrl+S v editoru)
  // zakázáno, nejde používat pro AI, kdy průběžně ukládá
 { if (FCurrentFile <> '') then
  begin
    T := GetFileWriteTime(FCurrentFile);
    if (T > 0) and (T > FLastWrite) then
    begin
      // Debug výpis - detekována změna časového razítka
      if Assigned(FOnExternalSave) then
      begin
        // Zkus načíst obsah souboru
        try
          Txt := ReadAllText(FCurrentFile);
        except
          // best-effort (soubor může být krátce zamčený)
          Txt := '';
        end;

        if (Txt <> '') then
        begin
          FLastWrite := T;
          FOnExternalSave(Txt);
        end;
      end;
    end;
  end;}

  // Kontrola příkazů z Cursor extension
  ProcessCommandFile;
end;

function TCursorBridge.ReadFieldText: string;
var
  FieldFilePath: string;
  Fields: TStringList;
  BOM: array[0..2] of Byte;
  FS: TFileStream;
  HasBOM: Boolean;
begin
  Result := '';
  FieldFilePath := GetFieldFilePath;
  
  // Pokud soubor neexistuje, vrať prázdný řetězec
  if not FileExists(FieldFilePath) then
    Exit;
    
  Fields := TStringList.Create;
  try
    try
      // Načti obsah - kontrola BOM
      FS := TFileStream.Create(FieldFilePath, fmOpenRead or fmShareDenyNone);
      try
        HasBOM := False;
        if FS.Size >= 3 then
        begin
          FS.Read(BOM, 3);
          HasBOM := (BOM[0] = $EF) and (BOM[1] = $BB) and (BOM[2] = $BF);
          
          // Pokud nemá BOM, vrať se na začátek
          if not HasBOM then
            FS.Position := 0;
        end;
        
        Fields.LoadFromStream(FS);
      finally
        FS.Free;
      end;
      
      // Vrať první řádek (nebo celý obsah pokud je to jen jeden řádek)
      if Fields.Count > 0 then
        Result := Trim(Fields[0])
      else
        Result := '';
        
    except
      // Při chybě čtení vrať prázdný řetězec
      Result := '';
    end;
    
  finally
    Fields.Free;
  end;
end;

procedure TCursorBridge.WriteFieldText(const FieldName: string);
var
  FieldFilePath: string;
  TmpPath: string;
  FS: TFileStream;
  BOM: array[0..2] of Byte;
  Content: AnsiString;
begin
  FieldFilePath := GetFieldFilePath;
  
  // Zajisti že .fsbridge složka existuje
  EnsureDir(ExtractFilePath(FieldFilePath));
  
  // Atomický zápis přes tmp soubor
  TmpPath := FieldFilePath + '.tmp';
  
  FS := TFileStream.Create(TmpPath, fmCreate or fmShareDenyWrite);
  try
    // Zapiš UTF-8 BOM (EF BB BF)
    BOM[0] := $EF;
    BOM[1] := $BB;
    BOM[2] := $BF;
    FS.WriteBuffer(BOM, 3);
    
    // Zapiš obsah jako UTF-8 (bez trailing newline)
    if FieldName <> '' then
    begin
      Content := UTF8Encode(FieldName);
      FS.WriteBuffer(Content[1], Length(Content));
    end;
  finally
    FS.Free;
  end;
  
  // Atomická výměna
  MoveFileEx(PChar(TmpPath), PChar(FieldFilePath), 
             MOVEFILE_REPLACE_EXISTING or MOVEFILE_WRITE_THROUGH);
end;


procedure TCursorBridge.WriteMsgState(const StateJson: string);
var
  StatePath: string;
  TmpPath: string;
  FS: TFileStream;
  BOM: array[0..2] of Byte;
  Content: AnsiString;
begin
  // Stav z Msg pro Cursor extension: <workspace>/.fsbridge/famsgstate.json
  StatePath := IncludeTrailingPathDelimiter(EffectiveExportFolder)
            + '.fsbridge' + PathDelim
            + 'famsgstate.json';
  
  // Zajisti že .fsbridge složka existuje
  EnsureDir(ExtractFilePath(StatePath));
  
  // Atomický zápis přes tmp soubor
  TmpPath := StatePath + '.tmp';
  
  FS := TFileStream.Create(TmpPath, fmCreate or fmShareDenyWrite);
  try
    // Zapiš UTF-8 BOM (EF BB BF)
    BOM[0] := $EF;
    BOM[1] := $BB;
    BOM[2] := $BF;
    FS.WriteBuffer(BOM, 3);
    
    // Zapiš obsah jako UTF-8
    if StateJson <> '' then
    begin
      Content := UTF8Encode(StateJson);
      FS.WriteBuffer(Content[1], Length(Content));
    end;
  finally
    FS.Free;
  end;
  
  // Atomická výměna
  MoveFileEx(PChar(TmpPath), PChar(StatePath), 
             MOVEFILE_REPLACE_EXISTING or MOVEFILE_WRITE_THROUGH);
end;

// ============================================================================
// Kontrola neuložených změn a zavření souboru v Cursoru
// ============================================================================

function TCursorBridge.GetResponseFilePath: string;
begin
  // Odpověď z Cursor extension: <workspace>/.fsbridge/{FA_PID}/facmd_response.txt
  Result := GetInstanceDir + 'facmd_response.txt';
end;

function TCursorBridge.GetFACommandFilePath: string;
begin
  // Příkazy z FA do Cursor extension: <workspace>/.fsbridge/{FA_PID}/facmd_from_fa.txt
  // facmd.txt je pouze pro komunikaci z Cursoru do FA!
  Result := GetInstanceDir + 'facmd_from_fa.txt';
end;

procedure TCursorBridge.WriteFACommandToFile(const Command: string);
var
  CmdFilePath: string;
  Content: AnsiString;
  RetryCount: Integer;
  Success: Boolean;
begin
  // Použij facmd_from_fa.txt místo facmd.txt (který je pouze pro komunikaci z Cursoru do FA)
  // Atomický zápis s retry mechanismem
  CmdFilePath := GetFACommandFilePath;
  EnsureDir(ExtractFilePath(CmdFilePath));
  
  Content := AnsiString(Command);
  Success := False;
  RetryCount := 0;
  
  while (not Success) and (RetryCount < 5) do
  begin
    try
      AtomicWriteAllText(CmdFilePath, Content);
      Success := True;
    except
      Inc(RetryCount);
      if RetryCount < 5 then
        Sleep(50); // Počkej 50ms před dalším pokusem
      // Pokud se nepodaří ani po 5 pokusech, tiše ignoruj
    end;
  end;
end;

function TCursorBridge.CheckAndCloseCursorFile: TCursorCloseResult;
var
  ResponseFile: string;
  Response: string;
  SL: TStringList;
  MaxWait: Integer;
  I: Integer;
  CommandFile: string;
  RetryCount: Integer;
begin
  Result := ccrError;
  
  // Pokud Cursor neběží, není co zavírat
  if not IsCursorProcessAlive then
  begin
    Result := ccrNotOpen;
    Exit;
  end;
  
  // Zakáže PollTick během zavírání záložky
  FIsClosingFile := True;
  try
    // Cesta k souboru pro odpověď z Cursor extension
    ResponseFile := GetResponseFilePath;
    CommandFile := GetFACommandFilePath; // facmd_from_fa.txt (ne facmd.txt!)
    
    // Smaž starou odpověď (pokud existuje) - ošetřeno proti zamykání souboru
    if FileExists(ResponseFile) then
    begin
      try
        DeleteFile(ResponseFile);
      except
        // Ignoruj chybu - soubor může být zamčený, ale to nevadí
      end;
    end;
    
    // Pošli příkaz do Cursor extension přes facmd_from_fa.txt
    WriteFACommandToFile('check_unsaved_and_close');
    
    // Debug: Zkontroluj, že příkaz byl zapsán
    if not FileExists(CommandFile) then
    begin
      // Příkaz se nezapsal - extension ho nemůže přečíst
      Result := ccrError;
      Exit;
    end;
    
    // Počkej na odpověď (max 5 sekund, každých 100ms kontrola)
    MaxWait := 50; // 50 × 100ms = 5 sekund
    for I := 1 to MaxWait do
    begin
      Sleep(100);
      if FileExists(ResponseFile) then
      begin
        // Načti odpověď - s retry mechanismem pro případ zamykání souboru
        SL := TStringList.Create;
        try
          // Zkus načíst soubor (max 3 pokusy s krátkým čekáním)
          RetryCount := 1;
          while RetryCount <= 3 do
          begin
            try
              SL.LoadFromFile(ResponseFile);
              Break; // Úspěch - pokračuj
            except
              if RetryCount < 3 then
              begin
                Sleep(50); // Počkej 50ms před dalším pokusem
                Inc(RetryCount);
              end
              else
                raise; // Po 3 pokusech přehod výjimku
            end;
          end;
          
          if SL.Count > 0 then
          begin
            Response := Trim(SL[0]);
            
            // Smaž soubor s odpovědí - ošetřeno proti zamykání
            try
              DeleteFile(ResponseFile);
            except
              // Ignoruj chybu - soubor může být zamčený, ale už jsme ho načetli
            end;
            
            if SameText(Response, 'OK') then
            begin
              Result := ccrClosed;
              // DŮLEŽITÉ: Aktualizuj FLastWrite, aby PollTick nedetekoval změnu
              // způsobenou zavřením záložky v Cursoru
              if (FCurrentFile <> '') and FileExists(FCurrentFile) then
                FLastWrite := GetFileWriteTime(FCurrentFile);
              Exit;
            end
            else if Pos('UNSAVED:', Response) = 1 then
            begin
              Result := ccrUnsaved;
              Exit;
            end
            else if SameText(Response, 'NOT_OPEN') then
            begin
              Result := ccrNotOpen;
              Exit;
            end;
          end;
        finally
          SL.Free;
        end;
      end;
    end;
    
    // Timeout - Cursor extension neodpověděl
    Result := ccrError;
  finally
    // Znovu povol PollTick
    FIsClosingFile := False;
  end;
end;

// Pomocná funkce pro čtení odpovědi z Cursor extension
function TCursorBridge.ReadCursorResponse(const Command: string; out Response: string): TCursorCloseResult;
var
  ResponseFile: string;
  SL: TStringList;
  MaxWait: Integer;
  I: Integer;
  CommandFile: string;
  RetryCount: Integer;
begin
  Result := ccrError;
  Response := '';
  
  // Pokud Cursor neběží, není co kontrolovat
  if not IsCursorProcessAlive then
  begin
    Result := ccrNotOpen;
    Exit;
  end;
  
  // Cesta k souboru pro odpověď z Cursor extension
  ResponseFile := GetResponseFilePath;
  CommandFile := GetFACommandFilePath; // facmd_from_fa.txt (ne facmd.txt!)
  
  // Smaž starou odpověď (pokud existuje) - ošetřeno proti zamykání souboru
  if FileExists(ResponseFile) then
  begin
    try
      DeleteFile(ResponseFile);
    except
      // Ignoruj chybu - soubor může být zamčený, ale to nevadí
    end;
  end;
  
  // Pošli příkaz do Cursor extension přes facmd_from_fa.txt
  WriteFACommandToFile(Command);
  
  // Debug: Zkontroluj, že příkaz byl zapsán
  if not FileExists(CommandFile) then
  begin
    // Příkaz se nezapsal - extension ho nemůže přečíst
    Result := ccrError;
    Exit;
  end;
  
  // Počkej na odpověď (max 1 sekunda, každých 100ms kontrola)
  MaxWait := 10; // 10 × 100ms = 1 sekunda
  for I := 1 to MaxWait do
  begin
    Sleep(100);
    if FileExists(ResponseFile) then
    begin
      // Načti odpověď - s retry mechanismem pro případ zamykání souboru
      SL := TStringList.Create;
      try
        // Zkus načíst soubor (max 3 pokusy s krátkým čekáním)
        RetryCount := 1;
        while RetryCount <= 3 do
        begin
          try
            SL.LoadFromFile(ResponseFile);
            Break; // Úspěch - pokračuj
          except
            if RetryCount < 3 then
            begin
              Sleep(50); // Počkej 50ms před dalším pokusem
              Inc(RetryCount);
            end
            else
              raise; // Po 3 pokusech přehod výjimku
          end;
        end;
        
        if SL.Count > 0 then
        begin
          Response := Trim(SL[0]);
          
          // Smaž soubor s odpovědí - ošetřeno proti zamykání
          try
            DeleteFile(ResponseFile);
          except
            // Ignoruj chybu - soubor může být zamčený, ale už jsme ho načetli
          end;
          
          if SameText(Response, 'OK') then
          begin
            Result := ccrClosed;
            Exit;
          end
          else if Pos('UNSAVED:', Response) = 1 then
          begin
            Result := ccrUnsaved;
            Exit;
          end
          else if SameText(Response, 'NOT_OPEN') then
          begin
            Result := ccrNotOpen;
            Exit;
          end;
        end;
      finally
        SL.Free;
      end;
    end;
  end;
  
  // Timeout - Cursor extension neodpověděl
  Result := ccrError;
end;

function TCursorBridge.CheckUnsavedChanges: TCursorCloseResult;
var
  Response: string;
begin
  Result := ReadCursorResponse('check_unsaved', Response);
end;

function TCursorBridge.CloseCursorFile: TCursorCloseResult;
var
  Response: string;
begin
  // Zakáže PollTick během zavírání záložky
  FIsClosingFile := True;
  try
    Result := ReadCursorResponse('close_file', Response);
    
    // Pokud bylo zavření úspěšné, aktualizuj FLastWrite
    if Result = ccrClosed then
    begin
      // DŮLEŽITÉ: Aktualizuj FLastWrite, aby PollTick nedetekoval změnu
      // způsobenou zavřením záložky v Cursoru
      if (FCurrentFile <> '') and FileExists(FCurrentFile) then
        FLastWrite := GetFileWriteTime(FCurrentFile);
    end;
  finally
    // Znovu povol PollTick
    FIsClosingFile := False;
  end;
end;

procedure TCursorBridge.ClearCurrentFile;
begin
  FCurrentFile := '';
  FCurrentFormId := '';
end;

function TCursorBridge.IsScriptOpenInCursor: Boolean;
var
  ResponseFile: string;
  Response: string;
  SL: TStringList;
  MaxWait: Integer;
  I: Integer;
  CommandFile: string;
  RetryCount: Integer;
begin
  Result := False;
  
  // Pokud Cursor neběží, script není otevřený
  if not IsCursorProcessAlive then
  begin
    Exit;
  end;
  
  // Cesta k souboru pro odpověď z Cursor extension
  ResponseFile := GetResponseFilePath;
  CommandFile := GetFACommandFilePath; // facmd_from_fa.txt
  
  // Smaž starou odpověď (pokud existuje)
  if FileExists(ResponseFile) then
  begin
    try
      DeleteFile(ResponseFile);
    except
      // Ignoruj chybu
    end;
  end;
  
  // Pošli příkaz do Cursor extension přes facmd_from_fa.txt
  WriteFACommandToFile('check_if_open');
  
  // Počkej na odpověď (max 2 sekundy, každých 100ms kontrola)
  MaxWait := 20; // 20 × 100ms = 2 sekundy
  for I := 1 to MaxWait do
  begin
    Sleep(100);
    if FileExists(ResponseFile) then
    begin
      // Načti odpověď - s retry mechanismem
      SL := TStringList.Create;
      try
        RetryCount := 1;
        while RetryCount <= 3 do
        begin
          try
            SL.LoadFromFile(ResponseFile);
            Break; // Úspěšně načteno
          except
            if RetryCount < 3 then
              Sleep(50);
            Inc(RetryCount);
          end;
        end;
        
        if SL.Count > 0 then
        begin
          Response := Trim(SL[0]);
          // Odstraň BOM pokud existuje
          if (Length(Response) > 0) and (Ord(Response[1]) = $FEFF) then
            Delete(Response, 1, 1);
          Response := Trim(Response);
          
          // Odpověď 'OPEN' znamená, že script je otevřený
          Result := (Response = 'OPEN');
        end;
      finally
        SL.Free;
      end;
      
      // Smaž odpověď po přečtení
      try
        DeleteFile(ResponseFile);
      except
        // Ignoruj chybu
      end;
      
      Exit; // Odpověď byla přečtena
    end;
  end;
  
  // Timeout - script pravděpodobně není otevřený
  Result := False;
end;

// ============================================================================
// Mazání starých složek instance
// ============================================================================

function TCursorBridge.IsFAProcessAlive(PID: DWORD): Boolean;
var
  Snap: THandle;
  Pe32: TProcessEntry32;
  FAExeName: string;
begin
  Result := False;
  
  // Získej název vlastního exe souboru (FA.exe)
  FAExeName := ExtractFileName(ParamStr(0));
  
  // Projdi všechny běžící procesy
  Snap := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if Snap = INVALID_HANDLE_VALUE then Exit;
  
  try
    ZeroMemory(@Pe32, SizeOf(Pe32));
    Pe32.dwSize := SizeOf(Pe32);
    
    if Process32First(Snap, Pe32) then
    repeat
      // Zkontroluj PID a název exe
      if (Pe32.th32ProcessID = PID) and 
         SameText(ExtractFileName(Pe32.szExeFile), FAExeName) then
      begin
        Result := True;
        Break;
      end;
    until not Process32Next(Snap, Pe32);
  finally
    CloseHandle(Snap);
  end;
end;

function TCursorBridge.DeleteDirectory(const DirName: string; OnlyChildren: Boolean): Boolean;
var
  FileOp: TSHFileOpStruct;
  Dir: string;
begin
  Result := False;
  Dir := DirName;
  
  // Přidej dvojité null terminator pro SHFileOperation
  if Dir[Length(Dir)] <> #0 then
    Dir := Dir + #0;
  Dir := Dir + #0;
  
  ZeroMemory(@FileOp, SizeOf(FileOp));
  with FileOp do
  begin
    wFunc := FO_DELETE;
    pFrom := PChar(Dir);
    fFlags := FOF_NOCONFIRMATION or FOF_SILENT or FOF_NOERRORUI;
  end;
  
  Result := (SHFileOperation(FileOp) = 0) and (not FileOp.fAnyOperationsAborted);
end;

procedure TCursorBridge.CleanupOldInstanceFolders;
var
  FsBridgeDir: string;
  SearchRec: TSearchRec;
  PID: Integer;
  PIDStr: string;
  InstancePath: string;
begin
  FsBridgeDir := IncludeTrailingPathDelimiter(EffectiveExportFolder) + '.fsbridge';
  
  if not DirectoryExists(FsBridgeDir) then
    Exit;
  
  if FindFirst(FsBridgeDir + PathDelim + '*', faDirectory, SearchRec) = 0 then
  begin
    try
      repeat
        if (SearchRec.Name = '.') or (SearchRec.Name = '..') then
          Continue;
        
        if (SearchRec.Attr and faDirectory) = 0 then
          Continue;
        
        // Přeskoč workspace soubor (není složka)
        if SameText(SearchRec.Name, 'fa_scripts.code-workspace') then
          Continue;
        
        PIDStr := SearchRec.Name;
        if not TryStrToInt(PIDStr, PID) then
          Continue;
        
        // Přeskoč vlastní složku této instance (ta se maže v destruktoru)
        if PIDStr = FInstanceId then
          Continue;
        
        // Zkontroluj, jestli proces s tímto PID ještě běží
        if not IsFAProcessAlive(PID) then
        begin
          // Proces neběží - bezpečně smaž složku
          InstancePath := IncludeTrailingPathDelimiter(FsBridgeDir) + PIDStr;
          try
            DeleteDirectory(InstancePath, False);
          except
            // Při chybě tiše pokračuj (složka může být zamčená)
          end;
        end;
      until FindNext(SearchRec) <> 0;
    finally
      FindClose(SearchRec);
    end;
  end;
end;

function TCursorBridge.GetEffectiveExportFolder: string;
begin
  Result := EffectiveExportFolder;
end;

destructor TCursorBridge.Destroy;
var
  InstancePath: string;
begin
  // 1. Smaž vlastní složku této instance
  if FInstanceId <> '' then
  begin
    InstancePath := GetInstanceDir;
    if DirectoryExists(InstancePath) then
    begin
      try
        DeleteDirectory(InstancePath, False);
      except
        // Při chybě tiše ignoruj (složka může být zamčená)
      end;
    end;
  end;
  
  // 2. Vyčisti všechny ostatní staré složky (kde proces neběží)
  CleanupOldInstanceFolders;
  
  inherited;
end;

end.
