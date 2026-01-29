# Nastavení UTF-8 BOM pro Delphi 2007

## Problém
Delphi 2007 vyžaduje UTF-8 soubory s BOM (Byte Order Mark) pro správné zobrazení diakritiky. 
AI nástroje (Cursor Composer) při úpravách souborů mohou BOM odstranit.

## Řešení

### 1. Automatická oprava BOM
Spusťte skript po každé úpravě souboru přes AI:
```powershell
.\fix-bom.ps1
```

### 2. Konfigurační soubory
- `.editorconfig` - nastavení charset = utf-8-bom pro *.pas
- `.vscode/settings.json` - nastavení encoding pro VS Code
- `.cursor/settings.json` - nastavení encoding pro Cursor
- `.gitattributes` - nastavení pro Git

### 3. Ruční kontrola BOM
```powershell
$bytes = [System.IO.File]::ReadAllBytes('FTestUtils.pas')
$hasBOM = $bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF
if ($hasBOM) { Write-Host "Ma BOM" } else { Write-Host "Nema BOM" }
```

## Doporučení
Po každé úpravě souboru přes AI Composer spusťte `fix-bom.ps1` pro zajištění správného kódování.
