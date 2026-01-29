unit FCommStarter;

{
  ===================================================================
  FComm API Starter - Sdileny proces pro multiple aplikace
  ===================================================================
  
  Zajistuje dostupnost FComm API serveru pro libovolnou aplikaci:
  - Kontrola behu serveru
  - Kontrola verze serveru
  - Spousteni/restart serveru
  - Asynchronni/synchronni mod
  
  Pouziti:
    var
      MinVer: TFCommVersion;
      Res: TFCommStartResult;
    begin
      MinVer := TFCommVersion.Create(1, 0, 0);
      Res := EnsureFCommAPI(MinVer, '', '', smSync);
      if Res.Success then
        // Pouzit API
    end;
}

interface

uses
  Windows, Classes, SysUtils, FCommHttpClient, FCommJsonHelper, uLkJSON;

type
  // ===================================================================
  // Verze FComm API (Semantic Versioning)
  // ===================================================================
  TFCommVersion = record
    Major: Integer;
    Minor: Integer;
    Patch: Integer;
    
    function ToString: string;
    function IsCompatibleWith(const MinVersion: TFCommVersion): Boolean;
    function IsEmpty: Boolean;
    
    class function Parse(const VersionStr: string): TFCommVersion; static;
    class function Create(AMajor, AMinor, APatch: Integer): TFCommVersion; static;
    class function Empty: TFCommVersion; static;
  end;

  // ===================================================================
  // Mod spousteni
  // ===================================================================
  TFCommStartMode = (
    smAsync,      // Asynchronni - spusti a ihned vrati kontrolu (pro start aplikace)
    smSync        // Synchronni - ceka az je API ready, max 10s (pred pouzitim API)
  );

  // ===================================================================
  // Vysledek operace EnsureFCommAPI
  // ===================================================================
  TFCommStartResult = record
    Success: Boolean;
    ErrorMessage: string;
    ServerVersion: TFCommVersion;
    WasAlreadyRunning: Boolean;
    WasRestarted: Boolean;  // True pokud jsme museli restartovat kvuli verzi
  end;

// ===================================================================
// HLAVNI FUNKCE
// ===================================================================

/// <summary>
/// Zajisti dostupnost FComm API serveru
/// - Zkontroluje zda bezi
/// - Zkontroluje verzi (pokud bezi)
/// - Spusti pokud nebezi nebo ma nizkou verzi
/// - Pocka na ready (pokud je smSync) - MAX 10s, ale testuje kazdych 100ms
/// </summary>
function EnsureFCommAPI(
  const MinVersion: TFCommVersion;
  const FCommExePath: string = '';
  const BaseUrl: string = '';
  const StartMode: TFCommStartMode = smSync
): TFCommStartResult;

// ===================================================================
// POMOCNE FUNKCE
// ===================================================================

/// <summary>
/// Vypne FComm API server (graceful shutdown pres /admin/shutdown)
/// </summary>
function ShutdownFCommAPI(const BaseUrl: string = ''): Boolean;

/// <summary>
/// Zkontroluje zda FComm API bezi (GET /health)
/// </summary>
function IsFCommAPIRunning(const BaseUrl: string = ''): Boolean;

/// <summary>
/// Ziska verzi beziciho FComm API serveru (z /health response)
/// </summary>
function GetFCommAPIVersion(const BaseUrl: string = ''): TFCommVersion;

/// <summary>
/// Auto-detekce cesty k fcomm.exe (ve stejne slozce jako .exe programu)
/// </summary>
function GetFCommExePath: string;

/// <summary>
/// Detekce remote URL (non-localhost)
/// </summary>
function IsRemoteUrl(const BaseUrl: string): Boolean;

implementation

// ===================================================================
// TFCommVersion - implementace
// ===================================================================

function TFCommVersion.ToString: string;
begin
  Result := Format('%d.%d.%d', [Major, Minor, Patch]);
end;

