# FA Bridge - Launch VS Code Extension Development
# Spust: .\launch-vscode-dev.ps1

$vscodePath = "C:\Users\Kastner\AppData\Local\Programs\Microsoft VS Code\Code.exe"
$projectPath = "D:\Projekty\FsCursorBridge\fa-bridge"

Write-Host ""
Write-Host "Spoustim VS Code Extension Development..." -ForegroundColor Green
Write-Host "Project: $projectPath" -ForegroundColor Cyan
Write-Host ""

# Zkompiluj projekt
Write-Host "Kompiluji TypeScript..." -ForegroundColor Yellow
Set-Location $projectPath

$env:PATH = "C:\Program Files\nodejs;$env:PATH"
& "C:\Program Files\nodejs\npm.cmd" run compile

Write-Host "Zkompilovano" -ForegroundColor Green
Write-Host ""

# Spust VS Code s workspace v Dev Host okne
Write-Host "Oteviram VS Code..." -ForegroundColor Yellow
$args = @(
    "--extensionDevelopmentPath=`"$projectPath`""
    "`"$projectPath`""
)
Start-Process -FilePath $vscodePath -ArgumentList $args

Write-Host ""
Write-Host "VS Code spusten!" -ForegroundColor Green
Write-Host ""
Write-Host "V Dev Host okne muzes testovat extension:" -ForegroundColor Cyan
Write-Host "  - Ctrl+Shift+P -> 'FA: Test'" -ForegroundColor Gray
Write-Host "  - Ctrl+Alt+F -> Menu" -ForegroundColor Gray
Write-Host "  - Ctrl+Alt+1,2,3,9 -> Prikazy" -ForegroundColor Gray
Write-Host ""

# Pockej na stisk klavesy
Write-Host "Stiskni libovolnou klavesu pro ukonceni..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
