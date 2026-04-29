import 'package:logger/logger.dart';
import 'dart:io';

/// Service für die Canon SELPHY CP1500 Drucker-Steuerung
class PrinterService {
  static final PrinterService _instance = PrinterService._internal();
  final Logger logger = Logger();

  bool _isPrinterConnected = false;
  List<String> _availablePrinters = [];

  factory PrinterService() {
    return _instance;
  }

  PrinterService._internal();

  /// Initialisiert den Drucker
  Future<bool> initializePrinter() async {
    try {
      logger.i('Initialisiere Canon SELPHY CP1500 Drucker...');
      
      // Überprüfe verfügbare Drucker
      _availablePrinters = await getAvailablePrinters();
      
      if (_availablePrinters.isNotEmpty) {
        logger.i('Drucker gefunden: $_availablePrinters');
        _isPrinterConnected = true;
        return true;
      } else {
        logger.w('Kein Drucker erkannt');
        return false;
      }
    } catch (e) {
      logger.e('Fehler beim Drucker-Setup: $e');
      return false;
    }
  }

  /// Holt die Liste aller verfügbaren Drucker (plattformabhängig)
  Future<List<String>> getAvailablePrinters() async {
    try {
      if (Platform.isWindows) {
        return await _getAvailablePrintersWindows();
      } else if (Platform.isLinux || Platform.isMacOS) {
        return await _getAvailablePrintersUnix();
      }
      return [];
    } catch (e) {
      logger.e('Fehler beim Auslesen der Drucker: $e');
      return [];
    }
  }

  /// Holt Drucker auf Windows (PowerShell)
  Future<List<String>> _getAvailablePrintersWindows() async {
    try {
      final result = await Process.run(
        'powershell',
        [
          '-Command',
          'Get-Printer | Where-Object {\\\$_.Type -eq "Local"} | Select-Object -ExpandProperty Name'
        ],
      );
      
      if (result.exitCode == 0) {
        return result.stdout
            .toString()
            .split('\n')
            .where((line) => line.trim().isNotEmpty)
            .toList();
      }
      return [];
    } catch (e) {
      logger.e('Fehler beim Auslesen von Windows-Druckern: $e');
      return [];
    }
  }

  /// Holt Drucker auf Linux/macOS (CUPS)
  Future<List<String>> _getAvailablePrintersUnix() async {
    try {
      // Versuche lpstat (CUPS) zu verwenden
      final result = await Process.run('lpstat', ['-p', '-d']);
      
      if (result.exitCode == 0) {
        return result.stdout
            .toString()
            .split('\n')
            .where((line) => line.trim().isNotEmpty && line.contains('printer'))
            .map((line) {
              // Parse "printer PRINTER_NAME is ..." Format
              final parts = line.split(' ');
              return parts.length > 1 ? parts[1] : '';
            })
            .where((name) => name.isNotEmpty)
            .toList();
      }
      return [];
    } catch (e) {
      logger.e('Fehler beim Auslesen von Unix-Druckern: $e');
      return [];
    }
  }

  /// Gibt an, ob ein Drucker verbunden ist
  bool get isPrinterConnected => _isPrinterConnected;

  /// Gibt die verfügbaren Drucker zurück
  List<String> get availablePrinters => _availablePrinters;

  /// Druckt eine Datei (plattformabhängig)
  Future<bool> printPhoto(String filePath, {int copies = 1}) async {
    try {
      logger.i('Drucke Foto: $filePath (Kopien: $copies)');
      
      // Überprüfe ob die Datei existiert
      if (!await File(filePath).exists()) {
        logger.e('Datei nicht gefunden: $filePath');
        return false;
      }
      
      // Suche nach Canon SELPHY Drucker
      final canonPrinter = _availablePrinters.firstWhere(
        (printer) => printer.toLowerCase().contains('selphy') || 
                      printer.toLowerCase().contains('canon'),
        orElse: () => '',
      );
      
      if (canonPrinter.isEmpty && _availablePrinters.isNotEmpty) {
        // Falls kein Canon-Drucker gefunden, nutze den ersten
        logger.w('Kein Canon-Drucker gefunden, nutze: ${_availablePrinters.first}');
      }
      
      final printerName = canonPrinter.isNotEmpty ? canonPrinter : _availablePrinters.first;
      
      if (Platform.isWindows) {
        return await _printPhotoWindows(filePath, printerName, copies);
      } else if (Platform.isLinux || Platform.isMacOS) {
        return await _printPhotoUnix(filePath, printerName, copies);
      }
      
      return false;
    } catch (e) {
      logger.e('Fehler beim Drucken: $e');
      return false;
    }
  }

