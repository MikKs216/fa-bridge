unit mfcr_certificate_api;

{
  Nová implementace práce s certifikáty pøes fcomm HTTP API.
  Kompatibilní rozhraní s pùvodním mfcr_certificate.pas (CAPICOM).
}

interface

uses
  Windows, Classes, SysUtils, Contnrs, Dialogs, 
  FCommHttpClient, FCommJsonHelper, FCommLifecycle,
  mfcr_utils, mfcr_consts, mfcr_resources, FCommonUtils;

type
  /// <summary>
  /// Certifikát - ekvivalent TCertificate z mfcr_certificate.pas
  /// </summary>
  TCertificateAPI = class(TObject)
  private
    FThumbprint: String;
    FSubjectName: String;
    FSubjectFieldCommonName: String;
    FIssuerFieldCommonName: String;
    FSubjectOrganization: string;
    FValidFromDate: TDateTime;
    FValidToDate: TDateTime;
    FProviderType: string;
    FIsQualified: Boolean;
    FHttpClient: TFCommHttpClient; // Sdílený reference
  public
    constructor Create(const ACertInfo: TCertificateInfoRec; AHttpClient: TFCommHttpClient);
    
    /// <summary>
    /// Podepsat dokument certifikatem (volá fcomm API)
    /// </summary>
    procedure SignDocument(const DocumentFileName, SignatureFileName: String);
    
  published
    // Kompatibilní properties s TCertificate
    property SubjectName: String read FSubjectName;
    property SubjectFieldCommonName: String read FSubjectFieldCommonName;
    property IssuerFieldCommonName: String read FIssuerFieldCommonName;
    property ValidFromDate: TDateTime read FValidFromDate;
    property ValidToDate: TDateTime read FValidToDate;
    property Thumbprint: String read FThumbprint;
    property SubjectOrganization: string read FSubjectOrganization;
    property ProviderType: string read FProviderType;
    property IsQualified: Boolean read FIsQualified;
  end;

  /// <summary>
  /// Kolekce certifikátù - ekvivalent TCertificates z mfcr_certificate.pas
  /// </summary>
  TCertificatesAPI = class(TObject)
  private
    FCertificateList: TObjectList;
    FLifecycle: TFCommLifecycle;
    FHttpClient: TFCommHttpClient;
    function GetCount: Integer;
    procedure LoadCertificatesFromAPI;
  public
    constructor Create(const ABaseUrl: string = '');
    destructor Destroy; override;
    
    /// <summary>
    /// Jednotlivé certifikáty pro podpis
    /// </summary>
    function Certificate(Index: Integer): TCertificateAPI;
    
    /// <summary>
    /// Podepsat dokument certifikatem
    /// </summary>
    procedure SignDocument(Index: Integer; const DocumentFileName, SignatureFileName: String);
    
    /// <summary>
    /// Získání hashe certifikátu
    /// </summary>
    function GetCertificateThumbprint(Index: Integer): string;
    
    /// <summary>
    /// Získání certifikátu podle hashe
    /// </summary>
    function FindCertificate(const AThumbprint: string): TCertificateAPI;
    
  published
    /// <summary>
    /// Poèet certifikátù
    /// </summary>
    property Count: Integer read GetCount;
  end;

implementation

{ TCertificateAPI }

constructor TCertificateAPI.Create(const ACertInfo: TCertificateInfoRec; AHttpClient: TFCommHttpClient);
begin
  inherited Create;
  FThumbprint := ACertInfo.Thumbprint;
  FSubjectName := ACertInfo.SubjectName;
  FSubjectFieldCommonName := ACertInfo.SubjectFieldCommonName;
  FSubjectOrganization := ACertInfo.SubjectOrganization;
  FIssuerFieldCommonName := ACertInfo.IssuerFieldCommonName;
  FValidFromDate := ACertInfo.ValidFromDate;
  FValidToDate := ACertInfo.ValidToDate;
  FProviderType := ACertInfo.ProviderType;
  FIsQualified := ACertInfo.IsQualified;
  FHttpClient := AHttpClient; // Reference, ne kopie
end;

procedure TCertificateAPI.SignDocument(const DocumentFileName, SignatureFileName: String);
var
  JsonRequest: string;
  JsonResponse: string;
  Success: Boolean;
  ErrorMsg: string;
  OutputFile: string;
