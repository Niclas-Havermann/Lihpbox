@echo off
REM Lihpbox Setup-Skript für Windows
REM Dieses Skript hilft bei der Einrichtung der Lihpbox Flutter App

cls
color 0B
echo.
echo ============================================
echo     LIHPBOX - Fotobox Setup-Assistent
echo ============================================
echo.

REM Überprüfe Flutter Installation
echo [1/5] Überprüfe Flutter Installation...
flutter --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Flutter ist nicht installiert oder nicht im PATH
    echo Bitte Flutter von https://flutter.dev installieren
    pause
    exit /b 1
) else (
    echo [OK] Flutter ist installiert
)

REM Überprüfe Visual Studio
echo.
echo [2/5] Überprüfe Visual Studio...
where cl.exe >nul 2>&1
if errorlevel 1 (
    echo [WARNING] Visual Studio C++ Compiler nicht gefunden
    echo Bitte Visual Studio mit "Desktop development with C++" installieren
    echo https://visualstudio.microsoft.com/downloads/
    echo.
) else (
    echo [OK] Visual Studio Compiler gefunden
)

REM Überprüfe gPhoto2
echo.
echo [3/5] Überprüfe gPhoto2 für Kamera-Unterstützung...
where gphoto2 >nul 2>&1
if errorlevel 1 (
    echo [WARNING] gPhoto2 nicht im PATH gefunden
    echo Sie können es später installieren: https://sourceforge.net/projects/gphoto2/
    echo oder: winget install gPhoto2.gPhoto2
) else (
    echo [OK] gPhoto2 ist verfügbar
)

REM Abhängigkeiten installieren
echo.
echo [4/5] Installiere Flutter-Abhängigkeiten...
cd /d "%~dp0"
call flutter pub get
if errorlevel 1 (
    echo [ERROR] Fehler beim Installieren von Abhängigkeiten
    pause
    exit /b 1
) else (
    echo [OK] Abhängigkeiten installiert
)

REM Vollständige Diagnose
echo.
echo [5/5] Führe vollständige Diagnose durch...
call flutter doctor

echo.
echo ============================================
echo     SETUP ABGESCHLOSSEN
echo ============================================
echo.
echo Die App ist bereit zur Verwendung!
echo.
echo Um die App zu starten:
echo   flutter run -d windows
echo.
echo Weitere Informationen: README_DE.md
echo.
pause
