#!/bin/bash
# Lihpbox - Start-Skript für Linux
# Dieses Skript startet die Lihpbox Flutter App im Debug-Modus

echo "=================================================="
echo "       LIHPBOX - Fotobox Steuerung starten"
echo "=================================================="
echo ""

# Überprüfe Flutter Installation
if ! command -v flutter &> /dev/null; then
    echo "❌ [ERROR] Flutter ist nicht installiert"
    echo "Bitte Flutter von https://flutter.dev installieren"
    exit 1
fi

# Überprüfe gPhoto2 (optional, aber empfohlen)
echo "🔍 Überprüfe gPhoto2..."
if ! command -v gphoto2 &> /dev/null; then
    echo "⚠️  [WARNING] gPhoto2 nicht gefunden - Kamera wird im Simulator-Modus betrieben"
    echo "Installieren Sie gPhoto2 mit: sudo apt install gphoto2"
    echo ""
else
    echo "✅ [OK] gPhoto2 ist verfügbar"
fi

echo ""
echo "🚀 Starte Lihpbox im Debug-Modus..."
echo ""

cd "$(dirname "$0")"
flutter run -d linux

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ App wurde erfolgreich beendet"
else
    echo ""
    echo "❌ Fehler beim Starten der App"
    exit 1
fi
