import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:masterfaster/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  // 1. Check if user already filled the form
  final prefs = await SharedPreferences.getInstance();
  final bool isSetupComplete = prefs.getBool('isSetupComplete') ?? false;
  final String? savedUserId = prefs.getString('userId');

  runApp(MyApp(isSetupComplete: isSetupComplete, userId: savedUserId));
}

class MyApp extends StatelessWidget {
  final bool isSetupComplete;
  final String? userId;

  const MyApp({super.key, required this.isSetupComplete, this.userId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VoiceFor',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1D5CFF)),
      ),
      // CHANGE THIS LINE:
      home: SplashScreen(isSetupComplete: isSetupComplete, userId: userId),
    );
  }
}
