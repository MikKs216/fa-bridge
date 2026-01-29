# FComm Shared Process - Sdílený API Server

## Přehled

FComm API server běží jako **sdílený proces**, který mohou používat multiple instance FA i jiné aplikace současně. Server se automaticky spouští, kontroluje verze a volitelně se ukončuje.

## Architektura

```
┌─────────────────────────────────────────────────────────────┐
│                     FComm API Server                         │
│                    (fcomm.exe - port 54321)                  │
│                                                              │
│  - Běží stále (až do restartu počítače)                     │
│  - Sdílený mezi všemi aplikacemi                            │
│  - Automatické spouštění při prvním použití                 │
│  - Automatický restart při upgrade verze                    │
└─────────────────────────────────────────────────────────────┘
         ▲              ▲              ▲              ▲
         │              │              │              │
    ┌────┴────┐    ┌────┴────┐    ┌────┴────┐    ┌────┴────┐
    │ FA #1   │    │ FA #2   │    │ FA #3   │    │ Jiná    │
    │         │    │         │    │         │    │ aplikace│
    └─────────┘    └─────────┘    └─────────┘    └─────────┘
```

## Klíčové komponenty

### 1. FCommStarter.pas

Samostatný unit s funkcemi pro správu FComm API serveru:

- `EnsureFCommAPI()` - hlavní funkce pro zajištění dostupnosti
- `IsFCommAPIRunning()` - kontrola běhu serveru
- `GetFCommAPIVersion()` - zjištění verze serveru
- `ShutdownFCommAPI()` - ukončení serveru
- `GetFCommExePath()` - auto-detekce cesty k fcomm.exe

### 2. Verze API

Každá aplikace specifikuje **minimální požadovanou verzi** API:

```pascal
const
  FCOMM_MIN_VERSION_MAJOR = 1;
  FCOMM_MIN_VERSION_MINOR = 0;
  FCOMM_MIN_VERSION_PATCH = 0;
```

## Životní cyklus

### Flowchart

```
Start aplikace (FA)
         │
         ▼
  UseFCommAPI = 1?
         │
    ┌────┴────┐
    │ NE      │ ANO
    │         │
    ▼         ▼
  CAPICOM   EnsureFCommAPI(async)
            │
            ▼
      Je server dostupný? (/health)
            │
       ┌────┴────┐
       │ ANO     │ NE
       │         │
       ▼         ▼
  Verze OK?   Spustit fcomm.exe
       │         │
  ┌────┴────┐   │
  │ ANO     │ NE│
  │         │   │
  ▼         ▼   │
 Ready    Shutdown + Restart
            │   │
            └───┴───► Čekat max 10s
                      (test každých 100ms)
                            │
                       ┌────┴────┐
                       │ Ready?  │
                       │         │
                  ┌────┴────┐    │
                  │ ANO     │ NE │
                  │         │    │
                  ▼         ▼    ▼
                Ready    Chyba  Pokračovat
                                (async mode)
```

### Scénáře

#### 1. První spuštění FA (server neběží)

```
1. FormCreate → EnsureFCommAPIAvailable(True)  // async
2. Server neběží → spustí fcomm.exe
3. Vrátí Success=True ihned (async)
4. FA pokračuje v načítání
```

#### 2. Druhá instance FA (server už běží)

```
1. FormCreate → EnsureFCommAPIAvailable(True)  // async
2. Server běží → zkontroluje verzi
3. Verze OK → vrátí Success=True ihned
4. FA pokračuje v načítání
```

#### 3. Použití API (otevření el. podání)

```
1. EElPodani.Init → EnsureFCommAPIAvailable(False)  // sync
2. Server běží → zkontroluje verzi
3. Verze OK → vrátí Success=True (cca 50ms)
4. Načte certifikáty přes API
```

#### 4. Stará verze běží

```
1. EnsureFCommAPIAvailable(False)  // sync
2. Server běží, ale verze 0.9.0 < 1.0.0
3. Zavolá /admin/shutdown
4. Počká max 10s na ukončení (test každých 100ms)
5. Spustí nový fcomm.exe
6. Počká max 10s na ready (test každých 100ms)
7. Vrátí Success=True (WasRestarted=True)
```

#### 5. Remote testing z VM

```
1. FCommBaseUrl = http://192.168.0.28:54321
2. EnsureFCommAPIAvailable(True)
3. Detekuje remote URL → nespouští lokální proces
4. Testuje /health na remote URL
5. Pokud běží → Success=True
6. Pokud neběží → Success=False (nelze spustit remote)
```

## Použití v kódu

### Start aplikace (asynchronní)

```pascal
procedure TfaMain.FormCreate(Sender: TObject);
begin
  // ... inicializace ...
  
  // Zajistit dostupnost FComm API (asynchronne - nezdrzujeme start)
  if UseFCommAPI then
    EnsureFCommAPIAvailable(True);  // True = async
  
  // ... zbytek FormCreate ...
end;
```

### Před použitím API (synchronní)

```pascal
procedure TfmElPodani.Init;
begin
  if GfaMain.UseFCommAPI then
  begin
    // Zajistit dostupnost FComm API (synchronne - musime pockat)
    mxStatusBar.Panels[0].Text := 'Kontrola komunikačního modulu ...';
    
    if not GfaMain.EnsureFCommAPIAvailable(False) then  // False = sync
    begin
      MessageErr(Caption, 'Komunikacni modul není dostupný.', [MBOK]);
      EXIT;
    end;
    
    // Pouzit API...
    MFCRModule.CertificatesLoad;
  end;
end;
```

