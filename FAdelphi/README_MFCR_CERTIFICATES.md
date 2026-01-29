# MFCR Certifikáty - Integrace do FAdelphi

## 📁 Struktura modulů

```
FAdelphi/
├── FCommHttpClient.pas        # HTTP klient pro komunikaci s fcomm API
├── FCommJsonHelper.pas        # JSON parsing (uLkJSON)
├── FCommLifecycle.pas         # Lifecycle management fcomm.exe
├── FCommPlatform.pas          # Detekce platformy (Win7 vs Win10/11)
└── EPMF/                      # MFCR certifikáty
    ├── mfcr_certificate_api.pas            # API pro práci s certifikáty
    ├── mfcr_certificate_api_example.pas    # Příklady použití
    ├── mfcr_certificate.pas                # Certifikát objekty
    ├── mfcr_consts.pas                     # Konstanty
    ├── mfcr_utils.pas                      # Pomocné utility
    ├── mfcr_resources.pas                  # Resources
    └── lib/                                # DLL knihovny
```

## 🔧 Konfigurace pro VM testování

### Windows 7 VM (Delphi 2007)

V kódu, kde vytváříš `TFCommLifecycle`, nastav BaseUrl pro přístup na fyzický stroj:

```pascal
uses
  FCommLifecycle, FCommHttpClient;

var
  FCommManager: TFCommLifecycle;
begin
  FCommManager := TFCommLifecycle.Create;
  try
    // Pro testování z VM nastav IP fyzického stroje
    FCommManager.HttpClient.BaseUrl := 'http://192.168.0.28:54321';
    
    // Spustit fcomm.exe server (pokud není spuštěn)
    FCommManager.Start;
    
    // Nyní můžeš používat API...
  finally
    FCommManager.Free;
  end;
end;
```

### Produkční prostředí (Windows 11 - localhost)

```pascal
var
  FCommManager: TFCommLifecycle;
begin
  FCommManager := TFCommLifecycle.Create;
  try
    // Výchozí nastavení je localhost, není třeba měnit
    // FCommManager.HttpClient.BaseUrl := 'http://127.0.0.1:54321';
    
    FCommManager.Start;
    
    // API použití...
  finally
    FCommManager.Free;
  end;
end;
```

## 📚 Příklady použití

### 1. Načtení seznamu certifikátů

```pascal
uses
  FCommLifecycle, EPMF.mfcr_certificate_api;

var
  FCommManager: TFCommLifecycle;
  CertAPI: TCertificatesAPI;
  i: Integer;
begin
  FCommManager := TFCommLifecycle.Create;
  try
    // VM: Nastav IP fyzického stroje
    FCommManager.HttpClient.BaseUrl := 'http://192.168.0.28:54321';
    
    FCommManager.Start;
    
    CertAPI := TCertificatesAPI.Create(FCommManager.HttpClient);
    try
      if CertAPI.LoadCertificates then
      begin
        ShowMessage('Počet certifikátů: ' + IntToStr(CertAPI.Count));
        
        for i := 0 to CertAPI.Count - 1 do
        begin
          ShowMessage(Format('Cert %d: %s', [
            i,
            CertAPI.Items[i].SubjectFieldCommonName
          ]));
        end;
      end
      else
        ShowMessage('Chyba načtení certifikátů: ' + CertAPI.LastError);
    finally
      CertAPI.Free;
    end;
  finally
    FCommManager.Free;
  end;
end;
```

### 2. Podepsání dokumentu

