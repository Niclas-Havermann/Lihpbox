<<<<<<< HEAD
# Lihpbox - Flutter Fotobox Steuerung

Flutter-Anwendung zur Steuerung einer Fotobox mit Nikon D7100 und Canon SELPHY CP1500.
Unterstutzt Windows und Linux.
=======
# lihpbox
#Test
A new Flutter project.
>>>>>>> 9fdd2c95e50983efacf7869f516f37d613a04b42

---

## Features

- Live-Kamera-Preview von der Nikon D7100
- Konfigurierbarer Timer-Ausloser (3, 5 oder 10 Sekunden)
- Automatischer Druck auf Canon SELPHY CP1500
- Foto-Speicherung auf USB-Stick
- Touchscreen-optimierte Bedienung
- Foto-Bestatigungs-Screen vor dem Druck

---

## Systemanforderungen

### Hardware

- Windows 10/11 PC mit Touchscreen (oder Linux Ubuntu 20.04+)
- Nikon D7100 Kamera (USB-Verbindung)
- Canon SELPHY CP1500 Drucker
- USB-Stick (mind. 2 GB, FAT32 oder NTFS)
- 4 GB RAM empfohlen

### Software

- Flutter 3.9.2+
- gPhoto2 (Kamera-Integration)
- **Nur Windows:** Visual Studio 2022+ mit Workload "Desktop development with C++"
- **Nur Linux:** GCC/CMake/GTK3 Build-Tools, CUPS

---

## Setup

### Windows

1. **Visual Studio installieren**
   - Download: https://visualstudio.microsoft.com/
   - Workload wahlen: "Desktop development with C++"
   - PC nach Installation neu starten

2. **gPhoto2 installieren**
   ```bat
   winget install gPhoto2.gPhoto2
   ```

3. **Projekt vorbereiten**
   ```bat
   .\setup.bat
   ```
   Das Skript pruft Flutter, installiert Dependencies und diagnostiziert die Hardware.

4. **App starten**
   ```bat
   flutter run -d windows
   ```

### Linux / Ubuntu

1. **Abhangigkeiten installieren**
   ```bash
   sudo apt update
   sudo apt install -y build-essential cmake pkg-config libssl-dev \
     gphoto2 libgphoto2-dev libusb-1.0-0-dev libgtk-3-dev libblkid-dev
   ```

2. **Flutter installieren** (falls noch nicht vorhanden)
   ```bash
   git clone https://github.com/flutter/flutter.git ~/flutter
   echo 'export PATH="$PATH:~/flutter/bin"' >> ~/.bashrc
   source ~/.bashrc
   ```

3. **Projekt vorbereiten**
   ```bash
   bash setup.sh
   ```

4. **App starten**
   ```bash
   bash START_APP.sh
   # oder: flutter run -d linux
   ```

5. **USB-Kamera-Berechtigungen** (falls Kamera nicht erkannt)
   ```bash
   sudo usermod -a -G dialout $USER
   newgrp dialout
   ```

---

## App starten - Ubersicht

| Methode | Datei / Befehl | Verwendung |
|---------|---------------|------------|
| Terminal Debug | `flutter run -d windows` | Entwicklung, Logs sichtbar |
| Batch-Skript | `START_APP.bat` | Taglicher Betrieb (Windows) |
| Shell-Skript | `bash START_APP.sh` | Taglicher Betrieb (Linux) |
| Release-Build | `BUILD_RELEASE.bat` / `BUILD_RELEASE.sh` | Produktion, keine Flutter-Abhangigkeit |
| Launcher-Menu | `LIHPBOX_LAUNCHER.bat` | Menu mit Start / Release / Bereinigen |
| VS Code | F5 | Entwicklung mit Debugger |

**Release-Build erstellen (Windows):**
```bat
.\BUILD_RELEASE.bat
```
Die fertige `.exe` liegt unter: `build\windows\x64\runner\Release\lihpbox.exe`

**Release-Build erstellen (Linux):**
```bash
bash BUILD_RELEASE.sh
# Ergebnis: ./build/linux/x64/release/bundle/lihpbox
```

**Desktop-Shortcut erstellen (Windows):**
```bat
.\CREATE_SHORTCUT.bat
```

