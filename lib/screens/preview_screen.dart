import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import '../services/camera_service.dart';
import '../services/photo_service.dart';
import '../services/storage_service.dart';
import '../models/photo.dart';
import '../widgets/custom_button.dart';
import '../widgets/timer_widget.dart';
import 'dart:io';
import 'dart:async';

/// Preview Screen - Zeigt das letzte aufgenommene Foto
class PreviewScreen extends StatefulWidget {
  const PreviewScreen({Key? key}) : super(key: key);

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen>
    with WidgetsBindingObserver {
  final _cameraService = CameraService();
  final _photoService = PhotoService();
  final _storageService = StorageService();

  String? _lastPhotoPath;
  bool _isLoadingPreview = true;
  bool _isCapturing = false;
  bool _showTimer = false;
  int _timerDuration = 5;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadLastPhoto();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadLastPhoto();
    }
  }

  /// Lädt das zuletzt gespeicherte Foto aus dem Speicherpfad
  Future<void> _loadLastPhoto() async {
    if (!mounted) return;

    setState(() => _isLoadingPreview = true);

    try {
      final storagePath = _storageService.getPhotoStoragePath();

      if (storagePath != null) {
        final dir = Directory(storagePath);
        if (await dir.exists()) {
          // Alle Bilddateien im Ordner suchen
          final files = dir
              .listSync()
              .whereType<File>()
              .where((f) =>
                  f.path.endsWith('.jpg') ||
                  f.path.endsWith('.jpeg') ||
                  f.path.endsWith('.png'))
              .toList();

          if (files.isNotEmpty) {
            // Nach Änderungsdatum sortieren → neuestes zuerst
            files.sort((a, b) => b
                .statSync()
                .modified
                .compareTo(a.statSync().modified));

            if (mounted) {
              setState(() {
                _lastPhotoPath = files.first.path;
                _isLoadingPreview = false;
              });
              return;
            }
          }
        }
      }

      // Fallback: Letztes Foto aus PhotoService
      final photos = _photoService.getAllPhotos();
      if (photos.isNotEmpty) {
        final latest = photos.last;
        if (mounted) {
          setState(() {
            _lastPhotoPath = latest.filePath;
            _isLoadingPreview = false;
          });
          return;
        }
      }
    } catch (e) {
      debugPrint('Fehler beim Laden des letzten Fotos: $e');
    }

    // Kein Foto gefunden
    if (mounted) {
      setState(() {
        _lastPhotoPath = null;
        _isLoadingPreview = false;
      });
    }
  }

  Future<void> _onTimerComplete() async {
    if (mounted) {
      setState(() => _isCapturing = true);
    }

    final storagePath = _storageService.getPhotoStoragePath();
    if (storagePath == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('USB-Pfad nicht gesetzt')),
        );
        setState(() {
          _isCapturing = false;
          _showTimer = false;
        });
      }
      return;
    }

    final photoPath = await _cameraService.capturePhoto(storagePath);

    if (mounted) {
      setState(() {
        _showTimer = false;
        _isCapturing = false;
      });

      if (photoPath != null) {
        final photo = Photo(
          id: _photoService.generatePhotoId(),
          filePath: photoPath,
          timestamp: DateTime.now(),
          fileName: path.basename(photoPath),
        );

        _photoService.addPhoto(photo);

        if (mounted) {
          Navigator.of(context).pushReplacementNamed(
            '/photo-confirmation',
            arguments: photo,
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fehler beim Aufnehmen des Fotos')),
        );
      }
    }
  }

  void _capturePhoto() {
    setState(() => _showTimer = true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Letztes Foto'),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadLastPhoto,
              tooltip: 'Aktualisieren',
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Foto Anzeige
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _isLoadingPreview
                      ? const Center(child: CircularProgressIndicator())
                      : _lastPhotoPath != null &&
                              File(_lastPhotoPath!).existsSync()
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(_lastPhotoPath!),
                                fit: BoxFit.contain,
                              ),
                            )
                          : const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.photo_outlined,
                                      size: 64, color: Colors.grey),
                                  SizedBox(height: 16),
                                  Text(
                                    'Noch kein Foto vorhanden',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                ),
              ),

              // Timer oder Button
              if (_showTimer)
                TimerWidget(
                  duration: _timerDuration,
                  isRunning: _showTimer,
                  onComplete: _onTimerComplete,
                )
              else
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: CustomButton(
                    label: _isCapturing ? 'Aufnahme läuft...' : 'Foto aufnehmen',
                    onPressed: _capturePhoto,
                    isLoading: _isCapturing,
                    backgroundColor: Colors.red,
                    width: 300,
                    height: 70,
                    fontSize: 24,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}