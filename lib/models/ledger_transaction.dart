import 'package:uuid/uuid.dart';

/// Model for Transaction in the Ledger System
/// Represents a financial transaction for a person
class LedgerTransaction {
  final String id;
  final String personId;
  final String type; // 'sale', 'purchase', 'payment_received', 'payment_given'
  final double amount;
  final String description;
  final String? referenceNumber;
  final String? relatedTransactionId;
  final String currency;
  final DateTime transactionDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  LedgerTransaction({
    String? id,
    required this.personId,
    required this.type,
    required this.amount,
    required this.description,
    this.referenceNumber,
    this.relatedTransactionId,
    this.currency = 'PKR',
    DateTime? transactionDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       transactionDate = transactionDate ?? DateTime.now(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory LedgerTransaction.fromMap(Map<String, dynamic> map) {
    return LedgerTransaction(
      id: map['id'] ?? const Uuid().v4(),
      personId: map['person_id'] ?? '',
      type: map['type'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      description: map['description'] ?? '',
      referenceNumber: map['reference_number'],
      relatedTransactionId: map['related_transaction_id'],
      currency: map['currency'] ?? 'PKR',
      transactionDate:
          DateTime.tryParse(map['transaction_date']?.toString() ?? '') ??
          DateTime.now(),
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
      'person_id': personId,
      'type': type,
      'amount': amount,
      'description': description,
      'reference_number': referenceNumber,
      'related_transaction_id': relatedTransactionId,
      'currency': currency,
      'transaction_date': transactionDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  LedgerTransaction copyWith({
    String? id,
    String? personId,
    String? type,
    double? amount,
    String? description,
    String? referenceNumber,
    String? relatedTransactionId,
    String? currency,
    DateTime? transactionDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LedgerTransaction(
      id: id ?? this.id,
      personId: personId ?? this.personId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      relatedTransactionId: relatedTransactionId ?? this.relatedTransactionId,
      currency: currency ?? this.currency,
      transactionDate: transactionDate ?? this.transactionDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper getters
  bool get isCredit => type == 'sale' || type == 'payment_received';
  bool get isDebit => type == 'purchase' || type == 'payment_given';

  String get typeDisplayName {
    switch (type) {
      case 'sale':
        return 'Sale';
      case 'purchase':
        return 'Purchase';
      case 'payment_received':
        return 'Payment Received';
      case 'payment_given':
        return 'Payment Given';
      default:
        return type.toUpperCase();
    }
  }

  String get typeIcon {
    switch (type) {
      case 'sale':
        return '💰';
      case 'purchase':
        return '🛒';
      case 'payment_received':
        return '📥';
      case 'payment_given':
        return '📤';
      default:
        return '💳';
    }
  }

  @override
  String toString() {
    return 'LedgerTransaction(id: $id, personId: $personId, type: $type, amount: $amount, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LedgerTransaction && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Model for Ledger Entry (combines transaction with running balance)
class LedgerEntry {
  final String transactionId;
  final String personId;
  final String personName;
  final DateTime createdAt;
  final String type;
  final String description;
  final String? referenceNumber;
  final double amount;
  final double debit;
  final double credit;
  final double runningBalance;
  final String currency;

  LedgerEntry({
    required this.transactionId,
    required this.personId,
    required this.personName,
    required this.createdAt,
    required this.type,
    required this.description,
    this.referenceNumber,
    required this.amount,
    required this.debit,
    required this.credit,
    required this.runningBalance,
    this.currency = 'PKR',
  });

  factory LedgerEntry.fromMap(Map<String, dynamic> map) {
    return LedgerEntry(
      transactionId: map['transaction_id'] ?? '',
      personId: map['person_id'] ?? '',
      personName: map['person_name'] ?? '',
      createdAt:
          DateTime.tryParse(map['created_at']?.toString() ?? '') ??
          DateTime.now(),
      type: map['type'] ?? '',
      description: map['description'] ?? '',
      referenceNumber: map['reference_number'],
      amount: (map['amount'] ?? 0.0).toDouble(),
      debit: (map['debit'] ?? 0.0).toDouble(),
      credit: (map['credit'] ?? 0.0).toDouble(),
      runningBalance: (map['running_balance'] ?? 0.0).toDouble(),
      currency: map['currency'] ?? 'PKR',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'transaction_id': transactionId,
      'person_id': personId,
      'person_name': personName,
      'created_at': createdAt.toIso8601String(),
      'type': type,
      'description': description,
      'reference_number': referenceNumber,
      'amount': amount,
      'debit': debit,
      'credit': credit,
      'running_balance': runningBalance,
      'currency': currency,
    };
  }

  // Helper getters
  bool get isCredit => type == 'sale' || type == 'payment_received';
  bool get isDebit => type == 'purchase' || type == 'payment_given';

  String get typeDisplayName {
    switch (type) {
      case 'sale':
        return 'Sale';
      case 'purchase':
        return 'Purchase';
      case 'payment_received':
        return 'Payment Received';
      case 'payment_given':
        return 'Payment Given';
      default:
        return type.toUpperCase();
    }
  }

  String get typeIcon {
    switch (type) {
      case 'sale':
        return '💰';
      case 'purchase':
        return '🛒';
      case 'payment_received':
        return '📥';
      case 'payment_given':
        return '📤';
      default:
        return '💳';
    }
  }

  bool get hasPositiveBalance => runningBalance >= 0;

  @override
  String toString() {
    return 'LedgerEntry(transactionId: $transactionId, personName: $personName, type: $type, amount: $amount, runningBalance: $runningBalance)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LedgerEntry && other.transactionId == transactionId;
  }

  @override
  int get hashCode => transactionId.hashCode;
}
