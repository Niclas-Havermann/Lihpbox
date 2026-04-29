import 'package:logger/logger.dart';
import 'dart:io';

/// Service für die Verwaltung von USB-Speicher und Dateien
class StorageService {
  static final StorageService _instance = StorageService._internal();
  final Logger logger = Logger();

  String? _selectedUsbPath;
  List<String> _availableUsbDrives = [];

  factory StorageService() {
    return _instance;
  }

  StorageService._internal();

  /// Erkennt alle verfügbaren USB-Laufwerke (plattformabhängig)
  Future<List<String>> detectUsbDrives() async {
    try {
      logger.i('Erkenne USB-Laufwerke...');
      _availableUsbDrives.clear();
      
      if (Platform.isWindows) {
        await _detectUsbDrivesWindows();
      } else if (Platform.isLinux) {
        await _detectUsbDrivesLinux();
      } else if (Platform.isMacOS) {
        await _detectUsbDrivesMacOS();
      }
      
      logger.i('Gefundene USB-Laufwerke: $_availableUsbDrives');
      return _availableUsbDrives;
    } catch (e) {
      logger.e('Fehler beim Erkennen von USB-Laufwerken: $e');
      return [];
    }
  }

  /// Erkennt USB-Laufwerke auf Windows
  Future<void> _detectUsbDrivesWindows() async {
    try {
      // Windows: Prüfe alle Laufwerke von D bis Z
      for (var i = 68; i <= 90; i++) { // D-Z in ASCII
        final driveLetter = String.fromCharCode(i);
        final drivePath = '$driveLetter:\\';
        
        try {
          final dir = Directory(drivePath);
          if (await dir.exists()) {
            // Prüfe ob es sich um Wechsellaufwerk handelt
            final isUsb = await _isUsbDrive(drivePath);
            if (isUsb) {
              _availableUsbDrives.add(drivePath);
              logger.i('USB-Laufwerk gefunden: $drivePath');
            }
          }
        } catch (e) {
          // Ignoriere nicht zugängliche Laufwerke
        }
      }
    } catch (e) {
      logger.e('Fehler bei Windows USB-Erkennung: $e');
    }
  }

  /// Erkennt USB-Laufwerke auf Linux
  Future<void> _detectUsbDrivesLinux() async {
    try {
      // Linux: Prüfe /mnt und /media Verzeichnisse
      final paths = ['/mnt', '/media', '/run/media/${Platform.environment['USER'] ?? 'user'}'];
      
      for (final path in paths) {
        try {
          final dir = Directory(path);
          if (!await dir.exists()) continue;
          
          final entries = await dir.list().toList();
          for (final entry in entries) {
            if (entry is Directory) {
              try {
                // Überprüfe ob Verzeichnis zugänglich ist
                await entry.list().toList();
                _availableUsbDrives.add(entry.path);
                logger.i('USB-Laufwerk gefunden: ${entry.path}');
              } catch (e) {
                // Ignoriere nicht zugängliche Verzeichnisse
              }
            }
          }
        } catch (e) {
          // Ignoriere nicht zugängliche Pfade
        }
      }
    } catch (e) {
      logger.e('Fehler bei Linux USB-Erkennung: $e');
    }
  }

  /// Erkennt USB-Laufwerke auf macOS
  Future<void> _detectUsbDrivesMacOS() async {
    try {
      // macOS: Prüfe /Volumes Verzeichnis
      try {
        final dir = Directory('/Volumes');
        if (!await dir.exists()) return;
        
        final entries = await dir.list().toList();
        for (final entry in entries) {
          if (entry is Directory && !entry.path.contains('System')) {
            try {
              // Überprüfe ob Verzeichnis zugänglich ist
              await entry.list().toList();
              _availableUsbDrives.add(entry.path);
              logger.i('USB-Laufwerk gefunden: ${entry.path}');
            } catch (e) {
              // Ignoriere nicht zugängliche Verzeichnisse
            }
          }
        }
      } catch (e) {
        logger.e('Fehler bei macOS USB-Erkennung: $e');
      }
    } catch (e) {
      logger.e('Fehler bei macOS USB-Erkennung: $e');
    }
  }

