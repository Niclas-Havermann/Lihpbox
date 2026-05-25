import 'package:flutter/material.dart';
import 'dart:io';

/// Widget zur Anzeige eines Fotos mit Optionen
class PhotoDisplayWidget extends StatelessWidget {
  final String photoPath;
  final VoidCallback onPrint;
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final bool isPrinting;
  final bool hasPaper;
  

  const PhotoDisplayWidget({
    Key? key,
    required this.photoPath,
    required this.onPrint,
    required this.onCancel,
    required this.onSave,
    this.isPrinting = false,
    this.hasPaper = true,
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
                // Save Button
                ElevatedButton.icon(
                  onPressed: isPrinting ? null : onSave,
                  icon: const Icon(Icons.save_alt),
                  label: const Text('Speichern'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 53, 241, 226),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                ),
                // Drucken Button oder Papier-Warnung
                if (hasPaper)
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
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.3),
                      border: Border.all(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                      child: Text(
                        'Kein Druckerpapier vorhanden.\nDrucken nicht möglich',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
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
