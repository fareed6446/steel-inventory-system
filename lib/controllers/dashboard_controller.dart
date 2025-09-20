import 'package:get/get.dart';
import '../services/supabase_service.dart';

class DashboardController extends GetxController {
  final SupabaseService _supabaseService = SupabaseService();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Dashboard metrics
  final RxDouble totalRevenue = 0.0.obs;
  final RxDouble totalExpenses = 0.0.obs;
  final RxDouble totalProfit = 0.0.obs;
  final RxInt totalProducts = 0.obs;
  final RxInt lowStockItems = 0.obs;
  final RxInt overstockItems = 0.obs;
  final RxDouble totalStockValue = 0.0.obs;

  // Chart data
  final RxMap<String, double> dailyRevenue = <String, double>{}.obs;
  final RxMap<String, double> dailyExpenses = <String, double>{}.obs;
  final RxMap<String, double> stockLevels = <String, double>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Load sales data
      final sales = await _supabaseService.getSales();
      totalRevenue.value = sales.fold(
        0.0,
        (sum, sale) => sum + (sale['total_amount'] as num).toDouble(),
      );

      // Load purchases data
      final purchases = await _supabaseService.getPurchases();
      totalExpenses.value = purchases.fold(
        0.0,
        (sum, purchase) => sum + (purchase['total_amount'] as num).toDouble(),
      );

      // Calculate profit
      totalProfit.value = totalRevenue.value - totalExpenses.value;

      // Load products count
      final products = await _supabaseService.getProducts();
      totalProducts.value = products.length;

      // Load stock data
      final stock = await _supabaseService.getStock();
      totalStockValue.value = stock.fold(
        0.0,
        (sum, item) => sum + (item['current_quantity'] as num).toDouble(),
      );

      // Calculate low stock items
      lowStockItems.value = stock
          .where(
            (item) =>
                (item['available_quantity'] as num).toDouble() <=
                (item['minimum_stock_level'] as num).toDouble(),
          )
          .length;

      // Calculate overstock items
      overstockItems.value = stock
          .where(
            (item) =>
                (item['available_quantity'] as num).toDouble() >=
                (item['maximum_stock_level'] as num).toDouble(),
          )
          .length;

      // Load chart data for last 7 days
      await _loadChartData();
    } catch (e) {
      errorMessage.value = 'Error loading dashboard data: $e';
      print('Error loading dashboard data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadChartData() async {
    try {
      final now = DateTime.now();
      final startDate = now.subtract(const Duration(days: 7));

      // Load revenue data
      final revenueData = await _supabaseService.getTotalSalesByDateRange(
        startDate,
        now,
      );
      dailyRevenue.clear();
      for (var data in revenueData) {
        dailyRevenue[data['date'].toString()] = (data['total'] as num)
            .toDouble();
      }

      // Load expense data
      final expenseData = await _supabaseService.getTotalPurchasesByDateRange(
        startDate,
        now,
      );
      dailyExpenses.clear();
      for (var data in expenseData) {
        dailyExpenses[data['date'].toString()] = (data['total'] as num)
            .toDouble();
      }

      // Load stock levels
      final stock = await _supabaseService.getStock();
      stockLevels.clear();
      for (var item in stock) {
        stockLevels[item['product_id'].toString()] =
            (item['available_quantity'] as num).toDouble();
      }
    } catch (e) {
      print('Error loading chart data: $e');
    }
  }

  Future<void> refreshData() async {
    await loadDashboardData();
  }

  void clearError() {
    errorMessage.value = '';
  }

  // Helper methods
  double get profitMargin {
    if (totalRevenue.value == 0) return 0.0;
    return (totalProfit.value / totalRevenue.value) * 100;
  }

  bool get hasLowStock {
    return lowStockItems.value > 0;
  }

  bool get hasOverstock {
    return overstockItems.value > 0;
  }
}