function TFCommVersion.IsCompatibleWith(const MinVersion: TFCommVersion): Boolean;
begin
  // Kontrola podle Semantic Versioning pravidel
  if Major > MinVersion.Major then
    Result := True
  else if Major < MinVersion.Major then
    Result := False
  else if Minor > MinVersion.Minor then
    Result := True
  else if Minor < MinVersion.Minor then
    Result := False
  else
    Result := Patch >= MinVersion.Patch;
end;

function TFCommVersion.IsEmpty: Boolean;
begin
  Result := (Major = 0) and (Minor = 0) and (Patch = 0);
end;

class function TFCommVersion.Parse(const VersionStr: string): TFCommVersion;
var
  Parts: TStringList;
begin
  Result := Empty;
  
  Parts := TStringList.Create;
  try
    Parts.Delimiter := '.';
    Parts.StrictDelimiter := True;
    Parts.DelimitedText := VersionStr;
    
    if Parts.Count >= 1 then Result.Major := StrToIntDef(Parts[0], 0);
    if Parts.Count >= 2 then Result.Minor := StrToIntDef(Parts[1], 0);
    if Parts.Count >= 3 then Result.Patch := StrToIntDef(Parts[2], 0);
  finally
    Parts.Free;
  end;
end;

class function TFCommVersion.Create(AMajor, AMinor, APatch: Integer): TFCommVersion;
begin
  Result.Major := AMajor;
  Result.Minor := AMinor;
  Result.Patch := APatch;
end;

class function TFCommVersion.Empty: TFCommVersion;
begin
  Result.Major := 0;
  Result.Minor := 0;
  Result.Patch := 0;
end;

// ===================================================================
// Pomocne funkce
// ===================================================================

function GetDefaultBaseUrl: string;
begin
  Result := 'http://localhost:54321';
end;

function IsRemoteUrl(const BaseUrl: string): Boolean;
var
  LowerUrl: string;
begin
  LowerUrl := LowerCase(BaseUrl);
  
  // Detekce lokalnich adres
  Result := not (
    (Pos('localhost', LowerUrl) > 0) or
    (Pos('127.0.0.1', LowerUrl) > 0) or
    (Pos('::1', LowerUrl) > 0)  // IPv6 localhost
  );
end;

function GetFCommExePath: string;
var
  BasePath: string;
  FCommPath: string;
begin
  // fcomm.exe musi byt ve stejne slozce jako spusteny program
  BasePath := ExtractFilePath(ParamStr(0));
  FCommPath := BasePath + 'fcomm.exe';
  
  if FileExists(FCommPath) then
    Result := FCommPath
  else
    raise Exception.Create('fcomm.exe nebyl nalezen. Ocekavana cesta: ' + FCommPath);
end;

function IsFCommAPIRunning(const BaseUrl: string): Boolean;
var
  HttpClient: TFCommHttpClient;
  Response: string;
  Url: string;
begin
  Result := False;
  
  if BaseUrl <> '' then
    Url := BaseUrl
  else
    Url := GetDefaultBaseUrl;
  
  HttpClient := TFCommHttpClient.Create;
  try
    HttpClient.BaseUrl := Url;
    
    try
      Response := HttpClient.Get('/health');
      Result := (Response <> '') and (Pos('"status"', Response) > 0);
    except
      // Pokud vyjimka, server nebezi
      Result := False;
    end;
  finally
    HttpClient.Free;
  end;
end;

function GetFCommAPIVersion(const BaseUrl: string): TFCommVersion;
var
  HttpClient: TFCommHttpClient;
  Response: string;
  Url: string;
  JSON: TlkJSONobject;
  VersionStr: string;
