class AppConstants {
  // Database
  static const String databaseName = 'steel_factory_inventory.db';
  static const int databaseVersion = 1;

  // Steel Categories
  static const List<String> steelCategories = [
    'Carbon Steel',
    'Stainless Steel',
    'Alloy Steel',
    'Tool Steel',
    'Structural Steel',
    'Sheet Metal',
    'Rebar',
    'Wire Rod',
    'Pipe',
    'Tube',
  ];

  // Steel Grades
  static const List<String> steelGrades = [
    'A36',
    'A572',
    'A992',
    '304',
    '316',
    '316L',
    '410',
    '420',
    '440C',
    'D2',
    'H13',
    'S7',
  ];

  // Units
  static const List<String> units = [
    'kg',
    'tons',
    'pieces',
    'meters',
    'feet',
    'inches',
    'sheets',
    'coils',
  ];

  // Transaction Status
  static const List<String> transactionStatuses = [
    'pending',
    'completed',
    'cancelled',
  ];

  // Stock Locations
  static const List<String> stockLocations = [
    'Main Warehouse',
    'Storage Area A',
    'Storage Area B',
    'Outdoor Storage',
    'Quality Control',
  ];

  // Default Values
  static const double defaultMinimumStock = 10.0;
  static const double defaultMaximumStock = 1000.0;
  static const String defaultLocation = 'Main Warehouse';

  // UI Constants
  static const double cardElevation = 4.0;
  static const double borderRadius = 12.0;
  static const double buttonBorderRadius = 8.0;

  // Colors
  static const int primaryColorValue = 0xFF1976D2;
  static const int successColorValue = 0xFF4CAF50;
  static const int warningColorValue = 0xFFFF9800;
  static const int errorColorValue = 0xFFF44336;
  static const int infoColorValue = 0xFF2196F3;
}
