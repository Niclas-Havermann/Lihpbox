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
      
      // Überprüfe verfügbare Drucker (Windows spezifisch)
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

  /// Holt die Liste aller verfügbaren Drucker
  Future<List<String>> getAvailablePrinters() async {
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
      logger.e('Fehler beim Auslesen der Drucker: $e');
      return [];
    }
  }

  /// Gibt an, ob ein Drucker verbunden ist
  bool get isPrinterConnected => _isPrinterConnected;

  /// Gibt die verfügbaren Drucker zurück
  List<String> get availablePrinters => _availablePrinters;

  /// Druckt eine Datei
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
      
      // Verwende Windows Print-API über PowerShell
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
      logger.e('Fehler beim Drucken: $e');
      return false;
    }
  }

  /// Alternative Druckmethode mit Shellexecute
  Future<bool> printPhotoAlternative(String filePath) async {
    try {
      logger.i('Verwende alternative Druckmethode für: $filePath');
      
      final result = await Process.run(
        'cmd',
        ['/c', 'start', '', 'rundll32.exe', 'shimgvw.dll,ImageView_Fullscreen', filePath],
      );
      
      return result.exitCode == 0;
    } catch (e) {
      logger.e('Fehler bei alternativer Druckmethode: $e');
      return false;
    }
  }

  /// Gibt Druckerstatus zurück
  Future<String> getPrinterStatus() async {
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
      logger.e('Fehler beim Auslesen des Druckerstatus: $e');
      return 'Fehler';
    }
  }
}