```pascal
uses
  FCommLifecycle, EPMF.mfcr_certificate_api;

var
  FCommManager: TFCommLifecycle;
  CertAPI: TCertificateAPI;
  Thumbprint: string;
begin
  FCommManager := TFCommLifecycle.Create;
  try
    // VM: Nastav IP fyzického stroje
    FCommManager.HttpClient.BaseUrl := 'http://192.168.0.28:54321';
    
    FCommManager.Start;
    
    // Předpoklad: Thumbprint certifikátu je znám
    Thumbprint := '1234567890ABCDEF...';
    
    CertAPI := TCertificateAPI.Create(FCommManager.HttpClient, Thumbprint);
    try
      if CertAPI.SignDocument('C:\Temp\input.xml', 'C:\Temp\signed.xml') then
        ShowMessage('Dokument podepsán: ' + CertAPI.LastSignedFile)
      else
        ShowMessage('Chyba podpisu: ' + CertAPI.LastError);
    finally
      CertAPI.Free;
    end;
  finally
    FCommManager.Free;
  end;
end;
```

### 3. Kompletní příklad - výběr certifikátu a podpis

Viz soubor: `EPMF\mfcr_certificate_api_example.pas`

## 🌐 Síťová konfigurace

### Zjištění IP adresy fyzického stroje (Win11)

```powershell
# PowerShell na Win11 (fyzický stroj)
ipconfig
```

Hledej adaptér s bridged připojením (např. `192.168.0.28`).

### Test konektivity z VM

```cmd
REM CMD na Win7 VM
curl http://192.168.0.28:54321/health
```

Očekávaná odpověď:
```json
{"status":"ok","version":"1.0.0","timestamp":"..."}
```

## 🔥 Firewall pravidlo (Win11)

Na fyzickém stroji Win11 je třeba povolit port 54321:

```powershell
# PowerShell jako Administrator
New-NetFirewallRule -DisplayName "FAComm Server" -Direction Inbound -Protocol TCP -LocalPort 54321 -Action Allow
```

## 🚀 Spuštění fcomm serveru

Na Win11 fyzickém stroji:

```cmd
cd D:\Projekty\fcomm-FAkomunikace\fcomm
start-development.bat
```

Server se spustí a naslouchá na `0.0.0.0:54321` (všechny síťové rozhraní).

## ⚙️ Konfigurace server-config.json

```json
{
  "Server": {
    "BindAddress": "any"
  }
}
```

- `"any"` - naslouchá na všech rozhraních (0.0.0.0)
- `"localhost"` - pouze lokální přístup (127.0.0.1)
- `"192.168.0.28"` - specifická IP adresa

## 📝 Závislosti Delphi

### Potřebné komponenty

1. **Indy 9** (TIdHTTP) - HTTP klient
   - Součástí Delphi 2007
   
2. **uLkJSON** - JSON parsing
   - Musí být přidán do projektu
   - Použit v `FCommJsonHelper.pas`

### Přidání do projektu

V Delphi IDE:
1. `Project` → `Add to Project...`
2. Vyber všechny `.pas` soubory z `FAdelphi/` a `FAdelphi/EPMF/`
3. Zkompiluj

## 🐛 Ladění

### Kontrola dostupnosti serveru

```pascal
if FCommManager.IsRunning then
  ShowMessage('Server běží OK')
else
  ShowMessage('Server není dostupný');
```

### Verze serveru

```pascal
var
  Ver: TFCommVersion;
begin
  Ver := FCommManager.ServerVersion;
  ShowMessage(Format('fcomm verze: %d.%d.%d', [Ver.Major, Ver.Minor, Ver.Patch]));
end;
```

### Kontrola funkcí

```pascal
if FCommManager.CheckVersion('basicsigning') then
  ShowMessage('Funkce BasicSigning je dostupná')
else
  ShowMessage('Funkce BasicSigning NENÍ dostupná');
```

## 📦 Distribuce

Pro produkční nasazení je třeba distribuovat:

1. **fcomm.exe** (Win10/11 - .NET 9, 64-bit)
2. **fcomm-win7.exe** (Win7 - .NET 6, 32-bit)
3. Automatická detekce platformy zajištěna v `FCommPlatform.pas`

`FCommLifecycle.Start()` automaticky vybere správnou verzi podle OS.
