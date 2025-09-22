import 'package:get/get.dart';
import '../models/ledger_person.dart';
import '../models/ledger_transaction.dart';
import '../services/ledger_service.dart';

/// LedgerController - Manages all ledger-related business logic
/// Handles person management, transaction tracking, and ledger calculations
class LedgerController extends GetxController {
  final LedgerService _ledgerService = LedgerService();

  // ============================================================================
  // OBSERVABLE STATE
  // ============================================================================

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isLoadingPersons = false.obs;
  final RxBool isLoadingTransactions = false.obs;
  final RxBool isLoadingSummary = false.obs;

  // Error handling
  final RxString errorMessage = ''.obs;

  // Data lists
  final RxList<PersonSummary> allPersons = <PersonSummary>[].obs;
  final RxList<LedgerEntry> currentPersonTransactions = <LedgerEntry>[].obs;
  final RxList<PersonSummary> filteredPersons = <PersonSummary>[].obs;

  // Current selection
  final Rx<PersonSummary?> selectedPerson = Rx<PersonSummary?>(null);
  final Rx<PersonSummary?> currentPersonSummary = Rx<PersonSummary?>(null);

  // Search and filter
  final RxString searchQuery = ''.obs;
  final RxString selectedBusinessType = 'all'.obs;

  // ============================================================================
  // INITIALIZATION
  // ============================================================================

  @override
  void onInit() {
    super.onInit();
    loadAllPersons();
  }

  // ============================================================================
  // PERSONS MANAGEMENT
  // ============================================================================

  /// Load all persons with their summary information
  Future<void> loadAllPersons() async {
    try {
      isLoadingPersons.value = true;
      errorMessage.value = '';

      final persons = await _ledgerService.getAllPersonsSummary();
      allPersons.value = persons;
      filteredPersons.value = persons;

      // If no person is selected and we have persons, select the first one
      if (selectedPerson.value == null && persons.isNotEmpty) {
        selectPerson(persons.first);
      }
    } catch (e) {
      errorMessage.value = 'Error loading persons: $e';
      print('Error loading persons: $e');
    } finally {
      isLoadingPersons.value = false;
    }
  }

  /// Refresh all data
  Future<void> refreshAllData() async {
    await loadAllPersons();
    if (selectedPerson.value != null) {
      await loadPersonTransactions(selectedPerson.value!.id);
      await loadPersonSummary(selectedPerson.value!.id);
    }
  }

  /// Add a new person
  Future<bool> addPerson(LedgerPerson person) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _ledgerService.addPerson(person);
      await loadAllPersons(); // Refresh the list

      Get.snackbar(
        'Success',
        'Person added successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
      );

