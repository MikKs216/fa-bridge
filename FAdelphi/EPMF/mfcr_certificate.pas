unit mfcr_certificate;

interface

uses
  Windows, Classes, contnrs;

type
  TCertificate = class(TObject)
    constructor Create(Cert: Variant);
  private
    FVersion: Integer;
    FSerialNumber: String;
    FSubjectName: String;
    FIssuerName: String;
    FValidFromDate: TDateTime;
    FValidToDate: TDateTime;
    FThumbprint: String;
    FSubjectFieldCommonName: String;
    FIssuerFieldCommonName: String;
    FSubjectOrganization: string;
    procedure ParseField(var S, FieldName, FieldValue: String);
    procedure ParseAll;
  public

    // Ukazat certifikat jako dialogove okno
    procedure Display;

    // Podepsat dokument certifikatem
    procedure SignDocument(const DocumentFileName, SignatureFileName: String);

  published

    // Verze certifikatu
    property Version: Integer read FVersion;

    // Seriove cislo
    property SerialNumber: String read FSerialNumber;

    // Udaje subjektu
    property SubjectName: String read FSubjectName;

    // Udaje vystavitele
    property IssuerName: String read FIssuerName;

    // Platnost od
    property ValidFromDate: TDateTime read FValidFromDate;

    // Platnost do
    property ValidToDate: TDateTime read FValidToDate;

    // Otisk certifikatu
    property Thumbprint: String read FThumbprint;

    // Vyparsovano - jmeno subjektu
    property SubjectFieldCommonName: String read FSubjectFieldCommonName;

    // Vyparsovano - jmeno vystavitele
    property IssuerFieldCommonName: String read FIssuerFieldCommonName;

    property SubjectOrganization: string read FSubjectOrganization;

  end;

  TCertificates = class(TObject)
  private
    FCertificateList: TObjectList;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    // Jednotlive certifikaty pro podpis
    function Certificate(Index: Integer): TCertificate;

    // Ukazat certifikat jako dialogove okno
    procedure Display(Index: Integer);

    // Podepsat dokument certifikatem
    procedure SignDocument(Index: Integer; const DocumentFileName,
     SignatureFileName: String);

    // Ziskani hashe certifikatu, Index - poradove cislo certifikatu
    function GetCertificateThumbprint(Index: Integer): string;

    // Ziskani certifikatu podle hashe
    function FindCertificate(const AThumbprint: string):  TCertificate;
  published

    // Pocet certifikatu
    property Count: Integer read GetCount;

  end;

implementation

uses
  SysUtils, ComObj, Variants, mfcr_utils, mfcr_consts, mfcr_resources,
  FCommonUtils;

{ TCertificate }

constructor TCertificate.Create(Cert: Variant);
begin
  inherited Create;
  FVersion := Cert.Version;
  FSerialNumber := Cert.SerialNumber;
  FSubjectName := Cert.SubjectName;
  FIssuerName := Cert.IssuerName;
  FValidFromDate := Cert.ValidFromDate;
  FValidToDate := Cert.ValidToDate;
  FThumbprint := Cert.Thumbprint;
  FSubjectFieldCommonName := '';
  FIssuerFieldCommonName := '';
  ParseAll;
end;

procedure TCertificate.ParseField(var S, FieldName, FieldValue: String);
var
  I: Integer;
  FindStr: String;
begin
  S := Trim(S);
  FieldName := '';
  FieldValue := '';
  I := Pos('=', S);
  if (S = '') or (I < 2) or (I >= Length(S)) then
    S := ''
  else
    begin
      FieldName := Copy(S, 1, I-1);
      Delete(S, 1, I);
      if S[1] = '"' then
        begin
          FindStr := '",';
          Delete(S, 1, 1);
        end
      else
        FindStr := ',';
      I := Pos(FindStr, S);
      if I < 1 then
        begin
          FieldValue := S;
          S := '';
          if (Length(FieldValue) > 0) and (FieldValue[Length(FieldValue)] = '"') then
            Delete(FieldValue, Length(FieldValue), 1);
        end
      else
        begin
          if I = 1 then
            FieldValue := ''
          else
            FieldValue := Copy(S, 1, I-1);
          Delete(S, 1, I + Length(FindStr) - 1);
        end;
    end;
  S := Trim(S);
end;

procedure TCertificate.ParseAll;
var
  S: String;
  FieldName, FieldValue: String;
begin
  S := FSubjectName;
  while S <> '' do
    begin
      ParseField(S, FieldName, FieldValue);
      if FieldName = 'CN' then
        FSubjectFieldCommonName := FieldValue;
      if FieldName = 'O' then
        FSubjectOrganization := FieldValue;
    end;
  S := FIssuerName;
  while S <> '' do
    begin
      ParseField(S, FieldName, FieldValue);
      if FieldName = 'CN' then
        FIssuerFieldCommonName := FieldValue;
    end;
end;

procedure TCertificate.Display;
var
  Store: Variant;
  I: Integer;
  Cert: Variant;
begin
  Store := CreateOleObject(CAPICOM_STORE);
  try
    Cert := null;
    Store.Open(CAPICOM_CURRENT_USER_STORE, sCertificateStoreName, CAPICOM_STORE_OPEN_READ_ONLY);
    for I := 1 to Store.Certificates.Count do
      if Store.Certificates.Item[I].SerialNumber = FSerialNumber then
        Cert := Store.Certificates.Item[I];
    if VarType(Cert) = varNull then
      raise Exception.CreateFmt(errCertificateNotFound, [FSerialNumber]);
    Cert.Display;
  finally
    Store := null;
  end;
end;

procedure TCertificate.SignDocument(const DocumentFileName, SignatureFileName: String);
var
  Store: Variant;
  Cert: Variant;
  SignedData: Variant;
  Signer: Variant;
  SigningTime: Variant;
  I: Integer;
  WS: WideString;
