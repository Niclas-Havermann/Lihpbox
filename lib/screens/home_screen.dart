import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/camera_service.dart';
import '../services/printer_service.dart';
import '../widgets/custom_button.dart';

/// Homescreen - Hauptbildschirm der Anwendung
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storageService = StorageService();
  final _cameraService = CameraService();
  final _printerService = PrinterService();

  List<String> _usbDrives = [];
  String? _selectedUsbDrive;
  bool _isLoadingUsb = false;
  bool _isCameraReady = false;
  bool _isPrinterReady = false;

  @override
  void initState() {
    super.initState();
    _initializeDevices();
  }

  Future<void> _initializeDevices() async {
    setState(() => _isLoadingUsb = true);

    // Erkenne USB-Laufwerke
    _usbDrives = await _storageService.detectUsbDrives();

    // Initialisiere Kamera
    _isCameraReady = await _cameraService.initializeCamera();

    // Initialisiere Drucker
    _isPrinterReady = await _printerService.initializePrinter();

    setState(() => _isLoadingUsb = false);
  }

  Future<void> _selectUsbDrive() async {
    if (_selectedUsbDrive == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte ein USB-Laufwerk auswählen')),
      );
      return;
    }

    final success = await _storageService.setUsbPath(_selectedUsbDrive!);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('USB-Laufwerk gesetzt: $_selectedUsbDrive')),
      );
      // Starte die Kamera-Preview
      if (mounted) {
        Navigator.of(context).pushNamed('/preview');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fehler beim Setzen des USB-Laufwerks')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lihpbox - Fotobox Steuerung'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title
                const Text(
                  'Willkommen zur Lihpbox',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 40),

                // Status Cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatusCard(
                      'Kamera',
                      _isCameraReady,
                      Icons.camera_alt,
                    ),
                    _buildStatusCard(
                      'Drucker',
                      _isPrinterReady,
                      Icons.print,
                    ),
                  ],
                ),
                const SizedBox(height: 50),

                // USB Drive Selection
                if (_isLoadingUsb)
                  const CircularProgressIndicator()
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'USB-Laufwerk auswählen:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      if (_usbDrives.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange, width: 2),
                          ),
                          child: const Text(
                            'Keine USB-Laufwerke erkannt. Bitte USB-Stick anschließen.',
                            style: TextStyle(color: Colors.orange, fontSize: 16),
                          ),
                        )
                      else
                        DropdownButton<String>(
                          value: _selectedUsbDrive,
                          hint: const Text('USB-Laufwerk wählen...'),
                          isExpanded: true,
                          items: _usbDrives.map((String drive) {
                            return DropdownMenuItem<String>(
                              value: drive,
                              child: Text(drive),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() => _selectedUsbDrive = newValue);
                          },
                        ),
                    ],
                  ),
                const SizedBox(height: 50),

                // Start Button
                CustomButton(
                  label: 'Fotobox starten',
                  onPressed: _selectUsbDrive,
                  backgroundColor: Colors.green,
                  width: 300,
                  height: 70,
                  fontSize: 24,
                ),
                const SizedBox(height: 20),

                // Settings Button
                CustomButton(
                  label: 'Einstellungen',
                  onPressed: () => Navigator.of(context).pushNamed('/settings'),
                  backgroundColor: Colors.grey,
                  width: 300,
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

  Widget _buildStatusCard(String title, bool isReady, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isReady ? Colors.green[100] : Colors.red[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isReady ? Colors.green : Colors.red,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 40,
            color: isReady ? Colors.green : Colors.red,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            isReady ? 'Verbunden' : 'Nicht verbunden',
            style: TextStyle(
              color: isReady ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
