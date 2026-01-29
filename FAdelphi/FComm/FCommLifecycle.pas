unit FCommLifecycle;

interface

uses
  Windows, Classes, SysUtils, FCommHttpClient, FCommJsonHelper;

type
  /// <summary>
  /// Verze fcomm serveru - Semantic Versioning
  /// </summary>
  TFCommVersion = record
    Major: Integer;
    Minor: Integer;
    Patch: Integer;
    Build: Integer;
    
    /// <summary>
    /// Konvertuje na string "MAJOR.MINOR.PATCH"
    /// </summary>
    function ToString: string;
    
    /// <summary>
    /// Kontroluje, zda tato verze je >= MinimumRequired
    /// </summary>
    function IsCompatibleWith(const MinimumRequired: string): Boolean;
    
    class function Parse(const VersionStr: string): TFCommVersion; static;
  end;

type
  /// <summary>
  /// Správce životního cyklu fcomm.exe
  /// - Spuštění serveru
  /// - Health check
  /// - Verifikace verzí
  /// </summary>
  TFCommLifecycle = class
  private
    FHttpClient: TFCommHttpClient;
    FProcessHandle: THandle;
    FUsingExternalServer: Boolean; // True = pouzivame externi server
    FServerVersion: TFCommVersion;
    FVersionChecked: Boolean;
    
    /// <summary>
    /// Stažení verze ze serveru
    /// </summary>
    function GetServerVersion: TFCommVersion;
    
    /// <summary>
    /// Detekce remote URL (non-localhost)
    /// </summary>
    function IsRemoteBaseUrl(const BaseUrl: string): Boolean;
    
    /// <summary>
    /// Vrati cestu k fcomm.exe (ve stejne slozce jako FA.exe)
    /// </summary>
    function GetFCommExePath: string;
    
  public
    constructor Create;
    destructor Destroy; override;
    
    /// <summary>
    /// Spustit fcomm.exe a čekat na startup
    /// </summary>
    procedure Start(const FCommExePath: string = '');
    
    /// <summary>
    /// Vypnout fcomm.exe
    /// </summary>
    procedure Stop;
    
    /// <summary>
    /// Health check - vrátí True, pokud server běží
    /// </summary>
    function IsRunning: Boolean;
    
    /// <summary>
    /// Kontrola verze - vrátí True, pokud je dostupná požadovaná funkce
    /// </summary>
    function CheckVersion(const RequiredFeature: string): Boolean;
    
    property HttpClient: TFCommHttpClient read FHttpClient;
    property ServerVersion: TFCommVersion read GetServerVersion;
  end;

implementation

// ===================================================================
// TFCommVersion - Verze management
// ===================================================================

function TFCommVersion.ToString: string;
begin
  Result := Format('%d.%d.%d', [Major, Minor, Patch]);
end;

function TFCommVersion.IsCompatibleWith(const MinimumRequired: string): Boolean;
var
  Required: TFCommVersion;
begin
  Required := TFCommVersion.Parse(MinimumRequired);
  
  if Self.Major > Required.Major then
    Result := True
  else if Self.Major < Required.Major then
    Result := False
  else if Self.Minor > Required.Minor then
    Result := True
  else if Self.Minor < Required.Minor then
    Result := False
  else
    Result := Self.Patch >= Required.Patch;
end;

class function TFCommVersion.Parse(const VersionStr: string): TFCommVersion;
var
  Parts: TStringList;
begin
  Result.Major := 0;
  Result.Minor := 0;
  Result.Patch := 0;
  Result.Build := 0;
  
  Parts := TStringList.Create;
  try
    // Parsuj "1.0.0" nebo "1.0.0.5"
    Parts.Delimiter := '.';
    Parts.DelimitedText := VersionStr;
    
    if Parts.Count >= 1 then Result.Major := StrToIntDef(Parts[0], 0);
    if Parts.Count >= 2 then Result.Minor := StrToIntDef(Parts[1], 0);
    if Parts.Count >= 3 then Result.Patch := StrToIntDef(Parts[2], 0);
    if Parts.Count >= 4 then Result.Build := StrToIntDef(Parts[3], 0);
  finally
    Parts.Free;
  end;
