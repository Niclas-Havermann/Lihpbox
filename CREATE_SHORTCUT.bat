@echo off
REM Erstellt einen Shortcut auf dem Desktop

setlocal enabledelayedexpansion

color 0C
cls

echo.
echo =====================================
echo    LIHPBOX SHORTCUT ERSTELLER
echo =====================================
echo.

cd /d "%~dp0"

REM Desktop-Pfad
set "DESKTOP=%USERPROFILE%\Desktop"

REM PowerShell Skript zur Shortcut-Erstellung
powershell -Command ^
"$WshShell = New-Object -ComObject WScript.Shell; ^
$Shortcut = $WshShell.CreateShortcut('%DESKTOP%\Lihpbox.lnk'); ^
$Shortcut.TargetPath = '%~dp0START_APP.bat'; ^
$Shortcut.WorkingDirectory = '%~dp0'; ^
$Shortcut.IconLocation = '%~dp0\windows\runner\resources\app_icon.ico'; ^
$Shortcut.Description = 'Lihpbox Fotobox App'; ^
$Shortcut.Save()"

if %errorlevel% equ 0 (
    echo [OK] Shortcut erstellt!
    echo Pfad: %DESKTOP%\Lihpbox.lnk
) else (
    echo [ERROR] Fehler beim Erstellen des Shortcuts
)

echo.
pause
