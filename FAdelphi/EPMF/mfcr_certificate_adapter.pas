unit mfcr_certificate_adapter;

{
  ADAPTER PATTERN PRO PREPINANI MEZI CAPICOM A FCOMM API
  
  Tento unit poskytuje wrapper tridy TCertificatesWrapper a TCertificateWrapper,
  ktere umoznuji pouzivat jak stary zpusob (CAPICOM) tak novy (fcomm API)
  bez zmeny existujiciho kodu v EElPodani.pas a dalsich unitech.
  
  Pouziti:
    - Misto TCertificates.Create pouzijte TCertificatesWrapper.Create(UseFCommAPI, BaseUrl)
    - Wrapper automaticky vytvori spravnou implementaci
    - Vse ostatni zustava stejne (Certificate(), Display(), SignDocument(), atd.)
}

interface

uses
  Windows, Classes, Contnrs, SysUtils, Dialogs, ShellApi, ComObj,
  mfcr_certificate, mfcr_certificate_api;

type
  // Forward deklarace
  TCertificateWrapper = class;
  
  {
    Wrapper pro kolekci certifikatu - delega na TCertificates nebo TCertificatesAPI
    Poskytuje UPLNE STEJNE rozhrani jako TCertificates
  }
  TCertificatesWrapper = class(TObject)
  private
    FUseFCommAPI: Boolean;
    FBaseUrl: string;
    
    // Interni instance - prave jedna je non-nil
    FCertificatesOld: TCertificates;
    FCertificatesAPI: TCertificatesAPI;
    
    // Seznam wrapperu pro jednotlive certifikaty
    FWrapperList: TObjectList;
    
    function GetCount: Integer;
    procedure BuildWrapperList;
  public
    constructor Create(AUseFCommAPI: Boolean; const ABaseUrl: string = '');
    destructor Destroy; override;
    
    // Stejne metody jako TCertificates
    function Certificate(Index: Integer): TCertificateWrapper;
    procedure Display(Index: Integer);
    procedure SignDocument(Index: Integer; const DocumentFileName, SignatureFileName: String);
    function GetCertificateThumbprint(Index: Integer): string;
    function FindCertificate(const AThumbprint: string): TCertificateWrapper;
    
  published
    property Count: Integer read GetCount;
  end;

  {
    Wrapper pro jednotlivy certifikat - delega na TCertificate nebo TCertificateAPI
    Poskytuje UPLNE STEJNE rozhrani jako TCertificate
  }
  TCertificateWrapper = class(TObject)
  private
    FUseFCommAPI: Boolean;
    
    // Interni instance - prave jedna je non-nil
    FCertificateOld: TCertificate;
    FCertificateAPI: TCertificateAPI;
    
    function GetVersion: Integer;
    function GetSerialNumber: String;
    function GetSubjectName: String;
    function GetIssuerName: String;
    function GetValidFromDate: TDateTime;
    function GetValidToDate: TDateTime;
    function GetThumbprint: String;
    function GetSubjectFieldCommonName: String;
    function GetIssuerFieldCommonName: String;
    function GetSubjectOrganization: string;
    function GetIsQualified: Boolean;
  public
    constructor CreateOld(ACert: TCertificate);
    constructor CreateAPI(ACert: TCertificateAPI);
    destructor Destroy; override;
    
    // Stejne metody jako TCertificate
    procedure Display;
    procedure SignDocument(const DocumentFileName, SignatureFileName: String);
    
  published
    property Version: Integer read GetVersion;
    property SerialNumber: String read GetSerialNumber;
    property SubjectName: String read GetSubjectName;
    property IssuerName: String read GetIssuerName;
    property ValidFromDate: TDateTime read GetValidFromDate;
    property ValidToDate: TDateTime read GetValidToDate;
    property Thumbprint: String read GetThumbprint;
    property SubjectFieldCommonName: String read GetSubjectFieldCommonName;
    property IssuerFieldCommonName: String read GetIssuerFieldCommonName;
    property SubjectOrganization: string read GetSubjectOrganization;
    property IsQualified: Boolean read GetIsQualified;
  end;

implementation

{ TCertificatesWrapper }

constructor TCertificatesWrapper.Create(AUseFCommAPI: Boolean; const ABaseUrl: string);
var
  CapicomPath: string;
