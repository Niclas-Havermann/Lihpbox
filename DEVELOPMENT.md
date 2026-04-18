# 👨‍💻 Lihpbox - Development Guide

Dieses Dokument ist für Entwickler, die den Lihpbox-Code erweitern und verbessern möchten.

---

## 🏗️ Architektur-Übersicht

```
┌─────────────────────────────────────────┐
│          UI Layer (Screens)             │
│  (home, preview, confirmation, settings)│
└────────────────┬────────────────────────┘
                 │
┌─────────────────▼────────────────────────┐
│         Widget Layer (Components)        │
│    (buttons, timer, photo_display)       │
└─────────────────┬────────────────────────┘
                 │
┌─────────────────▼────────────────────────┐
│       Service Layer (Business Logic)     │
│  (camera, printer, storage, photo)       │
└─────────────────┬────────────────────────┘
                 │
┌─────────────────▼────────────────────────┐
│      Platform Layer (OS Integration)     │
│  (gPhoto2, Windows APIs, USB)            │
└─────────────────────────────────────────┘
```

---

## 📦 Projektstruktur - Detailliert

### `lib/models/` - Datenmodelle

**photo.dart**
```dart
class Photo {
  final String id;                // Eindeutige ID
  final String filePath;          // Pfad zur Datei
  final DateTime timestamp;       // Zeitstempel
  final String fileName;          // Dateiname
  bool isPrinted;                 // Gedruckt? ja/nein
}
```

**app_settings.dart**
```dart
class AppSettings {
  int timerDuration;              // 3, 5, oder 10 Sekunden
  String? usbStoragePath;         // USB-Laufwerk Pfad
  bool autoDeleteAfterPrint;      // Automatisch nach Druck löschen
  bool enablePreview;             // Live-Preview aktiviert
}
```

---

### `lib/services/` - Geschäftslogik

#### **camera_service.dart** - Nikon D7100 Kontrolle

**Hauptmethoden:**
```dart
// Initialisierung
Future<bool> initializeCamera()

// Live Preview laden
Future<String?> startLivePreview()

// Foto aufnehmen
Future<String?> capturePhoto(String outputPath)

// Verbindung trennen
Future<void> disconnect()

// Verfügbare Kameras auflisten
Future<List<String>> getConnectedCameras()
```

**Implementierungsdetails:**
- Nutzt `Process.run()` um gPhoto2 zu starten
- gPhoto2 wird mit verschiedenen CLI-Argumenten aufgerufen
- Rückgabewerte werden geparst

#### **printer_service.dart** - Canon SELPHY Kontrolle

**Hauptmethoden:**
```dart
// Initialisierung
Future<bool> initializePrinter()

// Verfügbare Drucker
Future<List<String>> getAvailablePrinters()

// Foto drucken
Future<bool> printPhoto(String filePath, {int copies = 1})

// Alternative Druck-Methode
Future<bool> printPhotoAlternative(String filePath)

// Status abrufen
Future<String> getPrinterStatus()
```

**Implementierungsdetails:**
- Nutzt PowerShell für Drucker-Verwaltung
- Canon SELPHY wird als Windows-Drucker registriert
- Fallback auf Standard-Drucker möglich

#### **storage_service.dart** - USB-Verwaltung

**Hauptmethoden:**
```dart
// USB-Laufwerke erkennen
Future<List<String>> detectUsbDrives()

// USB-Pfad setzen
Future<bool> setUsbPath(String usbPath)

// Foto speichern
Future<String?> savePhoto(String sourcePath)

// Speicherplatz prüfen
Future<bool> hasEnoughSpace()

// Foto löschen
Future<bool> deletePhoto(String filePath)

// Gespeicherte Fotos auflisten
Future<List<String>> getStoredPhotos()
```

