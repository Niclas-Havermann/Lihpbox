#!/bin/bash
# Lihpbox - Build-Skript für Linux Release
# Dieses Skript erstellt eine optimierte Release-Version für Linux

echo "=================================================="
echo "   LIHPBOX - Release Build für Linux erstellen"
echo "=================================================="
echo ""

# Überprüfe Flutter Installation
if ! command -v flutter &> /dev/null; then
    echo "❌ [ERROR] Flutter ist nicht installiert"
    echo "Bitte Flutter von https://flutter.dev installieren"
    exit 1
fi

echo "✅ Flutter erkannt: $(flutter --version | head -1)"
echo ""

# Wechsle in das Projektverzeichnis
cd "$(dirname "$0")" || exit 1

# Bereinige vorherige Builds
echo "🧹 Bereinige vorherige Builds..."
flutter clean
if [ $? -ne 0 ]; then
    echo "❌ Fehler beim Cleanup"
    exit 1
fi
echo "✅ Cleanup abgeschlossen"
echo ""

# Installiere Abhängigkeiten
echo "📦 Installiere Abhängigkeiten..."
flutter pub get
if [ $? -ne 0 ]; then
    echo "❌ Fehler beim Installieren von Abhängigkeiten"
    exit 1
fi
echo "✅ Abhängigkeiten installiert"
echo ""

# Erstelle Release-Build
echo "🔨 Erstelle Release-Build..."
flutter build linux --release
if [ $? -ne 0 ]; then
    echo "❌ Fehler beim Build"
    exit 1
fi
echo "✅ Release-Build abgeschlossen"
echo ""

# Info zum Ausführen
echo "=================================================="
echo "✅ BUILD ERFOLGREICH!"
echo "=================================================="
echo ""
echo "Die ausführbare Datei befindet sich unter:"
echo "  ./build/linux/x64/release/bundle/lihpbox"
echo ""
echo "Um die App zu starten:"
echo "  ./build/linux/x64/release/bundle/lihpbox"
echo ""