end;

// ===================================================================
// TFCommLifecycle
// ===================================================================

constructor TFCommLifecycle.Create;
begin
  inherited Create;
  FHttpClient := TFCommHttpClient.Create;
  FProcessHandle := 0;
  FUsingExternalServer := False;
  FVersionChecked := False;
end;

destructor TFCommLifecycle.Destroy;
begin
  Stop;
  FHttpClient.Free;
  inherited;
end;

procedure TFCommLifecycle.Start(const FCommExePath: string = '');
var
  SI: TStartupInfo;
  PI: TProcessInformation;
  Attempts: Integer;
  DetectedPath: string;
  IsRemoteUrl: Boolean;
begin
  // NOVA LOGIKA: Nejprve zkontrolovat, zda jiz server bezi
  if IsRunning then
  begin
    // Server uz bezi (bud lokalne nebo remote) - neni treba spoustet
    FUsingExternalServer := True; // Indikator ze pouzivame externi server
    
    // Zkontrolovat verzi
    FVersionChecked := False;
    GetServerVersion;
    Exit; // Uspech - server je dostupny
  end;
  
  // Server nebezi - rozhodnout, zda spustit lokalne nebo vyhodit chybu
  IsRemoteUrl := IsRemoteBaseUrl(FHttpClient.BaseUrl);
  
  if IsRemoteUrl then
  begin
    // Remote URL ale server neodpovida - chyba
    raise Exception.Create(
      'fcomm server na adrese ' + FHttpClient.BaseUrl + 
      ' není dostupný. Ujistěte se, že server běží na vzdáleném počítači.'
    );
  end;
  
  // Lokální URL a server neběží - spustit ho
  if FCommExePath = '' then
    DetectedPath := GetFCommExePath  // Cesta k fcomm.exe ve slozce s FA.exe
  else
    DetectedPath := FCommExePath;
  
  // Kontrola existence souboru
  if not FileExists(DetectedPath) then
    raise Exception.Create('Komunikacni modul fcomm.exe nebyl nalezen: ' + DetectedPath);
  
  // Spustit fcomm.exe
  FillChar(SI, SizeOf(SI), 0);
  SI.cb := SizeOf(SI);
  SI.dwFlags := STARTF_USESHOWWINDOW;
  SI.wShowWindow := SW_HIDE; // Skryty process
  
  if CreateProcess(nil, PChar(DetectedPath), nil, nil, False, 0, nil, nil, SI, PI) then
  begin
    CloseHandle(PI.hThread);
    FProcessHandle := PI.hProcess;
    
    // Pockat az se spusti (max 5 sekund)
    for Attempts := 1 to 50 do
    begin
      Sleep(100);
      if IsRunning then
      begin
        // Zkontrolovat verzi po startu
        FVersionChecked := False;
        GetServerVersion;
        Exit;
      end;
    end;
    
    // Timeout - ukoncit proces a vyhodit chybu
    Stop;
    raise Exception.Create('Komunikacni modul fcomm.exe se nespustil vcas (timeout 5s).');
  end
  else
    raise Exception.Create('Nepodarilo se spustit fcomm.exe. Error: ' + IntToStr(GetLastError));
end;

