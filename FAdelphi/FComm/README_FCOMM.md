# FComm - Komunikační moduly pro FA

Tato složka obsahuje Delphi utility pro komunikaci s `fcomm.exe` HTTP API serverem.

## Struktura

```
FComm/
├── FCommHttpClient.pas      - HTTP klient pro komunikaci s fcomm API
├── FCommJsonHelper.pas      - Parsování JSON odpovědí z API
├── FCommLifecycle.pas       - Správa životního cyklu fcomm.exe procesu
└── README_FCOMM.md         - Tento soubor
```

## Použití

### 1. FCommLifecycle - Správa procesu fcomm.exe

**Lazy Initialization (doporučeno):**

```pascal
// V Main.pas - globalni promenna
private
  FCommLifecycle: TFCommLifecycle;

// Lazy initialization - spusti fcomm.exe pri prvnim pouziti
function TfaMain.GetFCommLifecycle: TFCommLifecycle;
begin
  if not Assigned(FCommLifecycle) then
  begin
    FCommLifecycle := TFCommLifecycle.Create;
    
    // Nastavit BaseUrl (pokud je zadana)
    if FCommBaseUrl <> '' then
      FCommLifecycle.HttpClient.BaseUrl := FCommBaseUrl;
    
    // Asynchronni start - NEZDRZUJE aplikaci
    try
      FCommLifecycle.Start('');  // Prazdny string = automaticke hledani fcomm.exe
    except
      // Ignorovat chyby - zkusime to pozdeji
    end;
  end;
  
  Result := FCommLifecycle;
end;

// Uvolnit v FormDestroy
procedure TfaMain.FormDestroy(Sender: TObject);
begin
  if Assigned(FCommLifecycle) then
  begin
    FCommLifecycle.Free;  // Ukoncit proces
    FCommLifecycle := nil;
  end;
end;
```

**Použití v EElPodani.pas:**

```pascal
procedure TfmElPodani.Init;
var
  Lifecycle: TFCommLifecycle;
  i: Integer;
begin
  // Pouzit globalni Lifecycle (lazy init)
  Lifecycle := GfaMain.GetFCommLifecycle;
  
  // Pockat, pokud jeste neni pripraveno (max 5s)
  if not Lifecycle.IsRunning then
  begin
    for i := 1 to 50 do
    begin
      if Lifecycle.IsRunning then Break;
      Sleep(100);
    end;
  end;
  
  // Kontrola dostupnosti
  if not Lifecycle.IsRunning then
  begin
    MessageErr(Caption, 'fcomm.exe není dostupný', [MBOK]);
    EXIT;
  end;
  
  // Pouzit API...
end;
```

### 2. FCommHttpClient - HTTP komunikace

```pascal
var
  HttpClient: TFCommHttpClient;
  Response: string;
begin
  HttpClient := TFCommHttpClient.Create;
  try
    // Nastavit BaseUrl (vychozi: http://localhost:54321)
    HttpClient.BaseUrl := 'http://192.168.0.28:54321';
    
    // GET request
    Response := HttpClient.Get('/api/certificates');
    
    // POST request
    Response := HttpClient.Post('/api/certificates/sign', '{"thumbprint":"..."}');
  finally
    HttpClient.Free;
  end;
end;
```

### 3. FCommJsonHelper - Parsování JSON

```pascal
uses
  FCommJsonHelper;

var
  JsonResponse: string;
  Certificates: TCertificateInfoArray;
begin
  JsonResponse := HttpClient.Get('/api/certificates');
  Certificates := ParseCertificatesJson(JsonResponse);
  
  // Pouzit certifikaty...
  for i := 0 to Length(Certificates) - 1 do
  begin
    ShowMessage(Certificates[i].SubjectFieldCommonName);
  end;
end;
```

## Konfigurace v FormStudio.ini

