import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/ledger_person.dart';
import '../models/ledger_transaction.dart';
import 'supabase_service.dart';

/// Extended Supabase service for Ledger operations
/// This service handles all database operations related to the ledger system
class LedgerService {
  final SupabaseService _supabaseService = SupabaseService();

  SupabaseClient get client => _supabaseService.client;
  // ============================================================================
  // PERSONS OPERATIONS
  // ============================================================================

  /// Get all persons with their summary information
  Future<List<PersonSummary>> getAllPersonsSummary() async {
    try {
      final response = await client
          .from('persons_summary')
          .select()
          .order('name', ascending: true);

      return (response as List)
          .map((data) => PersonSummary.fromMap(data))
          .toList();
    } catch (e) {
      print('Error getting persons summary: $e');
      rethrow;
    }
  }

  /// Get all persons (basic information)
  Future<List<LedgerPerson>> getAllPersons() async {
    try {
      final response = await client
          .from('persons')
          .select()
          .eq('is_active', true)
          .order('name', ascending: true);

      return (response as List)
          .map((data) => LedgerPerson.fromMap(data))
          .toList();
    } catch (e) {
      print('Error getting persons: $e');
      rethrow;
    }
  }

  /// Get a specific person by ID
  Future<LedgerPerson?> getPersonById(String personId) async {
    try {
      final response = await client
          .from('persons')
          .select()
          .eq('id', personId)
          .maybeSingle();

      return response != null ? LedgerPerson.fromMap(response) : null;
    } catch (e) {
      print('Error getting person by ID: $e');
      return null;
    }
  }

  /// Add a new person
  Future<void> addPerson(LedgerPerson person) async {
    try {
      await client.from('persons').insert(person.toMap());
    } catch (e) {
      print('Error adding person: $e');
      rethrow;
    }
  }

  /// Update an existing person
  Future<void> updatePerson(String personId, LedgerPerson person) async {
    try {
      await client.from('persons').update(person.toMap()).eq('id', personId);
    } catch (e) {
      print('Error updating person: $e');
      rethrow;
    }
  }

