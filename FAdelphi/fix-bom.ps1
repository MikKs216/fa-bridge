# Skript pro opravu UTF-8 BOM v souboru FTestUtils.pas
$file = "FTestUtils.pas"
$bytes = [System.IO.File]::ReadAllBytes($file)
$hasBOM = $bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF

if (-not $hasBOM) {
    Write-Host "Soubor nema BOM - pridavam..."
    $bom = [byte[]](0xEF, 0xBB, 0xBF)
    $newContent = $bom + $bytes
    [System.IO.File]::WriteAllBytes($file, $newContent)
    Write-Host "BOM byl pridan"
} else {
    Write-Host "Soubor jiz ma BOM"
}
