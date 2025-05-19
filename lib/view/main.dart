import 'package:flutter/material.dart';
import 'package:kalamkart_mobileapp/view/login_screen.dart';


void main() {
  runApp(const KalamKartApp());
}

class KalamKartApp extends StatelessWidget {
  const KalamKartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KalamKart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFF0A1B2E),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0A1B2E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const LoginScreen(), 
    );
  }
}
