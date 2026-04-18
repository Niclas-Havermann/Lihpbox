/// Modell für ein aufgenommenes Foto
class Photo {
  final String id;
  final String filePath;
  final DateTime timestamp;
  final String fileName;
  bool isPrinted;

  Photo({
    required this.id,
    required this.filePath,
    required this.timestamp,
    required this.fileName,
    this.isPrinted = false,
  });

  /// Konvertiert das Foto zu JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filePath': filePath,
      'timestamp': timestamp.toIso8601String(),
      'fileName': fileName,
      'isPrinted': isPrinted,
    };
  }

  /// Erstellt ein Foto aus JSON
  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      filePath: json['filePath'],
      timestamp: DateTime.parse(json['timestamp']),
      fileName: json['fileName'],
      isPrinted: json['isPrinted'] ?? false,
    );
  }
}
