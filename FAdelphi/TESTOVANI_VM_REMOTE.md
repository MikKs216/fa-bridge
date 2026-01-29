# Testování FA z VM s remote fcomm API

## 🎯 Cíl
Testovat FA z Windows 7 VM, které se připojuje k `fcomm.exe` běžícím na fyzickém Windows 11 stroji.

## ✅ Co bylo implementováno

`GetFCommLifecycle()` nyní **automaticky detekuje**, jestli je `BaseUrl` lokální nebo remote:

### Lokální URL (localhost, 127.0.0.1)
- ✅ **SPUSTÍ** lokální `fcomm.exe` automaticky
- ✅ Při zavření FA se proces **UKONČÍ**

### Remote URL (jiné IP, např. 192.168.0.28)
- ✅ **NESPOUŠTÍ** lokální proces
- ✅ Očekává, že server **již běží** na fyzickém stroji
- ✅ Při zavření FA se remote server **NEUKONČÍ**

## 📋 Postup testování

### 1️⃣ Na fyzickém stroji (Windows 11)

**Spustit fcomm API server:**

```bash
cd D:\Projekty\fcomm-FAkomunikace\fcomm
start-development.bat
```

Server běží na: `http://0.0.0.0:54321` (naslouchá na všech rozhraních)

**Zjistit IP adresu:**

```bash
ipconfig
```

Hledat "Ethernet adapter VMware Network Adapter VMnet8" (Bridged mode)  
Např: **192.168.0.28**

**Ověřit firewall:**

```powershell
# Zkontrolovat existujici pravidlo
netsh advfirewall firewall show rule name="fcomm API Server"

# Pokud neexistuje, vytvorit (s admin pravy):
netsh advfirewall firewall add rule name="fcomm API Server" dir=in action=allow protocol=TCP localport=54321
```

### 2️⃣ Na VM (Windows 7)

**Upravit `FormStudio.ini`:**

```ini
[Certificates]
UseFCommAPI=1
FCommBaseUrl=http://192.168.0.28:54321  ; IP fyzickeho stroje (zjistit z ipconfig)
```

**Spustit FA:**
- FA se spustí **rychle** (bez pokusu o start lokálního `fcomm.exe`)
- Otevřít dialog el. podání
- Měly by se načíst certifikáty z fyzického stroje

### 3️⃣ Ověření

**Test připojení z VM:**

```bash
# V CMD nebo PowerShell na VM
curl http://192.168.0.28:54321/health
```

Mělo by vrátit:
```json
{"status":"ok","version":"1.0.0","...}
```

**V FA:**
- Otevřít dialog el. podání
- Měl by se zobrazit status: "Čekání na spuštění komunikačního modulu ..."
- Po max 5s by se měly načíst certifikáty

## 🔍 Řešení problémů

### ❌ "fcomm.exe není dostupný"

**Příčiny:**
1. Server na fyzickém stroji neběží → spustit `start-development.bat`
2. Firewall blokuje → přidat pravidlo (viz výše)
3. Špatná IP adresa → zkontrolovat `ipconfig` na fyzickém stroji
4. VM není v bridged mode → změnit v VMware Workstation

**Kontrola:**
```bash
# Na VM
curl http://192.168.0.28:54321/health
```

### ❌ "Čekání" trvá 5s a pak chyba

Server je spuštěný, ale FA ho nevidí:
- Zkontrolovat firewall na fyzickém stroji
- Zkontrolovat IP adresu v `FormStudio.ini`
- Zkontrolovat, že VM je v bridged mode

### ❌ FA se pokouší spustit lokální fcomm.exe

`BaseUrl` je špatně nastaveno:
- Musí být: `http://192.168.0.28:54321` (IP fyzického stroje)
- **NE**: `http://localhost:54321` nebo `http://127.0.0.1:54321`

## 📊 Očekávané chování

| Scénář | BaseUrl | Start lokálního fcomm.exe? | Ukončení při zavření FA? |
|--------|---------|---------------------------|--------------------------|
| **Lokální test** | `http://localhost:54321` | ✅ ANO | ✅ ANO |
| **Remote test z VM** | `http://192.168.0.28:54321` | ❌ NE | ❌ NE |

## 🎉 Výhody

1. **Automatická detekce** - není třeba manuálně říkat, jestli spustit server
2. **Rychlý start FA** - na VM se nečeká na start lokálního procesu
3. **Bezpečné ukončení** - remote server se neukončuje při zavření FA
4. **Jednoduchá konfigurace** - stačí změnit `FCommBaseUrl` v INI

## 🔗 Související soubory

- `Main.pas` - obsahuje `GetFCommLifecycle()` s detekcí remote URL
- `EElPodani.pas` - používá globální Lifecycle
- `FormStudio.ini` - konfigurace `FCommBaseUrl`
- `ZMENY_FCOMM_LAZY_INIT_2026-01-20.txt` - technický popis změn
