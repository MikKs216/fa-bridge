# Changelog - Integrace MFCR certifikátů do FAdelphi

## 2026-01-17 - Integrace certifikátního API

### ✅ Provedené změny

#### 1. Zkopírování složky EPMF
- Zdrojová cesta: `FADelphiComm/EPMF/`
- Cílová cesta: `FAdelphi/EPMF/`
- Zkopírováno **20 souborů**:
  - `mfcr_certificate_api.pas` - hlavní API pro certifikáty
  - `mfcr_certificate_api_example.pas` - příklady použití
  - `mfcr_certificate.pas` - objektový model certifikátů
  - `mfcr_consts.pas` - konstanty
  - `mfcr_utils.pas` - pomocné funkce
  - `mfcr_resources.pas` - resources
  - DLL knihovny v `lib/` (OpenSSL, PVTPZP)

#### 2. Úprava FCommHttpClient.pas
- **Přidán komentář** do konstruktoru s návody pro VM testování:
  ```pascal
  // Výchozí localhost pro produkční prostředí
  // Pro VM testování z Win7 použij: SetBaseUrl('http://192.168.0.28:54321')
  FBaseUrl := 'http://127.0.0.1:54321';
  ```
- **Property `BaseUrl`** je již veřejné (read/write), takže lze snadno přenastavit pro VM

#### 3. Dokumentace
- **README_MFCR_CERTIFICATES.md**
  - Kompletní návod na použití API
  - Příklady kódu pro načtení certifikátů a podepisování
  - Konfigurace pro VM testování vs. produkční prostředí
  - Síťová konfigurace a firewall pravidla

### 📁 Stávající moduly (beze změn)
Následující moduly již byly v FAdelphi a jsou **plně funkční**:
- ✅ `FCommHttpClient.pas` - HTTP klient (Indy TIdHTTP)
- ✅ `FCommJsonHelper.pas` - JSON parsing (uLkJSON)
- ✅ `FCommLifecycle.pas` - lifecycle management fcomm.exe
- ✅ `FCommPlatform.pas` - detekce platformy (Win7/Win10/11)

### 🔄 Závislosti mezi moduly

```
┌─────────────────────────────────────────┐
│ Vaše FA aplikace (Delphi 2007)          │
└───────────────┬─────────────────────────┘
                │
                ▼
┌───────────────────────────────────────────┐
│ mfcr_certificate_api.pas                  │
│ - TCertificateAPI (jeden certifikát)     │
│ - TCertificatesAPI (seznam certifikátů)  │
└───────────────┬───────────────────────────┘
                │
                ▼
┌───────────────────────────────────────────┐
│ FCommLifecycle.pas                        │
│ - Start/Stop fcomm.exe                    │
│ - Health check                            │
│ - Version management                      │
└───────────────┬───────────────────────────┘
                │
                ├──────────────┬─────────────┐
                ▼              ▼             ▼
┌──────────────────┐ ┌──────────────┐ ┌─────────────────┐
│FCommHttpClient   │ │FCommPlatform │ │FCommJsonHelper  │
│- GET/POST        │ │- Win7 detect │ │- JSON parsing   │
└──────────────────┘ └──────────────┘ └─────────────────┘
                │
                ▼
┌───────────────────────────────────────────┐
│ fcomm API server (HTTP)                   │
│ - Port 54321                              │
│ - Endpoints: /health, /v1/certificates,   │
│              /v1/sign                     │
└───────────────────────────────────────────┘
                │
                ▼
┌───────────────────────────────────────────┐
│ FormStudio.Communications.Certificates    │
│ - Windows Certificate Store               │
│ - PKCS#7 Signing                          │
└───────────────────────────────────────────┘
```

### 🌐 Topologie VM testování

```
┌────────────────────────────────────────────┐
│ Windows 11 (Fyzický stroj)                 │
│ - IP: 192.168.0.28                         │
│ - fcomm server (port 54321)                │
│ - Firewall: port 54321 otevřen            │
└────────────────────────────────────────────┘
                │
                │ VMware Bridged Network
                │
┌────────────────────────────────────────────┐
│ Windows 7 VM                               │
│ - Delphi 2007                              │
│ - FA aplikace                              │
│ - BaseUrl = 'http://192.168.0.28:54321'    │
└────────────────────────────────────────────┘
```

