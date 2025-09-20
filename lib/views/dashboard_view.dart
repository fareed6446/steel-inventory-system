import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/metric_card.dart';
import '../widgets/chart_card.dart';
import '../widgets/stock_alert_card.dart';
import '../core/theme_constants.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController =
        Get.find<DashboardController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Steel Factory Inventory Dashboard'),
        backgroundColor: ThemeConstants.primary,
        foregroundColor: ThemeConstants.textInverse,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => dashboardController.refreshData(),
          ),
        ],
      ),
      backgroundColor: ThemeConstants.backgroundSecondary,
      body: Obx(() {
        if (dashboardController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: ThemeConstants.primary),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Dashboard Overview',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              const SizedBox(height: 20),

              // Metrics Cards Row
              Row(
                children: [
                  Expanded(
                    child: MetricCard(
                      title: 'Total Revenue',
                      value:
                          '\$${dashboardController.totalRevenue.value.toStringAsFixed(2)}',
                      icon: Icons.trending_up,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: MetricCard(
                      title: 'Total Expenses',
                      value:
                          '\$${dashboardController.totalExpenses.value.toStringAsFixed(2)}',
                      icon: Icons.trending_down,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: MetricCard(
                      title: 'Net Profit',
                      value:
                          '\$${dashboardController.totalProfit.value.toStringAsFixed(2)}',
                      icon: Icons.account_balance_wallet,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: MetricCard(
                      title: 'Total Products',
                      value: '${dashboardController.totalProducts.value}',
                      icon: Icons.inventory,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: MetricCard(
                      title: 'Stock Value',
                      value:
                          '\$${dashboardController.totalStockValue.value.toStringAsFixed(2)}',
                      icon: Icons.warehouse,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: MetricCard(
                      title: 'Profit Margin',
                      value:
                          '${dashboardController.totalProfit.value > 0 ? ((dashboardController.totalProfit.value / dashboardController.totalRevenue.value) * 100).toStringAsFixed(1) : 0.0}%',
                      icon: Icons.percent,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Stock Alerts
              StockAlertCard(
                lowStockCount: dashboardController.lowStockItems.value,
                overstockCount: dashboardController.overstockItems.value,
              ),
              const SizedBox(height: 24),

              // Charts Section
              Text(
                'Analytics',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              const SizedBox(height: 16),

              // Revenue vs Expenses Chart
              ChartCard(
                title: 'Revenue vs Expenses (Last 7 Days)',
                child: SizedBox(
                  height: 300,
                  child: LineChart(
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
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: _generateRevenueSpots(
                            dashboardController.dailyRevenue,
                          ),
                          isCurved: true,
                          color: Colors.green,
                          barWidth: 3,
                          dotData: FlDotData(show: true),
                          belowBarData: BarAreaData(show: false),
                        ),
                        LineChartBarData(
                          spots: _generateExpenseSpots(
                            dashboardController.dailyExpenses,
                          ),
                          isCurved: true,
                          color: Colors.red,
                          barWidth: 3,
                          dotData: FlDotData(show: true),
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Stock Movement Chart
              ChartCard(
                title: 'Stock Movements (Last 7 Days)',
                child: SizedBox(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 100.0, // Default max value for stock movements
                      barTouchData: BarTouchData(enabled: true),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(value.toInt().toString());
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
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      barGroups: _generateStockMovementBars(
                        {}, // Empty map for now - will be populated when stock movements are available
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  List<FlSpot> _generateRevenueSpots(Map<String, double> revenueData) {
    List<FlSpot> spots = [];
    for (int i = 0; i < 7; i++) {
      final date = DateTime.now().subtract(Duration(days: 6 - i));
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      spots.add(FlSpot(i.toDouble(), revenueData[dateKey] ?? 0.0));
    }
    return spots;
  }

  List<FlSpot> _generateExpenseSpots(Map<String, double> expenseData) {
    List<FlSpot> spots = [];
    for (int i = 0; i < 7; i++) {
      final date = DateTime.now().subtract(Duration(days: 6 - i));
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      spots.add(FlSpot(i.toDouble(), expenseData[dateKey] ?? 0.0));
    }
    return spots;
  }

  List<BarChartGroupData> _generateStockMovementBars(
    Map<String, double> movementData,
  ) {
    List<BarChartGroupData> bars = [];
    for (int i = 0; i < 7; i++) {
      final date = DateTime.now().subtract(Duration(days: 6 - i));
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      bars.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: movementData[dateKey] ?? 0.0,
              color: Colors.blue,
              width: 20,
            ),
          ],
        ),
      );
    }
    return bars;
  }
}
