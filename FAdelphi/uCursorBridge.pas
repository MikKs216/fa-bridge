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
- Soubor facmd.txt se maže OKAMŽITĚ po přečtení (před voláním callbacku) aby se předešlo nekonečné smyčce
- Čtení dat z .fsbridge/fafield.txt pomocí ReadFieldText() (obsah fieldu z Cursor extension)
- Zápis dat do .fsbridge/fafield.txt pomocí WriteFieldText() (atomicky s UTF-8 BOM)
- Podpora příkazů: Polling pro čtení příkazů z .fsbridge/fadebug.txt a callback OnDebuggerCommand

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
  Bridge.OnDebuggerCommand := ProcessDebugCommand; // callback pro příkazy z fadebug.txt
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
  
  // Předá debugger příkaz z Cursor extension
  TDebuggerCommandEvent = procedure(const Command: string) of object;

  TCursorBridge = class
  private
    FExportFolder: string;       // uživatelsky nastaveno (může být relativní k EXE)
    FCursorCmdOrPath: string;    // 'cursor' | 'code' | plná cesta k EXE

    FCurrentFormId: string;
    FCurrentFile: string;
    FLastWrite: TDateTime;
    FInstanceId: string;         // PID této instance FA pro více-instanční podporu
    FCursorPID: DWORD;           // PID spuštěného cursoru pro tuto instanci FA

    FOnExternalSave: TExternalSaveEvent;
    FOnCommand: TCommandEvent;
    FOnDebuggerCommand: TDebuggerCommandEvent;

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
    procedure ActivateCursorWindow;

    // Nové pomocné metody pro spouštění editoru bez konzole
    function ResolveEditorCommand: string;
    function ShellExecNoConsole(const FileName, Params, WorkDir: string; ShowCmd: Integer): Boolean;
    
    // Zpracování příkazů z Cursor extension
    function GetCommandFilePath: string;
    procedure ProcessCommandFile;
    
    // Podpora příkazů
    function GetDebugFilePath: string;
    procedure ProcessDebugFile;
    
    // Čtení field.txt ze Cursor extension
    function GetFieldFilePath: string;
    
    // Podpora více instancí FA - složka pro každou instanci
    function GetInstanceDir: string;
    function GetInstanceFilePath: string;
    procedure WriteInstanceId;
    function ReadInstanceId: string;
    
    // Podpora párování FA-Cursor instance
    function GetCursorInstanceFilePath: string;
    procedure WriteCursorInstanceId;
    function ReadCursorInstanceId: DWORD;
    function IsCursorProcessAlive: Boolean;
    function FindWindowByPID(PID: DWORD): HWND;
    
    // Podpora multi-root workspace souborů
    function GetWorkspaceFilePath(const FormId: string): string;
    function CreateWorkspaceFile(const FormId: string): Boolean;
    function EscapeJsonString(const S: string): string;
  public
    constructor Create;

    // Konfigurace před použitím
    property ExportFolder: string read FExportFolder write FExportFolder;           // např. 'DataPrg\FormsProject'
    property CursorCmdOrPath: string read FCursorCmdOrPath write FCursorCmdOrPath; // 'code' / 'cursor' / plná cesta

    // Stav
    property CurrentFormId: string read FCurrentFormId;
    property CurrentFile: string read FCurrentFile;

    // Události
    property OnExternalSave: TExternalSaveEvent read FOnExternalSave write FOnExternalSave;
    property OnCommand: TCommandEvent read FOnCommand write FOnCommand;
    property OnDebuggerCommand: TDebuggerCommandEvent read FOnDebuggerCommand write FOnDebuggerCommand;

    // Hlavní API
    function StartEditing(const FormId: string; const Code: AnsiString; JumpLine, JumpCol: Integer): Boolean;
    function BringToCursor(const Code: AnsiString; JumpLine, JumpCol: Integer): Boolean;
    procedure PollTick;
    
    // Čtení a zápis dat z/do Cursor extension
    function ReadFieldText: string; // Přečte obsah fafield.txt
    procedure WriteFieldText(const FieldName: string); // Zapíše název fieldu do fafield.txt
    
    // Debugger podpora
    procedure WriteMsgState(const StateJson: string); // Zapíše stav z Msg do famsgstate.json (UTF-8 s BOM)
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

function FindMainWindowOfProcess(const ExeName: string): HWND;
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
        TargetPID := Pe32.th32ProcessID;
        Break;
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

function TCursorBridge.GetInstanceFilePath: string;
begin
  // Instance ID soubor: <workspace>/.fsbridge/{FA_PID}/fa_instance.txt
  Result := GetInstanceDir + 'fa_instance.txt';
end;

procedure TCursorBridge.WriteInstanceId;
var
  InstanceFile: string;
  SL: TStringList;
