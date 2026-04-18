# Lihpbox - Hardware Setup & Troubleshooting Guide

## 1. Nikon D7100 Kamera Setup

### Verbindung herstellen
1. **USB-Kabel verbinden**
   - Verbinde die Nikon D7100 mit einem USB-Kabel mit dem Windows Laptop
   - Verwende USB 2.0 oder höher für bessere Geschwindigkeit

2. **Kamera-Einstellungen**
   - Schalte die Kamera ein
   - Gehe zu: Menu → Setup Menu → USB
   - Stelle sicher, dass "USB" als Verbindungsmodus gesetzt ist
   - Die Kamera sollte im PTP-Modus sein (Picture Transfer Protocol)

3. **gPhoto2 testen**
   ```bash
   # Öffne PowerShell und teste die Verbindung:
   gphoto2 --list-cameras
   
   # Sollte etwa das anzeigen:
   # Nikon D7100 (PTP mode)
   ```

### Troubleshooting - Kamera wird nicht erkannt

**Problem:** "Camera not recognized"

**Lösungen:**
1. USB-Kabel austauschen (defektes Kabel wahrscheinlich)
2. Anderen USB-Port probieren
3. Kamera im PTP-Modus sicherstellen
4. Kamera ausschalten, neu starten und erneut verbinden
5. gPhoto2 neu installieren:
   ```bash
   winget uninstall gPhoto2
   winget install gPhoto2.gPhoto2
   ```

**Wenn immer noch Probleme:**
- Firmware der Nikon D7100 aktualisieren
- Windows-Treiber aktualisieren
- Im gPhoto2 Wiki nach Nikon D7100 Kompatibilität suchen

---

## 2. Canon SELPHY CP1500 Drucker Setup

### Installation auf Windows

1. **Kabel verbinden**
   - Verbinde den Canon SELPHY CP1500 via USB
   - Oder verbinde ihn über das Netzwerk (wenn WLAN-fähig)

2. **Drucker als Windows-Drucker registrieren**
   ```
   Einstellungen → Geräte → Drucker und Scanner
   → "Drucker hinzufügen"
   → Wähle "Canon SELPHY CP1500"
   → Treiber installieren (Windows lädt diese automatisch)
   ```

3. **Treiber manuell (falls nötig)**
   - Gehe zu: https://www.canon.de/support/
   - Suche nach "CP1500"
   - Lade den neuesten Drucker-Treiber herunter
   - Installiere den Treiber

4. **Test**
   ```bash
   # In PowerShell:
   Get-Printer
   
   # Du solltest "Canon SELPHY CP1500" sehen
   ```

### Papier und Farbtinte einlegen

1. **Fotopapier Kassette**
   - Öffne die hintere Luke
   - Schiebe die Canon Fotopapier-Kassette ein
   - Das Papier sollte automatisch erkannt werden

2. **Farbband-Kassette**
   - Neben der Papier-Kassette ist eine Farbband-Kassette
   - Diese sollte gleichzeitig mit dem Papier eingelegt werden
   - Automatische Erfassung und Installation

3. **Testdruck**
   - Drucke über Windows Einstellungen
   - Datei → Drucken → Canon SELPHY CP1500 → Test-Drucken

### Troubleshooting - Drucker wird nicht erkannt

**Problem:** Drucker nicht in der App sichtbar

**Lösungen:**
1. Stelle sicher, dass der Drucker in Windows registriert ist:
   ```bash
   Get-Printer | Where-Object {$_.Type -eq "Local"} | Select-Object Name
   ```

2. Drucker neu anschließen und Power-Zyklus:
   - Trenne das USB-Kabel
   - Starte den Drucker neu
   - Warte 10 Sekunden
   - Verbinde das USB-Kabel erneut

3. Treiber erneuern:
   ```bash
   # In PowerShell (als Administrator):
   Remove-Printer -Name "Canon SELPHY CP1500"
   # Dann erneut über Einstellungen hinzufügen
   ```

4. Windows Druck-Warteschlange leeren:
   ```bash
   # PowerShell (als Administrator):
   Remove-Item -Path "C:\Windows\System32\spool\PRINTERS\*" -Force
   Restart-Service spooler
   ```

---

## 3. USB-Stick Setup & Verwaltung

### USB-Stick vorbereiten

1. **Formatierung überprüfen**
   - Der USB-Stick sollte FAT32 oder NTFS formatiert sein
   - Andere Dateisysteme können Probleme verursachen

2. **Speicherplatz überprüfen**
   - Mindestens 2 GB freier Speicherplatz empfohlen
   - Für 1000 Fotos in Full HD: ~500 GB benötigt

