import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:io';
import 'screens/home_screen.dart';
import 'screens/preview_screen.dart';
import 'screens/photo_confirmation_screen.dart';
import 'screens/settings_screen.dart';
import 'models/photo.dart';

final logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Window Manager nur für Desktop-Plattformen initialisieren
  if (Platform.isWindows || Platform.isLinux) {
    await windowManager.ensureInitialized();
    
    WindowOptions windowOptions = const WindowOptions(
      size: Size(1920, 1080),
      center: true,
      backgroundColor: Colors.black,
      skipTaskbar: true,
      fullScreen: true,
    );
    
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
  
  runApp(const LihpboxApp());
}

class LihpboxApp extends StatelessWidget {
  const LihpboxApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lihpbox - Fotobox Steuerung',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      routes: {
        '/preview': (context) => const PreviewScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/photo-confirmation': (context) {
          final photo = ModalRoute.of(context)?.settings.arguments as Photo?;
          if (photo == null) {
            return const HomeScreen();
          }
          return PhotoConfirmationScreen(photo: photo);
        },
      },
      onUnknownRoute: (settings) {
        logger.w('Unbekannte Route: ${settings.name}');
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
      },
    );
  }
}
