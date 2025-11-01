unit FCommJsonHelper;

interface

uses
  Classes, SysUtils, uLkJSON;

type
  /// <summary>
  /// Pomocná struktura pro informace o certifikátu z JSON
  /// </summary>
  TCertificateInfoRec = record
    Thumbprint: string;
    SubjectName: string;
    SubjectFieldCommonName: string;
    SubjectOrganization: string;
    IssuerName: string;
    IssuerFieldCommonName: string;
    ValidFromDate: TDateTime;
    ValidToDate: TDateTime;
    ProviderType: string;
    IsQualified: Boolean;
  end;

/// <summary>
/// Parsuje JSON odpověď se seznamem certifikátů
/// </summary>
function ParseCertificatesJson(const JsonStr: string; out CertList: array of TCertificateInfoRec): Integer;

/// <summary>
/// Vytvoří JSON request pro podepsání dokumentu
/// </summary>
function BuildSignRequestJson(const Thumbprint, InputFile, OutputFile: string): string;

/// <summary>
/// Parsuje JSON odpověď z endpointu /v1/sign
/// </summary>
function ParseSignResponseJson(const JsonStr: string; out Success: Boolean; 
  out ErrorMsg, OutputFile: string): Boolean;

/// <summary>
/// Konvertuje ISO 8601 datum na TDateTime
/// </summary>
function ISO8601ToDateTime(const DateStr: string): TDateTime;

implementation

function ISO8601ToDateTime(const DateStr: string): TDateTime;
var
  Year, Month, Day, Hour, Min, Sec: Integer;
  S: string;
begin
  Result := 0;
  if Length(DateStr) < 19 then Exit;
  
  try
    // Formát: 2024-10-23T15:30:45
    S := Copy(DateStr, 1, 10); // datum
    Year := StrToInt(Copy(S, 1, 4));
    Month := StrToInt(Copy(S, 6, 2));
    Day := StrToInt(Copy(S, 9, 2));
    
    S := Copy(DateStr, 12, 8); // čas
    Hour := StrToInt(Copy(S, 1, 2));
    Min := StrToInt(Copy(S, 4, 2));
    Sec := StrToInt(Copy(S, 7, 2));
    
    Result := EncodeDate(Year, Month, Day) + EncodeTime(Hour, Min, Sec, 0);
  except
    Result := 0;
  end;
end;

function ParseCertificatesJson(const JsonStr: string; out CertList: array of TCertificateInfoRec): Integer;
var
  JSONRoot: TlkJSONbase;
  JSONObj: TlkJSONobject;
  JSONArray: TlkJSONlist;
  JSONCert: TlkJSONobject;
  i: Integer;
begin
  Result := 0;
  
  try
    JSONRoot := TlkJSON.ParseText(JsonStr);
    if JSONRoot = nil then Exit;
    
    try
      JSONObj := JSONRoot as TlkJSONobject;
      
      // Kontrola success
      if not JSONObj.getBoolean('success') then Exit;
      
      // Získat pole certifikátů
      JSONArray := JSONObj.Field['data'] as TlkJSONlist;
      if JSONArray = nil then Exit;
      
      // Parsovat jednotlivé certifikáty
      for i := 0 to JSONArray.Count - 1 do
      begin
        if i > High(CertList) then Break; // Ochrana proti přetečení pole
        
        JSONCert := JSONArray.Child[i] as TlkJSONobject;
        if JSONCert = nil then Continue;
        
        // Bezpečné načtení s lowercase názvy polí (JSON vrací lowercase!)
        try
          CertList[i].Thumbprint := JSONCert.Field['thumbprint'].Value;
        except
          CertList[i].Thumbprint := '';
        end;
        
        try
          CertList[i].SubjectName := JSONCert.Field['subjectName'].Value;
        except
          CertList[i].SubjectName := '';
        end;
        
        try
          CertList[i].SubjectFieldCommonName := JSONCert.Field['subjectFieldCommonName'].Value;
        except
          CertList[i].SubjectFieldCommonName := '';
        end;
        
        try
          CertList[i].SubjectOrganization := JSONCert.Field['subjectOrganization'].Value;
        except
          CertList[i].SubjectOrganization := '';
        end;
        
        try
          CertList[i].IssuerName := JSONCert.Field['issuerName'].Value;
        except
          CertList[i].IssuerName := '';
        end;
        
        try
          CertList[i].IssuerFieldCommonName := JSONCert.Field['issuerFieldCommonName'].Value;
        except
          CertList[i].IssuerFieldCommonName := '';
        end;
        
        try
          CertList[i].ValidFromDate := ISO8601ToDateTime(JSONCert.Field['validFromDate'].Value);
        except
          CertList[i].ValidFromDate := 0;
        end;
        
        try
          CertList[i].ValidToDate := ISO8601ToDateTime(JSONCert.Field['validToDate'].Value);
        except
          CertList[i].ValidToDate := 0;
        end;
        
        try
          CertList[i].ProviderType := JSONCert.Field['providerType'].Value;
        except
          CertList[i].ProviderType := '';
        end;
        
        try
          if JSONCert.Field['isQualified'] <> nil then
            CertList[i].IsQualified := (JSONCert.Field['isQualified'] as TlkJSONboolean).Value
          else
            CertList[i].IsQualified := False;
        except
          CertList[i].IsQualified := False;
        end;
        
        Inc(Result);
      end;
    finally
      JSONRoot.Free;
    end;
  except
    Result := 0;
  end;
end;

function BuildSignRequestJson(const Thumbprint, InputFile, OutputFile: string): string;
var
  JSONObj: TlkJSONobject;
begin
  JSONObj := TlkJSONobject.Create;
  try
    // camelCase - .NET API očekává lowercase začátek
    JSONObj.Add('thumbprint', Thumbprint);
    JSONObj.Add('inputFile', InputFile);
    JSONObj.Add('outputFile', OutputFile);
    Result := TlkJSON.GenerateText(JSONObj);
  finally
    JSONObj.Free;
  end;
end;

function ParseSignResponseJson(const JsonStr: string; out Success: Boolean; 
  out ErrorMsg, OutputFile: string): Boolean;
var
  JSONRoot: TlkJSONbase;
  JSONObj: TlkJSONobject;
begin
  Result := False;
  Success := False;
  ErrorMsg := '';
  OutputFile := '';
  
  try
    JSONRoot := TlkJSON.ParseText(JsonStr);
    if JSONRoot = nil then
    begin
      ErrorMsg := 'Neplatný JSON response';
      Exit;
    end;
    
    try
      JSONObj := JSONRoot as TlkJSONobject;
      
      // camelCase - .NET API vrací lowercase začátek
      try
        Success := (JSONObj.Field['success'] as TlkJSONboolean).Value;
      except
        Success := False;
      end;
      
      if not Success then
      begin
        try
          ErrorMsg := JSONObj.Field['errorMessage'].Value;
        except
          ErrorMsg := 'Neznámá chyba';
        end;
      end
      else
      begin
        try
          OutputFile := JSONObj.Field['outputFile'].Value;
        except
          OutputFile := '';
        end;
      end;
      
      Result := True;
    finally
      JSONRoot.Free;
    end;
  except
    on E: Exception do
    begin
      ErrorMsg := 'Chyba při parsování JSON: ' + E.Message;
      Result := False;
    end;
  end;
end;

end.


