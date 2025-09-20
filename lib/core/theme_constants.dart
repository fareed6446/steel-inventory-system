import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Theme Constants for Steel Factory Inventory Management System
///
/// This file provides easy access to theme colors and styles
/// throughout the application.
class ThemeConstants {
  // Private constructor to prevent instantiation
  ThemeConstants._();

  // ============================================================================
  // QUICK ACCESS TO COLORS
  // ============================================================================

  // Primary Colors
  static const Color primary = AppTheme.primarySteel;
  static const Color secondary = AppTheme.secondarySteel;
  static const Color light = AppTheme.lightSteel;
  static const Color dark = AppTheme.darkSteel;

  // Steel Colors
  static const Color brushedSteel = AppTheme.brushedSteel;
  static const Color polishedSteel = AppTheme.polishedSteel;
  static const Color galvanizedSteel = AppTheme.galvanizedSteel;
  static const Color oxidizedSteel = AppTheme.oxidizedSteel;

  // Industrial Colors
  static const Color industrialOrange = AppTheme.industrialOrange;
  static const Color safetyYellow = AppTheme.safetyYellow;
  static const Color warningRed = AppTheme.warningRed;
  static const Color successGreen = AppTheme.successGreen;
  static const Color infoBlue = AppTheme.infoBlue;

  // Module Colors
  static const Color purchase = AppTheme.purchasePrimary;
  static const Color sales = AppTheme.salesPrimary;
  static const Color stock = AppTheme.stockPrimary;
  static const Color products = AppTheme.productsPrimary;

  // Status Colors
  static const Color success = AppTheme.statusSuccess;
  static const Color warning = AppTheme.statusWarning;
  static const Color error = AppTheme.statusError;
  static const Color info = AppTheme.statusInfo;
  static const Color pending = AppTheme.statusPending;

  // Background Colors
  static const Color background = AppTheme.backgroundPrimary;
  static const Color backgroundSecondary = AppTheme.backgroundSecondary;
  static const Color backgroundTertiary = AppTheme.backgroundTertiary;

  // Text Colors
  static const Color textPrimary = AppTheme.textPrimary;
  static const Color textSecondary = AppTheme.textSecondary;
  static const Color textTertiary = AppTheme.textTertiary;
  static const Color textInverse = AppTheme.textInverse;

  // Border Colors
  static const Color borderLight = AppTheme.borderLight;
  static const Color borderMedium = AppTheme.borderMedium;
  static const Color borderDark = AppTheme.borderDark;

  // ============================================================================
  // COMMON STYLES
  // ============================================================================

  /// Standard border radius for cards and containers
  static const double borderRadius = 12.0;

  /// Standard border radius for buttons
  static const double buttonBorderRadius = 8.0;

  /// Standard border radius for input fields
  static const double inputBorderRadius = 8.0;

  /// Standard padding for cards
  static const EdgeInsets cardPadding = EdgeInsets.all(20.0);

  /// Standard padding for sections
  static const EdgeInsets sectionPadding = EdgeInsets.all(24.0);

  /// Standard margin between elements
  static const EdgeInsets elementMargin = EdgeInsets.all(16.0);

