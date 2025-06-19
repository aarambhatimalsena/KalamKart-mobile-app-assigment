import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kalamkart_mobileapp/app/service_locator/service_locator.dart' as di;

// Hive Model
import 'package:kalamkart_mobileapp/features/auth/data/model/user_hive_model.dart';

// Bloc ViewModels
import 'package:kalamkart_mobileapp/features/auth/presentation/view_model/login_viewmodel/login_viewmodel.dart';
import 'package:kalamkart_mobileapp/features/auth/presentation/view_model/signup_viewmodel/signup_viewmodel.dart';

// Screens
import 'package:kalamkart_mobileapp/features/auth/presentation/view/View/login_screen.dart';
import 'package:kalamkart_mobileapp/features/auth/presentation/view/View/signup_screen.dart';
import 'package:kalamkart_mobileapp/features/home/presentation/view/dashboard_screen.dart';
import 'package:kalamkart_mobileapp/features/splash/presentation/view/splash_screen_View.dart'; // ✅ SplashScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(UserHiveModelAdapter());

  await di.init(); // service locator init

  runApp(const KalamKartApp());
}

class KalamKartApp extends StatelessWidget {
  const KalamKartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<LoginViewModel>()),
        BlocProvider(create: (_) => di.sl<SignupViewModel>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'KalamKart',
        theme: ThemeData(fontFamily: 'Roboto'),
        initialRoute: '/', 
        routes: {
          '/': (_) => const SplashScreen(),     
          '/login': (_) => const LoginScreen(), 
          '/signup': (_) => const SignupScreen(),
          '/dashboard': (_) => const DashboardScreen(), 
        },
      ),
    );
  }
}