begin
  // Zapíše PID této instance FA do fa_instance.txt
  FInstanceId := IntToStr(GetCurrentProcessId);
  InstanceFile := GetInstanceFilePath;
  
  // Zajisti existenci složky .fsbridge
  EnsureDir(ExtractFilePath(InstanceFile));
  
  SL := TStringList.Create;
  try
    SL.Text := FInstanceId;
    SL.SaveToFile(InstanceFile);
  finally
    SL.Free;
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
  SL: TStringList;
begin
  // Zapíše PID spuštěného cursoru do cursor_instance.txt
  if FCursorPID = 0 then Exit;
  
  InstanceFile := GetCursorInstanceFilePath;
  
  // Zajisti existenci složky .fsbridge
  EnsureDir(ExtractFilePath(InstanceFile));
  
  SL := TStringList.Create;
  try
    SL.Text := IntToStr(FCursorPID);
    SL.SaveToFile(InstanceFile);
  finally
    SL.Free;
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

function TCursorBridge.IsCursorProcessAlive: Boolean;
var
  PID: DWORD;
  H: THandle;
  ExitCode: DWORD;
begin
  Result := False;
  PID := ReadCursorInstanceId;
  if PID = 0 then Exit;
  
  H := OpenProcess(PROCESS_QUERY_INFORMATION, False, PID);
  if H <> 0 then
  begin
    try
      if GetExitCodeProcess(H, ExitCode) then
        Result := (ExitCode = STILL_ACTIVE);
    finally
      CloseHandle(H);
    end;
  end;
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
var
  InstanceId: string;
begin
  // Workspace soubor: <workspace>/.fsbridge/workspace_{FormId}_FA_{PID}.code-workspace
  // Trvalý soubor pro každou dvojici FormId + FA instance (PID)
  if FInstanceId = '' then
    FInstanceId := IntToStr(GetCurrentProcessId);
  
  InstanceId := FInstanceId;
  Result := IncludeTrailingPathDelimiter(EffectiveExportFolder)
          + '.fsbridge' + PathDelim
          + 'workspace_' + FormId + '_FA_' + InstanceId + '.code-workspace';
end;

function TCursorBridge.CreateWorkspaceFile(const FormId: string): Boolean;
var
  WorkspaceFile: string;
  ScriptFolder: string;
  CommonFolder: string;
  InstanceFolder: string;
  SL: TStringList;
  JsonContent: string;