**Speicherstruktur:**
```
D:\                              (USB-Stick)
└── Lihpbox\
    ├── Photos\
    │   ├── photo_1714000000000.jpg
    │   ├── photo_1714000060000.jpg
    │   └── ...
    └── backup.txt               (optional)
```

#### **photo_service.dart** - Foto-Management

**Hauptmethoden:**
```dart
// Foto hinzufügen
void addPhoto(Photo photo)

// Aktuelles Foto
Photo? get currentPhoto

// Als gedruckt markieren
void markAsPrinted(String photoId)

// Foto entfernen
void removePhoto(String photoId)

// Alle löschen
void clearAll()
```

---

## 🎨 `lib/screens/` - Benutzeroberfläche

### **home_screen.dart**
- Startbildschirm der App
- Geräte-Diagnostik durchführen
- USB-Stick auswählen
- Navigation zu anderen Screens

**State Management:**
```dart
List<String> _usbDrives;              // Erkannte USB-Laufwerke
String? _selectedUsbDrive;             // Ausgewähltes Laufwerk
bool _isCameraReady;                   // Kamera verbunden?
bool _isPrinterReady;                  // Drucker verbunden?
```

### **preview_screen.dart**
- Live-Kamera-Vorschau anzeigen
- Timer-Countdown vor Auslösung
- Foto aufnehmen

**Workflow:**
1. `initState()` → `_loadPreview()` lädt Live-Bild
2. User klickt "Foto aufnehmen" → `_capturePhoto()`
3. Timer startet → `_onTimerComplete()` löst Kamera aus
4. Navigation zu `photo_confirmation_screen`

### **photo_confirmation_screen.dart**
- Aufgenommenes Foto anzeigen
- Druck-Option anbieten
- Foto verwerfen oder zurück zur Preview

**Navigation:**
```
Drucken → PrinterService → Erfolgreich → Zurück zu Preview
    ↓
Abbrechen → Foto löschen → Zurück zu Preview
```

### **settings_screen.dart**
- Timer-Dauer konfigurieren
- Auto-Delete Option
- Live-Preview Kontrolle

**State Management:**
```dart
int _selectedTimerDuration;            // 3, 5, oder 10
bool _autoDeleteAfterPrint;
bool _enablePreview;
```

---

## 🧩 `lib/widgets/` - Wiederverwendbare Komponenten

### **custom_button.dart**
```dart
CustomButton(
  label: 'Foto aufnehmen',
  onPressed: () => _capturePhoto(),
  backgroundColor: Colors.red,
  width: 300,
  height: 70,
  fontSize: 24,
  isLoading: false,
)
```

**Features:**
- Hover-Effekt auf Desktop
- Loading-Indikator
- Customizable Farben und Größe

### **timer_widget.dart**
```dart
TimerWidget(
  duration: 5,                         // Sekunden
  isRunning: true,
  onComplete: () => _capturePhoto(),
)
```

**Features:**
- Circular Progress Indicator
- Countdown-Text
- Farbwechsel bei < 3 Sekunden

### **photo_display_widget.dart**
```dart
PhotoDisplayWidget(
  photoPath: '/path/to/photo.jpg',
  onPrint: () => _printPhoto(),
  onCancel: () => _discardPhoto(),
  isPrinting: false,
)
```

---

## 🔧 Services - Detaillierte Implementierung

### Singleton-Pattern für Services

```dart
class CameraService {
  // Singleton Instance
  static final CameraService _instance = CameraService._internal();
  
  // Private Constructor
  CameraService._internal();
  
  // Factory Constructor
  factory CameraService() {
    return _instance;
  }
}

// Verwendung:
final camera = CameraService();
final camera2 = CameraService();
// camera und camera2 sind das gleiche Objekt!
```

### Fehlerbehandlung

```dart
try {
  final result = await _cameraService.capturePhoto(storagePath);
  if (result != null) {
    // Erfolg
    _photoService.addPhoto(photo);
  } else {
    // Fehler
    _showError('Fehler beim Aufnehmen des Fotos');
  }
} catch (e) {
  logger.e('Exception: $e');
  _showError('Unerwarteter Fehler: $e');
}
```

