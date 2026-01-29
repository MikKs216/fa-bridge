# fcomm Remote Testing - Testování z VM

## Přehled

Upravená logika v `FCommLifecycle.pas` umožňuje používat **externí běžící fcomm server** místo spouštění lokální instance. To je ideální pro testování z VM na fyzický stroj.

## Jak to funguje

### Nová logika při `Start()`:

```
1. Zkontrolovat HealthCheck na nakonfigurované URL
   ↓
2. Pokud odpovídá → ✅ POUŽÍT (nespouštět nový)
   ↓
3. Pokud neodpovídá:
   ├─ Remote URL? → ❌ ERROR (server není dostupný)
   └─ Lokální URL? → Spustit lokální fcomm.exe
```

### Detekce Remote vs. Lokální URL:

**Lokální URL** (spustí se fcomm.exe, pokud neběží):
- `http://localhost:54321`
- `http://127.0.0.1:54321`
- `http://[::1]:54321` (IPv6)
- prázdný string (default)

**Remote URL** (NESPUSTÍ fcomm.exe, jen zkusí připojit):
- `http://192.168.0.28:54321`
- `http://10.0.0.5:54321`
- jakákoliv jiná IP adresa

## Testovací scénáře

### ✅ Scénář A: VM → Fyzický stroj (hlavní use-case)

**Na fyzickém stroji (Windows 11):**
```cmd
cd D:\Projekty\fcomm-FAkomunikace\fcomm
dotnet run
```
Server běží na `http://192.168.0.28:54321`

**Na VM (Windows 7):**

`FormStudio.ini`:
```ini
[Certificates]
UseFCommAPI=1
FCommBaseUrl=http://192.168.0.28:54321
```

**Výsledek:**
1. FA detekuje remote URL
2. Zkontroluje HealthCheck na 192.168.0.28:54321
3. ✅ Server odpovídá → použije ho
4. ❌ Lokální fcomm.exe se **NESPUSTÍ**

---

### ✅ Scénář B: Lokální testování (Windows 11)

`FormStudio.ini`:
```ini
[Certificates]
UseFCommAPI=1
FCommBaseUrl=                    ; prázdné nebo http://localhost:54321
```

**Výsledek:**
1. FA detekuje lokální URL
2. Zkontroluje HealthCheck na localhost:54321
3. Pokud neodpovídá → **SPUSTÍ** lokální fcomm.exe
4. Pokud už běží → použije existující

---

### ✅ Scénář C: Lokální s ručně spuštěným serverem

**Terminál:**
```cmd
cd D:\Projekty\fcomm-FAkomunikace\fcomm
dotnet run
```

`FormStudio.ini`:
```ini
[Certificates]
UseFCommAPI=1
FCommBaseUrl=                    ; prázdné
```

**Výsledek:**
1. FA detekuje lokální URL
2. Zkontroluje HealthCheck na localhost:54321
3. ✅ Server už běží → použije ho
4. **NESPUSTÍ** druhý proces

---

### ❌ Scénář D: Remote server není dostupný

`FormStudio.ini`:
```ini
[Certificates]
UseFCommAPI=1
FCommBaseUrl=http://192.168.0.28:54321
```

Server na 192.168.0.28 **NEBĚŽÍ**

**Výsledek:**
```
Exception: fcomm server na adrese http://192.168.0.28:54321 
           neni dostupny. Ujistete se, ze server bezi na vzdalem pocitaci.
```

## Technické detaily

### Změny v `FCommLifecycle.pas`:

#### 1. Nová private metoda `IsRemoteBaseUrl`:
```pascal
function TFCommLifecycle.IsRemoteBaseUrl(const BaseUrl: string): Boolean;
var
  LowerUrl: string;
begin
  LowerUrl := LowerCase(BaseUrl);
  
  Result := not (
    (Pos('localhost', LowerUrl) > 0) or
    (Pos('127.0.0.1', LowerUrl) > 0) or
    (Pos('::1', LowerUrl) > 0) or
    (LowerUrl = '') or
    (LowerUrl = 'http://localhost:54321')
  );
end;
```

#### 2. Upravená `Start` metoda:
- Nejprve zkontroluje `IsRunning()` (HealthCheck)
- Pokud běží → nastaví `FProcessHandle := -1` (externí server)
- Pokud neběží a je remote URL → Exception
- Pokud neběží a je lokální URL → spustí fcomm.exe

#### 3. Upravená `Stop` metoda:
- Pouze ukončí proces, pokud `FProcessHandle > 0` (lokální proces)
- Pokud `FProcessHandle = -1` (externí server) → NIC NEUKONČUJE

### Indikátor typu serveru:

| `FProcessHandle` | Význam |
|------------------|--------|
| `> 0` | Lokální proces spuštěný FA |
| `= -1` | Externí server (VM → fyzický stroj) |
| `= 0` | Žádný server |

## Konfigurace pro různá prostředí

### Development (Windows 11):
```ini
[Certificates]
UseFCommAPI=1
FCommBaseUrl=
```

### VM Testing (Windows 7 → Windows 11):
```ini
[Certificates]
UseFCommAPI=1
FCommBaseUrl=http://192.168.0.28:54321
```

### Production:
```ini
[Certificates]
UseFCommAPI=0    ; Zatím starý CAPICOM
; FCommBaseUrl=  ; Nepoužívá se
```

## Firewall pravidla (připomenutí)

Pro testování z VM musí být na fyzickém stroji povolen příchozí provoz:

```cmd
netsh advfirewall firewall add rule name="fcomm API" dir=in action=allow protocol=TCP localport=54321
```

## Výhody tohoto řešení

✅ **Žádné ruční spouštění/zastavování** - automatická detekce  
✅ **Bezpečné pro remote** - nepokoušíme se ukončit cizí server  
✅ **Flexibilní** - funguje pro lokální i remote scénáře  
✅ **Chytrá detekce** - podle URL pozná, co má dělat  
✅ **Debug friendly** - můžete manuálně spustit server a FA ho použije  

## Troubleshooting

### Problém: "fcomm server není dostupný"
**Příčina:** Server na remote IP neběží nebo je firewall blokuje  
**Řešení:**
1. Ověřit, že server běží: `curl http://192.168.0.28:54321/health`
2. Zkontrolovat firewall pravidla
3. Ověřit síťové připojení mezi VM a fyzickým strojem

### Problém: FA spustí nový fcomm.exe místo použití existujícího
**Příčina:** Pravděpodobně není nastavena `FCommBaseUrl` v INI  
**Řešení:** Zkontrolovat `FormStudio.ini` sekci `[Certificates]`

### Problém: FA se pokouší spustit fcomm.exe, který neexistuje
**Příčina:** `UseFCommAPI=1` ale fcomm.exe není ve složce s FA.exe  
**Řešení:**
1. Zkompilovat fcomm: `dotnet publish -c Release -r win-x64 --self-contained`
2. Zkopírovat do složky s FA.exe
3. Nebo použít remote URL místo lokálního

---

**Datum:** 2026-01-19  
**Autor:** AI Assistant  
**Verze:** 1.0
