import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'services/supabase_service.dart';
import 'models/hive_user.dart';
import 'core/dependency_injection.dart';
import 'core/app_theme.dart';
import 'views/splash_screen.dart';
import 'views/main_navigation.dart';
import 'views/stock_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Add error handling for Flutter web
  FlutterError.onError = (FlutterErrorDetails details) {
    print('Flutter Error: ${details.exception}');
    print('Stack trace: ${details.stack}');
  };

  try {
    // Initialize Hive
    await Hive.initFlutter();
    print('Hive initialized successfully');

    // Register Hive adapters
    Hive.registerAdapter(HiveUserAdapter());
    print('Hive adapters registered successfully');

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
    return GetMaterialApp(
      title: 'Steel Factory',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/main', page: () => const MainNavigation()),
        GetPage(name: '/stock', page: () => const StockView()),
      ],
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
