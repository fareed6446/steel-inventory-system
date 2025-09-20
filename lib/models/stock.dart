class Stock {
  final String id;
  final String productId;
  final double currentQuantity;
  final double reservedQuantity;
  final double availableQuantity;
  final double minimumStockLevel;
  final double maximumStockLevel;
  final DateTime lastUpdated;
  final String location; // Warehouse location
  final String? batchNumber;
  final DateTime? expiryDate;

  Stock({
    required this.id,
    required this.productId,
    required this.currentQuantity,
    required this.reservedQuantity,
    required this.availableQuantity,
    required this.minimumStockLevel,
    required this.maximumStockLevel,
    required this.lastUpdated,
    required this.location,
    this.batchNumber,
    this.expiryDate,
  });

  factory Stock.fromMap(Map<String, dynamic> map) {
    return Stock(
      id: map['id'] ?? '',
      productId: map['product_id'] ?? '',
      currentQuantity: map['current_quantity']?.toDouble() ?? 0.0,
      reservedQuantity: map['reserved_quantity']?.toDouble() ?? 0.0,
      availableQuantity: map['available_quantity']?.toDouble() ?? 0.0,
      minimumStockLevel: map['minimum_stock_level']?.toDouble() ?? 0.0,
      maximumStockLevel: map['maximum_stock_level']?.toDouble() ?? 0.0,
      lastUpdated: DateTime.parse(map['last_updated']),
      location: map['location'] ?? '',
      batchNumber: map['batch_number'],
      expiryDate: map['expiry_date'] != null
          ? DateTime.parse(map['expiry_date'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'current_quantity': currentQuantity,
      'reserved_quantity': reservedQuantity,
      'available_quantity': availableQuantity,
      'minimum_stock_level': minimumStockLevel,
      'maximum_stock_level': maximumStockLevel,
      'last_updated': lastUpdated.toIso8601String(),
      'location': location,
      'batch_number': batchNumber,
      'expiry_date': expiryDate?.toIso8601String(),
    };
  }

  Stock copyWith({
    String? id,
    String? productId,
    double? currentQuantity,
    double? reservedQuantity,
    double? availableQuantity,
    double? minimumStockLevel,
    double? maximumStockLevel,
    DateTime? lastUpdated,
    String? location,
    String? batchNumber,
    DateTime? expiryDate,
  }) {
    return Stock(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      currentQuantity: currentQuantity ?? this.currentQuantity,
      reservedQuantity: reservedQuantity ?? this.reservedQuantity,
      availableQuantity: availableQuantity ?? this.availableQuantity,
      minimumStockLevel: minimumStockLevel ?? this.minimumStockLevel,
      maximumStockLevel: maximumStockLevel ?? this.maximumStockLevel,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      location: location ?? this.location,
      batchNumber: batchNumber ?? this.batchNumber,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }

  // Helper methods
  bool get isLowStock => availableQuantity <= minimumStockLevel;
  bool get isOverstocked => availableQuantity >= maximumStockLevel;
  double get stockPercentage => (availableQuantity / maximumStockLevel) * 100;
}
