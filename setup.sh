#!/bin/bash
# Lihpbox Setup-Skript für macOS/Linux
# Dieses Skript hilft bei der Einrichtung der Lihpbox Flutter App

clear

echo "==========================================="
echo "    LIHPBOX - Fotobox Setup-Assistent"
echo "==========================================="
echo ""

# Überprüfe Flutter Installation
echo "[1/5] Überprüfe Flutter Installation..."
if ! command -v flutter &> /dev/null; then
    echo "[ERROR] Flutter ist nicht installiert"
    echo "Bitte Flutter von https://flutter.dev installieren"
    exit 1
else
    echo "[OK] Flutter ist installiert"
    flutter --version
fi

# Überprüfe gPhoto2
echo ""
echo "[2/5] Überprüfe gPhoto2 für Kamera-Unterstützung..."
if ! command -v gphoto2 &> /dev/null; then
    echo "[WARNING] gPhoto2 nicht gefunden"
    echo "Installation:"
    echo "  macOS: brew install gphoto2"
    echo "  Linux: sudo apt install gphoto2"
else
    echo "[OK] gPhoto2 ist verfügbar"
fi

# Abhängigkeiten installieren
echo ""
echo "[3/5] Installiere Flutter-Abhängigkeiten..."
cd "$(dirname "$0")"
flutter pub get
if [ $? -ne 0 ]; then
    echo "[ERROR] Fehler beim Installieren von Abhängigkeiten"
    exit 1
else
    echo "[OK] Abhängigkeiten installiert"
fi

# Überprüfe Windows-Plattform
echo ""
echo "[4/5] Überprüfe Plattformen..."
if ! grep -q "windows" pubspec.yaml; then
    echo "[INFO] Windows-Plattform aktivieren..."
    flutter config --enable-windows-desktop
fi

# Vollständige Diagnose
echo ""
echo "[5/5] Führe vollständige Diagnose durch..."
flutter doctor

echo ""
echo "==========================================="
echo "    SETUP ABGESCHLOSSEN"
echo "==========================================="
echo ""
echo "Die App ist bereit zur Verwendung!"
echo ""
echo "Um die App zu starten:"
echo "  flutter run -d windows"
echo ""
echo "Weitere Informationen: README_DE.md"
echo ""
