# Lihpbox - Flutter Fotobox Steuerung

Eine Flutter-Anwendung zur Steuerung einer Fotobox mit Nikon D7100 Kamera und Canon SELPHY CP1500 Drucker auf Windows.

## Features

✅ **Live-Kamera-Preview** - Echtzeit-Vorschau von der Nikon D7100
✅ **Timer-Auslöser** - Wählbare Verzögerung (3, 5 oder 10 Sekunden)
✅ **Automatischer Druck** - Drucke Fotos direkt auf den Canon SELPHY CP1500
✅ **USB-Speicher** - Speichere Fotos auf externem USB-Stick
✅ **Touchscreen-freundlich** - Optimiert für Touchscreen-Bedienung
✅ **Foto-Bestätigung** - Zeige das Foto vor dem Druck an

## Systemanforderungen

### Hardware
- Windows 10/11 PC mit Touchscreen
- Nikon D7100 Kamera (USB-Verbindung)
- Canon SELPHY CP1500 Drucker
- USB-Stick für Fotospeicherung

### Software - Installation notwendig!

#### 1. Visual Studio (ERFORDERLICH)
Die App kann nicht kompiliert werden, ohne Visual Studio installiert zu haben:

```bash
# Download von:
https://visualstudio.microsoft.com/downloads/

# Installiere die Workload "Desktop development with C++"
# Dies ist notwendig für Flutter Windows-Apps
```

#### 2. Flutter SDK
Falls noch nicht installiert:
```bash
# Von https://flutter.dev/docs/get-started/install/windows
```

#### 3. gPhoto2 (für Nikon-Kamera)
```bash
# Für Windows: Download von
https://sourceforge.net/projects/gphoto2/files/

# oder über Windows Package Manager:
winget install gPhoto2.gPhoto2
```

#### 4. Weitere Abhängigkeiten
```bash
cd c:\Users\nicla\OneDrive\Dokumente\Lihpbox
flutter pub get
```

## Installation & Setup

### Schritt 1: Visual Studio installieren (WICHTIG!)
1. Besuche: https://visualstudio.microsoft.com/
2. Lade "Community Edition" herunter
3. Führe den Installer aus
4. Wähle "Desktop development with C++" workload
5. Installiere alle Standard-Komponenten
6. Restart deinen PC nach Installation

### Schritt 2: Flutter vorbereiten
```bash
# Flutter diagnostizieren
flutter doctor

# Alle grünen Häkchen sollten sichtbar sein (außer Chrome/Android sind optional)
```

### Schritt 3: Nikon D7100 vorbereiten
1. Verbinde die Nikon D7100 via USB mit dem Laptop
2. Kamera sollte im USB-Modus sein (Mode: USB)
3. Überprüfe, dass gPhoto2 die Kamera erkennt:
```bash
gphoto2 --list-cameras
```

### Schritt 4: Canon SELPHY CP1500 vorbereiten
1. Verbinde den Canon SELPHY via USB
2. Installiere Drucker über Windows:
   - Einstellungen → Geräte → Drucker
   - "Drucker hinzufügen"
3. Der Drucker sollte dann in der App erkannt werden

### Schritt 5: USB-Stick vorbereiten
1. Verbinde einen USB-Stick
2. Der USB-Stick wird automatisch erkannt
3. Es wird ein "Lihpbox" Ordner erstellt

## App starten

```bash
cd c:\Users\nicla\OneDrive\Dokumente\Lihpbox

# App im Debug-Modus starten
flutter run -d windows

# Oder: Release-Build erstellen
flutter build windows --release
```

## Projektstruktur

