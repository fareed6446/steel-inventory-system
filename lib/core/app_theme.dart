import 'package:flutter/material.dart';

/// Steel Factory Inventory Management System Theme
///
/// This theme file provides a comprehensive color palette and styling
/// that represents the steel industry with professional, industrial colors.
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // ============================================================================
  // STEEL INDUSTRY COLOR PALETTE
  // ============================================================================

  /// Primary Steel Colors - Based on actual steel colors
  static const Color primarySteel = Color(0xFF2C3E50); // Dark steel blue-gray
  static const Color secondarySteel = Color(0xFF34495E); // Medium steel gray
  static const Color lightSteel = Color(0xFF7F8C8D); // Light steel gray
  static const Color darkSteel = Color(0xFF1A252F); // Very dark steel

  /// Steel Metallic Colors - Representing different steel finishes
  static const Color brushedSteel = Color(0xFF95A5A6); // Brushed steel finish
  static const Color polishedSteel = Color(0xFFBDC3C7); // Polished steel
  static const Color galvanizedSteel = Color(0xFFECF0F1); // Galvanized steel
  static const Color oxidizedSteel = Color(
    0xFF8E44AD,
  ); // Oxidized steel (purple tint)

  /// Industrial Accent Colors
  static const Color industrialOrange = Color(0xFFE67E22); // Industrial orange
  static const Color safetyYellow = Color(0xFFF39C12); // Safety yellow
  static const Color warningRed = Color(0xFFE74C3C); // Warning red
  static const Color successGreen = Color(0xFF27AE60); // Success green
  static const Color infoBlue = Color(0xFF3498DB); // Info blue

  /// Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color lightGray = Color(0xFFF8F9FA);
  static const Color mediumGray = Color(0xFF6C757D);
  static const Color darkGray = Color(0xFF343A40);

  // ============================================================================
  // MODULE-SPECIFIC COLOR SCHEMES
  // ============================================================================

  /// Purchase Module Colors
  static const Color purchasePrimary = Color(0xFF2E86AB); // Steel blue
  static const Color purchaseSecondary = Color(0xFFA23B72); // Steel purple
  static const Color purchaseAccent = Color(0xFFF18F01); // Steel orange

  /// Sales Module Colors
  static const Color salesPrimary = Color(0xFF27AE60); // Steel green
  static const Color salesSecondary = Color(0xFF16A085); // Steel teal
  static const Color salesAccent = Color(0xFFF39C12); // Steel yellow

  /// Stock Module Colors
  static const Color stockPrimary = Color(0xFFE67E22); // Steel orange
  static const Color stockSecondary = Color(0xFFD35400); // Dark steel orange
  static const Color stockAccent = Color(0xFFF1C40F); // Steel gold

  /// Products Module Colors
  static const Color productsPrimary = Color(0xFF8E44AD); // Steel purple
  static const Color productsSecondary = Color(
    0xFF9B59B6,
  ); // Light steel purple
  static const Color productsAccent = Color(0xFFE74C3C); // Steel red

  /// Dashboard Module Colors
  static const Color dashboardPrimary = Color(0xFF2C3E50); // Primary steel
  static const Color dashboardSecondary = Color(0xFF34495E); // Secondary steel
  static const Color dashboardAccent = Color(0xFF3498DB); // Steel blue

  // ============================================================================
  // STATUS COLORS
  // ============================================================================

  static const Color statusSuccess = successGreen;
  static const Color statusWarning = safetyYellow;
  static const Color statusError = warningRed;
  static const Color statusInfo = infoBlue;
  static const Color statusPending = industrialOrange;

  // ============================================================================
  // BACKGROUND COLORS
  // ============================================================================

  static const Color backgroundPrimary = white;
  static const Color backgroundSecondary = lightGray;
  static const Color backgroundTertiary = galvanizedSteel;
  static const Color backgroundDark = darkSteel;

  // ============================================================================
  // TEXT COLORS
  // ============================================================================

  static const Color textPrimary = darkSteel;
  static const Color textSecondary = mediumGray;
  static const Color textTertiary = lightSteel;
  static const Color textInverse = white;
  static const Color textDisabled = brushedSteel;

  // ============================================================================
  // BORDER COLORS
  // ============================================================================

  static const Color borderLight = Color(0xFFE9ECEF);
  static const Color borderMedium = brushedSteel;
  static const Color borderDark = secondarySteel;

  // ============================================================================
  // SHADOW COLORS
  // ============================================================================

  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);

  // ============================================================================
  // THEME DATA
  // ============================================================================

  /// Main application theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: primarySteel,
        secondary: secondarySteel,
        tertiary: industrialOrange,
        surface: backgroundPrimary,
        background: backgroundSecondary,
        error: warningRed,
        onPrimary: white,
        onSecondary: white,
        onTertiary: white,
        onSurface: textPrimary,
        onBackground: textPrimary,
        onError: white,
      ),

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: primarySteel,
        foregroundColor: white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: white,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: backgroundPrimary,
        shadowColor: shadowLight,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primarySteel,
          foregroundColor: white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primarySteel,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primarySteel,
          side: const BorderSide(color: primarySteel),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundPrimary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primarySteel, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: warningRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: warningRed, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textTertiary),
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: textPrimary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: textSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: textSecondary, size: 24),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: borderLight,
        thickness: 1,
        space: 1,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: galvanizedSteel,
        labelStyle: const TextStyle(color: textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: backgroundPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        contentTextStyle: const TextStyle(fontSize: 14, color: textPrimary),
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: backgroundPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        elevation: 8,
      ),

      // Snack Bar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkSteel,
        contentTextStyle: const TextStyle(color: white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================================
  // MODULE-SPECIFIC THEMES
  // ============================================================================

  /// Purchase module color scheme
  static const ColorScheme purchaseColorScheme = ColorScheme.light(
    primary: purchasePrimary,
    secondary: purchaseSecondary,
    tertiary: purchaseAccent,
    surface: backgroundPrimary,
    background: backgroundSecondary,
    error: warningRed,
    onPrimary: white,
    onSecondary: white,
    onTertiary: white,
    onSurface: textPrimary,
    onBackground: textPrimary,
    onError: white,
  );

  /// Sales module color scheme
  static const ColorScheme salesColorScheme = ColorScheme.light(
    primary: salesPrimary,
    secondary: salesSecondary,
    tertiary: salesAccent,
    surface: backgroundPrimary,
    background: backgroundSecondary,
    error: warningRed,
    onPrimary: white,
    onSecondary: white,
    onTertiary: white,
    onSurface: textPrimary,
    onBackground: textPrimary,
    onError: white,
  );

  /// Stock module color scheme
  static const ColorScheme stockColorScheme = ColorScheme.light(
    primary: stockPrimary,
    secondary: stockSecondary,
    tertiary: stockAccent,
    surface: backgroundPrimary,
    background: backgroundSecondary,
    error: warningRed,
    onPrimary: white,
    onSecondary: white,
    onTertiary: white,
    onSurface: textPrimary,
    onBackground: textPrimary,
    onError: white,
  );

  /// Products module color scheme
  static const ColorScheme productsColorScheme = ColorScheme.light(
    primary: productsPrimary,
    secondary: productsSecondary,
    tertiary: productsAccent,
    surface: backgroundPrimary,
    background: backgroundSecondary,
    error: warningRed,
    onPrimary: white,
    onSecondary: white,
    onTertiary: white,
    onSurface: textPrimary,
    onBackground: textPrimary,
    onError: white,
  );

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Get module-specific primary color
  static Color getModulePrimaryColor(String module) {
    switch (module.toLowerCase()) {
      case 'purchase':
      case 'purchases':
        return purchasePrimary;
      case 'sale':
      case 'sales':
        return salesPrimary;
      case 'stock':
        return stockPrimary;
      case 'product':
      case 'products':
        return productsPrimary;
      case 'dashboard':
        return dashboardPrimary;
      default:
        return primarySteel;
    }
  }

  /// Get module-specific secondary color
  static Color getModuleSecondaryColor(String module) {
    switch (module.toLowerCase()) {
      case 'purchase':
      case 'purchases':
        return purchaseSecondary;
      case 'sale':
      case 'sales':
        return salesSecondary;
      case 'stock':
        return stockSecondary;
      case 'product':
      case 'products':
        return productsSecondary;
      case 'dashboard':
        return dashboardSecondary;
      default:
        return secondarySteel;
    }
  }

  /// Get module-specific accent color
  static Color getModuleAccentColor(String module) {
    switch (module.toLowerCase()) {
      case 'purchase':
      case 'purchases':
        return purchaseAccent;
      case 'sale':
      case 'sales':
        return salesAccent;
      case 'stock':
        return stockAccent;
      case 'product':
      case 'products':
        return productsAccent;
      case 'dashboard':
        return dashboardAccent;
      default:
        return industrialOrange;
    }
  }

  /// Get status color based on status string
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
      case 'completed':
      case 'active':
        return statusSuccess;
      case 'warning':
      case 'pending':
      case 'processing':
        return statusWarning;
      case 'error':
      case 'failed':
      case 'cancelled':
        return statusError;
      case 'info':
      case 'inactive':
        return statusInfo;
      default:
        return textSecondary;
    }
  }

  /// Create a steel-themed gradient
  static LinearGradient getSteelGradient() {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [primarySteel, secondarySteel, brushedSteel],
    );
  }

  /// Create a module-specific gradient
  static LinearGradient getModuleGradient(String module) {
    switch (module.toLowerCase()) {
      case 'purchase':
      case 'purchases':
        return const LinearGradient(
          colors: [purchasePrimary, purchaseSecondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'sale':
      case 'sales':
        return const LinearGradient(
          colors: [salesPrimary, salesSecondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'stock':
        return const LinearGradient(
          colors: [stockPrimary, stockSecondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'product':
      case 'products':
        return const LinearGradient(
          colors: [productsPrimary, productsSecondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return getSteelGradient();
    }
  }
}
