import 'package:get/get.dart';
import '../controllers/purchase_controller.dart';
import '../controllers/product_controller.dart';
import '../controllers/sale_controller.dart';
import '../controllers/stock_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/supabase_auth_controller.dart';
import '../controllers/settings_controller.dart';
import '../controllers/parties_controller.dart';
import '../services/supabase_service.dart';

class DependencyInjection {
  static Future<void> init() async {
    // Services
    Get.put<SupabaseService>(SupabaseService(), permanent: true);

    // Controllers
    Get.put<SupabaseAuthController>(SupabaseAuthController(), permanent: true);
    Get.put<ProductController>(ProductController(), permanent: true);
    Get.put<PurchaseController>(PurchaseController(), permanent: true);
    Get.put<SaleController>(SaleController(), permanent: true);
    Get.put<StockController>(StockController(), permanent: true);
    Get.put<DashboardController>(DashboardController(), permanent: true);
    Get.put<SettingsController>(SettingsController(), permanent: true);
    Get.put<PartiesController>(PartiesController(), permanent: true);
  }

  static void dispose() {
    // Controllers will be automatically disposed by GetX when not in use
    // Services marked as permanent will persist
  }
}
