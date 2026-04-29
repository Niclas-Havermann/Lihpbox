import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'screens/home_screen.dart';
import 'screens/preview_screen.dart';
import 'screens/photo_confirmation_screen.dart';
import 'screens/settings_screen.dart';
import 'models/photo.dart';

final logger = Logger();

void main() {
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
