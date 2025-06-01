import 'package:flutter/material.dart';
import 'bottom_navigation_screen/dashboard_screen.dart';
import 'view/login_screen.dart';
import 'view/signup_screen.dart';
import 'view/splash_screen.dart';


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
        fontFamily: 'Roboto', // ✅ Your downloaded Roboto font
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
      initialRoute: '/', // Start from Splash
      routes: {
        '/': (context) => const SplashScreen(),    // Initial screen
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}