**App beim Windows-Autostart:**
Shortcut zur `.exe` in `%AppData%\Microsoft\Windows\Start Menu\Programs\Startup\` legen.

**Linux systemweit verfugbar machen:**
```bash
sudo ln -sf "$(pwd)/build/linux/x64/release/bundle/lihpbox" /usr/local/bin/lihpbox
```

---

## Erste Verwendung

### Homescreen

1. Geratediagnostik abwarten (grun = verbunden)
2. USB-Stick aus der Dropdown-Liste wahlen
3. "Fotobox starten" klicken

### Foto aufnehmen

1. **Preview-Screen:** "Foto aufnehmen" klicken
2. Timer zahlt runter (5 → 4 → 3 → 2 → 1 → Foto)
3. **Bestatigungsscreen:** Foto prufen
   - "Drucken" → Canon SELPHY druckt (~30 Sek.)
   - "Abbrechen" → Foto wird geloscht, zuruck zur Vorschau

### Einstellungen

- Timer-Dauer: 3 / 5 / 10 Sekunden
- Auto-Delete nach Druck
- Live-Preview aktivieren/deaktivieren

**Empfehlungen:**
- 3 Sek.: Schnappschusse
- 5 Sek.: Standard
- 10 Sek.: Gruppenfotos

---

## Hardware-Konfiguration

### Nikon D7100

1. USB-Kabel anschliessen
2. Kamera-Menu: Setup → USB → PTP-Modus aktivieren
3. Verbindung prufen:
   ```
   gphoto2 --list-cameras
   # Ausgabe: Nikon D7100 (PTP mode)
   ```

**Troubleshooting:**
- Anderes USB-Kabel / anderen Port versuchen
- Kamera aus- und wieder einschalten
- gPhoto2 neu installieren: `winget uninstall gPhoto2 && winget install gPhoto2.gPhoto2`
- Windows-Treiber aktualisieren

### Canon SELPHY CP1500

**Installation (Windows):**
1. USB verbinden oder WLAN-Netzwerk
2. Einstellungen → Gerate → Drucker hinzufugen → "Canon SELPHY CP1500"
3. Prufen: `Get-Printer` in PowerShell

**Papier und Farbband einlegen:**
- Hintere Luke offnen
- Canon Fotopapier-Kassette einschieben
- Farbband-Kassette einschieben (gleichzeitig)

**Installation (Linux - CUPS):**
```bash
lpstat -p -d      # Drucker anzeigen
```

**Troubleshooting:**
```powershell
# Windows: Druckwarteschlange leeren
Remove-Item -Path "C:\Windows\System32\spool\PRINTERS\*" -Force
Restart-Service spooler

# Treiber erneuern
Remove-Printer -Name "Canon SELPHY CP1500"
```

### USB-Stick

- FAT32 oder NTFS formatiert
- Mindestens 2 GB freier Speicherplatz
- USB 3.0 fur bessere Geschwindigkeit empfohlen

**Ordnerstruktur auf USB-Stick:**
```
D:\
└── Lihpbox\
    └── Photos\
        ├── photo_1714000000000.jpg
        └── ...
```

**USB-Stick wechseln:** App neu starten, neuer Stick wird automatisch erkannt.

---

## Entwicklung

### Architektur

```
UI Layer (Screens)
    └── Widget Layer (Components)
            └── Service Layer (Business Logic)
                    └── Platform Layer (gPhoto2, PowerShell, CUPS, USB)
```

### Projektstruktur

```
lib/
├── main.dart
├── models/
│   ├── photo.dart            # Foto-Objekt (id, filePath, timestamp, isPrinted)
│   └── app_settings.dart     # Einstellungen (timerDuration, usbPath, autoDelete)
├── services/
│   ├── camera_service.dart   # Nikon D7100 via gPhoto2
│   ├── printer_service.dart  # Canon SELPHY (Windows: PowerShell, Linux: CUPS)
│   ├── storage_service.dart  # USB-Erkennung (Windows: D-Z:\, Linux: /mnt /media)
│   └── photo_service.dart    # Foto-Metadaten-Verwaltung
├── screens/
│   ├── home_screen.dart
│   ├── preview_screen.dart
│   ├── photo_confirmation_screen.dart
│   └── settings_screen.dart
└── widgets/
    ├── custom_button.dart    # Button mit Loading-Indikator und Hover-Effekt
    ├── timer_widget.dart     # Countdown mit Circular Progress, Farbwechsel < 3 Sek.
    └── photo_display_widget.dart
