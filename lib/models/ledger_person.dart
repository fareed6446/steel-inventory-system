import 'package:uuid/uuid.dart';

/// Model for Person in the Ledger System
/// Represents a person/company with financial transactions
class LedgerPerson {
  final String id;
  final String name;
  final double openingBalance;
  final String currency;
  final Map<String, dynamic>? contactInfo;
  final String businessType; // 'supplier', 'customer', 'both'
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  LedgerPerson({
    String? id,
    required this.name,
    this.openingBalance = 0.0,
    this.currency = 'PKR',
    this.contactInfo,
    this.businessType = 'customer',
    this.isActive = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory LedgerPerson.fromMap(Map<String, dynamic> map) {
    return LedgerPerson(
      id: map['id'] ?? const Uuid().v4(),
      name: map['name'] ?? '',
      openingBalance: (map['opening_balance'] ?? 0.0).toDouble(),
      currency: map['currency'] ?? 'PKR',
      contactInfo: map['contact_info'] != null
          ? Map<String, dynamic>.from(map['contact_info'])
          : null,
      businessType: map['business_type'] ?? 'customer',
      isActive: map['is_active'] ?? true,
      createdAt:
          DateTime.tryParse(map['created_at']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(map['updated_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'opening_balance': openingBalance,
      'currency': currency,
      'contact_info': contactInfo,
      'business_type': businessType,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  LedgerPerson copyWith({
    String? id,
    String? name,
    double? openingBalance,
    String? currency,
    Map<String, dynamic>? contactInfo,
    String? businessType,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LedgerPerson(
      id: id ?? this.id,
      name: name ?? this.name,
      openingBalance: openingBalance ?? this.openingBalance,
      currency: currency ?? this.currency,
      contactInfo: contactInfo ?? this.contactInfo,
      businessType: businessType ?? this.businessType,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper getters
  String get email => contactInfo?['email'] ?? '';
  String get phone => contactInfo?['phone'] ?? '';
  String get address => contactInfo?['address'] ?? '';

  bool get isSupplier => businessType == 'supplier' || businessType == 'both';
  bool get isCustomer => businessType == 'customer' || businessType == 'both';

  @override
  String toString() {
    return 'LedgerPerson(id: $id, name: $name, openingBalance: $openingBalance, currency: $currency, businessType: $businessType, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LedgerPerson && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Model for Person Summary (includes calculated totals)
class PersonSummary {
  final String id;
  final String name;
  final String businessType;
  final bool isActive;
  final double openingBalance;
  final double totalSales;
  final double totalPurchases;
  final double totalPaymentsReceived;
  final double totalPaymentsGiven;
  final double remainingBalance;
  final int transactionCount;
  final DateTime createdAt;

  PersonSummary({
    required this.id,
    required this.name,
    required this.businessType,
    required this.isActive,
    required this.openingBalance,
    required this.totalSales,
    required this.totalPurchases,
    required this.totalPaymentsReceived,
    required this.totalPaymentsGiven,
    required this.remainingBalance,
    required this.transactionCount,
    required this.createdAt,
  });

  factory PersonSummary.fromMap(Map<String, dynamic> map) {
    return PersonSummary(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      businessType: map['business_type'] ?? 'customer',
      isActive: map['is_active'] ?? true,
      openingBalance: (map['opening_balance'] ?? 0.0).toDouble(),
      totalSales: (map['total_sales'] ?? 0.0).toDouble(),
      totalPurchases: (map['total_purchases'] ?? 0.0).toDouble(),
      totalPaymentsReceived: (map['total_payments_received'] ?? 0.0).toDouble(),
      totalPaymentsGiven: (map['total_payments_given'] ?? 0.0).toDouble(),
      remainingBalance: (map['remaining_balance'] ?? 0.0).toDouble(),
      transactionCount: map['transaction_count'] ?? 0,
      createdAt:
          DateTime.tryParse(map['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'business_type': businessType,
      'is_active': isActive,
      'opening_balance': openingBalance,
      'total_sales': totalSales,
      'total_purchases': totalPurchases,
      'total_payments_received': totalPaymentsReceived,
      'total_payments_given': totalPaymentsGiven,
      'remaining_balance': remainingBalance,
      'transaction_count': transactionCount,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Helper getters
  bool get isSupplier => businessType == 'supplier' || businessType == 'both';
  bool get isCustomer => businessType == 'customer' || businessType == 'both';
  bool get hasPositiveBalance => remainingBalance >= 0;
  double get totalCredits => totalSales + totalPaymentsReceived;
  double get totalDebits => totalPurchases + totalPaymentsGiven;

  @override
  String toString() {
    return 'PersonSummary(id: $id, name: $name, remainingBalance: $remainingBalance, transactionCount: $transactionCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PersonSummary && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
