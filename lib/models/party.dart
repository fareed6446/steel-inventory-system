import 'package:uuid/uuid.dart';

class Party {
  final String id;
  final String name;
  final String type; // 'supplier' or 'customer'
  final String partyCategory; // 'company' or 'person'
  final String? email;
  final String? phone;
  final String? address;
  final String? city;
  final String? country;
  final String? taxNumber;
  final String? registrationNumber;
  final String? contactPerson;
  final String? notes;
  final double openingBalance;
  final String currency;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Party({
    String? id,
    required this.name,
    required this.type,
    this.partyCategory = 'company',
    this.email,
    this.phone,
    this.address,
    this.city,
    this.country,
    this.taxNumber,
    this.registrationNumber,
    this.contactPerson,
    this.notes,
    this.openingBalance = 0.0,
    this.currency = 'PKR',
    this.isActive = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Party.fromMap(Map<String, dynamic> map) {
    return Party(
      id: map['id'] ?? const Uuid().v4(),
      name: map['name'] ?? '',
      type: map['type'] ?? 'customer',
      partyCategory: map['party_category'] ?? 'company',
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
      city: map['city'],
      country: map['country'],
      taxNumber: map['tax_number'],
      registrationNumber: map['registration_number'],
      contactPerson: map['contact_person'],
      notes: map['notes'],
      openingBalance: (map['opening_balance'] ?? 0.0).toDouble(),
      currency: map['currency'] ?? 'PKR',
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
      'type': type,
      'party_category': partyCategory,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'country': country,
      'tax_number': taxNumber,
      'registration_number': registrationNumber,
      'contact_person': contactPerson,
      'notes': notes,
      'opening_balance': openingBalance,
      'currency': currency,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Party copyWith({
    String? id,
    String? name,
    String? type,
    String? partyCategory,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? country,
    String? taxNumber,
    String? registrationNumber,
    String? contactPerson,
    String? notes,
    double? openingBalance,
    String? currency,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Party(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      partyCategory: partyCategory ?? this.partyCategory,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      taxNumber: taxNumber ?? this.taxNumber,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      contactPerson: contactPerson ?? this.contactPerson,
      notes: notes ?? this.notes,
      openingBalance: openingBalance ?? this.openingBalance,
      currency: currency ?? this.currency,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Party(id: $id, name: $name, type: $type, email: $email, phone: $phone, address: $address, city: $city, country: $country, taxNumber: $taxNumber, registrationNumber: $registrationNumber, contactPerson: $contactPerson, notes: $notes, openingBalance: $openingBalance, currency: $currency, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Party && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class PartyTransaction {
  final String id;
  final String partyId;
  final String
  transactionType; // 'purchase', 'sale', 'payment_received', 'payment_made'
  final String transactionId; // Reference to purchase/sale ID
  final double amount;
  final String currency;
  final String description;
  final DateTime transactionDate;
  final String? invoiceNumber;
  final String? notes;
  final DateTime createdAt;

  PartyTransaction({
    String? id,
    required this.partyId,
    required this.transactionType,
    required this.transactionId,
    required this.amount,
    this.currency = 'PKR',
    required this.description,
    required this.transactionDate,
    this.invoiceNumber,
    this.notes,
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  factory PartyTransaction.fromMap(Map<String, dynamic> map) {
    return PartyTransaction(
      id: map['id'] ?? const Uuid().v4(),
      partyId: map['party_id'] ?? '',
      transactionType: map['transaction_type'] ?? '',
      transactionId: map['transaction_id'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      currency: map['currency'] ?? 'PKR',
      description: map['description'] ?? '',
      transactionDate:
          DateTime.tryParse(map['transaction_date']?.toString() ?? '') ??
          DateTime.now(),
      invoiceNumber: map['invoice_number'],
      notes: map['notes'],
      createdAt:
          DateTime.tryParse(map['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'party_id': partyId,
      'transaction_type': transactionType,
      'transaction_id': transactionId,
      'amount': amount,
      'currency': currency,
      'description': description,
      'transaction_date': transactionDate.toIso8601String(),
      'invoice_number': invoiceNumber,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'PartyTransaction(id: $id, partyId: $partyId, transactionType: $transactionType, transactionId: $transactionId, amount: $amount, currency: $currency, description: $description, transactionDate: $transactionDate, invoiceNumber: $invoiceNumber, notes: $notes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PartyTransaction && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class PartyBalance {
  final String partyId;
  final String partyName;
  final String partyType;
  final double totalPurchases;
  final double totalSales;
  final double totalPaymentsReceived;
  final double totalPaymentsMade;
  final double openingBalance;
  final double currentBalance;
  final String currency;
  final int transactionCount;

  PartyBalance({
    required this.partyId,
    required this.partyName,
    required this.partyType,
    required this.totalPurchases,
    required this.totalSales,
    required this.totalPaymentsReceived,
    required this.totalPaymentsMade,
    required this.openingBalance,
    required this.currentBalance,
    required this.currency,
    required this.transactionCount,
  });

  factory PartyBalance.fromTransactions(
    String partyId,
    String partyName,
    String partyType,
    double openingBalance,
    String currency,
    List<PartyTransaction> transactions,
  ) {
    double totalPurchases = 0.0;
    double totalSales = 0.0;
    double totalPaymentsReceived = 0.0;
    double totalPaymentsMade = 0.0;

    for (final transaction in transactions) {
      switch (transaction.transactionType) {
        case 'purchase':
          totalPurchases += transaction.amount;
          break;
        case 'sale':
          totalSales += transaction.amount;
          break;
        case 'payment_received':
          totalPaymentsReceived += transaction.amount;
          break;
        case 'payment_made':
          totalPaymentsMade += transaction.amount;
          break;
      }
    }

    // For suppliers: balance = opening + purchases - payments_made
    // For customers: balance = opening + sales - payments_received
    double currentBalance;
    if (partyType == 'supplier') {
      currentBalance = openingBalance + totalPurchases - totalPaymentsMade;
    } else {
      currentBalance = openingBalance + totalSales - totalPaymentsReceived;
    }

    return PartyBalance(
      partyId: partyId,
      partyName: partyName,
      partyType: partyType,
      totalPurchases: totalPurchases,
      totalSales: totalSales,
      totalPaymentsReceived: totalPaymentsReceived,
      totalPaymentsMade: totalPaymentsMade,
      openingBalance: openingBalance,
      currentBalance: currentBalance,
      currency: currency,
      transactionCount: transactions.length,
    );
  }

  @override
  String toString() {
    return 'PartyBalance(partyId: $partyId, partyName: $partyName, partyType: $partyType, totalPurchases: $totalPurchases, totalSales: $totalSales, totalPaymentsReceived: $totalPaymentsReceived, totalPaymentsMade: $totalPaymentsMade, openingBalance: $openingBalance, currentBalance: $currentBalance, currency: $currency, transactionCount: $transactionCount)';
  }
}
