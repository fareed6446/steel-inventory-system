import 'package:flutter/material.dart';
import 'services/supabase_service.dart';
import 'core/dependency_injection.dart';
import 'core/app_theme.dart';
import 'views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Add error handling for Flutter web
  FlutterError.onError = (FlutterErrorDetails details) {
    print('Flutter Error: ${details.exception}');
    print('Stack trace: ${details.stack}');
  };

  try {
    // Initialize Supabase
    await SupabaseService.initialize();
    print('Supabase initialized successfully');

    // Initialize Dependency Injection
    await DependencyInjection.init();
    print('Dependency injection initialized successfully');
  } catch (e) {
    print('Error initializing app: $e');
    // Continue running the app even if initialization fails
  }

  runApp(const SteelFactoryInventoryApp());
}

class SteelFactoryInventoryApp extends StatelessWidget {
  const SteelFactoryInventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Steel Factory Inventory Management',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: 1.0, // Prevent text scaling issues
          ),
          child: child!,
        );
      },
    );
  }
}