begin
  Result := False;
  
  // Zajisti FInstanceId
  if FInstanceId = '' then
    FInstanceId := IntToStr(GetCurrentProcessId);
  
  // Cesty k workspace složkám (absolutní)
  ScriptFolder := IncludeTrailingPathDelimiter(EffectiveExportFolder) + FormId;
  CommonFolder := EffectiveExportFolder; // Celá Scripts složka jako sekundární workspace
  // Instance-specifická složka - zajistí unikátnost workspace pro každou FA instanci
  // i když pracují se stejným formulářem
  InstanceFolder := IncludeTrailingPathDelimiter(EffectiveExportFolder) + '.fsbridge' + PathDelim + FInstanceId;
  
  // Zajisti existenci instance složky
  EnsureDir(InstanceFolder);
  
  // Escape cesty pro JSON (obrácená lomítka -> dvojitá obrácená lomítka)
  ScriptFolder := StringReplace(ScriptFolder, '\', '\\', [rfReplaceAll]);
  CommonFolder := StringReplace(CommonFolder, '\', '\\', [rfReplaceAll]);
  InstanceFolder := StringReplace(InstanceFolder, '\', '\\', [rfReplaceAll]);
  
  // Vytvoř JSON obsah workspace souboru
  // Třetí složka (Instance) zajistí, že Cursor bude považovat každý workspace za unikátní
  JsonContent := '{' + #13#10 +
    '  "folders": [' + #13#10 +
    '    {' + #13#10 +
    '      "path": "' + ScriptFolder + '",' + #13#10 +
    '      "name": "Script: ' + EscapeJsonString(FormId) + '"' + #13#10 +
    '    },' + #13#10 +
    '    {' + #13#10 +
    '      "path": "' + CommonFolder + '",' + #13#10 +
    '      "name": "Common Files"' + #13#10 +
    '    },' + #13#10 +
    '    {' + #13#10 +
    '      "path": "' + InstanceFolder + '",' + #13#10 +
    '      "name": "FA Instance ' + FInstanceId + '"' + #13#10 +
    '    }' + #13#10 +
    '  ],' + #13#10 +
    '  "settings": {}' + #13#10 +
    '}';
  
  // Cesta k workspace souboru
  WorkspaceFile := GetWorkspaceFilePath(FormId);
  
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
  // Příkazy z Cursor extension: <workspace>/.fsbridge/{FA_PID}/facmd.txt
  Result := GetInstanceDir + 'facmd.txt';
end;

function TCursorBridge.GetFieldFilePath: string;
begin
  // Field data z Cursor extension: <workspace>/.fsbridge/{FA_PID}/fafield.txt
  Result := GetInstanceDir + 'fafield.txt';
end;

function TCursorBridge.GetDebugFilePath: string;
begin
  // Debugger příkazy z Cursor extension: <workspace>/.fsbridge/{FA_PID}/fadebug.txt
  Result := GetInstanceDir + 'fadebug.txt';
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

procedure TCursorBridge.ProcessCommandFile;
var
  CmdFilePath: string;
  Commands: TStringList;
  Command: string;
  BOM: array[0..2] of Byte;
  FS: TFileStream;
  HasBOM: Boolean;
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
        
        // Pokud je příkaz prázdný, jen smaž soubor
        if Command = '' then
        begin
          DeleteFile(CmdFilePath);
          Exit;
        end;
        
        // NEJDŘÍV smaž soubor (před voláním callbacku!)
        DeleteFile(CmdFilePath);
        
        // PAK teprve zavolej callback pro zpracování příkazu
        if Assigned(FOnCommand) then
          FOnCommand(Command);
      end
      else
      begin
        // Pokud není žádný příkaz, smaž prázdný soubor
        DeleteFile(CmdFilePath);
      end;
      
    except
      // Při chybě zkus soubor smazat, aby se neblokoval
      try
        DeleteFile(CmdFilePath);
      except
        // Tiše ignoruj chybu při mazání
      end;
    end;
    
  finally
    Commands.Free;
  end;
end;

procedure TCursorBridge.ProcessDebugFile;
var
  DebugFilePath: string;
  Commands: TStringList;
  Command: string;
  BOM: array[0..2] of Byte;
  FS: TFileStream;
  HasBOM: Boolean;
begin
  DebugFilePath := GetDebugFilePath;
  
  // Pokud soubor neexistuje, nic nedělej
  if not FileExists(DebugFilePath) then
    Exit;
    
  Commands := TStringList.Create;
  try
    try
      // Krátký sleep pro případ že právě probíhá zápis
      Sleep(10);
      
      // Načti příkaz(y) - kontrola BOM
      FS := TFileStream.Create(DebugFilePath, fmOpenRead or fmShareDenyNone);
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
        
        // Pokud je příkaz prázdný, jen smaž soubor
        if Command = '' then
        begin
          DeleteFile(DebugFilePath);
          Exit;
        end;
        
        // NEJDŘÍV smaž soubor (před voláním callbacku!)
        DeleteFile(DebugFilePath);
        
        // PAK teprve zavolej callback pro zpracování příkazu
        if Assigned(FOnDebuggerCommand) then
          FOnDebuggerCommand(Command);
      end
      else
      begin
        // Pokud není žádný příkaz, smaž prázdný soubor
        DeleteFile(DebugFilePath);
      end;
      
    except
      // Při chybě zkus soubor smazat, aby se neblokoval
      try
        DeleteFile(DebugFilePath);
      except
        // Tiše ignoruj chybu při mazání
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
  UseWorkspaceFile: Boolean;
  SI: TStartupInfo;
  PI: TProcessInformation;
  FormId: string;
  RelativeFile: string;
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
  
  // Urči, jestli používáme workspace soubor
  UseWorkspaceFile := False;
  RelativeFile := '';
  
  if FormId <> '' then
  begin
    // Vytvoř workspace soubor pro multi-root workspace
    if CreateWorkspaceFile(FormId) then
    begin
      // Použij workspace soubor místo složky
      WorkspaceFile := GetWorkspaceFilePath(FormId);
      FolderArg := '"' + WorkspaceFile + '"';
      
      // Pro workspace soubor musíme použít relativní cestu k souboru vzhledem k primárnímu workspace
      // Primární workspace je složka scriptu: EffectiveExportFolder + '\' + FormId
      // Soubor je: EffectiveExportFolder + '\' + FormId + '\' + ExtractFileName(AFile)
      RelativeFile := ExtractFileName(AFile);
      UseWorkspaceFile := True;
    end;
  end;
  
  // Zkontroluj, jestli MÁ TATO INSTANCE FA běžící cursor S EXISTUJÍCÍM OKNEM
  UseReuse := False;
  if IsCursorProcessAlive then
  begin
    // Náš uložený Cursor proces běží - zkontroluj jeho okno
    H := FindWindowByPID(FCursorPID);
    UseReuse := (H <> 0);
  end;
  
  if not UseWorkspaceFile then
  begin
    // Použijeme starý způsob (složka místo workspace souboru)
    WS := EffectiveExportFolder;
    FolderArg := '"' + WS + '"';
  end;

  // Urči FileArg podle toho, jestli používáme workspace soubor nebo složku
  if UseWorkspaceFile then
  begin
    // Používáme workspace soubor - použijeme absolutní cestu k souboru
    // aby Cursor otevřel soubor pouze v primárním workspace a nevytvářel ho v sekundárním
    if (ALine > 0) and (ACol > 0) then
      FileArg := Format(' -g "%s:%d:%d"', [AFile, ALine, ACol])
    else if (ALine > 0) then
      FileArg := Format(' -g "%s:%d"', [AFile, ALine])
    else
      FileArg := Format(' "%s"', [AFile]);
  end
  else
  begin
    // Používáme složku - absolutní nebo relativní cesta k souboru
    if (ALine > 0) and (ACol > 0) then
      FileArg := Format(' -g "%s:%d:%d"', [AFile, ALine, ACol])
    else if (ALine > 0) then
      FileArg := Format(' -g "%s:%d"', [AFile, ALine])
    else
      FileArg := Format(' "%s"', [AFile]);
  end;

  if UseReuse then
  begin
    // Cursor této instance FA běží A má okno - AKTIVUJ okno a použij -r
    H := FindWindowByPID(FCursorPID);
    if H <> 0 then
    begin
      // Nejdřív aktivuj okno (aby Cursor věděl, že má použít TOTO okno pro -r)
      SetForegroundWindow(H);
      ShowWindow(H, SW_RESTORE); // Pokud je minimalizované
      Sleep(100); // Krátké zpoždění aby se okno aktivovalo
    end;
    
    // Použij -r pro reuse TOHOTO okna (mělo by fungovat protože je aktivní)
    Params := Format('-r %s%s', [FolderArg, FileArg]);
  end
  else
  begin
    // Cursor této instance neběží NEBO nemá okno - spustit NOVÝ cursor
    // Použijeme --new-window aby Cursor otevřel nové okno
    // i když už existuje jiné okno se stejným workspace
    Params := Format('--new-window %s%s', [FolderArg, FileArg]);
    // Vynuluj starý PID
    FCursorPID := 0;
  end;

  // Working directory musí být vždy složka, ne workspace soubor
  WS := EffectiveExportFolder;
  
  // Najdi skutečný spustitelný soubor (EXE), případně CMD na PATH
  Cmd := ResolveEditorCommand;
  Ext := LowerCase(ExtractFileExt(Cmd));

  if (Ext = '.cmd') or (Ext = '.bat') then
  begin
    // Pro .cmd/.bat použij ShellExecute (nezískáme PID, ale je to fallback)
    Result := ShellExecNoConsole(Cmd, Params, WS, SW_HIDE);
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
      // Nový cursor spuštěn - ulož jeho PID
      FCursorPID := PI.dwProcessId;
      WriteCursorInstanceId;
      // Zapiš FA PID do fa_instance_{CURSOR_PID}.txt (aby Cursor věděl, kam posílat příkazy)
      WriteInstanceId;
    end;
    
    // Zavři handles
    if PI.hProcess <> 0 then CloseHandle(PI.hProcess);
    if PI.hThread <> 0 then CloseHandle(PI.hThread);
  end;
end;

procedure TCursorBridge.ActivateCursorWindow;
var
  H: HWND;
  PID: DWORD;
  Preferred: string;
begin
  // Nejdřív zkus najít okno podle uloženého PID cursoru (naše instance)
  PID := ReadCursorInstanceId;
  if PID <> 0 then
  begin
    H := FindWindowByPID(PID);
    if H <> 0 then
    begin
      if IsIconic(H) then
        ShowWindow(H, SW_RESTORE);
      SetForegroundWindow(H);
      Exit;
    end;
  end;
  
  // Fallback: hledej podle názvu procesu (starý způsob)
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
  // 1) Kontrola změn v editovaném souboru (Ctrl+S v editoru)
  if (FCurrentFile <> '') then
  begin
    T := GetFileWriteTime(FCurrentFile);
    if (T > 0) and (T > FLastWrite) then
    begin
      FLastWrite := T;
      try
        Txt := ReadAllText(FCurrentFile);
      except
        // best-effort (soubor může být krátce zamčený)
        Txt := '';
      end;

      if (Txt <> '') and Assigned(FOnExternalSave) then
        FOnExternalSave(Txt);
    end;
  end;
  
  // 2) Kontrola příkazů z Cursor extension
  ProcessCommandFile;
  
  // 3) Kontrola debugger příkazů z Cursor extension
  ProcessDebugFile;
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

end.
