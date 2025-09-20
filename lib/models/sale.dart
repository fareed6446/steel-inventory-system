class Sale {
  final String id;
  final String productId;
  final String customerName;
  final String customerContact;
  final double quantity;
  final double unitPrice;
  final double totalAmount;
  final DateTime saleDate;
  final String invoiceNumber;
  final String? notes;
  final String status; // pending, completed, cancelled
  final DateTime createdAt;
  final DateTime updatedAt;

  Sale({
    required this.id,
    required this.productId,
    required this.customerName,
    required this.customerContact,
    required this.quantity,
    required this.unitPrice,
    required this.totalAmount,
    required this.saleDate,
    required this.invoiceNumber,
    this.notes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Sale.fromMap(Map<String, dynamic> map) {
    return Sale(
      id: map['id'] ?? '',
      productId: map['product_id'] ?? '',
      customerName: map['customer_name'] ?? '',
      customerContact: map['customer_contact'] ?? '',
      quantity: map['quantity']?.toDouble() ?? 0.0,
      unitPrice: map['unit_price']?.toDouble() ?? 0.0,
      totalAmount: map['total_amount']?.toDouble() ?? 0.0,
      saleDate: DateTime.parse(map['sale_date']),
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
      'customer_name': customerName,
      'customer_contact': customerContact,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_amount': totalAmount,
      'sale_date': saleDate.toIso8601String(),
      'invoice_number': invoiceNumber,
      'notes': notes,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Sale copyWith({
    String? id,
    String? productId,
    String? customerName,
    String? customerContact,
    double? quantity,
    double? unitPrice,
    double? totalAmount,
    DateTime? saleDate,
    String? invoiceNumber,
    String? notes,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Sale(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      customerName: customerName ?? this.customerName,
      customerContact: customerContact ?? this.customerContact,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalAmount: totalAmount ?? this.totalAmount,
      saleDate: saleDate ?? this.saleDate,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
