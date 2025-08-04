import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kalamkart_mobileapp/app/service/proximity_service.dart';
import 'package:kalamkart_mobileapp/app/service_locator/service_locator.dart' as di;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shake/shake.dart';

// ViewModels
import 'package:kalamkart_mobileapp/features/auth/presentation/view_model/login_viewmodel/login_viewmodel.dart';
import 'package:kalamkart_mobileapp/features/auth/presentation/view_model/signup_viewmodel/signup_viewmodel.dart';

// Screens
import 'package:kalamkart_mobileapp/features/auth/presentation/view/login_screen.dart';
import 'package:kalamkart_mobileapp/features/auth/presentation/view/signup_screen.dart';
import 'package:kalamkart_mobileapp/features/home/presentation/view/dashboard_screen.dart' as home;
import 'package:kalamkart_mobileapp/features/splash/presentation/view/splash_screen_View.dart';
import 'package:kalamkart_mobileapp/features/home/presentation/view/bottom_navigation/my_orders_screen.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await di.init();

  runApp(const KalamKartApp());
}

class KalamKartApp extends StatefulWidget {
  const KalamKartApp({super.key});

  @override
  State<KalamKartApp> createState() => _KalamKartAppState();
}

class _KalamKartAppState extends State<KalamKartApp> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  ShakeDetector? shakeDetector;

  @override
  void initState() {
    super.initState();

    // ✅ Updated: shake callback must be synchronous
    shakeDetector = ShakeDetector.autoStart(onPhoneShake: (event) {
      _handleShakeLogout(); // async method called inside sync block
    });

    ProximityService().startListening();
  }

  Future<void> _handleShakeLogout() async {
    await secureStorage.deleteAll();
    if (navigatorKey.currentContext != null) {
      Navigator.of(navigatorKey.currentContext!).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  @override
  void dispose() {
    shakeDetector?.stopListening();
    super.dispose();
  }

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
        navigatorKey: navigatorKey,
        navigatorObservers: [routeObserver],
        initialRoute: '/',
        routes: {
          '/': (_) => const SplashScreen(),
          '/login': (_) => const LoginScreen(),
          '/signup': (_) => const SignupScreen(),
          '/dashboard': (_) => const home.DashboardScreen(),
          '/orders': (_) => const MyOrdersScreen(),

        },
      ),
    );
  }
}
