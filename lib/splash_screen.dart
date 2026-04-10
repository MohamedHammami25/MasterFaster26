import 'package:flutter/material.dart';
import 'dart:async';
import 'package:masterfaster/screenone.dart';
import 'package:masterfaster/screentwo.dart';

class SplashScreen extends StatefulWidget {
  final bool isSetupComplete;
  final String? userId;

  const SplashScreen({super.key, required this.isSetupComplete, this.userId});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    // 1. Start Fade In
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => _opacity = 1.0);
    });

    // 2. Wait, then Fade Out and Navigate
    Timer(const Duration(seconds: 3), () {
      setState(() => _opacity = 0.0);

      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) =>
                  widget.isSetupComplete && widget.userId != null
                  ? ScenarioSelectionPage(userId: widget.userId!)
                  : const InformationsSetupPage(),
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 800),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/logo.png', // Ensure this matches your asset path
                width: 200,
              ),
              const SizedBox(height: 20),
              const Text(
                "VoiceFor",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D5CFF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
