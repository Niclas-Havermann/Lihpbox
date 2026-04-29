# 🎉 Lihpbox - Jetzt auch auf Linux/Ubuntu!

Dein Projekt wurde erfolgreich für Linux/Ubuntu umgestellt! Hier ist eine Übersicht aller Änderungen.

---

## ✅ Was wurde geändert?

### 1. **Linux-Plattform-Support hinzugefügt**
   - ✅ `linux/` Verzeichnis erstellt (Flutter Desktop Framework für Linux)
   - ✅ CMake Build-Konfiguration für Linux eingerichtet
   - ✅ GTK3 UI Framework konfiguriert

### 2. **Plattformunabhängiger Code**
   - ✅ `storage_service.dart`: USB-Erkennung jetzt auf Windows, Linux und macOS
   - ✅ `printer_service.dart`: Druckerfunktion für Windows (PowerShell) und Unix/Linux (CUPS)
   - ✅ `setup.sh`: Nun erkennt dein OS automatisch und gibt die richtigen Anweisungen

### 3. **Linux-Skripte erstellt**
   - ✅ `START_APP.sh` - App im Debug-Modus starten
   - ✅ `BUILD_RELEASE.sh` - Optimierte Release-Version bauen
   - ✅ `LINUX_QUICKSTART.txt` - Schnellstart für Linux-Benutzer

### 4. **Dokumentation**
   - ✅ `LINUX_SETUP.md` - Detaillierte Anleitung für Linux Setup
   - ✅ `LINUX_QUICKSTART.txt` - Kurzer Überblick für Eilige

---

## 🚀 Erste Schritte auf Linux/Ubuntu

### Schritt 1: Abhängigkeiten installieren
```bash
sudo apt update
sudo apt install -y build-essential cmake pkg-config libssl-dev \
  gphoto2 libgphoto2-dev libusb-1.0-0-dev libgtk-3-dev libblkid-dev
```

### Schritt 2: Flutter vorbereiten
```bash
# Starte das Setup-Skript
bash setup.sh
```

### Schritt 3: App starten
```bash
# Debug-Modus (für Entwicklung)
bash START_APP.sh

# oder direkt
flutter run -d linux
```

### Schritt 4: Release-Build erstellen
```bash
bash BUILD_RELEASE.sh

# Fertige App befindet sich in:
./build/linux/x64/release/bundle/lihpbox
```

---

## 📝 Änderungen im Code

### USB-Erkennung (storage_service.dart)
```dart
// Windows: D:\, E:\, etc.
// Linux: /mnt/, /media/, /run/media/
// macOS: /Volumes/
```

### Drucker-Unterstützung (printer_service.dart)
```dart
// Windows: PowerShell + Print API
// Linux/macOS: CUPS (lpstat, lp)
```

---

## 🔧 Systemanforderungen (Linux/Ubuntu)

- Ubuntu 20.04 LTS oder neuer
- Flutter 3.9.2+
- GCC/G++ Compiler
- GTK3 Dev-Libraries
- gPhoto2 (für Kamera-Unterstützung)
- CUPS (für Drucker-Unterstützung)

---

## 📚 Weitere Ressourcen

| Datei | Beschreibung |
|-------|-------------|
| [LINUX_SETUP.md](LINUX_SETUP.md) | Detaillierte Linux-Anleitung |
| [LINUX_QUICKSTART.txt](LINUX_QUICKSTART.txt) | Schnellstart-Anleitung |
| [DEVELOPMENT.md](DEVELOPMENT.md) | Entwickler-Dokumentation |
| [README_DE.md](README_DE.md) | Allgemeine Projektdokumentation |

---

## 🐛 Häufige Fehler und Lösungen

### "gphoto2: command not found"
```bash
sudo apt install gphoto2
```

### CMake/Build-Fehler
```bash
flutter clean
flutter pub get
flutter build linux --release
```

### Berechtigungsfehler bei Kamera
```bash
sudo usermod -a -G dialout $USER
newgrp dialout
```

---

## 💡 Tipps

1. **App systemweit verfügbar machen:**
   ```bash
   sudo ln -sf "$(pwd)/build/linux/x64/release/bundle/lihpbox" /usr/local/bin/lihpbox
   lihpbox  # Ab sofort von überall aufrufbar
   ```

2. **Desktop-Verknüpfung erstellen:**
   Siehe [LINUX_SETUP.md](LINUX_SETUP.md#-desktop-verknüpfung)

3. **Simulator-Modus verwenden:**
   Die App funktioniert auch ohne echte Kamera/Drucker (Simulator-Modus)

---

## 🎯 Was ist noch zu tun?

- [ ] App auf Linux testen
- [ ] gPhoto2 Verbindung zur Kamera überprüfen
- [ ] CUPS Drucker-Setup überprüfen
- [ ] Optional: macOS Support aktivieren

---

## ✨ Viel Erfolg auf Linux! 🐧

Bei Fragen oder Problemen, schau in [LINUX_SETUP.md](LINUX_SETUP.md) nach oder führe folgendes aus:

```bash
flutter doctor -v
```

Dies zeigt dir alle verfügbaren Plattformen und mögliche Probleme.

---

**Happy Coding! 🚀**
