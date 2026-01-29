===============================================================================
RYCHLÝ START - KONFIGURACE CERTIFIKÁTŮ
===============================================================================

OTEVŘETE: FormStudio.ini

NAJDĚTE SEKCI:
[Certificates]
UseFCommAPI=1
FCommBaseUrl=

===============================================================================
VARIANTY NASTAVENÍ
===============================================================================

1. PRODUKCE (Windows 10/11 - localhost)
   UseFCommAPI=1
   FCommBaseUrl=

2. VM TESTOVÁNÍ (Win7 VM → Win11 fyzický stroj)
   UseFCommAPI=1
   FCommBaseUrl=http://192.168.0.28:54321
   (Nahraďte IP adresou vašeho fyzického stroje)

3. STARÝ ZPŮSOB (Windows 7 bez fcomm)
   UseFCommAPI=0
   FCommBaseUrl=

===============================================================================
SPUŠTĚNÍ fcomm SERVERU (pro UseFCommAPI=1)
===============================================================================

Na Windows 11 (fyzický stroj):
cd D:\Projekty\fcomm-FAkomunikace\fcomm
start-development.bat

Server běží na: http://0.0.0.0:54321

===============================================================================
FIREWALL (pro VM testování)
===============================================================================

PowerShell jako Administrator:
New-NetFirewallRule -DisplayName "FAComm Server" -Direction Inbound -Protocol TCP -LocalPort 54321 -Action Allow

===============================================================================
TEST KONEKTIVITY Z VM
===============================================================================

curl http://192.168.0.28:54321/health

Očekávaný výstup:
{"status":"ok","version":"1.0.0","timestamp":"..."}

===============================================================================
PODROBNÁ DOKUMENTACE
===============================================================================

Viz: KONFIGURACE_CERTIFIKATY.md

===============================================================================