### 📋 Použití v projektu

#### Krok 1: Přidání do Delphi projektu

V Delphi IDE (`Project` → `Add to Project...`):
- `FCommHttpClient.pas`
- `FCommJsonHelper.pas`
- `FCommLifecycle.pas`
- `FCommPlatform.pas`
- `EPMF\mfcr_certificate_api.pas`
- `EPMF\mfcr_certificate_api_example.pas` (volitelně - jen příklady)
- `EPMF\mfcr_certificate.pas`
- `EPMF\mfcr_consts.pas`
- `EPMF\mfcr_utils.pas`

#### Krok 2: Základní použití

```pascal
uses
  FCommLifecycle, EPMF.mfcr_certificate_api;

var
  FCommManager: TFCommLifecycle;
  CertAPI: TCertificatesAPI;
begin
  FCommManager := TFCommLifecycle.Create;
  try
    // *** PRO VM TESTOVÁNÍ ***
    FCommManager.HttpClient.BaseUrl := 'http://192.168.0.28:54321';
    
    // *** PRO PRODUKCI ***
    // (neměnit, výchozí je localhost)
    
    // Spustit fcomm server
    FCommManager.Start;
    
    // Načíst seznam certifikátů
    CertAPI := TCertificatesAPI.Create(FCommManager.HttpClient);
    try
      if CertAPI.LoadCertificates then
      begin
        ShowMessage('Načteno certifikátů: ' + IntToStr(CertAPI.Count));
        // ... zpracování certifikátů ...
      end;
    finally
      CertAPI.Free;
    end;
  finally
    FCommManager.Free;
  end;
end;
```

### ⚠️ Důležité poznámky

1. **BaseUrl nastavení**
   - VM testování: `FCommManager.HttpClient.BaseUrl := 'http://192.168.0.28:54321';`
   - Produkce: Ponechat výchozí `http://127.0.0.1:54321`

2. **Firewall na Win11**
   - Port 54321 musí být otevřen pro inbound připojení
   - Viz README sekce "Firewall pravidlo"

3. **server-config.json na Win11**
   - Musí být nastaven `"BindAddress": "any"`
   - Jinak server naslouchá pouze na localhost

4. **Delphi 2007 kompatibilita**
   - Používá Indy 9 (součást D2007)
   - JSON parsing přes uLkJSON (musí být dostupné)
   - UTF-8 encoding ručně (D2007 nemá nativní UTF-8 string support)

### ✅ Testování konektivity

#### Z VM Windows 7
```cmd
REM Test health check
curl http://192.168.0.28:54321/health

REM Očekávaný výstup:
REM {"status":"ok","version":"1.0.0","timestamp":"..."}
```

#### Z Delphi aplikace
```pascal
if FCommManager.IsRunning then
  ShowMessage('Server OK')
else
  ShowMessage('Server nedostupný');
```

### 🚀 Next Steps

1. ✅ **Integrace dokončena** - všechny soubory zkopírovány
2. ✅ **Dokumentace vytvořena** - README + Changelog
3. ⏭️ **Přidat moduly do Delphi projektu** - ručně v IDE
4. ⏭️ **Otestovat načtení certifikátů** - viz příklady v README
5. ⏭️ **Otestovat podepsání dokumentu** - viz příklady v README
6. ⏭️ **Implementovat UI pro výběr certifikátu** - podle potřeb FA aplikace

### 📚 Reference

- **README**: `FAdelphi\README_MFCR_CERTIFICATES.md`
- **Příklady**: `FAdelphi\EPMF\mfcr_certificate_api_example.pas`
- **VM testování**: `fcomm\TESTOVÁNÍ_Z_VM.md`
- **fcomm server**: `fcomm\README_START.md`

---

**Autor**: AI Assistant (Claude Sonnet 4.5)  
**Datum**: 2026-01-17  
**Verze**: 1.0
