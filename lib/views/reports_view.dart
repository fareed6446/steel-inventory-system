import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/purchase_controller.dart';
import '../controllers/sale_controller.dart';
import '../controllers/stock_controller.dart';

class ReportsView extends StatelessWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController = Get.put(
      DashboardController(),
    );
    final PurchaseController purchaseController = Get.put(PurchaseController());
    final SaleController saleController = Get.put(SaleController());
    final StockController stockController = Get.put(StockController());

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Reports & Analytics',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _showDateRangeDialog(context, dashboardController);
                      },
                      icon: const Icon(Icons.date_range),
                      label: const Text('Date Range'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        dashboardController.refreshData();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Refresh'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[800],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Summary Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryCard(
                            context,
                            'Total Revenue',
                            '\$${dashboardController.totalRevenue.value.toStringAsFixed(2)}',
                            Colors.green,
                            Icons.trending_up,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildSummaryCard(
                            context,
                            'Total Expenses',
                            '\$${dashboardController.totalExpenses.value.toStringAsFixed(2)}',
                            Colors.red,
                            Icons.trending_down,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildSummaryCard(
                            context,
                            'Net Profit',
                            '\$${dashboardController.totalProfit.value.toStringAsFixed(2)}',
                            Colors.blue,
                            Icons.account_balance_wallet,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildSummaryCard(
                            context,
                            'Profit Margin',
                            '${dashboardController.totalProfit.value > 0 ? ((dashboardController.totalProfit.value / dashboardController.totalRevenue.value) * 100).toStringAsFixed(1) : 0.0}%',
                            Colors.purple,
                            Icons.percent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Charts Section
                    Row(
                      children: [
                        Expanded(
                          child: _buildChartCard(
                            context,
                            'Revenue vs Expenses',
                            _buildRevenueExpenseChart(dashboardController),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildChartCard(
                            context,
                            'Stock Status',
                            _buildStockStatusChart(stockController),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Detailed Reports
                    Row(
                      children: [
                        Expanded(
                          child: _buildReportCard(
                            context,
                            'Top Selling Products',
                            _buildTopSellingProducts(saleController),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildReportCard(
                            context,
                            'Low Stock Alerts',
                            _buildLowStockAlerts(stockController),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Transaction Summary
                    _buildTransactionSummary(
                      context,
                      purchaseController,
                      saleController,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(BuildContext context, String title, Widget chart) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(height: 200, child: chart),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, String title, Widget content) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueExpenseChart(DashboardController controller) {
    return Obx(() {
      final revenueData = controller.dailyRevenue;
      final expenseData = controller.dailyExpenses;

      return LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text('\$${value.toInt()}');
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final date = DateTime.now().subtract(
                    Duration(days: 6 - value.toInt()),
                  );
                  return Text('${date.day}/${date.month}');
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: _generateSpots(revenueData),
              isCurved: true,
              color: Colors.green,
              barWidth: 3,
              dotData: FlDotData(show: true),
            ),
            LineChartBarData(
              spots: _generateSpots(expenseData),
              isCurved: true,
              color: Colors.red,
              barWidth: 3,
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStockStatusChart(StockController controller) {
    return Obx(() {
      final lowStock = controller.lowStockCount.value;
      final overstock = controller.overstockCount.value;
      final normal = controller.stockItems.length - lowStock - overstock;

      return PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: lowStock.toDouble(),
              title: 'Low Stock\n$lowStock',
              color: Colors.red,
              radius: 60,
            ),
            PieChartSectionData(
              value: overstock.toDouble(),
              title: 'Overstock\n$overstock',
              color: Colors.orange,
              radius: 60,
            ),
            PieChartSectionData(
              value: normal.toDouble(),
              title: 'Normal\n$normal',
              color: Colors.green,
              radius: 60,
            ),
          ],
          sectionsSpace: 2,
          centerSpaceRadius: 40,
        ),
      );
    });
  }

  Widget _buildTopSellingProducts(SaleController controller) {
    return Obx(() {
      final sales = controller.sales;
      if (sales.isEmpty) {
        return const Text('No sales data available');
      }

      // Group sales by product
      Map<String, double> productSales = {};
      for (var sale in sales) {
        productSales[sale.productId] =
            (productSales[sale.productId] ?? 0.0) + sale.quantity;
      }

      final sortedProducts = productSales.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      return Column(
        children: sortedProducts.take(5).map((entry) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Text('${sortedProducts.indexOf(entry) + 1}'),
            ),
            title: Text('Product ${entry.key.substring(0, 8)}...'),
            trailing: Text('${entry.value.toStringAsFixed(1)} units'),
          );
        }).toList(),
      );
    });
  }

  Widget _buildLowStockAlerts(StockController controller) {
    return Obx(() {
      final lowStockItems = controller.getLowStockItems();

      if (lowStockItems.isEmpty) {
        return const Text('No low stock alerts');
      }

      return Column(
        children: lowStockItems.take(5).map((stock) {
          return ListTile(
            leading: const Icon(Icons.warning, color: Colors.red),
            title: Text('Product ${stock.productId.substring(0, 8)}...'),
            subtitle: Text('Available: ${stock.availableQuantity}'),
            trailing: Text('Min: ${stock.minimumStockLevel}'),
          );
        }).toList(),
      );
    });
  }

  Widget _buildTransactionSummary(
    BuildContext context,
    PurchaseController purchaseController,
    SaleController saleController,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transaction Summary',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 16),
            Obx(() {
              return DataTable(
                columns: const [
                  DataColumn(label: Text('Type')),
                  DataColumn(label: Text('Count')),
                  DataColumn(label: Text('Total Amount')),
                ],
                rows: [
                  DataRow(
                    cells: [
                      const DataCell(Text('Purchases')),
                      DataCell(Text('${purchaseController.purchases.length}')),
                      DataCell(
                        Text(
                          '\$${purchaseController.totalPurchaseAmount.value.toStringAsFixed(2)}',
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      const DataCell(Text('Sales')),
                      DataCell(Text('${saleController.sales.length}')),
                      DataCell(
                        Text(
                          '\$${saleController.totalSaleAmount.value.toStringAsFixed(2)}',
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _generateSpots(Map<String, double> data) {
    List<FlSpot> spots = [];
    for (int i = 0; i < 7; i++) {
      final date = DateTime.now().subtract(Duration(days: 6 - i));
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      spots.add(FlSpot(i.toDouble(), data[dateKey] ?? 0.0));
    }
    return spots;
  }

  void _showDateRangeDialog(
    BuildContext context,
    DashboardController controller,
  ) {
    DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
    DateTime endDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Select Date Range'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Start Date'),
                subtitle: Text(startDate.toString().split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: startDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() {
                      startDate = date;
                    });
                  }
                },
              ),
              ListTile(
                title: const Text('End Date'),
                subtitle: Text(endDate.toString().split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: endDate,
                    firstDate: startDate,
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() {
                      endDate = date;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Update date range and refresh data
                Navigator.pop(context);
                controller.refreshData();
                Get.snackbar('Success', 'Date range updated');
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }
}
