/// Modell für die Anwendungseinstellungen
class AppSettings {
  int timerDuration; // in Sekunden: 3, 5 oder 10
  String? usbStoragePath; // Pfad zum USB-Stick
  bool autoDeleteAfterPrint;
  bool enablePreview;

  AppSettings({
    this.timerDuration = 5,
    this.usbStoragePath,
    this.autoDeleteAfterPrint = false,
    this.enablePreview = true,
  });

  /// Konvertiert die Einstellungen zu JSON
  Map<String, dynamic> toJson() {
    return {
      'timerDuration': timerDuration,
      'usbStoragePath': usbStoragePath,
      'autoDeleteAfterPrint': autoDeleteAfterPrint,
      'enablePreview': enablePreview,
    };
  }

  /// Erstellt Einstellungen aus JSON
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      timerDuration: json['timerDuration'] ?? 5,
      usbStoragePath: json['usbStoragePath'],
      autoDeleteAfterPrint: json['autoDeleteAfterPrint'] ?? false,
      enablePreview: json['enablePreview'] ?? true,
    );
  }

  /// Validiert die Timer-Dauer
  bool isValidTimerDuration(int duration) {
    return [3, 5, 10].contains(duration);
  }
}
