# Lihpbox - Erste Schritte

Willkommen bei Lihpbox! Diese Anleitung führt dich Schritt für Schritt durch die erste Verwendung.

## 🚀 Schnelleinstieg (5 Minuten)

### Voraussetzungen erfüllt?
Stelle sicher, dass:
- [ ] Visual Studio mit C++ Workload installiert ist
- [ ] Flutter installiert ist
- [ ] Nikon D7100 Kamera verbunden ist
- [ ] Canon SELPHY CP1500 Drucker verbunden ist
- [ ] USB-Stick angesteckt ist

Falls nicht, siehe: [HARDWARE_SETUP.md](HARDWARE_SETUP.md)

### Schritt 1: Setup durchführen
```bash
# Öffne PowerShell und navigiere zum Projekt:
cd c:\Users\nicla\OneDrive\Dokumente\Lihpbox

# Führe das Setup-Skript aus:
.\setup.bat
```

Das Skript wird:
- Flutter überprüfen
- Alle Abhängigkeiten installieren
- Hardware diagnostizieren
- Dich durch den Prozess führen

### Schritt 2: App starten
```bash
flutter run -d windows
```

Die App startet dann im Debug-Modus auf deinem Windows-Desktop.

### Schritt 3: App konfigurieren

**Homescreen:**
1. Warte auf die Geräte-Diagnostik
2. Du solltest grüne Häkchen für Kamera und Drucker sehen
3. Wähle deinen USB-Stick aus der Dropdown
4. Klicke "Fotobox starten"

---

## 📸 Erste Fotoaufnahme

### Live-Preview Screen
```
┌─────────────────────────────────┐
│    Kamera-Vorschau              │
├─────────────────────────────────┤
│                                 │
│    [Live-Vorschau der Kamera]   │
│                                 │
├─────────────────────────────────┤
│    [ Foto aufnehmen ]           │ ← Klick hier!
└─────────────────────────────────┘
```

### Was passiert dann?

**1. Timer startet**
```
Timer zählt: 5 → 4 → 3 → 2 → 1 → FOTO!
```

**2. Foto wird aufgenommen**
- Die Kamera schießt automatisch
- Das Foto wird auf den USB-Stick gespeichert
- Der Bildschirm zeigt: "Foto aufnehmen läuft..."

**3. Bestätigungsbildschirm**
```
┌─────────────────────────────────┐
│    Foto bestätigen              │
├─────────────────────────────────┤
│                                 │
│  [Dein aufgenommenes Foto]      │
│                                 │
├─────────────────────────────────┤
│ [Abbrechen]    [Drucken] ✓      │
└─────────────────────────────────┘
```

### Option A: Foto drucken
1. Klick "Drucken"
2. Der Canon SELPHY beginnt zu drucken
3. Nach ~30 Sekunden ist das Foto gedruckt
4. Die App kehrt zur Vorschau zurück
5. Nächstes Foto!

### Option B: Foto verwerfen
1. Klick "Abbrechen"
2. Das Foto wird gelöscht
3. Die App kehrt zur Vorschau zurück
4. Bereit für das nächste Foto

---

## ⚙️ Einstellungen anpassen

### Timer-Dauer einstellen

Im Homescreen klick auf "Einstellungen":

```
┌─────────────────────────────────┐
│    Einstellungen                │
├─────────────────────────────────┤
│                                 │
│ Timer-Einstellungen             │
│ ○ 3 Sekunden  (kurz)           │
│ ● 5 Sekunden  (standard)       │
│ ○ 10 Sekunden (lang)           │
│                                 │
│ □ Auto-Delete nach Druck       │
│ □ Live-Preview aktivieren      │
│                                 │
│ [Speichern]  [Abbrechen]       │
└─────────────────────────────────┘
```

**Empfehlungen:**
- **3 Sekunden:** Für schnelle Schnappschüsse
- **5 Sekunden:** Standard (Personen können reagieren)
- **10 Sekunden:** Für Gruppenfotos (mehr Zeit zum Posieren)

---

## 🎯 Tipps für beste Ergebnisse

### Beleuchtung
- Verwende natürliches Tageslicht oder LED-Leuchten
- Vermeide direkte Sonneneinstrahlung auf den Kameralinsen
- Helle Hintergründe funktionieren besser

### Kamera-Positionierung
- Befestige die Kamera auf einem Stativ (Höhe: ~150cm)
- Stelle die Kamera im 45°-Winkel auf die Personen aus
- Achte darauf, dass nichts die Linse blockiert

### Preview vor Druck
- Überprüfe das Foto immer vor dem Druck
- Klick "Abbrechen" wenn du nicht zufrieden bist
- Neue Versuche sind kostenlos!

### Drucker-Optimierung
- Stelle sicher, dass ausreichend Fotopapier und Farbtinte vorhanden ist
- Warte zwischen Drucken 5-10 Sekunden
- Verwende Original-Canon Fotopapier für beste Qualität

### USB-Stick Verwaltung
- Verwende einen hochwertigen USB 3.0 Stick
- Mindestens 2GB freier Speicherplatz
- Regelmäßige Backups der Fotos machen

---

## 🆘 Häufige Probleme

### Problem: "Kamera nicht verbunden"
**Lösung:**
1. Überprüfe das USB-Kabel
2. Starte die Kamera neu
3. Versuche einen anderen USB-Port
4. Siehe: HARDWARE_SETUP.md → Troubleshooting

### Problem: "Drucker nicht erkannt"
**Lösung:**
1. Überprüfe die Drucker-Installation in Windows
2. Starte den Drucker neu
3. Führe `Get-Printer` in PowerShell aus
4. Siehe: HARDWARE_SETUP.md → Canon Setup

### Problem: "USB-Stick nicht gefunden"
**Lösung:**
1. Stecke den USB-Stick erneut ein
2. Warte 3 Sekunden
3. Starte die App neu
4. Überprüfe die Formatierung des USB-Sticks

### Problem: "App startet nicht"
**Lösung:**
```bash
# Flutter Cache leeren und neu bauen:
flutter clean
flutter pub get
flutter run -d windows
```

---

## 📚 Nächste Schritte

### Erweiterte Features erkunden
- Schau dir die Einstellungen genauer an
- Probiere verschiedene Timer-Einstellungen
- Experimentiere mit der Beleuchtung

### Daten sichern
- Regelmäßig Fotos vom USB-Stick sichern
- Externe Festplatte für Backups verwenden
- Optional: Cloud-Backup einrichten

### App anpassen (für Entwickler)
- Siehe: [DEVELOPMENT.md](DEVELOPMENT.md)
- Neue Features hinzufügen
- Custom Branding/Logos einfügen

---

## 🎉 Du bist bereit!

Die Lihpbox ist nun vollständig eingerichtet und einsatzbereit!

**Viel Spaß beim Fotografieren!**

---

### Kontakt & Hilfe

Bei Fragen oder Problemen:
1. Konsultiere die [README_DE.md](README_DE.md)
2. Lese die [HARDWARE_SETUP.md](HARDWARE_SETUP.md)
3. Führe `flutter doctor` aus für Diagnostik

**Hinweis:** Das gPhoto2 System wird weiterentwickelt. Bei Inkompatibilitäten konsultiere die gPhoto2 Dokumentation unter: http://www.gphoto.org/

---

**Version:** 1.0  
**Letztes Update:** April 2026  
**Komplett getestet auf:** Windows 11 mit Nikon D7100 + Canon SELPHY CP1500
