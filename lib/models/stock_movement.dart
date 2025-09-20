class StockMovement {
  final String id;
  final String productId;
  final String transactionType; // purchase, sale, adjustment, transfer
  final String transactionId; // Reference to purchase/sale/adjustment ID
  final double quantity;
  final double previousQuantity;
  final double newQuantity;
  final String reason;
  final DateTime movementDate;
  final String? notes;
  final String userId; // Who made the movement
  final DateTime createdAt;

  StockMovement({
    required this.id,
    required this.productId,
    required this.transactionType,
    required this.transactionId,
    required this.quantity,
    required this.previousQuantity,
    required this.newQuantity,
    required this.reason,
    required this.movementDate,
    this.notes,
    required this.userId,
    required this.createdAt,
  });

  factory StockMovement.fromMap(Map<String, dynamic> map) {
    return StockMovement(
      id: map['id'] ?? '',
      productId: map['product_id'] ?? '',
      transactionType: map['transaction_type'] ?? '',
      transactionId: map['transaction_id'] ?? '',
      quantity: map['quantity']?.toDouble() ?? 0.0,
      previousQuantity: map['previous_quantity']?.toDouble() ?? 0.0,
      newQuantity: map['new_quantity']?.toDouble() ?? 0.0,
      reason: map['reason'] ?? '',
      movementDate: DateTime.parse(map['movement_date']),
      notes: map['notes'],
      userId: map['user_id'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'transaction_type': transactionType,
      'transaction_id': transactionId,
      'quantity': quantity,
      'previous_quantity': previousQuantity,
      'new_quantity': newQuantity,
      'reason': reason,
      'movement_date': movementDate.toIso8601String(),
      'notes': notes,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  StockMovement copyWith({
    String? id,
    String? productId,
    String? transactionType,
    String? transactionId,
    double? quantity,
    double? previousQuantity,
    double? newQuantity,
    String? reason,
    DateTime? movementDate,
    String? notes,
    String? userId,
    DateTime? createdAt,
  }) {
    return StockMovement(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      transactionType: transactionType ?? this.transactionType,
      transactionId: transactionId ?? this.transactionId,
      quantity: quantity ?? this.quantity,
      previousQuantity: previousQuantity ?? this.previousQuantity,
      newQuantity: newQuantity ?? this.newQuantity,
      reason: reason ?? this.reason,
      movementDate: movementDate ?? this.movementDate,
      notes: notes ?? this.notes,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Helper methods
  bool get isInbound =>
      transactionType == 'purchase' || transactionType == 'adjustment';
  bool get isOutbound =>
      transactionType == 'sale' || transactionType == 'transfer';
  String get movementDirection => isInbound ? 'IN' : 'OUT';
}