  /// Standard shadow for cards
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: AppTheme.shadowLight,
      spreadRadius: 0,
      blurRadius: 10,
      offset: Offset(0, 2),
    ),
  ];

  /// Standard shadow for elevated elements
  static const List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: AppTheme.shadowMedium,
      spreadRadius: 0,
      blurRadius: 20,
      offset: Offset(0, 4),
    ),
  ];

  // ============================================================================
  // TEXT STYLES
  // ============================================================================

  /// Large title text style
  static const TextStyle titleLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  /// Medium title text style
  static const TextStyle titleMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  /// Small title text style
  static const TextStyle titleSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  /// Body text style
  static const TextStyle bodyText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textPrimary,
  );

  /// Secondary body text style
  static const TextStyle bodySecondary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textSecondary,
  );

  /// Caption text style
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textTertiary,
  );

  /// Button text style
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textInverse,
  );

  // ============================================================================
  // DECORATION HELPERS
  // ============================================================================

  /// Standard card decoration
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: background,
    borderRadius: BorderRadius.circular(borderRadius),
    boxShadow: cardShadow,
  );

  /// Elevated card decoration
  static BoxDecoration get elevatedCardDecoration => BoxDecoration(
    color: background,
    borderRadius: BorderRadius.circular(borderRadius),
    boxShadow: elevatedShadow,
  );

  /// Module-specific card decoration
  static BoxDecoration getModuleCardDecoration(String module) => BoxDecoration(
    color: background,
    borderRadius: BorderRadius.circular(borderRadius),
    boxShadow: cardShadow,
    border: Border.all(
      color: AppTheme.getModulePrimaryColor(module).withOpacity(0.2),
      width: 1,
    ),
  );

  /// Status badge decoration
  static BoxDecoration getStatusBadgeDecoration(String status) => BoxDecoration(
    color: AppTheme.getStatusColor(status),
    borderRadius: BorderRadius.circular(20),
  );

  /// Icon container decoration
  static BoxDecoration getIconContainerDecoration(Color color) => BoxDecoration(
    color: color.withOpacity(0.1),
    borderRadius: BorderRadius.circular(12),
  );

  // ============================================================================
  // GRADIENT HELPERS
  // ============================================================================

  /// Steel gradient decoration
  static BoxDecoration get steelGradientDecoration => BoxDecoration(
    gradient: AppTheme.getSteelGradient(),
    borderRadius: BorderRadius.circular(borderRadius),
  );

  /// Module gradient decoration
  static BoxDecoration getModuleGradientDecoration(String module) =>
      BoxDecoration(
        gradient: AppTheme.getModuleGradient(module),
        borderRadius: BorderRadius.circular(borderRadius),
      );

  // ============================================================================
  // BUTTON STYLES
  // ============================================================================

  /// Primary button style
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: primary,
    foregroundColor: textInverse,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(buttonBorderRadius),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    elevation: 2,
  );

  /// Secondary button style
  static ButtonStyle get secondaryButtonStyle => OutlinedButton.styleFrom(
    foregroundColor: primary,
    side: const BorderSide(color: primary),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(buttonBorderRadius),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  );

  /// Module-specific button style
  static ButtonStyle getModuleButtonStyle(String module) =>
      ElevatedButton.styleFrom(
        backgroundColor: AppTheme.getModulePrimaryColor(module),
        foregroundColor: textInverse,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonBorderRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        elevation: 2,
      );

  // ============================================================================
  // INPUT FIELD STYLES
  // ============================================================================

  /// Standard input decoration
  static InputDecoration get inputDecoration => const InputDecoration(
    filled: true,
    fillColor: background,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(inputBorderRadius)),
      borderSide: BorderSide(color: borderLight),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(inputBorderRadius)),
      borderSide: BorderSide(color: borderLight),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(inputBorderRadius)),
      borderSide: BorderSide(color: primary, width: 2),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    labelStyle: TextStyle(color: textSecondary),
    hintStyle: TextStyle(color: textTertiary),
  );

  /// Module-specific input decoration
  static InputDecoration getModuleInputDecoration(
    String module,
  ) => InputDecoration(
    filled: true,
    fillColor: background,
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(inputBorderRadius)),
      borderSide: BorderSide(color: borderLight),
    ),
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(inputBorderRadius)),
      borderSide: BorderSide(color: borderLight),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(inputBorderRadius)),
      borderSide: BorderSide(
        color: AppTheme.getModulePrimaryColor(module),
        width: 2,
      ),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    labelStyle: const TextStyle(color: textSecondary),
    hintStyle: const TextStyle(color: textTertiary),
  );

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Get module color with opacity
  static Color getModuleColorWithOpacity(String module, double opacity) {
    return AppTheme.getModulePrimaryColor(module).withOpacity(opacity);
  }

  /// Get status color with opacity
  static Color getStatusColorWithOpacity(String status, double opacity) {
    return AppTheme.getStatusColor(status).withOpacity(opacity);
  }

  /// Create a steel-themed container
  static Widget createSteelContainer({
    required Widget child,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? borderRadius,
  }) {
    return Container(
      padding: padding ?? cardPadding,
      margin: margin ?? elementMargin,
      decoration: cardDecoration.copyWith(
        borderRadius: BorderRadius.circular(
          borderRadius ?? ThemeConstants.borderRadius,
        ),
      ),
      child: child,
    );
  }

  /// Create a module-themed container
  static Widget createModuleContainer({
    required String module,
    required Widget child,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? borderRadius,
  }) {
    return Container(
      padding: padding ?? cardPadding,
      margin: margin ?? elementMargin,
      decoration: getModuleCardDecoration(module).copyWith(
        borderRadius: BorderRadius.circular(
          borderRadius ?? ThemeConstants.borderRadius,
        ),
      ),
      child: child,
    );
  }
}
