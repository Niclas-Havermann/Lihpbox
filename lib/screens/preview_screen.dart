import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import '../services/camera_service.dart';
import '../services/photo_service.dart';
import '../services/storage_service.dart';
import '../models/photo.dart';
import '../widgets/custom_button.dart';
import '../widgets/timer_widget.dart';
import 'dart:io';

/// Preview Screen - Zeigt Live-Preview der Kamera
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

  String? _previewImagePath;
  bool _isLoadingPreview = true;
  bool _isCapturing = false;
  bool _showTimer = false;
  int _timerDuration = 5; // Standard-Timer

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadPreview();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Screen ist in den Vordergrund gekommen - lade Preview neu
      _loadPreview();
    }
  }

  Future<void> _loadPreview() async {
    if (!mounted) return;
    
    setState(() => _isLoadingPreview = true);
    
    final previewPath = await _cameraService.startLivePreview();
    if (mounted) {
      setState(() {
        _previewImagePath = previewPath;
        _isLoadingPreview = false;
      });
    }
  }

  void _refreshPreview() {
    _loadPreview();
  }

  Future<void> _onTimerComplete() async {
    // Timer ist abgelaufen - löse die Kamera aus
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
        // Erstelle Photo-Objekt
        final photo = Photo(
          id: _photoService.generatePhotoId(),
          filePath: photoPath,
          timestamp: DateTime.now(),
          fileName: path.basename(photoPath),
        );

        _photoService.addPhoto(photo);

        // Navigiere zum Bestätigungsbildschirm
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
          title: const Text('Kamera-Vorschau (Live)'),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _refreshPreview,
              tooltip: 'Preview aktualisieren',
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Preview Image
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _isLoadingPreview
                          ? const Center(child: CircularProgressIndicator())
                          : _previewImagePath != null &&
                                  File(_previewImagePath!).existsSync()
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(_previewImagePath!),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Center(
                                  child: Text(
                                    'Keine Vorschau verfügbar',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                    ),
                    // Live-Indikator
                    if (!_isLoadingPreview)
                      Positioned(
                        top: 30,
                        right: 30,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.videocam, color: Colors.white, size: 16),
                              SizedBox(width: 6),
                              Text(
                                'LIVE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Timer or Capture Button
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
