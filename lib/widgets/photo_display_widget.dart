import 'package:flutter/material.dart';
import 'dart:io';

/// Widget zur Anzeige eines Fotos mit Optionen
class PhotoDisplayWidget extends StatelessWidget {
  final String photoPath;
  final VoidCallback onPrint;
  final VoidCallback onCancel;
  final bool isPrinting;

  const PhotoDisplayWidget({
    Key? key,
    required this.photoPath,
    required this.onPrint,
    required this.onCancel,
    this.isPrinting = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final file = File(photoPath);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Foto Anzeige
          if (file.existsSync())
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    file,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: Center(
                child: Text(
                  'Foto nicht gefunden:\n$photoPath',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, color: Colors.red),
                ),
              ),
            ),
          // Buttons
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Abbrechen Button
                ElevatedButton.icon(
                  onPressed: isPrinting ? null : onCancel,
                  icon: const Icon(Icons.close),
                  label: const Text('Abbrechen'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                ),
                // Drucken Button
                ElevatedButton.icon(
                  onPressed: isPrinting ? null : onPrint,
                  icon: isPrinting
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Icon(Icons.print),
                  label: Text(isPrinting ? 'Drucke...' : 'Drucken'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
