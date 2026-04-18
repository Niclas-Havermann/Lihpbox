import 'package:flutter/material.dart';
import '../models/app_settings.dart';
import '../widgets/custom_button.dart';

/// Settings Screen - Einstellungen für Timer und andere Optionen
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late AppSettings _settings;
  int _selectedTimerDuration = 5;
  bool _autoDeleteAfterPrint = false;
  bool _enablePreview = true;

  @override
  void initState() {
    super.initState();
    _settings = AppSettings();
    _selectedTimerDuration = _settings.timerDuration;
    _autoDeleteAfterPrint = _settings.autoDeleteAfterPrint;
    _enablePreview = _settings.enablePreview;
  }

  void _saveSettings() {
    _settings.timerDuration = _selectedTimerDuration;
    _settings.autoDeleteAfterPrint = _autoDeleteAfterPrint;
    _settings.enablePreview = _enablePreview;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Einstellungen gespeichert!'),
        backgroundColor: Colors.green,
      ),
    );

    // Warte kurz und kehre zum Homescreen zurück
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/');
      }
    });
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
          title: const Text('Einstellungen'),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Timer Duration Settings
                const Text(
                  'Timer-Einstellungen',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Auslöse-Verzögerung (Sekunden):',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),

                // Timer Options
                ...[3, 5, 10].map((duration) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: RadioListTile<int>(
                      title: Text('$duration Sekunden'),
                      value: duration,
                      groupValue: _selectedTimerDuration,
                      onChanged: (value) {
                        setState(() => _selectedTimerDuration = value ?? 5);
                      },
                      activeColor: Colors.blue,
                    ),
                  );
                }).toList(),

                const SizedBox(height: 40),

                // Other Settings
                const Text(
                  'Weitere Optionen',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 20),

                // Auto-Delete After Print
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Fotos nach Druck automatisch löschen',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Switch(
                        value: _autoDeleteAfterPrint,
                        onChanged: (value) {
                          setState(() => _autoDeleteAfterPrint = value);
                        },
                        activeColor: Colors.green,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // Enable Preview
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Live-Preview aktivieren',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Switch(
                        value: _enablePreview,
                        onChanged: (value) {
                          setState(() => _enablePreview = value);
                        },
                        activeColor: Colors.green,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),

                // Save Button
                CustomButton(
                  label: 'Einstellungen speichern',
                  onPressed: _saveSettings,
                  backgroundColor: Colors.green,
                  width: double.infinity,
                  height: 60,
                  fontSize: 18,
                ),

                const SizedBox(height: 20),

                // Cancel Button
                CustomButton(
                  label: 'Abbrechen',
                  onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
                  backgroundColor: Colors.grey,
                  width: double.infinity,
                  height: 60,
                  fontSize: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
