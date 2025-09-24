import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/supabase_auth_controller.dart';
import 'auth_screen.dart';
import 'dashboard_view.dart';
import 'products_view.dart';
import 'purchases_view.dart';
import 'sales_view.dart';
import 'stock_view.dart';
import 'reports_view.dart';
import 'settings_view.dart';
import 'parties_view.dart';
import 'ledger_view.dart';
import '../core/theme_constants.dart';
import '../widgets/steel_factory_logo.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  final SupabaseAuthController _authController =
      Get.find<SupabaseAuthController>();

  final List<Widget> _pages = [
    const DashboardView(),
    const ProductsView(),
    const PurchasesView(),
    const SalesView(),
    const StockView(),
    const PartiesView(),
    const LedgerView(),
    const ReportsView(),
    const SettingsView(),
  ];

  final List<String> _pageTitles = [
    'Dashboard',
    'Products',
    'Purchases',
    'Sales',
    'Stock',
    'Parties',
    'Ledger',
    'Reports',
    'Settings',
  ];

  final List<IconData> _pageIcons = [
    Icons.dashboard,
    Icons.inventory,
    Icons.shopping_cart,
    Icons.sell,
    Icons.warehouse,
    Icons.people,
    Icons.account_balance_wallet,
    Icons.analytics,
    Icons.settings,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar Navigation
          Container(
            width: 250,
            decoration: BoxDecoration(
              color: ThemeConstants.primary,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/download12.png',height: 100,),
                      const SizedBox(height: 12),
                      Text(
                        'Steel Factory',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: ThemeConstants.textInverse,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Inventory System',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => Text(
                          _authController.userDisplayName,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.white60),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white24),
                // Navigation Items
                Expanded(
                  child: ListView.builder(
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      final isSelected = _selectedIndex == index;
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        child: ListTile(
                          leading: Icon(
                            _pageIcons[index],
                            color: isSelected
                                ? Colors.blue[800]
                                : Colors.white70,
                          ),
                          title: Text(
                            _pageTitles[index],
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.blue[800]
                                  : Colors.white,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          selected: isSelected,
                          selectedTileColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          onTap: () {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                // Footer
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Divider(color: Colors.white24),
                      ListTile(
                        leading: const Icon(
                          Icons.settings,
                          color: Colors.white70,
                        ),
                        title: const Text(
                          'Settings',
                          style: TextStyle(color: Colors.white70),
                        ),
                        onTap: () {
                          // Navigate to settings
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.logout,
                          color: Colors.white70,
                        ),
                        title: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.white70),
                        ),
                        onTap: () {
                          _showLogoutDialog();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Column(
              children: [
                // Top Bar
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _pageTitles[_selectedIndex],
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications_outlined),
                            onPressed: () {
                              // Show notifications
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.account_circle_outlined),
                            onPressed: () {
                              // Show user menu
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Page Content
                Expanded(child: _pages[_selectedIndex]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _authController.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
