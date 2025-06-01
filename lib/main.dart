import 'package:flutter/material.dart';
import 'theme/theme.dart'; // ✅ Import the theme
import 'view/login_screen.dart';
import 'view/signup_screen.dart';
import 'view/splash_screen.dart';
import 'bottom_navigation_screen/dashboard_screen.dart';

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
      theme: appTheme, // ✅ Use centralized theme
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/dashboard': (context) =>  DashboardScreen(),
      },
    );
  }
}
