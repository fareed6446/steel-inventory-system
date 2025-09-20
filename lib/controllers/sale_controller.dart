import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/sale.dart';
import '../models/stock_movement.dart';
import '../services/supabase_service.dart';

class SaleController extends GetxController {
  final SupabaseService _supabaseService = SupabaseService();

  final RxList<Sale> sales = <Sale>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxDouble totalSaleAmount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadSales();
  }

  Future<void> loadSales() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final saleList = await _supabaseService.getSales();
      sales.value = saleList.map((data) => Sale.fromMap(data)).toList();

      // Calculate total amount
      totalSaleAmount.value = sales.fold(
        0.0,
        (sum, sale) => sum + sale.totalAmount,
      );
    } catch (e) {
      errorMessage.value = 'Error loading sales: $e';
      print('Error loading sales: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadSalesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final saleList = await _supabaseService.getSalesByDateRange(
        startDate,
        endDate,
      );
      sales.value = saleList.map((data) => Sale.fromMap(data)).toList();

      // Calculate total amount
      totalSaleAmount.value = sales.fold(
        0.0,
        (sum, sale) => sum + sale.totalAmount,
      );
    } catch (e) {
      errorMessage.value = 'Error loading sales: $e';
      print('Error loading sales: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addSale(Sale sale) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final saleData = sale.toMap();
      await _supabaseService.insertSale(saleData);

      // Reload sales to get updated list
      await loadSales();
      return true;
    } catch (e) {
      errorMessage.value = 'Error adding sale: $e';
      print('Error adding sale: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateSale(Sale sale) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final saleData = sale.toMap();
      await _supabaseService.updateSale(sale.id, saleData);

      // Reload sales to get updated list
      await loadSales();
      return true;
    } catch (e) {
      errorMessage.value = 'Error updating sale: $e';
      print('Error updating sale: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteSale(String saleId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _supabaseService.deleteSale(saleId);

      // Reload sales to get updated list
      await loadSales();
      return true;
    } catch (e) {
      errorMessage.value = 'Error deleting sale: $e';
      print('Error deleting sale: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void clearError() {
    errorMessage.value = '';
  }

  // Helper methods
  List<Sale> getSalesByCustomer(String customerName) {
    return sales.where((sale) => sale.customerName == customerName).toList();
  }

  List<Sale> getSalesByDate(DateTime date) {
    return sales
        .where(
          (sale) =>
              sale.saleDate.year == date.year &&
              sale.saleDate.month == date.month &&
              sale.saleDate.day == date.day,
        )
        .toList();
  }
}