begin
  Store := CreateOleObject(CAPICOM_STORE);
  try
    Store.Open(CAPICOM_CURRENT_USER_STORE, sCertificateStoreName, CAPICOM_STORE_OPEN_READ_ONLY);
    Cert := null;
    for I := 1 to Store.Certificates.Count do
      if Store.Certificates.Item[I].SerialNumber = FSerialNumber then
        Cert := Store.Certificates.Item[I];
    if VarType(Cert) = varNull then
      raise Exception.CreateFmt(errCertificateNotFound, [FSerialNumber]);
    SignedData := CreateOleObject(CAPICOM_SIGNEDDATA);
    try
      Signer := CreateOleObject(CAPICOM_SIGNER);
      try
        SigningTime := CreateOleObject(CAPICOM_ATTRIBUTE);
        try
          SigningTime.Name := CAPICOM_AUTHENTICATED_ATTRIBUTE_SIGNING_TIME;
          SigningTime.Value := Now;
          Signer.Certificate := Cert;
          Signer.AuthenticatedAttributes.Add(SigningTime);
          SignedData.Content := FileToWideString(DocumentFileName);
          WS := SignedData.Sign(Signer, FALSE, CAPICOM_ENCODE_BASE64);
          Base64ToFile(WS, SignatureFileName);
        finally
          SigningTime := null;
        end;
      finally
        Signer := null;
      end;
    finally
      SignedData := null;
    end;
  finally
    Store := null;
  end;
end;

{ TCertificates }

constructor TCertificates.Create;
var
  Certificate: Variant;
  Store: Variant;
  Cert: TCertificate;

  procedure FindCertificates(AAll: boolean);
  var
    I, J: Integer;
  begin
    for I := 1 to Store.Certificates.Count do begin
      Certificate := Store.Certificates.Item[I];
      // Nutno mit privatni klic
      if Certificate.HasPrivateKey <> 0 then begin
        // Test na platnost s prihlednutim k mozne absenci root certifikatu
        Certificate.IsValid.CheckFlag :=
          // CAPICOM_CHECK_TRUSTED_ROOT + { tato polozka znamena, ze musi mit root certifikat }
          CAPICOM_CHECK_TIME_VALIDITY +
          CAPICOM_CHECK_SIGNATURE_VALIDITY +
          // CAPICOM_CHECK_COMPLETE_CHAIN + { neni potreba a nekdy nelze zajistit}
          CAPICOM_CHECK_NAME_CONSTRAINTS +
          CAPICOM_CHECK_BASIC_CONSTRAINTS +
          CAPICOM_CHECK_NESTED_VALIDITY_PERIOD;
        // Vlastni test platnosti nebo vse
        if Certificate.IsValid.Result then
          if AAll then begin
            Cert := TCertificate.Create(Store.Certificates.Item[I]);
            FCertificateList.Add(Cert);
          end
          else begin
            for J := 1 to Certificate.Extensions.Count do //test na identifikator MPSV
              if Certificate.Extensions.Item[J].OID.Value = sCertificateMPSVOID then begin
                Cert := TCertificate.Create(Store.Certificates.Item[I]);
                FCertificateList.Add(Cert);
              end;
          end;
      end;
    end;
  end;

begin
  FCertificateList := TObjectList.Create;
  Store := CreateOleObject(CAPICOM_STORE);
  try
    Store.Open(CAPICOM_CURRENT_USER_STORE, sCertificateStoreName,
     CAPICOM_STORE_OPEN_READ_ONLY);
    FindCertificates(TRUE); //tod ver. 3 uz hledame jen platne
    {if GetKeyState(VK_SHIFT)<0 then begin
      FindCertificates(TRUE); //vsechny platne
    end
    else begin
      FindCertificates(FALSE); //zkusit najit s identifikatorem MPSV
      if FCertificateList.Count=0 then
        FindCertificates(TRUE);
    end;}
  finally
    Store := null;
  end;
end;

destructor TCertificates.Destroy;
begin
  FCertificateList.Free;
  inherited Destroy;
end;

function TCertificates.GetCount: Integer;
begin
  Result := FCertificateList.Count;
end;

function TCertificates.Certificate(Index: Integer): TCertificate;
begin
  if (Index >= 0) and (Index < FCertificateList.Count) then
    Result := TCertificate(FCertificateList.Items[Index])
  else
    Result := nil;
end;

procedure TCertificates.Display(Index: Integer);
begin
  if (Index >= 0) and (Index < FCertificateList.Count) then
    TCertificate(FCertificateList.Items[Index]).Display;
end;

procedure TCertificates.SignDocument(Index: Integer; const DocumentFileName,
  SignatureFileName: String);
begin
  if (Index >= 0) and (Index < FCertificateList.Count) then
    TCertificate(FCertificateList.Items[Index]).SignDocument(DocumentFileName,
     SignatureFileName);
end;

function TCertificates.GetCertificateThumbprint(Index: Integer): string;
begin
  if (Index >= 0) and (Index < FCertificateList.Count) then
    Result:=TCertificate(FCertificateList.Items[Index]).FThumbprint
  else
    Result:='';  
end;

function TCertificates.FindCertificate(const AThumbprint: string): TCertificate;
var
  CertCount: Integer;
  I: Integer;
begin
  StartWait;
  Result:=nil;
  try
    CertCount := Count;
    if CertCount > 0 then begin
      for I := 0 to CertCount - 1 do begin
        if Certificate(I).Thumbprint = AThumbprint then begin
          Result:=Certificate(I);
          BREAK;
        end;
      end;
    end;
  finally
    StopWait;
  end;
end;

end.

