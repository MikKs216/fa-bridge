@echo off
REM Batch soubor pro kopirovani souboru do distribucnich slozek
REM Autor: AI Assistant
REM Datum: 2026-01-20

echo ========================================
echo Kopirovani souboru do distribucnich slozek
echo ========================================
echo.

REM 1. EPMF slozka - vsechny .pas soubory
echo [1/5] Kopirovani EPMF souboru...
xcopy /Y /I "Z:\Distrib\Projekty\FsCursorBridge\fa-bridge\FAdelphi\EPMF\*.pas" "D:\D2007AddOn\EPMF\"
if %errorlevel% equ 0 (
    echo OK: EPMF soubory zkopirovany
) else (
    echo CHYBA: Kopirovani EPMF souboru selhalo!
)
echo.

REM 2. FComm slozka - vsechny .pas soubory
echo [2/5] Kopirovani FComm souboru...
xcopy /Y /I "Z:\Distrib\Projekty\FsCursorBridge\fa-bridge\FAdelphi\FComm\*.pas" "D:\D2007AddOn\FComm\"
if %errorlevel% equ 0 (
    echo OK: FComm soubory zkopirovany
) else (
    echo CHYBA: Kopirovani FComm souboru selhalo!
)
echo.

REM 3. EElPodDM.pas
echo [3/5] Kopirovani EElPodDM.pas...
copy /Y "Z:\Distrib\Projekty\FsCursorBridge\fa-bridge\FAdelphi\EElPodDM.pas" "D:\Vyvoj\FormStudioFull\FA\"
if %errorlevel% equ 0 (
    echo OK: EElPodDM.pas zkopirovan
) else (
    echo CHYBA: Kopirovani EElPodDM.pas selhalo!
)
echo.

REM 4. EElPodani.pas
echo [4/5] Kopirovani EElPodani.pas...
copy /Y "Z:\Distrib\Projekty\FsCursorBridge\fa-bridge\FAdelphi\EElPodani.pas" "D:\Vyvoj\FormStudioFull\FA\"
if %errorlevel% equ 0 (
    echo OK: EElPodani.pas zkopirovan
) else (
    echo CHYBA: Kopirovani EElPodani.pas selhalo!
)
echo.

REM 5. Main.pas
echo [5/5] Kopirovani Main.pas...
copy /Y "Z:\Distrib\Projekty\FsCursorBridge\fa-bridge\FAdelphi\Main.pas" "D:\Vyvoj\FormStudioFull\FA\"
if %errorlevel% equ 0 (
    echo OK: Main.pas zkopirovan
) else (
    echo CHYBA: Kopirovani Main.pas selhalo!
)
echo.

echo ========================================
echo Kopirovani dokonceno!
echo ========================================
echo.
pause
