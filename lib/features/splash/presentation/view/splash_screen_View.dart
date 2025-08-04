import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalamkart_mobileapp/features/auth/presentation/view/login_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _taglineController;
  late AnimationController _loadingController;
  late AnimationController _backgroundController;
  late AnimationController _particleController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<Offset> _logoSlideAnimation;
  
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _textSlideAnimation;
  
  late Animation<double> _taglineOpacityAnimation;
  late Animation<Offset> _taglineSlideAnimation;
  
  late Animation<double> _loadingOpacityAnimation;
  late Animation<double> _backgroundOpacityAnimation;
  
  late Animation<double> _particleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    _initializeAnimations();
    _startAnimationSequence();
    _navigateToDashboard();
  }

  void _initializeAnimations() {
    // Logo animations
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));
    
    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));
    
    _logoSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutBack,
    ));

    // Text animations
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    ));
    
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    // Tagline animations
    _taglineController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _taglineOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _taglineController,
      curve: Curves.easeIn,
    ));
    
    _taglineSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _taglineController,
      curve: Curves.easeOut,
    ));

    // Loading animation
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _loadingOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeIn,
    ));

    // Background animation
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _backgroundOpacityAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    // Particle animation
    _particleController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    
    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _particleController,
      curve: Curves.linear,
    ));
  }

  void _startAnimationSequence() async {
    // Start background animation immediately
    _backgroundController.forward();
    _particleController.repeat();
    
    // Logo animation
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();
    
    // Text animation
    await Future.delayed(const Duration(milliseconds: 600));
    _textController.forward();
    
    // Tagline animation
    await Future.delayed(const Duration(milliseconds: 400));
    _taglineController.forward();
    
    // Loading animation
    await Future.delayed(const Duration(milliseconds: 300));
    _loadingController.forward();
  }

  Future<void> _navigateToDashboard() async {
    await Future.delayed(const Duration(seconds: 4));
    if (!mounted) return;

    // Fade out animation before navigation
    await Future.wait([
      _logoController.reverse(),
      _textController.reverse(),
      _taglineController.reverse(),
      _loadingController.reverse(),
    ]);

    if (!mounted) return;
    
    Navigator.pushReplacement(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _taglineController.dispose();
    _loadingController.dispose();
    _backgroundController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _backgroundController,
          _particleController,
        ]),
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF0A1B2E).withOpacity(_backgroundOpacityAnimation.value),
                  const Color(0xFF1A2B3E).withOpacity(_backgroundOpacityAnimation.value),
                  const Color(0xFF0F2027).withOpacity(_backgroundOpacityAnimation.value),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Animated background particles
                ...List.generate(20, (index) => _buildParticle(index)),
                
                // Main content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated logo
                      AnimatedBuilder(
                        animation: _logoController,
                        builder: (context, child) {
                          return SlideTransition(
                            position: _logoSlideAnimation,
                            child: FadeTransition(
                              opacity: _logoOpacityAnimation,
                              child: ScaleTransition(
                                scale: _logoScaleAnimation,
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.amber.withOpacity(0.3),
                                        blurRadius: 30,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
                                        colors: [Colors.amber, Colors.orange],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 15,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      size: 60,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Animated app name
                      AnimatedBuilder(
                        animation: _textController,
                        builder: (context, child) {
                          return SlideTransition(
                            position: _textSlideAnimation,
                            child: FadeTransition(
                              opacity: _textOpacityAnimation,
                              child: ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [Colors.amber, Colors.orange, Colors.yellow],
                                ).createShader(bounds),
                                child: const Text(
                                  'KalamKart',
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 2,
                                    fontFamily: 'Roboto_Condensed-Bold',
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Animated tagline
                      AnimatedBuilder(
                        animation: _taglineController,
                        builder: (context, child) {
                          return SlideTransition(
                            position: _taglineSlideAnimation,
                            child: FadeTransition(
                              opacity: _taglineOpacityAnimation,
                              child: const Text(
                                'Your Premium Stationery Destination',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  letterSpacing: 1,
                                  fontFamily: 'Roboto_Condensed-Italic',
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 60),
                      
                      // Animated loading indicator
                      AnimatedBuilder(
                        animation: _loadingController,
                        builder: (context, child) {
                          return FadeTransition(
                            opacity: _loadingOpacityAnimation,
                            child: Column(
                              children: [
                                // Custom loading animation
                                SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.amber.withOpacity(0.8),
                                    ),
                                    backgroundColor: Colors.white.withOpacity(0.2),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Loading your creative space...',
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 14,
                                    fontFamily: 'Roboto_Condensed-Regular',
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                
                // Bottom branding
                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: AnimatedBuilder(
                    animation: _loadingController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _loadingOpacityAnimation,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.favorite,
                                  color: Colors.red.withOpacity(0.7),
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Crafted with love for stationery enthusiasts',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                    fontFamily: 'Roboto_Condensed-Regular',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Version 1.0.0',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.3),
                                fontSize: 10,
                                fontFamily: 'Roboto_Condensed-Regular',
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildParticle(int index) {
    final random = (index * 1234567) % 1000 / 1000.0;
    final size = 2.0 + (random * 4);
    final speed = 0.5 + (random * 0.5);
    
    return AnimatedBuilder(
      animation: _particleAnimation,
      builder: (context, child) {
        final progress = (_particleAnimation.value + random) % 1.0;
        final opacity = (1.0 - progress) * 0.6;
        
        return Positioned(
          left: MediaQuery.of(context).size.width * random,
          top: MediaQuery.of(context).size.height * progress,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.amber.withOpacity(opacity),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withOpacity(opacity * 0.5),
                  blurRadius: size,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