begin
  // Sestavit JSON request
  JsonRequest := BuildSignRequestJson(FThumbprint, DocumentFileName, SignatureFileName);
  
  try
    // Volat API
    JsonResponse := FHttpClient.Post('/v1/sign', JsonRequest);
    
    // Parsovat odpovìï
    if not ParseSignResponseJson(JsonResponse, Success, ErrorMsg, OutputFile) then
      raise Exception.Create('Chyba pøi parsování odpovìdi z API.');
    
    if not Success then
      raise Exception.Create('Chyba pøi podepisování: ' + ErrorMsg);
      
  except
    on E: Exception do
      raise Exception.Create('Chyba pøi volání fcomm API: ' + E.Message);
  end;
end;

{ TCertificatesAPI }

constructor TCertificatesAPI.Create(const ABaseUrl: string = '');
begin
  inherited Create;
  
  FCertificateList := TObjectList.Create;
  FLifecycle := TFCommLifecycle.Create;
  FHttpClient := FLifecycle.HttpClient; // Sdílený HTTP klient
  
  // Pokud je zadán BaseUrl (pro VM testování), použít ho
  if ABaseUrl <> '' then
    FHttpClient.BaseUrl := ABaseUrl;
  
  // Spustit komunikacni modul
  // Prazdny string = automaticky najde fcomm.exe ve slozce s FA.exe
  try
    FLifecycle.Start('');  // Spusti fcomm.exe
  except
    on E: Exception do
    begin
      FCertificateList.Free;
      FLifecycle.Free;
      raise Exception.Create('Nepodaøilo se spustit komunikaèní modul fcomm: ' + E.Message);
    end;
  end;
  
  // Naèíst certifikáty z API
  try
    LoadCertificatesFromAPI;
  except
    on E: Exception do
    begin
      FCertificateList.Free;
      FLifecycle.Free;
      raise Exception.Create('Nepodaøilo se naèíst certifikáty z API: ' + E.Message);
    end;
  end;
end;

destructor TCertificatesAPI.Destroy;
begin
  FCertificateList.Free;
  FLifecycle.Free; // Ukonèí fcomm.exe
  inherited;
end;

procedure TCertificatesAPI.LoadCertificatesFromAPI;
var
  JsonResponse: string;
  CertArray: array[0..99] of TCertificateInfoRec; // Max 100 certifikátù
  CertCount: Integer;
  i: Integer;
  Cert: TCertificateAPI;
begin
  FCertificateList.Clear;
  
  // Inicializovat pole
  FillChar(CertArray, SizeOf(CertArray), 0);
  
  try
    // Zavolat API pro seznam certifikátù
    JsonResponse := FHttpClient.Get('/v1/certificates');
    
    // DEBUG: Zobrazit raw JSON pro kontrolu
    // ShowMessage('JSON Response: ' + JsonResponse);
    
    // Parsovat JSON
    CertCount := ParseCertificatesJson(JsonResponse, CertArray);
    
    if CertCount = 0 then
      Exit; // Žádné certifikáty
    
    // Vytvoøit objekty TCertificateAPI
    for i := 0 to CertCount - 1 do
    begin
      Cert := TCertificateAPI.Create(CertArray[i], FHttpClient);
      FCertificateList.Add(Cert);
    end;
    
  except
    on E: Exception do
      raise Exception.Create('Chyba pøi naèítání certifikátù: ' + E.Message);
  end;
end;

function TCertificatesAPI.GetCount: Integer;
begin
  Result := FCertificateList.Count;
end;

function TCertificatesAPI.Certificate(Index: Integer): TCertificateAPI;
begin
  if (Index >= 0) and (Index < FCertificateList.Count) then
    Result := TCertificateAPI(FCertificateList.Items[Index])
  else
    Result := nil;
end;

procedure TCertificatesAPI.SignDocument(Index: Integer; const DocumentFileName, SignatureFileName: String);
var
  Cert: TCertificateAPI;
begin
  Cert := Certificate(Index);
  if Cert <> nil then
    Cert.SignDocument(DocumentFileName, SignatureFileName)
  else
    raise Exception.Create('Neplatný index certifikátu: ' + IntToStr(Index));
end;

function TCertificatesAPI.GetCertificateThumbprint(Index: Integer): string;
var
  Cert: TCertificateAPI;
begin
  Cert := Certificate(Index);
  if Cert <> nil then
    Result := Cert.Thumbprint
  else
    Result := '';
end;

function TCertificatesAPI.FindCertificate(const AThumbprint: string): TCertificateAPI;
var
  CertCount: Integer;
  I: Integer;
begin
  StartWait;
  Result := nil;
  try
    CertCount := Count;
    if CertCount > 0 then
    begin
      for I := 0 to CertCount - 1 do
      begin
        if AnsiCompareText(Certificate(I).Thumbprint, AThumbprint) = 0 then
        begin
          Result := Certificate(I);
          Break;
        end;
      end;
    end;
  finally
    StopWait;
  end;
end;

end.