```ini
[Certificates]
; Prepinani mezi starym (CAPICOM) a novym (fcomm API) zpusobem
; UseFCommAPI=0  - stary zpusob pres CAPICOM (vychozi)
; UseFCommAPI=1  - novy zpusob pres fcomm HTTP API (doporuceno)
UseFCommAPI=0

; BaseUrl pro fcomm server (pro VM testovani)
; Vychozi: http://localhost:54321
; Pro testovani z VM: http://192.168.0.28:54321
FCommBaseUrl=http://localhost:54321
```

## Testování z VM

Pro testování z Windows 7 VM na fyzický stroj:

### 1. Spuštění serveru na fyzickém stroji (Windows 11)

```bash
cd D:\Projekty\fcomm-FAkomunikace\fcomm
start-development.bat
```

Server by měl běžet na portu 54321 a naslouchat na všech síťových rozhraních.

### 2. Zjištění IP adresy fyzického stroje

```bash
ipconfig
# Hledat "Ethernet adapter VMware Network Adapter VMnet8" (Bridged mode)
# Např: 192.168.0.28
```

### 3. Konfigurace FA na VM

V `FormStudio.ini` na VM:

```ini
[Certificates]
UseFCommAPI=1
FCommBaseUrl=http://192.168.0.28:54321  ; IP fyzickeho stroje
```

### 4. Jak to funguje

**Lokální URL** (localhost, 127.0.0.1):
- `GetFCommLifecycle()` **SPUSTÍ** lokální `fcomm.exe` automaticky
- Při zavření FA se proces **UKONČÍ**

**Remote URL** (jiné IP, např. 192.168.0.28):
- `GetFCommLifecycle()` **NESPOUŠTÍ** lokální proces
- Očekává, že server **již běží** na fyzickém stroji
- Při zavření FA se remote server **NEUKONČÍ**

### 5. Kontrola připojení

Po startu FA na VM zkontrolujte připojení:
- Dialog el. podání by měl načíst certifikáty z fyzického stroje
- Pokud se zobrazí chyba "fcomm.exe není dostupný", zkontrolujte:
  - Je server na fyzickém stroji spuštěný?
  - Je firewall na fyzickém stroji nakonfigurovaný?
  - Je IP adresa správná?
  - Je VM v bridged mode?

## Životní cyklus fcomm.exe

### Lazy Initialization (nová verze):

1. **Start FA:**
   - `FCommLifecycle` není vytvořen
   - FA se spustí rychle (bez čekání)

2. **První otevření el. podání:**
   - Zavolá se `GfaMain.GetFCommLifecycle`
   - Vytvoří se `FCommLifecycle`
   - Spustí se `fcomm.exe` (asynchronně)
   - Čeká se max 5s na připravení API
   - Načtou se certifikáty

3. **Další otevření el. podání:**
   - `fcomm.exe` už běží
   - Okamžité načtení certifikátů (bez čekání)

4. **Zavření FA:**
   - `FormDestroy` v `Main.pas`
   - Ukončí se `fcomm.exe`
   - Uvolní se `FCommLifecycle`

### Inteligentní detekce:

- Pokud `fcomm.exe` už běží (lokálně nebo remote), `Start()` ho znovu nespustí
- Pokud `BaseUrl` je remote, nepokouší se spustit lokální proces
- Pokud API není dostupné, zobrazí se chyba

## Delphi Search Path

Pro správnou kompilaci je třeba přidat do **Search Path** v Delphi 2007:

```
D:\Projekty\FsCursorBridge\fa-bridge\FAdelphi\FComm
```

**Postup:**
1. Project → Options → Directories/Conditionals
2. Search path: přidat cestu k FComm složce
3. OK

## Závislosti

- `IdHTTP` (Indy)
- `TlkJSON` (pro parsování JSON)
- `Windows` API (pro správu procesů)

## Poznámky

- Všechny unity v této složce jsou **nezávislé** na FA projektu
- Můžete je použít v jakémkoliv Delphi projektu
- Nepřidávejte prefix `FComm.` do `uses` - spravujte přes Search Path
- Pro Windows 10/11 pouze (Windows 7 není podporován)