### Logging

```dart
import 'package:logger/logger.dart';

final logger = Logger();

logger.i('Info-Nachricht');           // Blau
logger.w('Warnung');                   // Gelb
logger.e('Fehler', error: exception); // Rot
logger.d('Debug-Nachricht');           // Grün
```

**Output Beispiel:**
```
┌─ Logger ─────────────────────────────────
│ 💡 Info: Camera initialized successfully
├─────────────────────────────────────────
│ main.dart:45
└─────────────────────────────────────────
```

---

## 📱 State Management Pattern

Die App nutzt **StatefulWidget** mit lokalem State.

```dart
class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  String _myValue = '';
  
  void _updateValue() {
    setState(() {
      _myValue = 'new value';  // Triggert Widget Rebuild
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Text(_myValue);      // Zeigt aktuelle Werte
  }
}
```

**Für größere Apps später:** Provider, Riverpod, BLoC

---

## 🧪 Testing (zukünftig)

### Unit Tests Beispiel

```dart
// test/services/photo_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:lihpbox/services/photo_service.dart';
import 'package:lihpbox/models/photo.dart';

void main() {
  group('PhotoService', () {
    late PhotoService photoService;
    
    setUp(() {
      photoService = PhotoService();
    });
    
    test('addPhoto sollte Foto zur Liste hinzufügen', () {
      final photo = Photo(
        id: '123',
        filePath: '/path/to/photo.jpg',
        timestamp: DateTime.now(),
        fileName: 'photo.jpg',
      );
      
      photoService.addPhoto(photo);
      
      expect(photoService.allPhotos.length, 1);
      expect(photoService.currentPhoto, equals(photo));
    });
  });
}
```

---

## 🚀 Häufige Entwicklungs-Tasks

### Neue Screen hinzufügen

1. **Datei erstellen:**
   ```dart
   // lib/screens/new_screen.dart
   import 'package:flutter/material.dart';
   
   class NewScreen extends StatefulWidget {
     const NewScreen({Key? key}) : super(key: key);
   
     @override
     State<NewScreen> createState() => _NewScreenState();
   }
   
   class _NewScreenState extends State<NewScreen> {
     @override
     Widget build(BuildContext context) {
       return Scaffold(
         appBar: AppBar(title: const Text('Neue Screen')),
         body: Center(child: const Text('Inhalt hier')),
       );
     }
   }
   ```

2. **Route in main.dart hinzufügen:**
   ```dart
   routes: {
     '/new-screen': (context) => const NewScreen(),
   }
   ```

3. **Navigation:**
   ```dart
   Navigator.of(context).pushNamed('/new-screen');
   ```

### Neuen Service erstellen

```dart
// lib/services/my_service.dart
import 'package:logger/logger.dart';

class MyService {
  static final MyService _instance = MyService._internal();
  final Logger logger = Logger();
  
  factory MyService() => _instance;
  MyService._internal();
  
  Future<void> doSomething() async {
    try {
      logger.i('Mache etwas...');
      // Implementierung hier
    } catch (e) {
      logger.e('Fehler: $e');
    }
  }
}
```

### Hot Reload nutzen

```bash
# Hot Reload (schnell, nur Code-Änderungen)
flutter run
> r        # Drücke 'r' für Hot Reload

# Hot Restart (langsamer, vollständiger Neustart)
> R        # Drücke 'R' für Hot Restart

# Quit
> q        # Drücke 'q' um App zu beenden
```

---

## 🐛 Debugging-Tools

### Dart DevTools

```bash
# DevTools öffnen (während App läuft)
# Im Terminal während flutter run die URL kopieren
# oder:
devtools
```

### Flutter Logs

```bash
# Nur eigene Logs sehen (Logger filtert)
flutter run -v | grep "Log:"

# Alle Logs
flutter run -v
```