      return true;
    } catch (e) {
      errorMessage.value = 'Error adding person: $e';
      print('Error adding person: $e');

      Get.snackbar(
        'Error',
        'Failed to add person: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update an existing person
  Future<bool> updatePerson(String personId, LedgerPerson person) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _ledgerService.updatePerson(personId, person);
      await loadAllPersons(); // Refresh the list

      Get.snackbar(
        'Success',
        'Person updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
      );

      return true;
    } catch (e) {
      errorMessage.value = 'Error updating person: $e';
      print('Error updating person: $e');

      Get.snackbar(
        'Error',
        'Failed to update person: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete a person
  Future<bool> deletePerson(String personId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _ledgerService.deletePerson(personId);
      await loadAllPersons(); // Refresh the list

      // If the deleted person was selected, clear selection
      if (selectedPerson.value?.id == personId) {
        selectedPerson.value = null;
        currentPersonSummary.value = null;
        currentPersonTransactions.clear();
      }

      Get.snackbar(
        'Success',
        'Person deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
      );

      return true;
    } catch (e) {
      errorMessage.value = 'Error deleting person: $e';
      print('Error deleting person: $e');

      Get.snackbar(
        'Error',
        'Failed to delete person: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================================
  // PERSON SELECTION AND TRANSACTION LOADING
  // ============================================================================

  /// Select a person and load their data
  Future<void> selectPerson(PersonSummary person) async {
    try {
      selectedPerson.value = person;

      // Load transactions and summary in parallel
      await Future.wait([
        loadPersonTransactions(person.id),
        loadPersonSummary(person.id),
      ]);
    } catch (e) {
      errorMessage.value = 'Error selecting person: $e';
      print('Error selecting person: $e');
    }
  }

  /// Load transactions for the selected person
  Future<void> loadPersonTransactions(String personId) async {
    try {
      isLoadingTransactions.value = true;
      errorMessage.value = '';

      final transactions = await _ledgerService.getLedgerEntriesByPersonId(
        personId,
      );
      currentPersonTransactions.value = transactions;
    } catch (e) {
      errorMessage.value = 'Error loading transactions: $e';
      print('Error loading transactions: $e');
    } finally {
      isLoadingTransactions.value = false;
    }
  }

  /// Load summary for the selected person
  Future<void> loadPersonSummary(String personId) async {
    try {
      isLoadingSummary.value = true;
      errorMessage.value = '';

      final summary = await _ledgerService.getCompletePersonSummary(personId);
      currentPersonSummary.value = summary;
    } catch (e) {
      errorMessage.value = 'Error loading summary: $e';
      print('Error loading summary: $e');
    } finally {
      isLoadingSummary.value = false;
    }
  }

  // ============================================================================
  // TRANSACTION MANAGEMENT
  // ============================================================================

  /// Add a new transaction
  Future<bool> addTransaction(LedgerTransaction transaction) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Validate transaction
      if (!_ledgerService.isValidTransactionType(transaction.type)) {
        errorMessage.value = 'Invalid transaction type';
        return false;
      }

      if (!_ledgerService.isValidTransactionAmount(transaction.amount)) {
        errorMessage.value = 'Invalid transaction amount';
        return false;
      }

      await _ledgerService.addTransaction(transaction);

      // Refresh current person's data
      if (selectedPerson.value != null) {
        await Future.wait([
          loadPersonTransactions(selectedPerson.value!.id),
          loadPersonSummary(selectedPerson.value!.id),
        ]);
      }

      Get.snackbar(
        'Success',
        'Transaction added successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
      );

      return true;
    } catch (e) {
      errorMessage.value = 'Error adding transaction: $e';
      print('Error adding transaction: $e');

      Get.snackbar(
        'Error',
        'Failed to add transaction: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update an existing transaction
  Future<bool> updateTransaction(
    String transactionId,
    LedgerTransaction transaction,
  ) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _ledgerService.updateTransaction(transactionId, transaction);

      // Refresh current person's data
      if (selectedPerson.value != null) {
        await Future.wait([
          loadPersonTransactions(selectedPerson.value!.id),
          loadPersonSummary(selectedPerson.value!.id),
        ]);
      }

      Get.snackbar(
        'Success',
        'Transaction updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
      );

      return true;
    } catch (e) {
      errorMessage.value = 'Error updating transaction: $e';
      print('Error updating transaction: $e');

      Get.snackbar(
        'Error',
        'Failed to update transaction: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete a transaction
  Future<bool> deleteTransaction(String transactionId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _ledgerService.deleteTransaction(transactionId);

      // Refresh current person's data
      if (selectedPerson.value != null) {
        await Future.wait([
          loadPersonTransactions(selectedPerson.value!.id),
          loadPersonSummary(selectedPerson.value!.id),
        ]);
      }

      Get.snackbar(
        'Success',
        'Transaction deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
      );

      return true;
    } catch (e) {
      errorMessage.value = 'Error deleting transaction: $e';
      print('Error deleting transaction: $e');

      Get.snackbar(
        'Error',
        'Failed to delete transaction: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================================
  // SEARCH AND FILTER
  // ============================================================================

  /// Set search query and filter persons
  void setSearchQuery(String query) {
    searchQuery.value = query;
    _filterPersons();
  }

  /// Set business type filter and filter persons
  void setBusinessTypeFilter(String businessType) {
    selectedBusinessType.value = businessType;
    _filterPersons();
  }

  /// Filter persons based on search query and business type
  void _filterPersons() {
    List<PersonSummary> filtered = allPersons;

    // Apply business type filter
    if (selectedBusinessType.value != 'all') {
      filtered = filtered
          .where((person) => person.businessType == selectedBusinessType.value)
          .toList();
    }

    // Apply search query filter
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered
          .where((person) => person.name.toLowerCase().contains(query))
          .toList();
    }

    filteredPersons.value = filtered;
  }

  // ============================================================================
  // ANALYTICS AND REPORTS
  // ============================================================================

  /// Get top customers by sales
  Future<List<PersonSummary>> getTopCustomersBySales({int limit = 10}) async {
    try {
      return await _ledgerService.getTopCustomersBySales(limit: limit);
    } catch (e) {
      print('Error getting top customers by sales: $e');
      return [];
    }
  }

  /// Get top suppliers by purchases
  Future<List<PersonSummary>> getTopSuppliersByPurchases({
    int limit = 10,
  }) async {
    try {
      return await _ledgerService.getTopSuppliersByPurchases(limit: limit);
    } catch (e) {
      print('Error getting top suppliers by purchases: $e');
      return [];
    }
  }

  /// Get persons with outstanding balances
  Future<List<PersonSummary>> getPersonsWithOutstandingBalances() async {
    try {
      return await _ledgerService.getPersonsWithOutstandingBalances();
    } catch (e) {
      print('Error getting persons with outstanding balances: $e');
      return [];
    }
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Clear error message
  void clearError() {
    errorMessage.value = '';
  }

  /// Check if data is loading
  bool get isAnyLoading =>
      isLoading.value ||
      isLoadingPersons.value ||
      isLoadingTransactions.value ||
      isLoadingSummary.value;

  /// Get current person's transaction count
  int get currentPersonTransactionCount => currentPersonTransactions.length;

  /// Check if a person is selected
  bool get hasSelectedPerson => selectedPerson.value != null;

  /// Get filtered persons count
  int get filteredPersonsCount => filteredPersons.length;

  /// Get total persons count
  int get totalPersonsCount => allPersons.length;

  /// Get total outstanding balance (sum of all positive balances)
  double get totalOutstandingBalance {
    return allPersons
        .where((person) => person.remainingBalance > 0)
        .fold(0.0, (sum, person) => sum + person.remainingBalance);
  }

  /// Get total debt (sum of all negative balances)
  double get totalDebt {
    return allPersons
        .where((person) => person.remainingBalance < 0)
        .fold(0.0, (sum, person) => sum + person.remainingBalance.abs());
  }
}
