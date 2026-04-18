@echo off
REM Lihpbox Release Builder
REM Erstellt eine produktionsreife .exe Datei

setlocal enabledelayedexpansion

color 0B
cls

echo.
echo =====================================
echo    LIHPBOX RELEASE BUILDER
echo =====================================
echo.

cd /d "%~dp0"

REM Überprüfe Flutter
flutter --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Flutter ist nicht installiert!
    pause
    exit /b 1
)

echo [INFO] Starte Release-Build...
echo Dies kann 3-5 Minuten dauern...
echo.

REM Erstelle Release-Build
call flutter build windows --release

if errorlevel 1 (
    echo.
    echo [ERROR] Build fehlgeschlagen!
    pause
    exit /b 1
)

echo.
echo =====================================
echo    BUILD ERFOLGREICH!
echo =====================================
echo.
echo Executable Pfad:
echo %~dp0build\windows\runner\Release\lihpbox.exe
echo.
echo Ordner öffnen? (J/N)
set /p choice="Eingabe: "

if /i "%choice%"=="J" (
    start explorer "%~dp0build\windows\runner\Release"
)

echo.
echo Fertig!
pause
