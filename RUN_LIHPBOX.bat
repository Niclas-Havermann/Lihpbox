@echo off
REM ============================================================
REM   LIHPBOX - Fotobox Steuerung - Launcher
REM   Diese Datei startet die Lihpbox-Anwendung
REM ============================================================

setlocal enabledelayedexpansion

echo.
echo ============================================================
echo            LIHPBOX - Fotobox Steuerung
echo ============================================================
echo.

REM Überprüfe ob Flutter installiert ist
echo [INFO] Überprüfe Flutter Installation...
flutter --version >nul 2>&1

if errorlevel 1 (
    echo [ERROR] Flutter ist nicht installiert!
    echo.
    echo Flutter ist erforderlich. Installiere es von:
    echo   https://flutter.dev/docs/get-started/install
    echo.
    echo Nach der Installation, führe dieses Skript erneut aus.
    echo.
    pause
    exit /b 1
)

echo [OK] Flutter gefunden
echo.

REM Wechsle in das Projektverzeichnis
cd /d "%~dp0"

REM Überprüfe ob pubspec.yaml existiert
if not exist pubspec.yaml (
    echo [ERROR] pubspec.yaml nicht gefunden!
    echo Stelle sicher, dass du diese Datei im Lihpbox-Verzeichnis startest.
    pause
    exit /b 1
)

echo [INFO] Überprüfe Abhängigkeiten...
flutter pub get >nul 2>&1

if errorlevel 1 (
    echo [ERROR] Fehler beim Installieren von Abhängigkeiten
    pause
    exit /b 1
)

echo [OK] Abhängigkeiten installiert
echo.

echo [INFO] Starte Lihpbox...
echo.

REM Starte die App
flutter run -d windows

if errorlevel 1 (
    echo.
    echo [ERROR] Fehler beim Starten der App
    pause
    exit /b 1
)

exit /b 0
