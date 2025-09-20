import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  SupabaseClient get client => Supabase.instance.client;

  // Initialize Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
  }

  // Authentication methods
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
    String? phone,
    String? department,
  }) async {
    try {
      print('Attempting to sign up user: $email');
      print('Supabase URL: ${SupabaseConfig.url}');
      print('Client initialized: ${client != null}');

      // Try signup with user metadata
      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': name,
          'role': role,
          'phone': phone,
          'department': department,
        },
      );

      print('Sign up response received');
      print('User: ${response.user?.email}');
      print('User ID: ${response.user?.id}');
      print('User confirmed: ${response.user?.emailConfirmedAt}');
      print('Session: ${response.session != null}');

      return response;
    } catch (e) {
      print('Supabase signup error: $e');
      print('Error type: ${e.runtimeType}');
      rethrow;
    }
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  User? get currentUser => client.auth.currentUser;

  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  // User profile methods
  Future<void> _createUserProfile(
    User user,
    String name,
    String role,
    String? phone,
    String? department,
  ) async {
    try {
      final userProfile = {
        'id': user.id,
        'email': user.email!,
        'name': name,
        'role': role,
        'phone': phone,
        'department': department,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        'is_active': true,
      };

      print('Attempting to insert user profile: $userProfile');

      final response = await client
          .from(SupabaseConfig.usersTable)
          .insert(userProfile);
      print('User profile insert response: $response');
    } catch (e) {
      print('Detailed error creating user profile: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final response = await client
          .from(SupabaseConfig.usersTable)
          .select()
          .eq('id', userId)
          .maybeSingle();
      return response;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  // Product CRUD operations
  Future<List<Map<String, dynamic>>> getProducts() async {
    final response = await client.from(SupabaseConfig.productsTable).select();
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>?> getProduct(String id) async {
    final response = await client
        .from(SupabaseConfig.productsTable)
        .select()
        .eq('id', id)
        .single();
    return response;
  }

  Future<void> insertProduct(Map<String, dynamic> product) async {
    await client.from(SupabaseConfig.productsTable).insert(product);
  }

  Future<void> updateProduct(String id, Map<String, dynamic> product) async {
    await client
        .from(SupabaseConfig.productsTable)
        .update(product)
        .eq('id', id);
  }

  Future<void> deleteProduct(String id) async {
    await client.from(SupabaseConfig.productsTable).delete().eq('id', id);
  }

  // Purchase CRUD operations
  Future<List<Map<String, dynamic>>> getPurchases() async {
    final response = await client.from(SupabaseConfig.purchasesTable).select();
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getPurchasesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final response = await client
        .from(SupabaseConfig.purchasesTable)
        .select()
        .gte('purchase_date', startDate.toIso8601String())
        .lte('purchase_date', endDate.toIso8601String());
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> insertPurchase(Map<String, dynamic> purchase) async {
    await client.from(SupabaseConfig.purchasesTable).insert(purchase);
  }

  Future<void> updatePurchase(String id, Map<String, dynamic> purchase) async {
    await client
        .from(SupabaseConfig.purchasesTable)
        .update(purchase)
        .eq('id', id);
  }

  Future<void> deletePurchase(String id) async {
    await client.from(SupabaseConfig.purchasesTable).delete().eq('id', id);
  }

  // Sale CRUD operations
  Future<List<Map<String, dynamic>>> getSales() async {
    final response = await client.from(SupabaseConfig.salesTable).select();
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getSalesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final response = await client
        .from(SupabaseConfig.salesTable)
        .select()
        .gte('sale_date', startDate.toIso8601String())
        .lte('sale_date', endDate.toIso8601String());
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> insertSale(Map<String, dynamic> sale) async {
    await client.from(SupabaseConfig.salesTable).insert(sale);
  }

  Future<void> updateSale(String id, Map<String, dynamic> sale) async {
    await client.from(SupabaseConfig.salesTable).update(sale).eq('id', id);
  }

  Future<void> deleteSale(String id) async {
    await client.from(SupabaseConfig.salesTable).delete().eq('id', id);
  }

  // Stock CRUD operations
  Future<List<Map<String, dynamic>>> getStock() async {
    final response = await client.from(SupabaseConfig.stockTable).select();
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>?> getStockByProductId(String productId) async {
    final response = await client
        .from(SupabaseConfig.stockTable)
        .select()
        .eq('product_id', productId)
        .single();
    return response;
  }

  Future<void> insertStock(Map<String, dynamic> stock) async {
    await client.from(SupabaseConfig.stockTable).insert(stock);
  }

  Future<void> updateStock(String productId, Map<String, dynamic> stock) async {
    await client
        .from(SupabaseConfig.stockTable)
        .update(stock)
        .eq('product_id', productId);
  }

  // Stock Movement operations
  Future<List<Map<String, dynamic>>> getStockMovements() async {
    final response = await client
        .from(SupabaseConfig.stockMovementsTable)
        .select();
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getStockMovementsByProductId(
    String productId,
  ) async {
    final response = await client
        .from(SupabaseConfig.stockMovementsTable)
        .select()
        .eq('product_id', productId)
        .order('movement_date', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getStockMovementsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final response = await client
        .from(SupabaseConfig.stockMovementsTable)
        .select()
        .gte('movement_date', startDate.toIso8601String())
        .lte('movement_date', endDate.toIso8601String())
        .order('movement_date', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> insertStockMovement(Map<String, dynamic> movement) async {
    await client.from(SupabaseConfig.stockMovementsTable).insert(movement);
  }

  // Analytics queries
  Future<List<Map<String, dynamic>>> getTotalPurchasesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final response = await client.rpc(
      'get_total_purchases_by_date_range',
      params: {
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
      },
    );
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getTotalSalesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final response = await client.rpc(
      'get_total_sales_by_date_range',
      params: {
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
      },
    );
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getLowStockProducts() async {
    final response = await client.rpc('get_low_stock_products');
    return List<Map<String, dynamic>>.from(response);
  }

  // Real-time subscriptions
  RealtimeChannel subscribeToProducts() {
    return client
        .channel('products_changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: SupabaseConfig.productsTable,
          callback: (payload) {
            print('Product changed: $payload');
          },
        )
        .subscribe();
  }

  RealtimeChannel subscribeToStock() {
    return client
        .channel('stock_changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: SupabaseConfig.stockTable,
          callback: (payload) {
            print('Stock changed: $payload');
          },
        )
        .subscribe();
  }

  RealtimeChannel subscribeToPurchases() {
    return client
        .channel('purchases_changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: SupabaseConfig.purchasesTable,
          callback: (payload) {
            print('Purchase changed: $payload');
          },
        )
        .subscribe();
  }

  RealtimeChannel subscribeToSales() {
    return client
        .channel('sales_changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: SupabaseConfig.salesTable,
          callback: (payload) {
            print('Sale changed: $payload');
          },
        )
        .subscribe();
  }
}
