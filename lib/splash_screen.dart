import 'package:flutter/material.dart';
import 'dart:async';
//import 'sebha_screen.dart'; // Import the main screen

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigate to SebhaScreen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed('/main');
    });

    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/splash@3x.png'), // Splash screen image
      ),
    );
  }
}