begin
  Result := TFCommVersion.Empty;
  
  if BaseUrl <> '' then
    Url := BaseUrl
  else
    Url := GetDefaultBaseUrl;
  
  HttpClient := TFCommHttpClient.Create;
  try
    HttpClient.BaseUrl := Url;
    
    try
      Response := HttpClient.Get('/health');
      
      // Parse JSON
      JSON := TlkJSON.ParseText(Response) as TlkJSONobject;
      try
        if Assigned(JSON) then
        begin
          // Ziskat verzi z JSON: {"status":"ok","version":"1.0.0",...}
          if Assigned(JSON.Field['version']) then
          begin
            VersionStr := JSON.Field['version'].Value;
            Result := TFCommVersion.Parse(VersionStr);
          end;
        end;
      finally
        if Assigned(JSON) then
          JSON.Free;
      end;
    except
      // Pri chybe vracime prazdnou verzi
      Result := TFCommVersion.Empty;
    end;
  finally
    HttpClient.Free;
  end;
end;

function ShutdownFCommAPI(const BaseUrl: string): Boolean;
var
  HttpClient: TFCommHttpClient;
  Url: string;
begin
  Result := False;
  
  if BaseUrl <> '' then
    Url := BaseUrl
  else
    Url := GetDefaultBaseUrl;
  
  HttpClient := TFCommHttpClient.Create;
  try
    HttpClient.BaseUrl := Url;
    
    try
      HttpClient.Post('/admin/shutdown', '{}');
      Result := True;
    except
      // Pokud vyjimka, server pravdepodobne jiz nebezi
      Result := False;
    end;
  finally
    HttpClient.Free;
  end;
end;

// ===================================================================
// Spousteni procesu fcomm.exe
// ===================================================================

function StartFCommProcess(const FCommExePath: string): Boolean;
var
  SI: TStartupInfo;
  PI: TProcessInformation;
  ExePath: string;
begin
  Result := False;
  
  // Auto-detect pokud neni zadana cesta
  if FCommExePath <> '' then
    ExePath := FCommExePath
  else
    ExePath := GetFCommExePath;
  
  if not FileExists(ExePath) then
    raise Exception.Create('fcomm.exe nebyl nalezen: ' + ExePath);
  
  // Spustit proces
  FillChar(SI, SizeOf(SI), 0);
  SI.cb := SizeOf(SI);
  SI.dwFlags := STARTF_USESHOWWINDOW;
  SI.wShowWindow := SW_HIDE;  // Skryt okno
  
  if CreateProcess(
    PChar(ExePath),
    nil,
    nil,
    nil,
    False,
    CREATE_NEW_CONSOLE or CREATE_NEW_PROCESS_GROUP,
    nil,
    PChar(ExtractFilePath(ExePath)),
    SI,
    PI
  ) then
  begin
    // Proces spusten uspesne
    CloseHandle(PI.hThread);
    CloseHandle(PI.hProcess);
    Result := True;
  end
  else
  begin
    raise Exception.Create('Nepodařilo se spustit fcomm.exe. Error: ' + IntToStr(GetLastError));
  end;
end;

// ===================================================================
// HLAVNI FUNKCE - EnsureFCommAPI
// ===================================================================

function EnsureFCommAPI(
  const MinVersion: TFCommVersion;
  const FCommExePath: string;
  const BaseUrl: string;
  const StartMode: TFCommStartMode
): TFCommStartResult;
var
  Url: string;
  CurrentVersion: TFCommVersion;
  IsRunning: Boolean;
  NeedsRestart: Boolean;
  i: Integer;
