import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/party.dart';
import '../models/purchase.dart';
import '../models/sale.dart';
import '../models/ledger_transaction.dart';
import 'supabase_service.dart';

/// Service to handle integration between Parties, Purchases, Sales, and Ledger
class IntegrationService {
  final SupabaseService _supabaseService = SupabaseService();

  SupabaseClient get client => _supabaseService.client;
  // ============================================================================
  // PARTY-LEDGER INTEGRATION
  // ============================================================================

  /// Sync a party to the ledger persons table
  Future<void> syncPartyToLedger(Party party) async {
    try {
      // Check if person already exists in ledger
      final existingPerson = await client
          .from('persons')
          .select()
          .eq('id', party.id)
          .maybeSingle();

      if (existingPerson == null) {
        // Create new person in ledger
        await client.from('persons').insert({
          'id': party.id,
          'name': party.name,
          'opening_balance': 0.0,
          'currency': 'PKR',
          'contact_info': {
            'email': party.email,
            'phone': party.phone,
            'address': party.address,
          },
          'business_type': party.type,
          'is_active': party.isActive,
        });
      } else {
        // Update existing person
        await client
            .from('persons')
            .update({
              'name': party.name,
              'contact_info': {
                'email': party.email,
                'phone': party.phone,
                'address': party.address,
              },
              'business_type': party.type,
              'is_active': party.isActive,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', party.id);
      }
    } catch (e) {
      print('Error syncing party to ledger: $e');
      rethrow;
    }
  }

  // ============================================================================
  // PURCHASE-LEDGER INTEGRATION
  // ============================================================================

  /// Create ledger transaction when purchase is created
  Future<void> createPurchaseLedgerEntry(Purchase purchase) async {
    try {
      // Find or create supplier party by name
      final supplierParty = await _findOrCreateSupplierParty(
        purchase.supplierName,
        purchase.supplierContact,
      );

      // Create ledger transaction for purchase
      final ledgerTransaction = LedgerTransaction(
        personId: supplierParty.id,
        type: 'purchase',
        amount: purchase.totalAmount,
        description: 'Purchase: ${purchase.invoiceNumber}',
        referenceNumber: purchase.invoiceNumber,
        transactionDate: purchase.purchaseDate,
      );

      await client.from('transactions').insert(ledgerTransaction.toMap());
    } catch (e) {
      print('Error creating purchase ledger entry: $e');
      rethrow;
    }
  }

  // ============================================================================
  // SALE-LEDGER INTEGRATION
  // ============================================================================

  /// Create ledger transaction when sale is created
  Future<void> createSaleLedgerEntry(Sale sale) async {
    try {
      // Find or create customer party by name
      final customerParty = await _findOrCreateCustomerParty(
        sale.customerName,
        sale.customerContact,
      );

      // Create ledger transaction for sale
      final ledgerTransaction = LedgerTransaction(
        personId: customerParty.id,
        type: 'sale',
        amount: sale.totalAmount,
        description: 'Sale: ${sale.invoiceNumber}',
        referenceNumber: sale.invoiceNumber,
        transactionDate: sale.saleDate,
      );

      await client.from('transactions').insert(ledgerTransaction.toMap());
    } catch (e) {
      print('Error creating sale ledger entry: $e');
      rethrow;
    }
  }

  // ============================================================================
  // PAYMENT INTEGRATION
  // ============================================================================

  /// Record payment received from customer
  Future<void> recordPaymentReceived({
    required String customerId,
    required double amount,
    required String description,
    String? referenceNumber,
  }) async {
    try {
      final ledgerTransaction = LedgerTransaction(
        personId: customerId,
        type: 'payment_received',
        amount: amount,
        description: description,
        referenceNumber: referenceNumber,
        transactionDate: DateTime.now(),
      );

      await client.from('transactions').insert(ledgerTransaction.toMap());
    } catch (e) {
      print('Error recording payment received: $e');
      rethrow;
    }
  }

  /// Record payment made to supplier
  Future<void> recordPaymentMade({
    required String supplierId,
    required double amount,
    required String description,
    String? referenceNumber,
  }) async {
    try {
      final ledgerTransaction = LedgerTransaction(
        personId: supplierId,
        type: 'payment_given',
        amount: amount,
        description: description,
        referenceNumber: referenceNumber,
        transactionDate: DateTime.now(),
      );

      await client.from('transactions').insert(ledgerTransaction.toMap());
    } catch (e) {
      print('Error recording payment made: $e');
      rethrow;
    }
  }

  // ============================================================================
  // BULK SYNC OPERATIONS
  // ============================================================================

  /// Sync all existing parties to ledger
  Future<void> syncAllPartiesToLedger() async {
    try {
      final parties = await client.from('parties').select();

      for (final partyData in parties) {
        final party = Party.fromMap(partyData);
        await syncPartyToLedger(party);
      }
    } catch (e) {
      print('Error syncing all parties to ledger: $e');
      rethrow;
    }
  }

  /// Sync all existing purchases to ledger
  Future<void> syncAllPurchasesToLedger() async {
    try {
      final purchases = await client.from('purchases').select();

      for (final purchaseData in purchases) {
        final purchase = Purchase.fromMap(purchaseData);
        await createPurchaseLedgerEntry(purchase);
      }
    } catch (e) {
      print('Error syncing all purchases to ledger: $e');
      rethrow;
    }
  }

  /// Sync all existing sales to ledger
  Future<void> syncAllSalesToLedger() async {
    try {
      final sales = await client.from('sales').select();

      for (final saleData in sales) {
        final sale = Sale.fromMap(saleData);
        await createSaleLedgerEntry(sale);
      }
    } catch (e) {
      print('Error syncing all sales to ledger: $e');
      rethrow;
    }
  }

  // ============================================================================
  // INTEGRATED QUERIES
  // ============================================================================

  /// Get party with their ledger summary
  Future<Map<String, dynamic>?> getPartyWithLedgerSummary(
    String partyId,
  ) async {
    try {
      final party = await client
          .from('parties')
          .select()
          .eq('id', partyId)
          .single();

      final ledgerSummary = await client.rpc(
        'get_person_summary',
        params: {'p_person_id': partyId},
      );

      return {
        'party': party,
        'ledger_summary': ledgerSummary.isNotEmpty ? ledgerSummary[0] : null,
      };
    } catch (e) {
      print('Error getting party with ledger summary: $e');
      return null;
    }
  }

  /// Get all parties with their ledger balances
  Future<List<Map<String, dynamic>>> getAllPartiesWithBalances() async {
    try {
      final response = await client
          .from('parties_ledger_summary')
          .select()
          .order('name', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error getting parties with balances: $e');
      return [];
    }
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Check if systems are properly integrated
  Future<bool> checkIntegrationStatus() async {
    try {
      // Check if all parties exist in ledger
      final partiesResponse = await client.from('parties').select('id');

      final ledgerPersonsResponse = await client.from('persons').select('id');

      return partiesResponse.length == ledgerPersonsResponse.length;
    } catch (e) {
      print('Error checking integration status: $e');
      return false;
    }
  }

  /// Initialize integration (run once to set up the integration)
  Future<void> initializeIntegration() async {
    try {
      await syncAllPartiesToLedger();
      await syncAllPurchasesToLedger();
      await syncAllSalesToLedger();
    } catch (e) {
      print('Error initializing integration: $e');
      rethrow;
    }
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Find or create supplier party
  Future<Party> _findOrCreateSupplierParty(
    String supplierName,
    String supplierContact,
  ) async {
    try {
      // Try to find existing party
      final existingParty = await client
          .from('parties')
          .select()
          .eq('name', supplierName)
          .eq('type', 'supplier')
          .maybeSingle();

      if (existingParty != null) {
        return Party.fromMap(existingParty);
      }

      // Create new supplier party
      final newParty = Party(
        name: supplierName,
        type: 'supplier',
        email: supplierContact.contains('@') ? supplierContact : null,
        phone: supplierContact.contains('@') ? null : supplierContact,
      );

      final insertedParty = await client
          .from('parties')
          .insert(newParty.toMap())
          .select()
          .single();

      return Party.fromMap(insertedParty);
    } catch (e) {
      print('Error finding or creating supplier party: $e');
      rethrow;
    }
  }

  /// Find or create customer party
  Future<Party> _findOrCreateCustomerParty(
    String customerName,
    String customerContact,
  ) async {
    try {
      // Try to find existing party
      final existingParty = await client
          .from('parties')
          .select()
          .eq('name', customerName)
          .eq('type', 'customer')
          .maybeSingle();

      if (existingParty != null) {
        return Party.fromMap(existingParty);
      }

      // Create new customer party
      final newParty = Party(
        name: customerName,
        type: 'customer',
        email: customerContact.contains('@') ? customerContact : null,
        phone: customerContact.contains('@') ? null : customerContact,
      );

      final insertedParty = await client
          .from('parties')
          .insert(newParty.toMap())
          .select()
          .single();

      return Party.fromMap(insertedParty);
    } catch (e) {
      print('Error finding or creating customer party: $e');
      rethrow;
    }
  }
}