begin
  inherited Create;
  
  FUseFCommAPI := AUseFCommAPI;
  FBaseUrl := ABaseUrl;
  FCertificatesOld := nil;
  FCertificatesAPI := nil;
  FWrapperList := TObjectList.Create(True); // Vlastni objekty
  
  // Vytvorime spravnou implementaci podle nastaveni
  if FUseFCommAPI then
    FCertificatesAPI := TCertificatesAPI.Create(FBaseUrl)
  else
  begin
    // Pro stary zpusob (CAPICOM) zkusit vytvorit objekt
    // Pokud selze, zkusit registrovat capicom.dll a zkusit znovu
    try
      FCertificatesOld := TCertificates.Create;
    except
      on E: EOleSysError do
      begin
        // Zkusit registrovat capicom.dll
        CapicomPath := ExtractFilePath(ParamStr(0)) + 'capicom.dll';
        if FileExists(CapicomPath) then
        begin
          ShellExecute(0, nil, PChar('regsvr32'), PChar('/s "' + CapicomPath + '"'), nil, SW_HIDE);
          Sleep(2000); // Pockat na registraci
          
          // Zkusit znovu vytvorit objekt
          try
            FCertificatesOld := TCertificates.Create;
          except
            // Pokud i po registraci selze, propagovat vyjimku
            raise Exception.Create('Nepodarilo se nacist certifikaty pres CAPICOM. ' +
              'Pricinou muze byt chybejici knihovna capicom.dll. ' +
              'Zkuste spustit davku comobjreg.bat v adresari programu. ' +
              'Chyba: ' + E.Message);
          end;
        end
        else
        begin
          // capicom.dll neexistuje
          raise Exception.Create('Nenalezena knihovna capicom.dll v adresáøi programu. ' +
            'Problém patrnì odstraníte reinstalací programu.');
        end;
      end;
    end;
  end;
  
  // Vytvorime wrappery pro vsechny certifikaty
  BuildWrapperList;
end;

destructor TCertificatesWrapper.Destroy;
begin
  FWrapperList.Free;
  
  if Assigned(FCertificatesOld) then
    FCertificatesOld.Free;
    
  if Assigned(FCertificatesAPI) then
    FCertificatesAPI.Free;
    
  inherited;
end;

function TCertificatesWrapper.GetCount: Integer;
begin
  if FUseFCommAPI then
    Result := FCertificatesAPI.Count
  else
    Result := FCertificatesOld.Count;
end;

procedure TCertificatesWrapper.BuildWrapperList;
var
  I: Integer;
  Wrapper: TCertificateWrapper;
begin
  FWrapperList.Clear;
  
  for I := 0 to GetCount - 1 do
  begin
    if FUseFCommAPI then
      Wrapper := TCertificateWrapper.CreateAPI(FCertificatesAPI.Certificate(I))
    else
      Wrapper := TCertificateWrapper.CreateOld(FCertificatesOld.Certificate(I));
      
    FWrapperList.Add(Wrapper);
  end;
end;

function TCertificatesWrapper.Certificate(Index: Integer): TCertificateWrapper;
begin
  if (Index >= 0) and (Index < FWrapperList.Count) then
    Result := TCertificateWrapper(FWrapperList[Index])
  else
    Result := nil;
end;

procedure TCertificatesWrapper.Display(Index: Integer);
begin
  if FUseFCommAPI then
  begin
    // fcomm API nema Display metodu, zobrazime jen zpravu
    MessageBox(0, 'Zobrazeni certifikatu neni v novem API podporovano', 
               'Informace', MB_OK or MB_ICONINFORMATION);
  end
  else
    FCertificatesOld.Display(Index);
end;

procedure TCertificatesWrapper.SignDocument(Index: Integer; 
  const DocumentFileName, SignatureFileName: String);
begin
  if FUseFCommAPI then
    FCertificatesAPI.SignDocument(Index, DocumentFileName, SignatureFileName)
  else
    FCertificatesOld.SignDocument(Index, DocumentFileName, SignatureFileName);
end;

function TCertificatesWrapper.GetCertificateThumbprint(Index: Integer): string;
begin
  if FUseFCommAPI then
    Result := FCertificatesAPI.GetCertificateThumbprint(Index)
  else
    Result := FCertificatesOld.GetCertificateThumbprint(Index);
end;