### Browser DevTools (für Web)

```bash
flutter run -d chrome
# Dann Chrome DevTools öffnen (F12)
```

---

## 📚 Best Practices

### 1. Const Keywords verwenden
```dart
// ✅ Gut
const Padding(
  padding: EdgeInsets.all(8.0),
  child: const Text('Hello'),
)

// ❌ Schlecht
Padding(
  padding: EdgeInsets.all(8.0),
  child: Text('Hello'),
)
```

### 2. Named Parameters nutzen
```dart
// ✅ Gut
buildButton(
  label: 'Click me',
  onPressed: _handleClick,
  backgroundColor: Colors.blue,
)

// ❌ Schlecht
buildButton('Click me', _handleClick, Colors.blue)
```

### 3. Separation of Concerns
```dart
// ✅ Gut: Service handhabt Logik
final result = await _cameraService.capturePhoto();

// ❌ Schlecht: UI handhabt komplexe Logik
Process.run('gphoto2', ['--capture-image']);
```

### 4. Fehlerbehandlung
```dart
// ✅ Gut
if (result != null) {
  // Erfolg
} else {
  _showError('Fehler aufgetreten');
}

// ❌ Schlecht
// result.filePath  // Könnten NullPointerException werfen
```

### 5. Responsive Design
```dart
// ✅ Gut: Anpassung an Bildschirmgröße
bool isMobile = MediaQuery.of(context).size.width < 600;

// ✅ Buttons sollten berührbar sein
SizedBox(
  height: 60,  // Mindestens 48dp
  width: 300,  // Großzügig dimensioniert
  child: ...
)
```

---

## 📖 Nützliche Ressourcen für Entwickler

### Offizielle Dokumentation
- [Flutter Docs](https://flutter.dev/docs)
- [Material Design](https://material.io/)
- [Dart API Docs](https://api.dart.dev/)

### Pakete (verfügbar in dieser App)
- [logger](https://pub.dev/packages/logger) - Logging
- [image](https://pub.dev/packages/image) - Bildverarbeitung
- [path_provider](https://pub.dev/packages/path_provider) - Dateiverwaltung
- [printing](https://pub.dev/packages/printing) - Drucken

### Tipps & Tricks
- Use `const` wenn möglich (Performance)
- Nutze `late` für lazy-initialization
- Verwende `final` statt `var`
- Nutze Streams für Echtzeit-Updates

---

## 🔍 Code-Style & Linting

Die App nutzt Flutter Lints für Code-Qualität:

```bash
# Analyse ausführen
flutter analyze

# Automatische Fixes anwenden
dart fix --apply
```

---

## 🎯 Zukünftige Features (TODO)

```dart
// TODO: Echtzeit Live-Preview via OpenCV
// TODO: Mehrfach-Druck Funktionen
// TODO: Galerie-Ansicht aller Fotos
// TODO: Foto-Filter & Effekte
// TODO: Cloud-Backup Integration
// TODO: Multisprachen-Unterstützung
// TODO: Dark Mode
```

---

## 🤝 Contribution Guidelines

1. Fork das Projekt
2. Feature-Branch erstellen (`git checkout -b feature/my-feature`)
3. Code committen (`git commit -m 'Add feature'`)
4. Branch pushen (`git push origin feature/my-feature`)
5. Pull Request erstellen

**Code Quality:**
- Alle Tests müssen passen
- `flutter analyze` ohne Fehler
- Dokumentation aktualisieren

---

## 📞 Kontakt für Entwickler-Fragen

Bei Fragen zur Codebase:
1. Konsultiere diese Dokumentation
2. Schaue auf [Stack Overflow](https://stackoverflow.com/)
3. Besuche [Flutter Community](https://flutter.dev/community)

---

**Version:** 1.0  
**Letztes Update:** April 2026  
**Für Flutter:** 3.35.5+