```
lib/
├── main.dart                      # App-Einstiegspunkt
├── models/
│   ├── photo.dart                # Foto-Datenmodell
│   └── app_settings.dart         # App-Einstellungen
├── services/
│   ├── camera_service.dart       # Nikon D7100 Steuerung
│   ├── printer_service.dart      # Canon SELPHY Steuerung
│   ├── storage_service.dart      # USB-Verwaltung
│   └── photo_service.dart        # Foto-Metadaten
├── screens/
│   ├── home_screen.dart          # Startbildschirm
│   ├── preview_screen.dart       # Kamera-Vorschau
│   ├── photo_confirmation_screen.dart  # Foto-Bestätigung
│   └── settings_screen.dart      # Einstellungen
└── widgets/
    ├── custom_button.dart        # Button-Widget
    ├── timer_widget.dart         # Timer-Anzeige
    └── photo_display_widget.dart # Foto-Display
```

## Verwendung

### Hauptbildschirm
1. Systemdiagnose wird durchgeführt (Kamera, Drucker)
2. Wähle USB-Stick aus der Dropdown-Liste
3. Klicke "Fotobox starten"

### Kamera-Vorschau
1. Live-Vorschau der Nikon D7100 wird angezeigt
2. Klicke "Foto aufnehmen" um zu starten
3. Timer zählt runter (3, 5 oder 10 Sekunden - konfigurierbar)
4. Foto wird automatisch aufgenommen

### Foto-Bestätigung
1. Das aufgenommene Foto wird groß angezeigt
2. Klicke "Drucken" zum Ausdrucken auf dem Canon SELPHY
3. Oder "Abbrechen" um das Foto zu verwerfen
4. Nach Bestätigung zurück zur Vorschau

### Einstellungen
- Timer-Dauer einstellen (3, 5 oder 10 Sekunden)
- Auto-Delete nach Druck (optional)
- Live-Preview aktivieren/deaktivieren

## Troubleshooting

### "Visual Studio not found"
→ Installiere Visual Studio mit C++ Workload (s.o.)

### "gPhoto2 not available"
→ Installiere gPhoto2 und stelle sicher, dass es im PATH ist

### "Camera not recognized"
→ Verbinde Nikon D7100 via USB und stelle sicher, dass der USB-Modus aktiv ist

### "Printer not found"
→ Stelle sicher, dass der Canon SELPHY als Drucker in Windows registriert ist

### App startet nicht
```bash
# Lösche Build-Artefakte
flutter clean

# Versuche neu zu bauen
flutter pub get
flutter run -d windows
```

## Development

### Code-Stil
- Dart Style Guide folgen
- Verwendung von const wo möglich
- Aussagekräftige Variablennamen

### Logging
Nutze den Logger für Debugging:
```dart
import 'package:logger/logger.dart';

final logger = Logger();
logger.i('Info Nachricht');
logger.e('Fehler Nachricht', error: e);
```

### Build für Release
```bash
flutter build windows --release

# Executable befindet sich dann in:
# build/windows/runner/Release/lihpbox.exe
```

## Bekannte Limitierungen

1. **gPhoto2 ist nur für Nikon-Kameras mit USB-Unterstützung**
2. **Drucker müssen manuell als Windows-Drucker installiert sein**
3. **Live-Preview aktualisiert nicht in Echtzeit** (gPhoto2 Limitation)
4. **USB-Stick Wechsel erfordert App-Neustart**

## Zukünftige Verbesserungen

- [ ] Echtzeit Live-Preview via OpenCV
- [ ] Mehrfach-Druck-Optionen
- [ ] Galerie-Ansicht aller Fotos
- [ ] Foto-Bearbeitung (Effekte, Filter)
- [ ] Automatische Backup auf Netzwerk-Drive
- [ ] Multisprachen-Unterstützung
- [ ] Dark-Mode

## Unterstützung & Kontakt

Bei Fragen oder Problemen:
1. Überprüfe das Troubleshooting-Kapitel
2. Führe `flutter doctor -v` aus für detaillierte Informationen
3. Überprüfe die gPhoto2 und Drucker-Dokumentation

## Lizenz

Dieses Projekt wurde für die Lihpbox Fotobox entwickelt.

---

**Hinweis**: Stelle sicher, dass alle Hardware-Komponenten korrekt verbunden und aktualisiert sind, bevor du die App startest.