function TCertificatesWrapper.FindCertificate(const AThumbprint: string): TCertificateWrapper;
var
  I: Integer;
  Thumbprint: string;
begin
  Result := nil;
  
  // Prohledame seznam wrapperu
  for I := 0 to FWrapperList.Count - 1 do
  begin
    Thumbprint := GetCertificateThumbprint(I);
    if SameText(Thumbprint, AThumbprint) then
    begin
      Result := TCertificateWrapper(FWrapperList[I]);
      Break;
    end;
  end;
end;

{ TCertificateWrapper }

constructor TCertificateWrapper.CreateOld(ACert: TCertificate);
begin
  inherited Create;
  FUseFCommAPI := False;
  FCertificateOld := ACert;
  FCertificateAPI := nil;
end;

constructor TCertificateWrapper.CreateAPI(ACert: TCertificateAPI);
begin
  inherited Create;
  FUseFCommAPI := True;
  FCertificateOld := nil;
  FCertificateAPI := ACert;
end;

destructor TCertificateWrapper.Destroy;
begin
  // Certifikaty jsou vlastneny puvodnimi kolekemi (TCertificates/TCertificatesAPI)
  // takze je zde NEmazeme
  inherited;
end;

function TCertificateWrapper.GetVersion: Integer;
begin
  if FUseFCommAPI then
    Result := 0  // API nema Version
  else
    Result := FCertificateOld.Version;
end;

function TCertificateWrapper.GetSerialNumber: String;
begin
  if FUseFCommAPI then
    Result := ''  // API nema SerialNumber
  else
    Result := FCertificateOld.SerialNumber;
end;

function TCertificateWrapper.GetSubjectName: String;
begin
  if FUseFCommAPI then
    Result := FCertificateAPI.SubjectName
  else
    Result := FCertificateOld.SubjectName;
end;

function TCertificateWrapper.GetIssuerName: String;
begin
  if FUseFCommAPI then
    Result := ''  // API nema IssuerName (jen IssuerFieldCommonName)
  else
    Result := FCertificateOld.IssuerName;
end;

function TCertificateWrapper.GetValidFromDate: TDateTime;
begin
  if FUseFCommAPI then
    Result := FCertificateAPI.ValidFromDate
  else
    Result := FCertificateOld.ValidFromDate;
end;

function TCertificateWrapper.GetValidToDate: TDateTime;
begin
  if FUseFCommAPI then
    Result := FCertificateAPI.ValidToDate
  else
    Result := FCertificateOld.ValidToDate;
end;

function TCertificateWrapper.GetThumbprint: String;
begin
  if FUseFCommAPI then
    Result := FCertificateAPI.Thumbprint
  else
    Result := FCertificateOld.Thumbprint;
end;

function TCertificateWrapper.GetSubjectFieldCommonName: String;
begin
  if FUseFCommAPI then
    Result := FCertificateAPI.SubjectFieldCommonName
  else
    Result := FCertificateOld.SubjectFieldCommonName;
end;

function TCertificateWrapper.GetIssuerFieldCommonName: String;
begin
  if FUseFCommAPI then
    Result := FCertificateAPI.IssuerFieldCommonName
  else
    Result := FCertificateOld.IssuerFieldCommonName;
end;

function TCertificateWrapper.GetSubjectOrganization: string;
begin
  if FUseFCommAPI then
    Result := FCertificateAPI.SubjectOrganization
  else
    Result := FCertificateOld.SubjectOrganization;
end;

function TCertificateWrapper.GetIsQualified: Boolean;
begin
  if FUseFCommAPI then
    Result := FCertificateAPI.IsQualified
  else
    Result := False; // CAPICOM nema IsQualified, takze vraci False
end;

procedure TCertificateWrapper.Display;
begin
  if FUseFCommAPI then
  begin
    MessageBox(0, 'Zobrazeni certifikatu neni v novem API podporovano', 
               'Informace', MB_OK or MB_ICONINFORMATION);
  end
  else
    FCertificateOld.Display;
end;

procedure TCertificateWrapper.SignDocument(const DocumentFileName, SignatureFileName: String);
begin
  if FUseFCommAPI then
    FCertificateAPI.SignDocument(DocumentFileName, SignatureFileName)
  else
    FCertificateOld.SignDocument(DocumentFileName, SignatureFileName);
end;

end.