```

### Services - API-Referenz

**CameraService** (Singleton)
```dart
Future<bool> initializeCamera()
Future<String?> startLivePreview()
Future<String?> capturePhoto(String outputPath)
Future<List<String>> getConnectedCameras()
Future<void> disconnect()
```

**PrinterService** (Singleton)
```dart
Future<bool> initializePrinter()
Future<List<String>> getAvailablePrinters()
Future<bool> printPhoto(String filePath, {int copies = 1})
Future<String> getPrinterStatus()
```

**StorageService** (Singleton)
```dart
Future<List<String>> detectUsbDrives()
Future<bool> setUsbPath(String usbPath)
Future<String?> savePhoto(String sourcePath)
Future<bool> hasEnoughSpace()
Future<bool> deletePhoto(String filePath)
Future<List<String>> getStoredPhotos()
```

**PhotoService** (Singleton)
```dart
void addPhoto(Photo photo)
Photo? get currentPhoto
void markAsPrinted(String photoId)
void removePhoto(String photoId)
void clearAll()
```

### Singleton-Pattern

Alle Services nutzen das Singleton-Pattern:
```dart
class CameraService {
  static final CameraService _instance = CameraService._internal();
  CameraService._internal();
  factory CameraService() => _instance;
}
```

### Logging

```dart
import 'package:logger/logger.dart';
final logger = Logger();
logger.i('Info');
logger.w('Warnung');
logger.e('Fehler', error: e);
logger.d('Debug');
```

### Neuen Screen hinzufugen

1. `lib/screens/new_screen.dart` erstellen
2. In `main.dart` Route hinzufugen:
   ```dart
   routes: { '/new-screen': (context) => const NewScreen() }
   ```
3. Navigation: `Navigator.of(context).pushNamed('/new-screen');`

### Neuen Service erstellen

```dart
// lib/services/my_service.dart
class MyService {
  static final MyService _instance = MyService._internal();
  factory MyService() => _instance;
  MyService._internal();

  Future<void> doSomething() async {
    try {
      // Implementierung
    } catch (e) {
      logger.e('Fehler: $e');
    }
  }
}
```

### Best Practices

- `const` verwenden wo moglich (Performance)
- `final` statt `var`
- Named Parameters fur Widgets
- Services kapseln die gesamte Geschaftslogik, nie direkt in UI
- Mindest-Button-Grosse: 48dp Hohe (Touchscreen)

### Debugging

```bash
flutter analyze          # Code-Qualitat prufen
dart fix --apply         # Automatische Fixes

flutter run -v           # Ausfuhrliche Logs
flutter run -d windows   # Starten + Hot Reload (r), Hot Restart (R), Quit (q)

# Dart DevTools
devtools
```

---

## Troubleshooting

| Problem | Losung |
|---------|--------|
| "Visual Studio not found" | Visual Studio mit C++ Workload installieren |
| "gPhoto2 not found" | `winget install gPhoto2.gPhoto2` |
| "Camera not recognized" | USB-Kabel, PTP-Modus prufen, gPhoto2 testen |
| "Printer not found" | Drucker als Windows-Drucker registrieren |
| "flutter not found" | Flutter neu installieren, PATH prufen |
| Build-Fehler / App startet nicht | `flutter clean && flutter pub get && flutter run -d windows` |
| Kamera-Berechtigungen (Linux) | `sudo usermod -a -G dialout $USER && newgrp dialout` |
| GTK3-Fehler (Linux) | `sudo apt install libgtk-3-dev libblkid-dev` |

---

## Bekannte Limitierungen

- gPhoto2 unterstutzt nur Kameras mit PTP/USB
- Drucker muss manuell als Windows-Drucker registriert sein
- Live-Preview aktualisiert nicht in Echtzeit (gPhoto2-Einschrankung)
- USB-Stick-Wechsel erfordert App-Neustart
- macOS noch nicht vollstandig getestet

---

## Zukuftige Features (TODO)

- Echtzeit Live-Preview via OpenCV
- Foto-Galerie-Ansicht
- Foto-Bearbeitung (Helligkeit, Filter, Effekte)
- Mehrfach-Druck-Optionen
- Multisprachen-Unterstutzung
- Cloud-Backup-Integration
- QR-Code-Generierung
- Remote-Bedienung via Web
- Dark Mode

---

## Projekt-Status

| Bereich | Status |
|---------|--------|
| Alle Screens | erledigt |
| Alle Services | erledigt |
| Alle Widgets | erledigt |
| Windows-Plattform | erledigt |
| Linux-Plattform | erledigt, noch zu testen |
| Hardware-Tests | ausstehend (abh. von Hardware) |
| Production-Build | bereit (nach VS-Installation) |

**Plattform-Unterstutzung:**

| Plattform | Kamera (gPhoto2) | Drucker | USB-Erkennung |
|-----------|-----------------|---------|---------------|
| Windows | ja | PowerShell + Print API | D:\ bis Z:\ |
| Linux | ja | CUPS (lpstat, lp) | /mnt, /media, /run/media |
| macOS | ja | CUPS | /Volumes |

---

## Abhangigkeiten (pubspec.yaml)

- `path_provider` - Dateisystem-Zugriff
- `file_picker` - Dateiauswahl
- `image` - Bildverarbeitung
- `printing` - Druck-Integration
- `logger` - Logging
- `fluttertoast` - Benachrichtigungen

---

**Version:** 1.0 | **Flutter:** 3.35.5+ | **Stand:** April 2026
