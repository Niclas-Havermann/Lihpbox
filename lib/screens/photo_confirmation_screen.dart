import 'package:flutter/material.dart';
import '../models/photo.dart';
import '../services/printer_service.dart';
import '../services/storage_service.dart';
import '../widgets/photo_display_widget.dart';

/// Photo Confirmation Screen - Zeigt das aufgenommene Foto und ermöglicht Druck
class PhotoConfirmationScreen extends StatefulWidget {
  final Photo photo;

  const PhotoConfirmationScreen({Key? key, required this.photo})
    : super(key: key);

  @override
  State<PhotoConfirmationScreen> createState() =>
      _PhotoConfirmationScreenState();
}

class _PhotoConfirmationScreenState extends State<PhotoConfirmationScreen> {
  final _printerService = PrinterService();
  final _storageService = StorageService();

  bool _isPrinting = false;
  bool _hasPaper = true;

  @override
  void initState() {
    super.initState();
    _checkPaperStatus();
  }

  Future<void> _checkPaperStatus() async {
    try {
      final hasPaper = await _printerService.checkPaperStatus();
      if (mounted) {
        setState(() => _hasPaper = hasPaper);
      }
    } catch (e) {
      // Im Fehlerfall annehmen dass Papier vorhanden ist
      if (mounted) {
        setState(() => _hasPaper = true);
      }
    }
  }

  Future<void> _printPhoto() async {
    // Sicherheitsprüfung: Kein Druck ohne Papier
    if (!_hasPaper) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Druck nicht möglich: Kein Papier im Drucker!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() => _isPrinting = true);

    try {
      final success = await _printerService.printPhoto(widget.photo.filePath);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Druck gesendet!'),
              backgroundColor: Colors.green,
            ),
          );

          // Warte 20 Sekunden, damit der Drucker Zeit hat zu drucken
          await Future.delayed(const Duration(seconds: 20));
          if (mounted) {
            // Prüfe ob der Drucker noch Papier hat
            final hasPaper = await _printerService.checkPaperStatus();
            
            if (!hasPaper) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('⚠️ Warnung: Drucker hat kein Papier!'),
                  backgroundColor: Colors.orange,
                  duration: Duration(seconds: 30),
                ),
              );
            }
            
            Navigator.of(context).pushReplacementNamed('/preview');
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fehler beim Druck'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() => _isPrinting = false);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: $e'), backgroundColor: Colors.red),
        );
        setState(() => _isPrinting = false);
      }
    }
  }

  void _discardPhoto() {
    // Lösche das Foto von USB
    _storageService.deletePhoto(widget.photo.filePath);

    // Zurück zur Preview
    Navigator.of(context).pushReplacementNamed('/preview');
  }

  void _savePhoto() {
    // Foto ist bereits auf USB gespeichert, daher einfach zurück zur Preview
    Navigator.of(context).pushReplacementNamed('/preview');
  }
  

@override
Widget build(BuildContext context) {
  return WillPopScope(
    onWillPop: () async {
      Navigator.of(context).pushReplacementNamed('/preview');
      return false;
    },
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Foto bestätigen'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        automaticallyImplyLeading: false,
      ),
      body: PhotoDisplayWidget(
        photoPath: widget.photo.filePath,
        isPrinting: _isPrinting,
        hasPaper: _hasPaper,
        onPrint: _printPhoto,
        onCancel: _discardPhoto,
        onSave: _savePhoto,
      ),
    ),
  );
}
}