import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/purchase.dart';
import '../models/stock_movement.dart';
import '../services/supabase_service.dart';

class PurchaseController extends GetxController {
  final SupabaseService _supabaseService = SupabaseService();

  final RxList<Purchase> purchases = <Purchase>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxDouble totalPurchaseAmount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadPurchases();
  }

  Future<void> loadPurchases() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final purchaseList = await _supabaseService.getPurchases();
      purchases.value = purchaseList
          .map((data) => Purchase.fromMap(data))
          .toList();

      // Calculate total amount
      totalPurchaseAmount.value = purchases.fold(
        0.0,
        (sum, purchase) => sum + purchase.totalAmount,
      );
    } catch (e) {
      errorMessage.value = 'Error loading purchases: $e';
      print('Error loading purchases: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadPurchasesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final purchaseList = await _supabaseService.getPurchasesByDateRange(
        startDate,
        endDate,
      );
      purchases.value = purchaseList
          .map((data) => Purchase.fromMap(data))
          .toList();

      // Calculate total amount
      totalPurchaseAmount.value = purchases.fold(
        0.0,
        (sum, purchase) => sum + purchase.totalAmount,
      );
    } catch (e) {
      errorMessage.value = 'Error loading purchases: $e';
      print('Error loading purchases: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addPurchase(Purchase purchase) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final purchaseData = purchase.toMap();
      await _supabaseService.insertPurchase(purchaseData);

      // Reload purchases to get updated list
      await loadPurchases();
      return true;
    } catch (e) {
      errorMessage.value = 'Error adding purchase: $e';
      print('Error adding purchase: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updatePurchase(Purchase purchase) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final purchaseData = purchase.toMap();
      await _supabaseService.updatePurchase(purchase.id, purchaseData);

      // Reload purchases to get updated list
      await loadPurchases();
      return true;
    } catch (e) {
      errorMessage.value = 'Error updating purchase: $e';
      print('Error updating purchase: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deletePurchase(String purchaseId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _supabaseService.deletePurchase(purchaseId);

      // Reload purchases to get updated list
      await loadPurchases();
      return true;
    } catch (e) {
      errorMessage.value = 'Error deleting purchase: $e';
      print('Error deleting purchase: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void clearError() {
    errorMessage.value = '';
  }

  // Helper methods
  List<Purchase> getPurchasesBySupplier(String supplierName) {
    return purchases
        .where((purchase) => purchase.supplierName == supplierName)
        .toList();
  }

  List<Purchase> getPurchasesByDate(DateTime date) {
    return purchases
        .where(
          (purchase) =>
              purchase.purchaseDate.year == date.year &&
              purchase.purchaseDate.month == date.month &&
              purchase.purchaseDate.day == date.day,
        )
        .toList();
  }
}
