# Integrace MFCR certifikátů do projektu FormAsistent

## ✅ Co bylo přidáno

### 1. Složka EPMF (20 souborů)
Zkopírováno z `FADelphiComm\EPMF\` do `FAdelphi\EPMF\`:

**Hlavní API soubory:**
- `mfcr_certificate_api.pas` - hlavní API pro práci s certifikáty
- `mfcr_certificate_api_example.pas` - příklady použití
- `mfcr_certificate.pas` - objektový model certifikátů
- `mfcr_consts.pas` - konstanty
- `mfcr_utils.pas` - pomocné funkce
- `mfcr_resources.pas` - resources

**DLL knihovny v `EPMF\lib\`:**
- `libeay32.dll`, `libssl32.dll`, `ssleay32.dll` - OpenSSL
- `PVTPZP.dll` - PKCS#7 signing
- `Microsoft.VC90.CRT.manifest`, `msvcr90.dll` - runtime

### 2. Existující moduly (již byly v projektu)
- ✅ `FCommHttpClient.pas` - HTTP klient (Indy)
- ✅ `FCommJsonHelper.pas` - JSON parsing (uLkJSON)  
- ✅ `FCommLifecycle.pas` - lifecycle management fcomm.exe
- ✅ `FCommPlatform.pas` - detekce platformy Win7/Win10/11

## 🚀 Jak používat

### Základní použití - načtení certifikátů

```pascal
uses
  FCommLifecycle, EPMF.mfcr_certificate_api;

procedure TfaMain.NactiCertifikaty;
var
  FCommManager: TFCommLifecycle;
  CertAPI: TCertificatesAPI;
  i: Integer;
begin
  FCommManager := TFCommLifecycle.Create;
  try
    // Pro testování z VM Windows 7:
    // FCommManager.HttpClient.BaseUrl := 'http://192.168.0.28:54321';
    
    // Spustit fcomm.exe
    FCommManager.Start;
    
    // Načíst seznam certifikátů
    CertAPI := TCertificatesAPI.Create(FCommManager.HttpClient);
    try
      if CertAPI.LoadCertificates then
      begin
        ShowMessage('Načteno certifikátů: ' + IntToStr(CertAPI.Count));
        
        for i := 0 to CertAPI.Count - 1 do
        begin
          Memo1.Lines.Add(Format('%d: %s (Valid: %s - %s)', [
            i + 1,
            CertAPI.Items[i].SubjectFieldCommonName,
            DateToStr(CertAPI.Items[i].ValidFromDate),
            DateToStr(CertAPI.Items[i].ValidToDate)
          ]));
        end;
      end
      else
        ShowMessage('Chyba: ' + CertAPI.LastError);
    finally
      CertAPI.Free;
    end;
  finally
    FCommManager.Free;
  end;
end;
```

### Podepsání dokumentu

```pascal
procedure TfaMain.PodepsatDokument;
var
  FCommManager: TFCommLifecycle;
  CertAPI: TCertificateAPI;
  Thumbprint: string;
begin
  // Thumbprint získáš ze seznamu certifikátů
  Thumbprint := '1234567890ABCDEF...';
  
  FCommManager := TFCommLifecycle.Create;
  try
    FCommManager.Start;
    
    CertAPI := TCertificateAPI.Create(FCommManager.HttpClient, Thumbprint);
    try
      if CertAPI.SignDocument('C:\Temp\dokument.xml', 'C:\Temp\podepsany.xml') then
        ShowMessage('Podepsáno OK: ' + CertAPI.LastSignedFile)
      else
        ShowMessage('Chyba: ' + CertAPI.LastError);
    finally
      CertAPI.Free;
    end;
  finally
    FCommManager.Free;
  end;
end;
```

## 📋 Přidání do Delphi projektu

V Delphi IDE otevři projekt `FormAsistentFull.dpr` a:

1. **Project → Add to Project...**
2. Vyber soubory:
   - `EPMF\mfcr_certificate_api.pas` ✅
   - `EPMF\mfcr_certificate.pas` ✅
   - `EPMF\mfcr_consts.pas` ✅
   - `EPMF\mfcr_utils.pas` ✅
   - Volitelně: `EPMF\mfcr_certificate_api_example.pas` (jen příklady)

3. **Compile → Build FormAsistentFull**

## 🌐 Testování z VM Windows 7

Pokud laděš projekt na VM Windows 7 a fcomm.exe běží na fyzickém Win11:

```pascal
FCommManager.HttpClient.BaseUrl := 'http://192.168.0.28:54321';
```

**Ověření konektivity z VM:**
```cmd
curl http://192.168.0.28:54321/health
```

## 🔥 Firewall na Win11 (fyzický stroj)

Port 54321 musí být otevřený:

```powershell
# PowerShell jako Administrator
New-NetFirewallRule -DisplayName "FAComm Server" -Direction Inbound -Protocol TCP -LocalPort 54321 -Action Allow
```

## 📚 Reference

- **Příklady použití**: `EPMF\mfcr_certificate_api_example.pas`
- **VM testování**: `fcomm\TESTOVÁNÍ_Z_VM.md`
- **Spuštění serveru**: `fcomm\start-development.bat`

## ✅ Next Steps

1. Přidat EPMF moduly do projektu v Delphi IDE
2. Zkompilovat projekt
3. Otestovat načtení certifikátů
4. Implementovat UI pro výběr certifikátu
5. Otestovat podepsání dokumentu

---
**Datum integrace**: 2026-01-17  
**Zdroj**: FADelphiComm\EPMF  
**Cíl**: FAdelphi\EPMF
