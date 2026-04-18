import 'package:logger/logger.dart';
import '../models/photo.dart';

/// Service für die Verwaltung von Fotos und Metadaten
class PhotoService {
  static final PhotoService _instance = PhotoService._internal();
  final Logger logger = Logger();

  List<Photo> _photos = [];
  Photo? _currentPhoto;

  factory PhotoService() {
    return _instance;
  }

  PhotoService._internal();

  /// Adds a new photo to the collection
  void addPhoto(Photo photo) {
    _photos.add(photo);
    _currentPhoto = photo;
    logger.i('Foto hinzugefügt: ${photo.fileName}');
  }

  /// Gibt das aktuelle Foto zurück
  Photo? get currentPhoto => _currentPhoto;

  /// Setzt das aktuelle Foto
  void setCurrentPhoto(Photo photo) {
    _currentPhoto = photo;
    logger.i('Aktuelles Foto gesetzt: ${photo.fileName}');
  }

  /// Gibt alle Fotos zurück
  List<Photo> get allPhotos => _photos;

  /// Gibt die Anzahl der Fotos zurück
  int get photoCount => _photos.length;

  /// Markiert ein Foto als gedruckt
  void markAsPrinted(String photoId) {
    try {
      final index = _photos.indexWhere((p) => p.id == photoId);
      if (index != -1) {
        _photos[index].isPrinted = true;
        logger.i('Foto als gedruckt markiert: $photoId');
      }
    } catch (e) {
      logger.e('Fehler beim Markieren als gedruckt: $e');
    }
  }

  /// Löscht ein Foto aus der Kollektion
  void removePhoto(String photoId) {
    try {
      _photos.removeWhere((p) => p.id == photoId);
      if (_currentPhoto?.id == photoId) {
        _currentPhoto = null;
      }
      logger.i('Foto entfernt: $photoId');
    } catch (e) {
      logger.e('Fehler beim Entfernen des Fotos: $e');
    }
  }

  /// Löscht alle Fotos
  void clearAll() {
    _photos.clear();
    _currentPhoto = null;
    logger.i('Alle Fotos gelöscht');
  }

  /// Gibt die Anzahl der gedruckten Fotos zurück
  int get printedPhotoCount => _photos.where((p) => p.isPrinted).length;

  /// Gibt die Anzahl der nicht gedruckten Fotos zurück
  int get unprintedPhotoCount => _photos.where((p) => !p.isPrinted).length;

  /// Generiert eine eindeutige Photo-ID
  String generatePhotoId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${_photos.length}';
  }
}