  /// Delete a person (soft delete by setting is_active to false)
  Future<void> deletePerson(String personId) async {
    try {
      await client
          .from('persons')
          .update({
            'is_active': false,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', personId);
    } catch (e) {
      print('Error deleting person: $e');
      rethrow;
    }
  }

  // ============================================================================
  // TRANSACTIONS OPERATIONS
  // ============================================================================

  /// Get all transactions for a specific person
  Future<List<LedgerTransaction>> getTransactionsByPersonId(
    String personId,
  ) async {
    try {
      final response = await client
          .from('transactions')
          .select()
          .eq('person_id', personId)
          .order('transaction_date', ascending: true)
          .order('created_at', ascending: true);

      return (response as List)
          .map((data) => LedgerTransaction.fromMap(data))
          .toList();
    } catch (e) {
      print('Error getting transactions by person ID: $e');
      rethrow;
    }
  }

  /// Add a new transaction
  Future<void> addTransaction(LedgerTransaction transaction) async {
    try {
      await client.from('transactions').insert(transaction.toMap());
    } catch (e) {
      print('Error adding transaction: $e');
      rethrow;
    }
  }

  /// Update an existing transaction
  Future<void> updateTransaction(
    String transactionId,
    LedgerTransaction transaction,
  ) async {
    try {
      await client
          .from('transactions')
          .update(transaction.toMap())
          .eq('id', transactionId);
    } catch (e) {
      print('Error updating transaction: $e');
      rethrow;
    }
  }

  /// Delete a transaction
  Future<void> deleteTransaction(String transactionId) async {
    try {
      await client.from('transactions').delete().eq('id', transactionId);
    } catch (e) {
      print('Error deleting transaction: $e');
      rethrow;
    }
  }

  // ============================================================================
  // LEDGER OPERATIONS
  // ============================================================================

  /// Get detailed ledger entries for a specific person
  Future<List<LedgerEntry>> getLedgerEntriesByPersonId(String personId) async {
    try {
      final response = await client
          .from('ledger_detailed')
          .select()
          .eq('person_id', personId)
          .order('created_at', ascending: true);

      return (response as List)
          .map((data) => LedgerEntry.fromMap(data))
          .toList();
    } catch (e) {
      print('Error getting ledger entries by person ID: $e');
      rethrow;
    }
  }

  /// Get person summary with calculated totals
  Future<PersonSummary?> getPersonSummary(String personId) async {
    try {
      final response = await client.rpc(
        'get_person_summary',
        params: {'p_person_id': personId},
      );

      if (response != null && response.isNotEmpty) {
        // The RPC function returns a single row, so we take the first element
        final summaryData = response[0];
        return PersonSummary.fromMap({
          'id': personId,
          'name': '', // We'll need to get this separately
          'business_type': '',
          'is_active': true,
          'created_at': DateTime.now().toIso8601String(),
          ...summaryData,
        });
      }
      return null;
    } catch (e) {
      print('Error getting person summary: $e');
      return null;
    }
  }

  /// Get complete person summary (including name and other details)
  Future<PersonSummary?> getCompletePersonSummary(String personId) async {
    try {
      // First get the basic person info
      final person = await getPersonById(personId);
      if (person == null) return null;

      // Then get the calculated summary
      final summary = await getPersonSummary(personId);
      if (summary == null) return null;

      // Combine the data
      return PersonSummary.fromMap({
        'id': personId,
        'name': person.name,
        'business_type': person.businessType,
        'is_active': person.isActive,
        'created_at': person.createdAt.toIso8601String(),
        'opening_balance': summary.openingBalance,
        'total_sales': summary.totalSales,
        'total_purchases': summary.totalPurchases,
        'total_payments_received': summary.totalPaymentsReceived,
        'total_payments_given': summary.totalPaymentsGiven,
        'remaining_balance': summary.remainingBalance,
        'transaction_count': summary.transactionCount,
      });
    } catch (e) {
      print('Error getting complete person summary: $e');
      return null;
    }
  }

  // ============================================================================
  // SEARCH AND FILTER OPERATIONS
  // ============================================================================

  /// Search persons by name
  Future<List<PersonSummary>> searchPersonsByName(String query) async {
    try {
      final response = await client
          .from('persons_summary')
          .select()
          .ilike('name', '%$query%')
          .order('name', ascending: true);

      return (response as List)
          .map((data) => PersonSummary.fromMap(data))
          .toList();
    } catch (e) {
      print('Error searching persons by name: $e');
      rethrow;
    }
  }

  /// Filter persons by business type
  Future<List<PersonSummary>> filterPersonsByType(String businessType) async {
    try {
      final response = await client
          .from('persons_summary')
          .select()
          .eq('business_type', businessType)
          .order('name', ascending: true);

      return (response as List)
          .map((data) => PersonSummary.fromMap(data))
          .toList();
    } catch (e) {
      print('Error filtering persons by type: $e');
      rethrow;
    }
  }

  /// Get transactions within a date range for a person
  Future<List<LedgerEntry>> getLedgerEntriesByDateRange(
    String personId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final response = await client
          .from('ledger_detailed')
          .select()
          .eq('person_id', personId)
          .gte('created_at', startDate.toIso8601String())
          .lte('created_at', endDate.toIso8601String())
          .order('created_at', ascending: true);

      return (response as List)
          .map((data) => LedgerEntry.fromMap(data))
          .toList();
    } catch (e) {
      print('Error getting ledger entries by date range: $e');
      rethrow;
    }
  }

  // ============================================================================
  // ANALYTICS OPERATIONS
  // ============================================================================

  /// Get top customers by total sales
  Future<List<PersonSummary>> getTopCustomersBySales({int limit = 10}) async {
    try {
      final response = await client
          .from('persons_summary')
          .select()
          .eq('business_type', 'customer')
          .order('total_sales', ascending: false)
          .limit(limit);

      return (response as List)
          .map((data) => PersonSummary.fromMap(data))
          .toList();
    } catch (e) {
      print('Error getting top customers by sales: $e');
      rethrow;
    }
  }

  /// Get top suppliers by total purchases
  Future<List<PersonSummary>> getTopSuppliersByPurchases({
    int limit = 10,
  }) async {
    try {
      final response = await client
          .from('persons_summary')
          .select()
          .eq('business_type', 'supplier')
          .order('total_purchases', ascending: false)
          .limit(limit);

      return (response as List)
          .map((data) => PersonSummary.fromMap(data))
          .toList();
    } catch (e) {
      print('Error getting top suppliers by purchases: $e');
      rethrow;
    }
  }

  /// Get persons with outstanding balances
  Future<List<PersonSummary>> getPersonsWithOutstandingBalances() async {
    try {
      final response = await client
          .from('persons_summary')
          .select()
          .neq('remaining_balance', 0)
          .order('remaining_balance', ascending: false);

      return (response as List)
          .map((data) => PersonSummary.fromMap(data))
          .toList();
    } catch (e) {
      print('Error getting persons with outstanding balances: $e');
      rethrow;
    }
  }

  // ============================================================================
  // VALIDATION HELPERS
  // ============================================================================

  /// Validate if a person exists and is active
  Future<bool> isPersonActive(String personId) async {
    try {
      final response = await client
          .from('persons')
          .select('is_active')
          .eq('id', personId)
          .maybeSingle();

      return response != null && response['is_active'] == true;
    } catch (e) {
      print('Error checking if person is active: $e');
      return false;
    }
  }

  /// Validate transaction type
  bool isValidTransactionType(String type) {
    return [
      'sale',
      'purchase',
      'payment_received',
      'payment_given',
    ].contains(type);
  }

  /// Validate transaction amount
  bool isValidTransactionAmount(double amount) {
    return amount > 0;
  }
}
