unit mfcr_certificate_api_example;

{
  PŘÍKLAD POUŽITÍ mfcr_certificate_api.pas
  
  Tento unit obsahuje příklady použití nové HTTP API implementace
  pro práci s certifikáty přes fcomm modul.
}

interface

uses
  SysUtils, Dialogs, mfcr_certificate_api;

/// <summary>
/// Příklad 1: Načtení seznamu certifikátů
/// </summary>
procedure Example1_ListCertificates;

/// <summary>
/// Příklad 2: Podepsání XML dokumentu
/// </summary>
procedure Example2_SignDocument;

/// <summary>
/// Příklad 3: Vyhledání certifikátu podle thumbprintu
/// </summary>
procedure Example3_FindCertificate;

implementation

procedure Example1_ListCertificates;
var
  Certs: TCertificatesAPI;
  i: Integer;
  Cert: TCertificateAPI;
  Msg: string;
begin
  Certs := TCertificatesAPI.Create;
  try
    Msg := Format('Počet certifikátů: %d', [Certs.Count]) + #13#10#13#10;
    
    for i := 0 to Certs.Count - 1 do
    begin
      Cert := Certs.Certificate(i);
      if Cert <> nil then
      begin
        Msg := Msg + Format('Certifikát %d:', [i + 1]) + #13#10;
        Msg := Msg + '  CN: ' + Cert.SubjectFieldCommonName + #13#10;
        Msg := Msg + '  Organizace: ' + Cert.SubjectOrganization + #13#10;
        Msg := Msg + '  Vystavitel: ' + Cert.IssuerFieldCommonName + #13#10;
        Msg := Msg + '  Platný do: ' + DateToStr(Cert.ValidToDate) + #13#10;
        Msg := Msg + '  Provider: ' + Cert.ProviderType + #13#10;
        Msg := Msg + #13#10;
      end;
    end;
    
    ShowMessage(Msg);
  finally
    Certs.Free; // Automaticky ukončí fcomm.exe
  end;
end;

procedure Example2_SignDocument;
var
  Certs: TCertificatesAPI;
  InputFile: string;
  OutputFile: string;
begin
  InputFile := 'C:\temp\document.xml';
  OutputFile := 'C:\temp\document.p7s';
  
  // Poznámka: V reálné aplikaci byste si cestu vybírali přes dialog
  if not FileExists(InputFile) then
  begin
    ShowMessage('Vstupní soubor neexistuje: ' + InputFile);
    Exit;
  end;
  
  Certs := TCertificatesAPI.Create;
  try
    if Certs.Count = 0 then
    begin
      ShowMessage('Žádné certifikáty nebyly nalezeny.');
      Exit;
    end;
    
    // Podepsat prvním certifikátem
    try
      Certs.SignDocument(0, InputFile, OutputFile);
      ShowMessage('Dokument byl úspěšně podepsán!' + #13#10 + 
                  'Výstup: ' + OutputFile);
    except
      on E: Exception do
        ShowMessage('Chyba při podepisování: ' + E.Message);
    end;
  finally
    Certs.Free;
  end;
end;

procedure Example3_FindCertificate;
var
  Certs: TCertificatesAPI;
  Cert: TCertificateAPI;
  Thumbprint: string;
begin
  // Příklad thumbprintu (v reálné aplikaci byste ho získali z konfigurace)
  Thumbprint := 'ABC123...';
  
  Certs := TCertificatesAPI.Create;
  try
    Cert := Certs.FindCertificate(Thumbprint);
    
    if Cert <> nil then
      ShowMessage('Certifikát nalezen!' + #13#10 +
                  'CN: ' + Cert.SubjectFieldCommonName)
    else
      ShowMessage('Certifikát s thumbprintem ' + Thumbprint + ' nebyl nalezen.');
  finally
    Certs.Free;
  end;
end;

end.


