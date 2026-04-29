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

# Überprüfe Desktop-Plattformen
echo ""
echo "[4/5] Überprüfe Desktop-Plattformen..."
case "$OSTYPE" in
  linux*)
    if ! grep -q "linux" pubspec.yaml; then
      echo "[INFO] Linux-Plattform wird unterstützt"
    fi
    echo "[OK] Linux erkannt"
    ;;
  darwin*)
    if ! grep -q "macos" pubspec.yaml; then
      echo "[INFO] macOS-Plattform aktivieren..."
      flutter config --enable-macos-desktop
    fi
    echo "[OK] macOS erkannt"
    ;;
  msys*|mingw*)
    if ! grep -q "windows" pubspec.yaml; then
      echo "[INFO] Windows-Plattform aktivieren..."
      flutter config --enable-windows-desktop
    fi
    echo "[OK] Windows erkannt"
    ;;
esac

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
case "$OSTYPE" in
  linux*)
    echo "Um die App zu starten:"
    echo "  bash START_APP.sh"
    echo "  oder: flutter run -d linux"
    echo ""
    echo "Weitere Informationen: LINUX_SETUP.md"
    ;;
  darwin*)
    echo "Um die App zu starten:"
    echo "  flutter run -d macos"
    ;;
  msys*|mingw*)
    echo "Um die App zu starten:"
    echo "  flutter run -d windows"
    ;;
esac
echo ""