begin
  // Inicializace vysledku
  Result.Success := False;
  Result.ErrorMessage := '';
  Result.ServerVersion := TFCommVersion.Empty;
  Result.WasAlreadyRunning := False;
  Result.WasRestarted := False;
  
  // Nastavit URL
  if BaseUrl <> '' then
    Url := BaseUrl
  else
    Url := GetDefaultBaseUrl;
  
  // ===================================================================
  // KROK 1: Zkontrolovat zda server bezi
  // ===================================================================
  
  IsRunning := IsFCommAPIRunning(Url);
  Result.WasAlreadyRunning := IsRunning;
  
  if IsRunning then
  begin
    // Server bezi - zkontrolovat verzi
    CurrentVersion := GetFCommAPIVersion(Url);
    Result.ServerVersion := CurrentVersion;
    
    if not CurrentVersion.IsEmpty and not CurrentVersion.IsCompatibleWith(MinVersion) then
    begin
      // Verze je nizsi nez pozadovana - je treba restart
      NeedsRestart := True;
      
      // Ale pouze pokud neni remote URL
      if IsRemoteUrl(Url) then
      begin
        Result.Success := False;
        Result.ErrorMessage := Format(
          'Remote FComm API ma nizkou verzi (%s). Pozadovano: %s. Nelze automaticky restartovat remote server.',
          [CurrentVersion.ToString, MinVersion.ToString]
        );
        Exit;
      end;
    end
    else
    begin
      // Verze je OK nebo se nepodarilo zjistit
      NeedsRestart := False;
    end;
  end
  else
  begin
    // Server nebezi - je treba spustit
    NeedsRestart := False;
    
    // Pokud je remote URL, nemuzeme spustit lokalni proces
    if IsRemoteUrl(Url) then
    begin
      Result.Success := False;
      Result.ErrorMessage := 'Remote FComm API nebezi a nelze spustit lokalni proces pro remote URL.';
      Exit;
    end;
  end;
  
  // ===================================================================
  // KROK 2: Restart pokud je potreba (nizka verze)
  // ===================================================================
  
  if NeedsRestart then
  begin
    // Ukoncit stary server
    if not ShutdownFCommAPI(Url) then
    begin
      Result.Success := False;
      Result.ErrorMessage := 'Nepodařilo se ukončit starší verzi FComm API.';
      Exit;
    end;
    
    // Pockat na ukonceni (max 10s = 100x po 100ms)
    for i := 1 to 100 do
    begin
      if not IsFCommAPIRunning(Url) then
        Break;
      Sleep(100);
    end;
    
    // Pokud stale bezi, chyba
    if IsFCommAPIRunning(Url) then
    begin
      Result.Success := False;
      Result.ErrorMessage := 'Starší verze FComm API se nepodařila ukončit ani po 10s.';
      Exit;
    end;
    
    Result.WasRestarted := True;
    IsRunning := False;  // Ted uz nebezi, musime spustit novy
  end;
  
  // ===================================================================
  // KROK 3: Spustit pokud nebezi
  // ===================================================================
  
  if not IsRunning then
  begin
    try
      if not StartFCommProcess(FCommExePath) then
      begin
        Result.Success := False;
        Result.ErrorMessage := 'Nepodařilo se spustit fcomm.exe.';
        Exit;
      end;
    except
      on E: Exception do
      begin
        Result.Success := False;
        Result.ErrorMessage := 'Chyba při spouštění fcomm.exe: ' + E.Message;
        Exit;
      end;
    end;
  end;
  
  // ===================================================================
  // KROK 4: Pockat na ready (pouze v sync modu)
  // ===================================================================
  
  if StartMode = smSync then
  begin
    // Pockat max 10s (100 iteraci po 100ms)
    // Jakmile je ready, hned pokracujeme (nečekáme celých 10s!)
    for i := 1 to 100 do
    begin
      if IsFCommAPIRunning(Url) then
      begin
        // Server je ready!
        CurrentVersion := GetFCommAPIVersion(Url);
        Result.ServerVersion := CurrentVersion;
        Result.Success := True;
        Exit;
      end;
      
      Sleep(100);
    end;
    
    // Po 10s stale neni ready
    Result.Success := False;
    Result.ErrorMessage := 'FComm API se nepodařilo spustit ani po 10s čekání.';
    Exit;
  end
  else
  begin
    // Asynchronni mod - vratime success ihned
    Result.Success := True;
    // Verzi nezname (jeste nebezi), ale to neni problem v async modu
    Result.ServerVersion := TFCommVersion.Empty;
  end;
end;

end.