procedure TFCommLifecycle.Stop;
begin
  // Pouze ukoncit, pokud jsme spustili lokalni proces
  // Pokud FUsingExternalServer = True, neukoncujeme externi server
  if (FProcessHandle <> 0) and (not FUsingExternalServer) then
  begin
    // Nejprve zkusit graceful shutdown pres API
    try
      if IsRunning then
        FHttpClient.Post('/admin/shutdown', '{}');
    except
      // Ignorovat chyby - pokud API nefunguje, pouzijeme TerminateProcess
    end;
    
    // Pockat kratce na graceful shutdown
    if WaitForSingleObject(FProcessHandle, 1000) <> WAIT_OBJECT_0 then
    begin
      // Pokud se neukoncil, forcovat
      TerminateProcess(FProcessHandle, 0);
    end;
    
    CloseHandle(FProcessHandle);
  end;
  
  // Reset
  FProcessHandle := 0;
  FUsingExternalServer := False;
end;

function TFCommLifecycle.GetFCommExePath: string;
var
  BasePath: string;
  FCommPath: string;
begin
  // fcomm.exe musi byt ve stejne slozce jako FA.exe
  BasePath := ExtractFilePath(ParamStr(0));
  FCommPath := BasePath + 'fcomm.exe';
  
  if FileExists(FCommPath) then
    Result := FCommPath
  else
    raise Exception.Create('fcomm.exe nebyl nalezen. Ocekavana cesta: ' + FCommPath);
end;

function TFCommLifecycle.IsRemoteBaseUrl(const BaseUrl: string): Boolean;
var
  LowerUrl: string;
begin
  LowerUrl := LowerCase(BaseUrl);
  
  // Detekce lokalnich adres
  Result := not (
    (Pos('localhost', LowerUrl) > 0) or
    (Pos('127.0.0.1', LowerUrl) > 0) or
    (Pos('::1', LowerUrl) > 0) or  // IPv6 localhost
    (LowerUrl = '') or
    (LowerUrl = 'http://localhost:54321')  // Default
  );
end;

function TFCommLifecycle.IsRunning: Boolean;
begin
  Result := FHttpClient.HealthCheck;
end;

function TFCommLifecycle.GetServerVersion: TFCommVersion;
var
  JsonResponse: string;
begin
  if FVersionChecked then
  begin
    Result := FServerVersion;
    Exit;
  end;
  
  try
    JsonResponse := FHttpClient.Get('/version');
    
    // Parsuj JSON response
    // Příklad: {"current":"1.0.0","build":1,"major":1,"minor":0,"patch":0,...}
    // TODO: Naparsovat JSON a vytvořit TFCommVersion
    
    FVersionChecked := True;
    Result := FServerVersion;
  except
    // Pokud verze není dostupná, je to OK - server je starší verze
    FServerVersion.Major := 1;
    FServerVersion.Minor := 0;
    FServerVersion.Patch := 0;
    FServerVersion.Build := 0;
    FVersionChecked := True;
    Result := FServerVersion;
  end;
end;

function TFCommLifecycle.CheckVersion(const RequiredFeature: string): Boolean;
var
  ServerVer: TFCommVersion;
  Feature: string;
begin
  ServerVer := GetServerVersion;
  Feature := LowerCase(RequiredFeature);
  
  // Mapování feature na required verzi
  // BasicSigning: 1.0.0
  // WithTimestamping: 1.1.0
  // DetachedSignatures: 1.2.0
  // EpoSubmission: 2.0.0
  // IsdsSupport: 3.0.0
  // BankingSupport: 4.0.0
  
  // D2007 kompatibilita: case nepodporuje string, použijeme if-then-else
  if Feature = 'basicsigning' then
    Result := ServerVer.IsCompatibleWith('1.0.0')
  else if Feature = 'withtimestamping' then
    Result := ServerVer.IsCompatibleWith('1.1.0')
  else if Feature = 'detachedsignatures' then
    Result := ServerVer.IsCompatibleWith('1.2.0')
  else if Feature = 'eposubmission' then
    Result := ServerVer.IsCompatibleWith('2.0.0')
  else if Feature = 'isdssupport' then
    Result := ServerVer.IsCompatibleWith('3.0.0')
  else if Feature = 'bankingsupport' then
    Result := ServerVer.IsCompatibleWith('4.0.0')
  else
    Result := False;
end;

end.


