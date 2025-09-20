import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/stock.dart';
import '../models/stock_movement.dart';
import '../services/supabase_service.dart';

class StockController extends GetxController {
  final SupabaseService _supabaseService = SupabaseService();

  final RxList<Stock> stockItems = <Stock>[].obs;
  final RxList<StockMovement> stockMovements = <StockMovement>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt lowStockCount = 0.obs;
  final RxInt overstockCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadStock();
    loadStockMovements();
  }

  Future<void> loadStock() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final stockList = await _supabaseService.getStock();
      stockItems.value = stockList.map((data) => Stock.fromMap(data)).toList();

      // Calculate low stock and overstock counts
      _calculateStockAlerts();
    } catch (e) {
      errorMessage.value = 'Error loading stock: $e';
      print('Error loading stock: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadStockMovements() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final movementList = await _supabaseService.getStockMovements();
      stockMovements.value = movementList
          .map((data) => StockMovement.fromMap(data))
          .toList();
    } catch (e) {
      errorMessage.value = 'Error loading stock movements: $e';
      print('Error loading stock movements: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadStockMovementsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final movementList = await _supabaseService.getStockMovementsByDateRange(
        startDate,
        endDate,
      );
      stockMovements.value = movementList
          .map((data) => StockMovement.fromMap(data))
          .toList();
    } catch (e) {
      errorMessage.value = 'Error loading stock movements: $e';
      print('Error loading stock movements: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadStockMovementsByProduct(String productId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final movementList = await _supabaseService.getStockMovementsByProductId(
        productId,
      );
      stockMovements.value = movementList
          .map((data) => StockMovement.fromMap(data))
          .toList();
    } catch (e) {
      errorMessage.value = 'Error loading stock movements: $e';
      print('Error loading stock movements: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateStock(Stock stock) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final stockData = stock.toMap();
      await _supabaseService.updateStock(stock.productId, stockData);

      // Reload stock to get updated list
      await loadStock();
      return true;
    } catch (e) {
      errorMessage.value = 'Error updating stock: $e';
      print('Error updating stock: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void _calculateStockAlerts() {
    lowStockCount.value = stockItems
        .where((stock) => stock.availableQuantity <= stock.minimumStockLevel)
        .length;

    overstockCount.value = stockItems
        .where((stock) => stock.availableQuantity >= stock.maximumStockLevel)
        .length;
  }

  void clearError() {
    errorMessage.value = '';
  }

  // Helper methods
  List<Stock> getLowStockItems() {
    return stockItems
        .where((stock) => stock.availableQuantity <= stock.minimumStockLevel)
        .toList();
  }

  List<Stock> getOverstockItems() {
    return stockItems
        .where((stock) => stock.availableQuantity >= stock.maximumStockLevel)
        .toList();
  }

  Stock? getStockByProductId(String productId) {
    try {
      return stockItems.firstWhere((stock) => stock.productId == productId);
    } catch (e) {
      return null;
    }
  }

  Future<bool> adjustStock({
    required String productId,
    required double quantity,
    required String reason,
    required String notes,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Get current stock
      final currentStock = getStockByProductId(productId);
      if (currentStock == null) {
        errorMessage.value = 'Stock not found for product';
        return false;
      }

      // Calculate new quantity
      final newQuantity = currentStock.currentQuantity + quantity;
      if (newQuantity < 0) {
        errorMessage.value = 'Cannot reduce stock below zero';
        return false;
      }

      // Update stock
      final updatedStock = Stock(
        id: currentStock.id,
        productId: currentStock.productId,
        currentQuantity: newQuantity,
        reservedQuantity: currentStock.reservedQuantity,
        availableQuantity: newQuantity - currentStock.reservedQuantity,
        minimumStockLevel: currentStock.minimumStockLevel,
        maximumStockLevel: currentStock.maximumStockLevel,
        lastUpdated: DateTime.now(),
        location: currentStock.location,
      );

      await _supabaseService.updateStock(currentStock.id, updatedStock.toMap());

      // Create stock movement record
      final movement = StockMovement(
        id: const Uuid().v4(),
        productId: productId,
        quantity: quantity.abs(),
        previousQuantity: currentStock.currentQuantity,
        newQuantity: newQuantity,
        transactionType: 'adjustment',
        transactionId: const Uuid().v4(),
        reason: reason,
        notes: notes,
        movementDate: DateTime.now(),
        userId: 'system', // TODO: Get actual user ID
        createdAt: DateTime.now(),
      );

      await _supabaseService.insertStockMovement(movement.toMap());

      // Reload stock data
      await loadStock();
      return true;
    } catch (e) {
      errorMessage.value = 'Error adjusting stock: $e';
      print('Error adjusting stock: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateStockLevels({
    required String productId,
    required double minimumLevel,
    required double maximumLevel,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final currentStock = getStockByProductId(productId);
      if (currentStock == null) {
        errorMessage.value = 'Stock not found for product';
        return false;
      }

      final updatedStock = Stock(
        id: currentStock.id,
        productId: currentStock.productId,
        currentQuantity: currentStock.currentQuantity,
        reservedQuantity: currentStock.reservedQuantity,
        availableQuantity: currentStock.availableQuantity,
        minimumStockLevel: minimumLevel,
        maximumStockLevel: maximumLevel,
        lastUpdated: DateTime.now(),
        location: currentStock.location,
      );

      await _supabaseService.updateStock(currentStock.id, updatedStock.toMap());

      // Reload stock data
      await loadStock();
      return true;
    } catch (e) {
      errorMessage.value = 'Error updating stock levels: $e';
      print('Error updating stock levels: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  List<StockMovement> getMovementsByProduct(String productId) {
    return stockMovements
        .where((movement) => movement.productId == productId)
        .toList();
  }
}
