import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/product.dart';
import '../models/stock.dart';
import '../services/supabase_service.dart';

class ProductController extends GetxController {
  final SupabaseService _supabaseService = SupabaseService();

  final RxList<Product> products = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final productList = await _supabaseService.getProducts();
      products.value = productList
          .map((data) => Product.fromMap(data))
          .toList();
    } catch (e) {
      errorMessage.value = 'Error loading products: $e';
      print('Error loading products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addProduct(Product product) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final productData = product.toMap();
      await _supabaseService.insertProduct(productData);

      // Reload products to get updated list
      await loadProducts();
      return true;
    } catch (e) {
      errorMessage.value = 'Error adding product: $e';
      print('Error adding product: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateProduct(Product product) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final productData = product.toMap();
      await _supabaseService.updateProduct(product.id, productData);

      // Reload products to get updated list
      await loadProducts();
      return true;
    } catch (e) {
      errorMessage.value = 'Error updating product: $e';
      print('Error updating product: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _supabaseService.deleteProduct(productId);

      // Reload products to get updated list
      await loadProducts();
      return true;
    } catch (e) {
      errorMessage.value = 'Error deleting product: $e';
      print('Error deleting product: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> initializeStockForProduct(String productId) async {
    try {
      // Check if stock already exists for this product
      final existingStock = await _supabaseService.getStockByProductId(
        productId,
      );

      if (existingStock == null) {
        // Create initial stock entry
        final stock = Stock(
          id: const Uuid().v4(),
          productId: productId,
          currentQuantity: 0,
          reservedQuantity: 0,
          availableQuantity: 0,
          minimumStockLevel: 10,
          maximumStockLevel: 1000,
          lastUpdated: DateTime.now(),
          location: 'Main Warehouse',
        );

        final stockData = stock.toMap();
        await _supabaseService.insertStock(stockData);
      }
    } catch (e) {
      print('Error initializing stock for product: $e');
    }
  }

  void clearError() {
    errorMessage.value = '';
  }

  // Helper methods
  List<Product> getProductsByCategory(String category) {
    return products.where((product) => product.category == category).toList();
  }

  List<Product> searchProducts(String query) {
    if (query.isEmpty) return products;

    return products
        .where(
          (product) =>
              product.name.toLowerCase().contains(query.toLowerCase()) ||
              product.description?.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ==
                  true ||
              product.category.toLowerCase().contains(query.toLowerCase()) ||
              product.grade.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  Product? getProductById(String productId) {
    try {
      return products.firstWhere((product) => product.id == productId);
    } catch (e) {
      return null;
    }
  }
}