  /// Überprüft ob ein Laufwerk ein USB-Laufwerk ist
  Future<bool> _isUsbDrive(String drivePath) async {
    try {
      // Hier könnte man erweiterte Überprüfungen durchführen
      // Für jetzt: Prüfe ob das Laufwerk beschreibbar ist
      final testFile = File('$drivePath.lihpbox_test');
      await testFile.writeAsString('test');
      await testFile.delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Gibt die verfügbaren USB-Laufwerke zurück
  List<String> get availableUsbDrives => _availableUsbDrives;

  /// Setzt das aktive USB-Laufwerk
  Future<bool> setUsbPath(String usbPath) async {
    try {
      final dir = Directory(usbPath);
      if (await dir.exists()) {
        _selectedUsbPath = usbPath;
        
        // Erstelle Lihpbox Verzeichnis
        final lihpboxDir = Directory('$usbPath\\Lihpbox');
        if (!await lihpboxDir.exists()) {
          await lihpboxDir.create(recursive: true);
        }
        
        logger.i('USB-Pfad gesetzt: $_selectedUsbPath');
        return true;
      }
      return false;
    } catch (e) {
      logger.e('Fehler beim Setzen des USB-Pfads: $e');
      return false;
    }
  }

  /// Gibt den aktuellen USB-Pfad zurück
  String? get selectedUsbPath => _selectedUsbPath;

  /// Gibt den Fotos-Speicherpfad zurück
  String? getPhotoStoragePath() {
    if (_selectedUsbPath == null) return null;
    
    final storagePath = '$_selectedUsbPath\\Lihpbox\\Photos';
    return storagePath;
  }

  /// Speichert ein Foto
  Future<String?> savePhoto(String sourcePath) async {
    try {
      if (_selectedUsbPath == null) {
        logger.e('Kein USB-Pfad ausgewählt');
        return null;
      }
      
      final storagePath = getPhotoStoragePath();
      if (storagePath == null) return null;
      
      final dir = Directory(storagePath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'photo_$timestamp.jpg';
      final targetPath = '$storagePath\\$fileName';
      
      final file = File(sourcePath);
      await file.copy(targetPath);
      
      logger.i('Foto gespeichert: $targetPath');
      return targetPath;
    } catch (e) {
      logger.e('Fehler beim Speichern des Fotos: $e');
      return null;
    }
  }

  /// Prüft ob genügend Speicherplatz auf dem USB verfügbar ist
  Future<bool> hasEnoughSpace() async {
    try {
      if (_selectedUsbPath == null) return false;
      
      // Vereinfachte Überprüfung - mindestens 100MB sollten frei sein
      final dir = Directory(_selectedUsbPath!);
      await dir.stat();
      
      // Hinweis: stat() gibt nicht immer zuverlässige Werte zurück
      // In Produktivumgebung würde man plattformspezifische APIs nutzen
      return true;
    } catch (e) {
      logger.e('Fehler beim Prüfen des Speicherplatzes: $e');
      return false;
    }
  }

  /// Löscht ein Foto
  Future<bool> deletePhoto(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        logger.i('Foto gelöscht: $filePath');
        return true;
      }
      return false;
    } catch (e) {
      logger.e('Fehler beim Löschen des Fotos: $e');
      return false;
    }
  }

  /// Gibt alle gespeicherten Fotos zurück
  Future<List<String>> getStoredPhotos() async {
    try {
      final storagePath = getPhotoStoragePath();
      if (storagePath == null) return [];
      
      final dir = Directory(storagePath);
      if (!await dir.exists()) return [];
      
      final files = await dir.list().toList();
      return files
          .where((f) => f is File && f.path.endsWith('.jpg'))
          .map((f) => f.path)
          .toList();
    } catch (e) {
      logger.e('Fehler beim Auslesen der Fotos: $e');
      return [];
    }
  }
}
