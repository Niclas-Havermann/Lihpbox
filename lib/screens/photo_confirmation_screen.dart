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

  Future<void> _printPhoto() async {
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

          // Warte kurz und kehre zur Preview zurück
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) {
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
        onPrint: _printPhoto,
        onCancel: _discardPhoto,
        onSave: _savePhoto,
      ),
    ),
  );
}
}