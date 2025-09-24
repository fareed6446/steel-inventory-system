import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_screen.dart';
import 'main_navigation.dart';
import '../core/theme_constants.dart';
import '../widgets/steel_factory_logo.dart';
import '../services/hive_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _progressController;

  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  late Animation<double> _progressAnimation;

  String _loadingText = 'Loading...';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Progress animation controller
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Logo scale and fade animation
    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutCubic),
    );

    // Text fade animation
    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
    );

    // Progress animation
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );
  }

  void _startAnimations() async {
    // Start logo animation
    await _logoController.forward();

    // Start text animation after logo
    await Future.delayed(const Duration(milliseconds: 300));
    await _textController.forward();

    // Start progress animation
    await Future.delayed(const Duration(milliseconds: 200));
    await _progressController.forward();

    // Wait for progress to complete and navigate
    await Future.delayed(const Duration(milliseconds: 1000));
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    try {
      // Update loading text
      setState(() {
        _loadingText = 'Initializing...';
      });

      // Wait for Hive service to initialize
      await Future.delayed(const Duration(milliseconds: 500));

      // Update loading text
      setState(() {
        _loadingText = 'Checking user data...';
      });

      // Get Hive service
      final HiveService hiveService = Get.find<HiveService>();

      // Wait for Hive to be initialized
      while (!hiveService.isInitialized.value) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // Debug Hive state
      await hiveService.debugHiveState();

      // Check if there's a current user in Hive
      if (hiveService.currentUser.value != null) {
        setState(() {
          _loadingText = 'Welcome back!';
        });

        print('User found in Hive: ${hiveService.currentUser.value!.email}');
        print('Navigating to Dashboard');

        // Small delay to show welcome message
        await Future.delayed(const Duration(milliseconds: 500));

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainNavigation()),
        );
      } else {
        setState(() {
          _loadingText = 'Ready to start...';
        });

        print('No user found in Hive, navigating to AuthScreen');

        // Small delay to show ready message
        await Future.delayed(const Duration(milliseconds: 500));

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AuthScreen()),
        );
      }
    } catch (e) {
      print('Error navigating from splash screen: $e');
      setState(() {
        _loadingText = 'Error occurred...';
      });

      // Fallback to auth screen if there's an error
      await Future.delayed(const Duration(milliseconds: 1000));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstants.primary,
      body: Container(
        decoration: BoxDecoration(
          gradient: ThemeConstants.getModuleGradientDecoration(
            'dashboard',
          ).gradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Logo with Text
              AnimatedBuilder(
                animation: _logoAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _logoAnimation.value.clamp(0.0, 1.0),
                    child: Opacity(
                      opacity: _logoAnimation.value.clamp(0.0, 1.0),
                      child: const SteelFactoryLogo(size: 400, showText: true),
                    ),
                  );
                },
              ),

              AnimatedBuilder(
                animation: _textAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _textAnimation.value.clamp(0.0, 1.0),
                    child: Text(
                      'Inventory Management System',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white70,
                        letterSpacing: 1,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 60),

              // Animated Progress Indicator
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _progressAnimation.value.clamp(0.0, 1.0),
                    child: Column(
                      children: [
                        Container(
                          width: 200,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: _progressAnimation.value.clamp(
                              0.0,
                              1.0,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _loadingText,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              // Animated Features List
              AnimatedBuilder(
                animation: _textAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: (_textAnimation.value * 0.8).clamp(0.0, 1.0),
                    child: Column(
                      children: [
                        _buildFeatureItem('📊 Real-time Analytics'),
                        _buildFeatureItem('📦 Smart Inventory Management'),
                        _buildFeatureItem('💰 Financial Tracking'),
                        _buildFeatureItem('🔔 Smart Alerts'),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
      ),
    );
  }
}
