# Konfigurace načítání certifikátů

## 📋 Přehled

FormAsistent podporuje **dva způsoby** načítání certifikátů:

1. **NOVÝ** - přes fcomm HTTP API (doporučeno, .NET 9)
2. **STARÝ** - přes CAPICOM (Windows 7 kompatibilní)

## ⚙️ Konfigurace v FormStudio.ini

Otevřete soubor `FormStudio.ini` a upravte sekci `[Certificates]`:

```ini
[Certificates]
; Způsob načítání certifikátů:
; UseFCommAPI=1  - nový způsob přes fcomm HTTP API (doporučeno)
; UseFCommAPI=0  - starý způsob přes CAPICOM (Windows 7 kompatibilní)
UseFCommAPI=1

; BaseUrl pro fcomm server (pouze při UseFCommAPI=1)
; Výchozí (prázdné): http://127.0.0.1:54321 (localhost)
; Pro VM testování z Win7: http://192.168.0.28:54321
FCommBaseUrl=
```

## 🚀 Použití

### Varianta 1: Nový způsob (fcomm API) - DOPORUČENO

**Pro produkční prostředí (Windows 10/11):**
```ini
[Certificates]
UseFCommAPI=1
FCommBaseUrl=
```

**Pro VM testování (Win7 VM → Win11 fyzický stroj):**
```ini
[Certificates]
UseFCommAPI=1
FCommBaseUrl=http://192.168.0.28:54321
```
*(Nahraďte IP adresou vašeho fyzického stroje)*

### Varianta 2: Starý způsob (CAPICOM)

**Pro Windows 7 nebo pokud nefunguje fcomm:**
```ini
[Certificates]
UseFCommAPI=0
FCommBaseUrl=
```

## 🔧 Požadavky

### Pro nový způsob (UseFCommAPI=1):
- ✅ Windows 10/11: `fcomm.exe` (.NET 9, 64-bit)
- ✅ Windows 7: `fcomm-win7.exe` (.NET 6, 32-bit)
- ✅ Automatická detekce OS a výběr správné verze
- ✅ Port 54321 musí být volný

### Pro starý způsob (UseFCommAPI=0):
- ✅ Windows 7/10/11
- ✅ CAPICOM.dll musí být registrována
- ✅ Funguje bez fcomm.exe

## 🌐 VM testování (Windows 7 VM)

### 1. Zjistit IP fyzického stroje (Win11)
```powershell
# Na Win11 (fyzický stroj)
ipconfig
```
Hledejte adaptér s bridged připojením (např. `192.168.0.28`).

### 2. Spustit fcomm server na Win11
```cmd
cd D:\Projekty\fcomm-FAkomunikace\fcomm
start-development.bat
```

Server naslouchá na `0.0.0.0:54321` (všechny síťové rozhraní).

### 3. Otevřít firewall na Win11
```powershell
# PowerShell jako Administrator
New-NetFirewallRule -DisplayName "FAComm Server" -Direction Inbound -Protocol TCP -LocalPort 54321 -Action Allow
```

### 4. Nastavit FormStudio.ini na Win7 VM
```ini
[Certificates]
UseFCommAPI=1
FCommBaseUrl=http://192.168.0.28:54321
```

### 5. Test konektivity z VM
```cmd
curl http://192.168.0.28:54321/health
```

Očekávaná odpověď:
```json
{"status":"ok","version":"1.0.0","timestamp":"..."}
```

## 🐛 Řešení problémů

### Certifikáty se nenačítají (nový způsob)
1. **Zkontrolujte, zda běží fcomm.exe:**
   - Otevřete Task Manager
   - Hledejte proces `FACommService.exe` nebo `fcomm.exe`

2. **Zkontrolujte port 54321:**
   ```cmd
   netstat -ano | findstr :54321
   ```

3. **Zkuste starý způsob:**
   ```ini
   UseFCommAPI=0
   ```

### Certifikáty se nenačítají (starý způsob)
1. **Registrujte CAPICOM.dll:**
   ```cmd
   regsvr32 /s "C:\cesta\k\capicom.dll"
   ```

2. **Zkuste nový způsob:**
   ```ini
   UseFCommAPI=1
   ```

### VM nemůže přistoupit na fcomm server
1. **Zkontrolujte IP adresu:**
   - Musí být IP fyzického stroje, ne `127.0.0.1`

2. **Zkontrolujte firewall:**
   - Port 54321 musí být otevřený na Win11

3. **Zkontrolujte síťové nastavení VM:**
   - Musí být Bridged mode, ne NAT

## 📝 Poznámky

- **Automatické přepínání:** Stačí změnit `UseFCommAPI` v INI souboru, není třeba překompilovat
- **Kompatibilita:** Oba způsoby mají stejné API, změna je transparentní
- **Výchozí nastavení:** Pokud INI soubor neexistuje, použije se nový způsob (fcomm API)
- **BaseUrl:** Pokud je prázdný, použije se výchozí `http://127.0.0.1:54321`

## 🎯 Doporučení

- **Produkce (Win10/11):** `UseFCommAPI=1`, `FCommBaseUrl=` (prázdné)
- **Vývoj/Ladění (Win7 VM):** `UseFCommAPI=1`, `FCommBaseUrl=http://192.168.0.28:54321`
- **Windows 7 bez VM:** `UseFCommAPI=0` (starý způsob)

---

**Datum:** 2026-01-17  
**Verze:** 1.0
