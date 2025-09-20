class Purchase {
  final String id;
  final String productId;
  final String supplierName;
  final String supplierContact;
  final double quantity;
  final double unitPrice;
  final double totalAmount;
  final DateTime purchaseDate;
  final String invoiceNumber;
  final String? notes;
  final String status; // pending, completed, cancelled
  final DateTime createdAt;
  final DateTime updatedAt;

  Purchase({
    required this.id,
    required this.productId,
    required this.supplierName,
    required this.supplierContact,
    required this.quantity,
    required this.unitPrice,
    required this.totalAmount,
    required this.purchaseDate,
    required this.invoiceNumber,
    this.notes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Purchase.fromMap(Map<String, dynamic> map) {
    return Purchase(
      id: map['id'] ?? '',
      productId: map['product_id'] ?? '',
      supplierName: map['supplier_name'] ?? '',
      supplierContact: map['supplier_contact'] ?? '',
      quantity: map['quantity']?.toDouble() ?? 0.0,
      unitPrice: map['unit_price']?.toDouble() ?? 0.0,
      totalAmount: map['total_amount']?.toDouble() ?? 0.0,
      purchaseDate: DateTime.parse(map['purchase_date']),
      invoiceNumber: map['invoice_number'] ?? '',
      notes: map['notes'],
      status: map['status'] ?? 'pending',
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'supplier_name': supplierName,
      'supplier_contact': supplierContact,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_amount': totalAmount,
      'purchase_date': purchaseDate.toIso8601String(),
      'invoice_number': invoiceNumber,
      'notes': notes,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Purchase copyWith({
    String? id,
    String? productId,
    String? supplierName,
    String? supplierContact,
    double? quantity,
    double? unitPrice,
    double? totalAmount,
    DateTime? purchaseDate,
    String? invoiceNumber,
    String? notes,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Purchase(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      supplierName: supplierName ?? this.supplierName,
      supplierContact: supplierContact ?? this.supplierContact,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalAmount: totalAmount ?? this.totalAmount,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
