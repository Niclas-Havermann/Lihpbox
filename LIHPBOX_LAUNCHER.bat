@echo off
REM ============================================================
REM   LIHPBOX - Fotobox Steuerung - Advanced Launcher
REM   Diese Datei startet die Lihpbox-Anwendung mit Optionen
REM ============================================================

setlocal enabledelayedexpansion
color 0A
title LIHPBOX Launcher

echo.
echo ============================================================
echo            LIHPBOX - Fotobox Steuerung
echo ============================================================
echo.

REM Überprüfe ob Flutter installiert ist
flutter --version >nul 2>&1

if errorlevel 1 (
    echo [ERROR] Flutter ist nicht installiert!
    echo.
    echo Flutter ist erforderlich. Installiere es von:
    echo   https://flutter.dev/docs/get-started/install/windows
    echo.
    pause
    exit /b 1
)

REM Wechsle in das Projektverzeichnis
cd /d "%~dp0"

REM Überprüfe ob pubspec.yaml existiert
if not exist pubspec.yaml (
    echo [ERROR] pubspec.yaml nicht gefunden!
    echo Starten Sie diese Datei im Lihpbox-Verzeichnis.
    pause
    exit /b 1
)

:MENU
cls
echo.
echo ============================================================
echo            LIHPBOX - Launcher
echo ============================================================
echo.
echo Wähle eine Option:
echo.
echo   1) STARTEN - App im Debug-Modus (normal)
echo   2) RELEASE - Optimierte Version bauen (erste Ausführung)
echo   3) BEREINIGEN - Cache leeren (falls Fehler)
echo   4) EINSTELLUNGEN - Entwickler-Optionen
echo   5) EXIT - Beenden
echo.
set /p choice="Deine Wahl (1-5): "

if "%choice%"=="1" goto RUN_DEBUG
if "%choice%"=="2" goto BUILD_RELEASE
if "%choice%"=="3" goto CLEAN
if "%choice%"=="4" goto SETTINGS
if "%choice%"=="5" exit /b 0

echo Ungültige Auswahl!
timeout /t 2 /nobreak
goto MENU

:RUN_DEBUG
cls
echo.
echo [INFO] Überprüfe Abhängigkeiten...
flutter pub get >nul 2>&1

echo [INFO] Starte Lihpbox im Debug-Modus...
echo.
flutter run -d windows

if errorlevel 1 (
    echo.
    echo [ERROR] Fehler beim Starten
    pause
)
goto MENU

:BUILD_RELEASE
cls
echo.
echo [INFO] Erstelle optimierte Release-Version...
echo Dies kann mehrere Minuten dauern...
echo.

echo [1/3] Bereinige Build-Cache...
flutter clean

echo [2/3] Installiere Abhängigkeiten...
flutter pub get

echo [3/3] Baue Release-Version...
flutter build windows --release

if errorlevel 1 (
    echo.
    echo [ERROR] Build fehlgeschlagen
    pause
) else (
    echo.
    echo [OK] Build erfolgreich!
    echo Die App befindet sich in:
    echo   build\windows\x64\runner\Release\lihpbox.exe
    echo.
    pause
)
goto MENU

:CLEAN
cls
echo.
echo [INFO] Bereinige Projekt...
flutter clean
flutter pub get
echo [OK] Projekt bereinigt
echo.
pause
goto MENU

:SETTINGS
cls
echo.
echo ============================================================
echo                  Entwickler-Optionen
echo ============================================================
echo.
echo   1) Zeige Flutter-Version
echo   2) Zeige Dart-Version
echo   3) Überprüfe Kamera (gPhoto2)
echo   4) Überprüfe Drucker
echo   5) Zurück zum Menü
echo.
set /p dev_choice="Wahl (1-5): "

if "%dev_choice%"=="1" (
    echo.
    flutter --version
)
if "%dev_choice%"=="2" (
    echo.
    dart --version
)
if "%dev_choice%"=="3" (
    echo.
    echo Überprüfe gPhoto2...
    gphoto2 --version
    if errorlevel 1 (
        echo gPhoto2 nicht installiert!
    )
)
if "%dev_choice%"=="4" (
    echo.
    echo Überprüfe Drucker...
    powershell -Command "Get-Printer | Select-Object Name,DriverName"
)

pause
goto SETTINGS

endlocal