  /// Druckt auf Windows
  Future<bool> _printPhotoWindows(String filePath, String printerName, int copies) async {
    try {
      final result = await Process.run(
        'powershell',
        [
          '-Command',
          'Add-PrinterPort -Name "FILE:" -PrinterPortType File; Print-Document -Path "$filePath" -PrinterName "$printerName" -Copies $copies'
        ],
      );
      
      if (result.exitCode == 0) {
        logger.i('Druck gesendet');
        return true;
      } else {
        logger.e('Druckfehler: ${result.stderr}');
        return false;
      }
    } catch (e) {
      logger.e('Fehler beim Windows-Druck: $e');
      return false;
    }
  }

  /// Druckt auf Linux/macOS mit CUPS
  Future<bool> _printPhotoUnix(String filePath, String printerName, int copies) async {
    try {
      final result = await Process.run(
        'lp',
        ['-d', printerName, '-n', copies.toString(), filePath],
      );
      
      if (result.exitCode == 0) {
        logger.i('Druck gesendet');
        return true;
      } else {
        logger.e('Druckfehler: ${result.stderr}');
        return false;
      }
    } catch (e) {
      logger.e('Fehler beim Unix-Druck: $e');
      return false;
    }
  }

  /// Alternative Druckmethode (plattformabhängig)
  Future<bool> printPhotoAlternative(String filePath) async {
    try {
      logger.i('Verwende alternative Druckmethode für: $filePath');
      
      if (Platform.isWindows) {
        final result = await Process.run(
          'cmd',
          ['/c', 'start', '', 'rundll32.exe', 'shimgvw.dll,ImageView_Fullscreen', filePath],
        );
        return result.exitCode == 0;
      } else if (Platform.isLinux) {
        // Auf Linux: Versuche Standard-Bildviewer zu öffnen
        final result = await Process.run('xdg-open', [filePath]);
        return result.exitCode == 0;
      } else if (Platform.isMacOS) {
        // Auf macOS: Öffne mit Preview
        final result = await Process.run('open', [filePath]);
        return result.exitCode == 0;
      }
      
      return false;
    } catch (e) {
      logger.e('Fehler bei alternativer Druckmethode: $e');
      return false;
    }
  }

  /// Gibt Druckerstatus zurück (plattformabhängig)
  Future<String> getPrinterStatus() async {
    try {
      if (Platform.isWindows) {
        return await _getPrinterStatusWindows();
      } else if (Platform.isLinux || Platform.isMacOS) {
        return await _getPrinterStatusUnix();
      }
      return 'Unbekannt';
    } catch (e) {
      logger.e('Fehler beim Auslesen des Druckerstatus: $e');
      return 'Fehler';
    }
  }

  /// Liest Druckerstatus auf Windows
  Future<String> _getPrinterStatusWindows() async {
    try {
      final result = await Process.run(
        'powershell',
        [
          '-Command',
          'Get-PrinterStatus | Where-Object {\\\$_.Name -like "*Canon*" -or \\\$_.Name -like "*SELPHY*"} | Select-Object -ExpandProperty Status'
        ],
      );
      
      if (result.exitCode == 0) {
        return result.stdout.toString().trim();
      }
      return 'Unbekannt';
    } catch (e) {
      logger.e('Fehler beim Auslesen des Windows-Druckerstatus: $e');
      return 'Fehler';
    }
  }

  /// Liest Druckerstatus auf Unix (CUPS)
  Future<String> _getPrinterStatusUnix() async {
    try {
      final result = await Process.run('lpstat', ['-t']);
      
      if (result.exitCode == 0) {
        final output = result.stdout.toString();
        if (output.contains('device for') || output.contains('is idle')) {
          return 'Bereit';
        } else if (output.contains('disabled')) {
          return 'Deaktiviert';
        }
        return 'Aktiv';
      }
      return 'Unbekannt';
    } catch (e) {
      logger.e('Fehler beim Auslesen des Unix-Druckerstatus: $e');
      return 'Fehler';
    }
  }
}

