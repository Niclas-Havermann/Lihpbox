import 'package:logger/logger.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

/// Service für die Steuerung der Nikon D7100 Kamera
class CameraService {
  static final CameraService _instance = CameraService._internal();
  final Logger logger = Logger();

  bool _isCameraConnected = false;
  bool _isSimulatorMode = false;
  String? _currentCameraPath;

  factory CameraService() {
    return _instance;
  }

  CameraService._internal();

  /// Prüft ob wir im Simulator-Modus sind (gPhoto2 nicht verfügbar)
  bool get isSimulatorMode => _isSimulatorMode;

  /// Initialisiert die Kamera-Verbindung
  Future<bool> initializeCamera() async {
    try {
      logger.i('Initialisiere Nikon D7100 Kamera...');
      
      // Prüfe ob gPhoto2 verfügbar ist
      try {
        final result = await Process.run('gphoto2', ['--version']);
        
        if (result.exitCode == 0) {
          logger.i('gPhoto2 erkannt: ${result.stdout}');
          _isCameraConnected = true;
          return true;
        } else {
          logger.e('gPhoto2 nicht verfügbar');
          return false;
        }
      } on ProcessException {
        // gPhoto2 nicht installiert - verwende Fallback/Simulator
        logger.w('gPhoto2 nicht gefunden. Verwende Simulator-Modus für Tests.');
        _isSimulatorMode = true;
        _isCameraConnected = true; // Simulator ist bereit
        return true;
      }
    } catch (e) {
      logger.e('Fehler beim Kamera-Setup: $e');
      return false;
    }
  }

  /// Prüft ob die Kamera verbunden ist
  bool get isCameraConnected => _isCameraConnected;

  /// Holt die Liste aller verbundenen Kameras
  Future<List<String>> getConnectedCameras() async {
    try {
      if (_isSimulatorMode) {
        logger.i('Simulator-Modus: Rückgabe simulierter Kamera');
        return ['Nikon D7100 (Simulator)'];
      }
      
      final result = await Process.run('gphoto2', ['--list-cameras']);
      if (result.exitCode == 0) {
        return result.stdout
            .toString()
            .split('\n')
            .where((line) => line.isNotEmpty)
            .toList();
      }
      return [];
    } catch (e) {
      logger.e('Fehler beim Auslesen der Kameras: $e');
      return [];
    }
  }

  /// Startet die Live-Preview von der Kamera
  /// Gibt den Pfad zur Preview-Datei zurück
  Future<String?> startLivePreview() async {
    try {
      logger.i('Starte Live-Preview...');
      
      // Temporärer Speicherort für Preview
      final tempDir = Directory.systemTemp;
      final previewPath = path.join(tempDir.path, 'lihpbox_preview.jpg');
      
      if (_isSimulatorMode) {
        logger.i('Simulator-Modus: Erstelle Dummy-Preview-Datei');
        // Erstelle eine Dummy-Bilddatei für Tests
        final file = File(previewPath);
        // Schreibe ein einfaches JPG Header als Platzhalter
        await file.writeAsBytes([
          0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10, 0x4A, 0x46, 0x49, 0x46,
        ]);
        return previewPath;
      }
      
      // Lädt das aktuelle Bild von der Kamera
      try {
        final result = await Process.run(
          'gphoto2',
          ['--capture-image-and-download', '--filename=$previewPath'],
        );
        
        if (result.exitCode == 0 && await File(previewPath).exists()) {
          logger.i('Live-Preview erfolgreich: $previewPath');
          return previewPath;
        }
      } on ProcessException {
        logger.w('gPhoto2 nicht verfügbar für Live-Preview');
        return null;
      }
      
      return null;
    } catch (e) {
      logger.e('Fehler bei Live-Preview: $e');
      return null;
    }
  }

  /// Löst die Kamera aus und speichert das Foto
  Future<String?> capturePhoto(String outputPath) async {
    try {
      logger.i('Löse Kamera aus und speichere nach: $outputPath');
      
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'photo_$timestamp.jpg';
      final fullPath = path.join(outputPath, fileName);
      
      // Stelle sicher, dass das Verzeichnis existiert
      final dir = Directory(outputPath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      
      if (_isSimulatorMode) {
        logger.i('Simulator-Modus: Erstelle Dummy-Fotodatei');
        // Erstelle eine Dummy-Bilddatei für Tests
        final file = File(fullPath);
        // Schreibe ein einfaches JPG Header als Platzhalter
        await file.writeAsBytes([
          0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10, 0x4A, 0x46, 0x49, 0x46,
        ]);
        logger.i('Foto erfolgreich gespeichert (Simulator): $fullPath');
        return fullPath;
      }
      
      // Löse die Kamera aus
      try {
        final result = await Process.run(
          'gphoto2',
          ['--capture-image-and-download', '--filename=$fullPath'],
        );
        
        if (result.exitCode == 0 && await File(fullPath).exists()) {
          logger.i('Foto erfolgreich gespeichert: $fullPath');
          return fullPath;
        } else {
          logger.e('Fehler beim Foto-Auslöser: ${result.stderr}');
          return null;
        }
      } on ProcessException {
        logger.w('gPhoto2 nicht verfügbar für Foto-Capture');
        return null;
      }
    } catch (e) {
      logger.e('Fehler beim Foto machen: $e');
      return null;
    }
  }

  /// Trennt die Kamera-Verbindung
  Future<void> disconnect() async {
    try {
      logger.i('Trenne Kamera-Verbindung');
      _isCameraConnected = false;
    } catch (e) {
      logger.e('Fehler beim Trennen der Kamera: $e');
    }
  }
}