### Ukončení aplikace (volitelné)

```pascal
procedure TfaMain.FormDestroy(Sender: TObject);
begin
  // VOLITELNE: Ukoncit FComm API pri zavreni FA
  // Vychozi: nechavame bezet pro dalsi instance
  // if UseFCommAPI then
  //   ShutdownFCommAPI(FCommBaseUrl);
  
  // ... zbytek FormDestroy ...
end;
```

## Inteligentní čekání

Funkce `EnsureFCommAPI` používá **inteligentní čekání**:

- **Maximum:** 10 sekund (100 iterací × 100ms)
- **Testování:** Každých 100ms zavolá `/health`
- **Okamžitý exit:** Jakmile je server ready, pokračuje dál

```pascal
// Pockat max 10s (100 iteraci po 100ms)
// Jakmile je ready, hned pokracujeme (nečekáme celých 10s!)
for i := 1 to 100 do
begin
  if IsFCommAPIRunning(Url) then
  begin
    // Server je ready!
    Exit;
  end;
  
  Sleep(100);
end;
```

**Typické časy:**
- Server už běží: **~50ms** (jeden health check)
- Server se spouští: **~1-2s** (čas na start + health check)
- Restart serveru: **~2-3s** (shutdown + start + health check)

## Konfigurace

### FormStudio.ini

```ini
[Certificates]
UseFCommAPI=1

; BaseUrl pro fcomm server
FCommBaseUrl=http://localhost:54321

; Cesta k fcomm.exe (volitelne)
; FCommExePath=C:\Custom\Path\fcomm.exe
```

### Main.pas - Požadovaná verze

```pascal
const
  FCOMM_MIN_VERSION_MAJOR = 1;
  FCOMM_MIN_VERSION_MINOR = 0;
  FCOMM_MIN_VERSION_PATCH = 0;
```

## Výhody

1. **Žádné objekty v paměti** - pouze funkce, žádný lifecycle management
2. **Sdílený proces** - multiple instance FA bez problémů
3. **Automatická kontrola verze** - restart pokud je stará
4. **Flexibilní ukončení** - volitelné (zakomentované v FormDestroy)
5. **Použitelné i jinde** - jiné aplikace mohou volat stejnou funkci
6. **Async start** - FA se nezdržuje při startu (~50ms overhead)
7. **Sync before use** - před použitím se počká na ready (typicky ~50ms)
8. **Inteligentní čekání** - max 10s, ale exit jakmile je ready

## Testování

### Lokální test

```bash
# 1. Spustit FA
# 2. Otevřít el. podání
# 3. Zkontrolovat, že fcomm.exe běží v Task Manageru
# 4. Zavřít FA
# 5. fcomm.exe stále běží (vychozi)
# 6. Spustit druhou instanci FA
# 7. Otevřít el. podání - okamžitě ready (server už běží)
```

### Remote test z VM

```bash
# 1. Na fyzickém stroji spustit fcomm.exe
cd D:\Projekty\fcomm-FAkomunikace\fcomm
start-development.bat

# 2. V FA na VM nastavit FormStudio.ini:
FCommBaseUrl=http://192.168.0.28:54321

# 3. Spustit FA na VM
# 4. Otevřít el. podání - připojí se na remote server
```

### Test upgrade verze

```bash
# 1. Spustit starou verzi fcomm.exe (např. 0.9.0)
# 2. Změnit FCOMM_MIN_VERSION_* na 1.0.0
# 3. Spustit FA
# 4. Otevřít el. podání
# 5. FA automaticky ukončí starou verzi a spustí novou
```

## Troubleshooting

### "Komunikacni modul není dostupný"

**Příčiny:**
1. fcomm.exe neexistuje v adresáři programu
2. fcomm.exe se nepodařilo spustit (chybí .NET 9.0)
3. Port 54321 je obsazený jiným procesem
4. Remote server neběží (při testování z VM)

**Řešení:**
1. Zkontrolovat, že fcomm.exe existuje
2. Zkontrolovat, že .NET 9.0 Runtime je nainstalovaný
3. Změnit port v server-config.json
4. Spustit fcomm.exe na fyzickém stroji

### Server se nespouští po upgradu

**Příčiny:**
1. Starý server se nepodařilo ukončit
2. Timeout 10s nestačil

**Řešení:**
1. Ručně ukončit fcomm.exe v Task Manageru
2. Spustit FA znovu

### Multiple instance FA spouští multiple servery

**Příčiny:**
1. Single-instance mutex nefunguje
2. Různé BaseUrl v různých instancích

**Řešení:**
1. Zkontrolovat, že všechny instance mají stejný FCommBaseUrl
2. Zkontrolovat, že fcomm.exe používá Named Mutex

## Související soubory

- `FComm/FCommStarter.pas` - hlavní funkce
- `Main.pas` - EnsureFCommAPIAvailable()
- `EElPodani.pas` - použití před načtením certifikátů
- `FormStudio.ini` - konfigurace
- `fcomm/Program.cs` - server s /health a /admin/shutdown endpointy
