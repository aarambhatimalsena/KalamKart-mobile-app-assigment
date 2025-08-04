import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalamkart_mobileapp/app/service_locator/service_locator.dart';

// Dashboard (from home module)
import 'package:kalamkart_mobileapp/features/home/presentation/view/dashboard_screen.dart';

// Bloc ViewModels
import 'package:kalamkart_mobileapp/features/auth/presentation/view_model/login_viewmodel/login_viewmodel.dart';
import 'package:kalamkart_mobileapp/features/auth/presentation/view_model/signup_viewmodel/signup_viewmodel.dart';

// Screens (view/View)
import 'package:kalamkart_mobileapp/features/auth/presentation/view/login_screen.dart';
import 'package:kalamkart_mobileapp/features/auth/presentation/view/signup_screen.dart';

//  Splash Screen
import 'package:kalamkart_mobileapp/features/splash/presentation/view/splash_screen_View.dart' hide DashboardScreen;

class KalamKartApp extends StatelessWidget {
  const KalamKartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<LoginViewModel>()),
        BlocProvider(create: (_) => sl<SignupViewModel>()),
      ],
      child: MaterialApp(
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
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          '/dashboard': (context) => const DashboardScreen(),
        },
      ),
    );
  }
}
