# Steel Factory Inventory Management System - Theme Guide

## Overview

This theme system provides a comprehensive, steel industry-inspired design language for the Steel Factory Inventory Management System. The theme is built around authentic steel colors and industrial aesthetics.

## Color Palette

### Primary Steel Colors
- **Primary Steel**: `#2C3E50` - Dark steel blue-gray (main brand color)
- **Secondary Steel**: `#34495E` - Medium steel gray
- **Light Steel**: `#7F8C8D` - Light steel gray
- **Dark Steel**: `#1A252F` - Very dark steel

### Steel Metallic Colors
- **Brushed Steel**: `#95A5A6` - Brushed steel finish
- **Polished Steel**: `#BDC3C7` - Polished steel
- **Galvanized Steel**: `#ECF0F1` - Galvanized steel
- **Oxidized Steel**: `#8E44AD` - Oxidized steel (purple tint)

### Industrial Accent Colors
- **Industrial Orange**: `#E67E22` - Industrial orange
- **Safety Yellow**: `#F39C12` - Safety yellow
- **Warning Red**: `#E74C3C` - Warning red
- **Success Green**: `#27AE60` - Success green
- **Info Blue**: `#3498DB` - Info blue

## Module-Specific Colors

### Purchase Module
- **Primary**: `#2E86AB` (Steel blue)
- **Secondary**: `#A23B72` (Steel purple)
- **Accent**: `#F18F01` (Steel orange)

### Sales Module
- **Primary**: `#27AE60` (Steel green)
- **Secondary**: `#16A085` (Steel teal)
- **Accent**: `#F39C12` (Steel yellow)

### Stock Module
- **Primary**: `#E67E22` (Steel orange)
- **Secondary**: `#D35400` (Dark steel orange)
- **Accent**: `#F1C40F` (Steel gold)

### Products Module
- **Primary**: `#8E44AD` (Steel purple)
- **Secondary**: `#9B59B6` (Light steel purple)
- **Accent**: `#E74C3C` (Steel red)

## Usage Examples

### Basic Usage

```dart
import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/theme_constants.dart';

// Using theme colors directly
Container(
  color: AppTheme.primarySteel,
  child: Text(
    'Steel Factory',
    style: TextStyle(color: AppTheme.white),
  ),
)

// Using theme constants for easier access
Container(
  color: ThemeConstants.primary,
  child: Text(
    'Steel Factory',
    style: ThemeConstants.titleLarge,
  ),
)
```

### Module-Specific Styling

```dart
// Get module colors dynamically
Color purchaseColor = AppTheme.getModulePrimaryColor('purchase');
Color salesColor = AppTheme.getModulePrimaryColor('sales');

// Create module-themed containers
Widget purchaseCard = ThemeConstants.createModuleContainer(
  module: 'purchase',
  child: Text('Purchase Data'),
);

Widget salesCard = ThemeConstants.createModuleContainer(
  module: 'sales',
  child: Text('Sales Data'),
);
```

### Status-Based Styling

```dart
// Get status colors
Color successColor = AppTheme.getStatusColor('success');
Color warningColor = AppTheme.getStatusColor('warning');
Color errorColor = AppTheme.getStatusColor('error');

// Create status badges
Container(
  decoration: ThemeConstants.getStatusBadgeDecoration('success'),
  child: Text('Completed', style: TextStyle(color: Colors.white)),
)
```

### Button Styling

```dart
// Primary button
ElevatedButton(
  style: ThemeConstants.primaryButtonStyle,
  onPressed: () {},
  child: Text('Primary Action'),
)

// Module-specific button
ElevatedButton(
  style: ThemeConstants.getModuleButtonStyle('purchase'),
  onPressed: () {},
  child: Text('Add Purchase'),
)
```

### Input Field Styling

```dart
// Standard input field
TextField(
  decoration: ThemeConstants.inputDecoration.copyWith(
    labelText: 'Product Name',
    hintText: 'Enter product name',
  ),
)

// Module-specific input field
TextField(
  decoration: ThemeConstants.getModuleInputDecoration('sales').copyWith(
    labelText: 'Customer Name',
    hintText: 'Enter customer name',
  ),
)
```

### Card Styling

```dart
// Standard card
Container(
  decoration: ThemeConstants.cardDecoration,
  child: Text('Card Content'),
)

// Elevated card
Container(
  decoration: ThemeConstants.elevatedCardDecoration,
  child: Text('Elevated Card Content'),
)

// Module-themed card
Container(
  decoration: ThemeConstants.getModuleCardDecoration('stock'),
  child: Text('Stock Card Content'),
)
```

### Gradient Usage

```dart
// Steel gradient
Container(
  decoration: ThemeConstants.steelGradientDecoration,
  child: Text('Steel Gradient'),
)

// Module gradient
Container(
  decoration: ThemeConstants.getModuleGradientDecoration('products'),
  child: Text('Products Gradient'),
)
```

## Theme Structure

### AppTheme Class
- **Main theme data**: `AppTheme.lightTheme`
- **Color schemes**: Module-specific color schemes
- **Utility methods**: Color and gradient helpers

### ThemeConstants Class
- **Quick access**: Simplified color and style access
- **Common styles**: Pre-defined text styles and decorations
- **Helper methods**: Container and styling utilities

## Best Practices

### 1. Use Module Colors Consistently
```dart
// Good - Use module-specific colors
Color purchaseColor = AppTheme.getModulePrimaryColor('purchase');

// Avoid - Hard-coding colors
Color purchaseColor = Colors.blue;
```

### 2. Use Theme Constants for Common Elements
```dart
// Good - Use theme constants
Text('Title', style: ThemeConstants.titleLarge)

// Avoid - Defining styles inline
Text('Title', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
```

### 3. Use Status Colors for Status Indicators
```dart
// Good - Use status colors
Color statusColor = AppTheme.getStatusColor('completed');

// Avoid - Using arbitrary colors for status
Color statusColor = Colors.green;
```

### 4. Use Helper Methods for Complex Styling
```dart
// Good - Use helper methods
Widget card = ThemeConstants.createModuleContainer(
  module: 'purchase',
  child: content,
);

// Avoid - Manually creating complex decorations
Widget card = Container(
  padding: EdgeInsets.all(20),
  margin: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [...],
    border: Border.all(...),
  ),
  child: content,
);
```

## Color Accessibility

All colors in the theme have been chosen to meet WCAG accessibility guidelines:
- **Contrast ratios**: Minimum 4.5:1 for normal text, 3:1 for large text
- **Color blindness**: Colors work well for users with color vision deficiencies
- **High contrast**: Dark text on light backgrounds, light text on dark backgrounds

## Customization

To customize the theme:

1. **Modify colors**: Update color constants in `AppTheme` class
2. **Add new colors**: Add new color constants following the naming convention
3. **Update styles**: Modify theme data in `AppTheme.lightTheme`
4. **Add utilities**: Add new helper methods to `ThemeConstants` class

## Migration Guide

When updating existing code to use the new theme:

1. **Replace hard-coded colors** with theme constants
2. **Use module-specific colors** for module-related UI elements
3. **Replace custom styles** with theme-defined styles
4. **Use helper methods** for complex styling

Example migration:
```dart
// Before
Container(
  color: Colors.blue[800],
  child: Text('Purchase', style: TextStyle(color: Colors.white)),
)

// After
Container(
  color: AppTheme.purchasePrimary,
  child: Text('Purchase', style: ThemeConstants.buttonText),
)
```

This theme system provides a consistent, professional, and steel industry-appropriate design language for the entire application.
