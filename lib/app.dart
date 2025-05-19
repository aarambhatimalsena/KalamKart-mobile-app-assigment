import 'package:flutter/material.dart';
import 'view/splash_screen.dart';
import 'view/login_screen.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const Logi(),
      },
    );
  }
}