3. **USB-Stick verbinden**
   - Stecke den USB-Stick in einen USB 3.0 Port
   - Windows sollte das Laufwerk automatisch erkennen

### USB-Stick in Lihpbox auswählen

1. **In der App**
   - Starte die Lihpbox App
   - Im Homescreen siehst du eine Dropdown-Liste
   - Wähle Dein USB-Laufwerk (z.B. "D:\")
   - Klicke "Fotobox starten"

2. **Verzeichnisstruktur**
   ```
   D:\                          (USB-Stick Root)
   ├── Lihpbox\
   │   └── Photos\
   │       ├── photo_1714000000000.jpg
   │       ├── photo_1714000060000.jpg
   │       └── ...
   ```

### USB-Stick wechseln

1. **Neuen USB-Stick einsetzen**
2. **App-Restart erforderlich**
   - Schließe die Lihpbox App
   - Starte sie neu
   - Der neue USB-Stick wird erkannt

3. **Daten vom alten USB-Stick sichern**
   - Kopiere den "Lihpbox" Ordner auf den neuen Stick
   - Oder sichere ihn auf der Festplatte

---

## 4. Touchscreen-Optimierung

### Touchscreen testen

1. **Windows Touchscreen erkannt?**
   ```bash
   # PowerShell:
   Get-PnpDevice | Where-Object {$_.FriendlyName -like "*touch*"}
   ```

2. **Touchscreen-Treiber aktualisieren**
   - Geräte-Manager öffnen
   - Suche nach Deinem Touchscreen
   - Rechtsklick → Treiber aktualisieren

3. **Touchscreen-Eingaben kalibrieren**
   ```bash
   # PowerShell (als Administrator):
   powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e
   ```

### Flutter-App für Touchscreen optimieren

Die App ist bereits für Touchscreen optimiert:
- Große Schaltflächen (70x300px mindestens)
- Gute Abstände zwischen Buttons
- Touch-friendly Timer-Display

---

## 5. Netzwerk & Fernzugriff (optional)

### Drucker über Netzwerk verbinden

Einige Canon SELPHY Modelle unterstützen WLAN:

1. **Drucker ins WLAN verbinden**
   - Drucker-Menü → Netzwerk → WLAN
   - Verbinde mit dem gleichen Netzwerk wie der Laptop

2. **In der App**
   - Die App sollte den Netzwerk-Drucker automatisch erkennen
   - Falls nicht, verwende die IP-Adresse des Druckers

### Remote-Steuerung (fortgeschrittenes Setup)

Für Remote-Bedienung von anderer Lokation:
- Installiere ein VPN auf dem Laptop
- Bediene die App via Remote-Desktop
- Beachte: Kamera muss lokal verbunden bleiben

---

## 6. Performance & Optimierung

### Speicher optimieren

```bash
# Alte Fotos löschen (nach 30 Tagen):
# In der App: Einstellungen → Auto-Delete nach Druck

# Manuell löschen:
# Öffne D:\Lihpbox\Photos\ und lösche alte Dateien
```

### Geschwindigkeit verbessern

1. **USB 3.0 verwenden** statt USB 2.0
2. **SSD auf dem Laptop** statt HDD
3. **Ausreichend RAM** (mindestens 4GB empfohlen)
4. **Keine anderen Apps im Hintergrund** während Fotoshoots

### Wärmeverwaltung

- Kamera sollte nicht länger als 2 Stunden unkinterbrochen laufen
- Drucker braucht 5-10 Sekunden Kühlzeit zwischen Drucken

---

## 7. Sicherheit & Datenschutz

### Daten schützen

1. **Backup-Strategie**
   - Wöchentliche Backups auf externe Festplatte
   - Cloud-Backup (Optional: OneDrive, Google Drive)

2. **USB-Stick verschlüsseln** (optional)
   ```bash
   # BitLocker für USB-Stick aktivieren:
   # Rechtsklick auf USB-Stick → Bitlocker aktivieren
   ```

3. **Zugriffsrechte**
   - Nur autorisierte Benutzer sollten Zugriff haben
   - Windows-Benutzerkonto mit Passwort sichern

---

## 8. Support & Ressourcen

### Offizielle Links
- Flutter: https://flutter.dev/
- Nikon D7100: https://www.nikon.de/
- Canon SELPHY CP1500: https://www.canon.de/
- gPhoto2: http://www.gphoto.org/

### Hilfreiches Zubehör
- **USB-Hub powered**: Falls mehrere Geräte Stromversorgung brauchen
- **USB-Verlängerungskabel**: Für flexible Positionierung
- **USB-Repeater**: Falls Kabel länger als 5m sein muss

---

**Letztes Update:** April 2026

Für weitere Fragen siehe: README_DE.md oder starte `flutter doctor`
