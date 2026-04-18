@echo off
REM Lihpbox Flutter App Starter
REM Einfach diese Datei doppelklicken zum Starten

setlocal enabledelayedexpansion

REM Farben
color 0A

cls
echo.
echo =====================================
echo    LIHPBOX STARTER
echo =====================================
echo.

REM Wechsle zum Projekt-Verzeichnis
cd /d "%~dp0"

REM Überprüfe ob Flutter installiert ist
flutter --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Flutter ist nicht installiert!
    echo Bitte Flutter von https://flutter.dev installieren
    pause
    exit /b 1
)

echo [INFO] Starte Lihpbox App...
echo.

REM Starte die App
flutter run -d windows

pause
