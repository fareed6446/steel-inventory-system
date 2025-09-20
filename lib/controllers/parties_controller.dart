import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/party.dart';
import '../models/purchase.dart';
import '../models/sale.dart';
import '../services/supabase_service.dart';

class PartiesController extends GetxController {
  final SupabaseService _supabaseService = SupabaseService();

  final RxList<Party> parties = <Party>[].obs;
  final RxList<PartyTransaction> transactions = <PartyTransaction>[].obs;
  final RxList<PartyBalance> balances = <PartyBalance>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedPartyType = 'all'.obs; // 'all', 'supplier', 'customer'
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadParties();
  }

  Future<void> loadParties() async {
    try {
      isLoading.value = true;

      // Load parties from Supabase
      final response = await _supabaseService.client
          .from('parties')
          .select()
          .order('name');

      parties.clear();
      for (final item in response) {
        parties.add(Party.fromMap(item));
      }

      // Load transactions
      await loadTransactions();

      // Calculate balances
      await calculateBalances();
    } catch (e) {
      print('Error loading parties: $e');
      Get.snackbar(
        'Error',
        'Failed to load parties: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadTransactions() async {
    try {
      final response = await _supabaseService.client
          .from('party_transactions')
          .select()
          .order('transaction_date', ascending: false);

      transactions.clear();
      for (final item in response) {
        transactions.add(PartyTransaction.fromMap(item));
      }
    } catch (e) {
      print('Error loading transactions: $e');
    }
  }

  Future<void> calculateBalances() async {
    try {
      balances.clear();

      for (final party in parties) {
        final partyTransactions = transactions
            .where((t) => t.partyId == party.id)
            .toList();

        final balance = PartyBalance.fromTransactions(
          party.id,
          party.name,
          party.type,
          party.openingBalance,
          party.currency,
          partyTransactions,
        );

        balances.add(balance);
      }
    } catch (e) {
      print('Error calculating balances: $e');
    }
  }

  Future<void> addParty(Party party) async {
    try {
      isLoading.value = true;

      final response = await _supabaseService.client
          .from('parties')
          .insert(party.toMap())
          .select()
          .single();

      final newParty = Party.fromMap(response);
      parties.add(newParty);

      // Create opening balance transaction if needed
      if (party.openingBalance != 0) {
        await addOpeningBalanceTransaction(newParty);
      }

      await loadTransactions();
      await calculateBalances();

      Get.snackbar(
        'Success',
        'Party added successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error adding party: $e');
      Get.snackbar(
        'Error',
        'Failed to add party: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateParty(Party party) async {
    try {
      isLoading.value = true;

      final updatedData = party.toMap();
      updatedData['updated_at'] = DateTime.now().toIso8601String();

      await _supabaseService.client
          .from('parties')
          .update(updatedData)
          .eq('id', party.id);

      final index = parties.indexWhere((p) => p.id == party.id);
      if (index != -1) {
        parties[index] = party;
      }

      await loadTransactions();
      await calculateBalances();

      Get.snackbar(
        'Success',
        'Party updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error updating party: $e');
      Get.snackbar(
        'Error',
        'Failed to update party: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteParty(String partyId) async {
    try {
      isLoading.value = true;

      // Delete related transactions first
      await _supabaseService.client
          .from('party_transactions')
          .delete()
          .eq('party_id', partyId);

      // Delete party
      await _supabaseService.client.from('parties').delete().eq('id', partyId);

      parties.removeWhere((p) => p.id == partyId);
      transactions.removeWhere((t) => t.partyId == partyId);
      balances.removeWhere((b) => b.partyId == partyId);

      Get.snackbar(
        'Success',
        'Party deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error deleting party: $e');
      Get.snackbar(
        'Error',
        'Failed to delete party: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addOpeningBalanceTransaction(Party party) async {
    try {
      final transaction = PartyTransaction(
        partyId: party.id,
        transactionType: party.openingBalance > 0
            ? 'payment_received'
            : 'payment_made',
        transactionId: 'opening_balance',
        amount: party.openingBalance.abs(),
        currency: party.currency,
        description: 'Opening Balance',
        transactionDate: party.createdAt,
        invoiceNumber: 'OB-${party.id.substring(0, 8)}',
        notes: 'Opening balance for ${party.name}',
      );

      await _supabaseService.client
          .from('party_transactions')
          .insert(transaction.toMap());
    } catch (e) {
      print('Error adding opening balance transaction: $e');
    }
  }

  Future<void> addTransactionFromPurchase(Purchase purchase) async {
    try {
      // Find or create party for supplier
      Party? party = parties.firstWhereOrNull(
        (p) => p.name == purchase.supplierName,
      );

      if (party == null) {
        // Create new supplier party
        party = Party(
          name: purchase.supplierName,
          type: 'supplier',
          currency: 'PKR',
        );
        await addParty(party);
      }

      // Get product details for better description
      String productDescription = 'Product ID: ${purchase.productId}';
      try {
        final productResponse = await _supabaseService.client
            .from('products')
            .select('name, unit')
            .eq('id', purchase.productId)
            .single();

        productDescription =
            '${productResponse['name']} (${productResponse['unit']})';
      } catch (e) {
        print('Error fetching product details: $e');
      }

      final transaction = PartyTransaction(
        partyId: party.id,
        transactionType: 'purchase',
        transactionId: purchase.id,
        amount: purchase.totalAmount,
        currency: 'PKR',
        description: 'Purchase - $productDescription',
        transactionDate: purchase.purchaseDate,
        invoiceNumber: purchase.invoiceNumber,
        notes:
            'Quantity: ${purchase.quantity}, Unit Price: PKR ${purchase.unitPrice}',
      );

      await _supabaseService.client
          .from('party_transactions')
          .insert(transaction.toMap());

      await loadTransactions();
      await calculateBalances();
    } catch (e) {
      print('Error adding transaction from purchase: $e');
    }
  }

  Future<void> addTransactionFromSale(Sale sale) async {
    try {
      // Find or create party for customer
      Party? party = parties.firstWhereOrNull(
        (p) => p.name == sale.customerName,
      );

      if (party == null) {
        // Create new customer party
        party = Party(
          name: sale.customerName,
          type: 'customer',
          currency: 'PKR',
        );
        await addParty(party);
      }

      // Get product details for better description
      String productDescription = 'Product ID: ${sale.productId}';
      try {
        final productResponse = await _supabaseService.client
            .from('products')
            .select('name, unit')
            .eq('id', sale.productId)
            .single();

        productDescription =
            '${productResponse['name']} (${productResponse['unit']})';
      } catch (e) {
        print('Error fetching product details: $e');
      }

      final transaction = PartyTransaction(
        partyId: party.id,
        transactionType: 'sale',
        transactionId: sale.id,
        amount: sale.totalAmount,
        currency: 'PKR',
        description: 'Sale - $productDescription',
        transactionDate: sale.saleDate,
        invoiceNumber: sale.invoiceNumber,
        notes: 'Quantity: ${sale.quantity}, Unit Price: PKR ${sale.unitPrice}',
      );

      await _supabaseService.client
          .from('party_transactions')
          .insert(transaction.toMap());

      await loadTransactions();
      await calculateBalances();
    } catch (e) {
      print('Error adding transaction from sale: $e');
    }
  }

  Future<void> addPaymentTransaction({
    required String partyId,
    required double amount,
    required String type, // 'payment_received' or 'payment_made'
    required String description,
    String? invoiceNumber,
    String? notes,
  }) async {
    try {
      final transaction = PartyTransaction(
        partyId: partyId,
        transactionType: type,
        transactionId: const Uuid().v4(),
        amount: amount,
        currency: 'PKR',
        description: description,
        transactionDate: DateTime.now(),
        invoiceNumber: invoiceNumber,
        notes: notes,
      );

      await _supabaseService.client
          .from('party_transactions')
          .insert(transaction.toMap());

      await loadTransactions();
      await calculateBalances();

      Get.snackbar(
        'Success',
        'Payment transaction added successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error adding payment transaction: $e');
      Get.snackbar(
        'Error',
        'Failed to add payment transaction: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  List<Party> get filteredParties {
    List<Party> filtered = parties;

    // Filter by type
    if (selectedPartyType.value != 'all') {
      filtered = filtered
          .where((p) => p.type == selectedPartyType.value)
          .toList();
    }

    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered
          .where(
            (p) =>
                p.name.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ||
                (p.email?.toLowerCase().contains(
                      searchQuery.value.toLowerCase(),
                    ) ??
                    false) ||
                (p.phone?.contains(searchQuery.value) ?? false),
          )
          .toList();
    }

    return filtered;
  }

  List<PartyTransaction> getTransactionsForParty(String partyId) {
    return transactions.where((t) => t.partyId == partyId).toList();
  }

  PartyBalance? getBalanceForParty(String partyId) {
    try {
      return balances.firstWhere((b) => b.partyId == partyId);
    } catch (e) {
      return null;
    }
  }

  double get totalSuppliersBalance {
    return balances
        .where((b) => b.partyType == 'supplier')
        .fold(0.0, (sum, balance) => sum + balance.currentBalance);
  }

  double get totalCustomersBalance {
    return balances
        .where((b) => b.partyType == 'customer')
        .fold(0.0, (sum, balance) => sum + balance.currentBalance);
  }

  int get suppliersCount {
    return parties.where((p) => p.type == 'supplier').length;
  }

  int get customersCount {
    return parties.where((p) => p.type == 'customer').length;
  }

  void setPartyTypeFilter(String type) {
    selectedPartyType.value = type;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }
}
