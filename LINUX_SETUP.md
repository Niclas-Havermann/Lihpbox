# 🐧 Lihpbox auf Linux (Ubuntu/Debian) einrichten

Dieses Dokument erklärt, wie du Lihpbox auf Linux-Systemen zum Laufen bringst.

---

## 📋 Voraussetzungen

- **Linux-Distribution**: Ubuntu 20.04 LTS oder neuer (oder äquivalentes Debian-basiertes System)
- **Flutter**: Version 3.9.2 oder neuer
- **Dart SDK**: Wird mit Flutter installiert
- **Build-Tools**: CMake, GCC, pkg-config

---

## 🚀 Schritt 1: Flutter installieren

Falls Flutter noch nicht installiert ist:

```bash
# 1. Flutter SDK herunterladen
git clone https://github.com/flutter/flutter.git ~/flutter
cd ~/flutter
git checkout stable

# 2. Flutter zum PATH hinzufügen
export PATH="$PATH:~/flutter/bin"

# Optional: Dauerhaft zum PATH hinzufügen
echo 'export PATH="$PATH:~/flutter/bin"' >> ~/.bashrc
source ~/.bashrc

# 3. Überprüfe Installation
flutter --version
flutter doctor
```

---

## 🔧 Schritt 2: Linux-Abhängigkeiten installieren

```bash
# Erforderliche Build-Pakete
sudo apt update
sudo apt install -y build-essential cmake pkg-config libssl-dev

# Für gPhoto2 (Kamera-Unterstützung)
sudo apt install -y gphoto2 libgphoto2-dev libusb-1.0-0-dev

# Für GTK (Flutter Linux GUI)
sudo apt install -y libgtk-3-dev libblkid-dev
```

---

## 💾 Schritt 3: Projekt einrichten

```bash
# 1. Projekt klonen oder in Projektverzeichnis navigieren
cd ~/lihpbox

# 2. Setup-Skript ausführen
bash setup.sh

# Oder manuell:
flutter pub get
```

---

## ▶️ Schritt 4: App starten

### Debug-Modus (Schnelle Entwicklung):
```bash
bash START_APP.sh
# oder
flutter run -d linux
```

### Release-Build (Optimiert für Produktion):
```bash
bash BUILD_RELEASE.sh

# Ausführbare Datei befindet sich dann in:
./build/linux/x64/release/bundle/lihpbox
```

---

## 📸 Kamera-Einrichtung

### gPhoto2 ist installiert?

```bash
# Überprüfe Installation
gphoto2 --version

# Verbinde Nikon D7100 und überprüfe Verbindung
gphoto2 --list-cameras

# Test: Live-Preview starten
gphoto2 --capture-image-and-download --skip-existing
```

### Berechtigungen für USB-Zugriff

Falls die Kamera nicht erkannt wird, benötigt dein Benutzer USB-Berechtigungen:

```bash
# Füge deinen Benutzer zur dialout-Gruppe hinzu
sudo usermod -a -G dialout $USER

# Änderungen werden nach Neustart wirksam
sudo reboot

# Oder führe Befehl aus, ohne neu zu starten
newgrp dialout
```

---

## 🐛 Häufige Probleme

### Problem: "flutter: command not found"
```bash
# Überprüfe, ob Flutter im PATH ist
echo $PATH | grep flutter

# Falls nein, füge es hinzu
export PATH="$PATH:~/flutter/bin"
```

### Problem: "gphoto2: command not found"
```bash
sudo apt install gphoto2
```

### Problem: CMake/Build-Fehler
```bash
# Installiere Build-Essentials
sudo apt install build-essential cmake

# Versuche Clean-Build
flutter clean
flutter pub get
flutter build linux
```

### Problem: GTK3-Fehler
```bash
sudo apt install libgtk-3-dev libblkid-dev
```

### Problem: Kamera wird nicht erkannt
```bash
# Überprüfe USB-Berechtigungen
gphoto2 --list-cameras

# Falls Fehler: Berechtigungen anpassen
sudo usermod -a -G dialout $USER
newgrp dialout
```

---

## 📦 Installation als Systembefehl

Um die App systemweit verfügbar zu machen:

```bash
# 1. Release-Build erstellen
bash BUILD_RELEASE.sh

# 2. Symbolic Link in /usr/local/bin erstellen
sudo ln -sf "$(pwd)/build/linux/x64/release/bundle/lihpbox" /usr/local/bin/lihpbox

# 3. Ab sofort von überall starten
lihpbox
```

---

## 🔗 Desktop-Verknüpfung

Erstelle eine `.desktop`-Datei für das Anwendungsmenü:

```bash
# Navigiere zum Projektverzeichnis
cd ~/lihpbox

# Erstelle Desktop-Datei
sudo nano ~/.local/share/applications/lihpbox.desktop
```

Füge folgendes ein:
```ini
[Desktop Entry]
Version=1.0
Type=Application
Name=Lihpbox - Fotobox Steuerung
Comment=Nikon D7100 Fotobox Steuerungssoftware
Exec=/path/to/build/linux/x64/release/bundle/lihpbox
Icon=camera
Terminal=false
Categories=Utility;Photography;
```

(Ersetze `/path/to/` mit dem echten Pfad)

Dann ist die App im Anwendungsmenü sichtbar.

---

## ✅ Alles fertig?

Starte die App:
```bash
bash START_APP.sh
```

Viel Erfolg! 🎉
