import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/modern_metric_card.dart';
import '../widgets/modern_chart_card.dart';
import '../widgets/stock_alert_card.dart';
import '../core/theme_constants.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView>
    with TickerProviderStateMixin {
  late AnimationController _cardsAnimationController;
  late Animation<double> _cardsFadeAnimation;

  @override
  void initState() {
    super.initState();
    _cardsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _cardsFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardsAnimationController, curve: Curves.easeIn),
    );

    _cardsAnimationController.forward();
  }

  @override
  void dispose() {
    _cardsAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController =
        Get.find<DashboardController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Obx(() {
        if (dashboardController.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: ThemeConstants.primary,
                  strokeWidth: 3,
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading Dashboard...',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Dashboard'),
            backgroundColor: ThemeConstants.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => dashboardController.refreshData(),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFF8FAFC),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: FadeTransition(
              opacity: _cardsFadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Key Metrics',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Metrics Grid using Wrap for better stability
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 320) / 2,
                        child: ModernMetricCard(
                          title: 'Total Revenue',
                          value:
                              'PKR ${dashboardController.totalRevenue.value.toStringAsFixed(0)}',
                          subtitle: 'This month',
                          icon: Icons.trending_up,
                          primaryColor: const Color(0xFF10B981),
                          secondaryColor: const Color(0xFF34D399),
                          trend: '+12.5%',
                          trendValue: 12.5,
                        ),
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 320) / 2,
                        child: ModernMetricCard(
                          title: 'Total Expenses',
                          value:
                              'PKR ${dashboardController.totalExpenses.value.toStringAsFixed(0)}',
                          subtitle: 'This month',
                          icon: Icons.trending_down,
                          primaryColor: const Color(0xFFEF4444),
                          secondaryColor: const Color(0xFFF87171),
                          trend: '-3.2%',
                          trendValue: -3.2,
                        ),
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 320) / 2,
                        child: ModernMetricCard(
                          title: 'Net Profit',
                          value:
                              'PKR ${dashboardController.totalProfit.value.toStringAsFixed(0)}',
                          subtitle: 'This month',
                          icon: Icons.account_balance_wallet,
                          primaryColor: const Color(0xFF3B82F6),
                          secondaryColor: const Color(0xFF60A5FA),
                          trend: '+8.7%',
                          trendValue: 8.7,
                        ),
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 320) / 2,
                        child: ModernMetricCard(
                          title: 'Total Products',
                          value: '${dashboardController.totalProducts.value}',
                          subtitle: 'In inventory',
                          icon: Icons.inventory_2,
                          primaryColor: const Color(0xFF8B5CF6),
                          secondaryColor: const Color(0xFFA78BFA),
                          trend: '+5',
                          trendValue: 5,
                        ),
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 320) / 2,
                        child: ModernMetricCard(
                          title: 'Stock Value',
                          value:
                              'PKR ${dashboardController.totalStockValue.value.toStringAsFixed(0)}',
                          subtitle: 'Current inventory value',
                          icon: Icons.warehouse,
                          primaryColor: const Color(0xFFF59E0B),
                          secondaryColor: const Color(0xFFFBBF24),
                          trend: '+2.1%',
                          trendValue: 2.1,
                        ),
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 320) / 2,
                        child: ModernMetricCard(
                          title: 'Profit Margin',
                          value:
                              '${dashboardController.totalProfit.value > 0 ? ((dashboardController.totalProfit.value / dashboardController.totalRevenue.value) * 100).toStringAsFixed(1) : 0.0}%',
                          subtitle: 'Net profit margin',
                          icon: Icons.percent,
                          primaryColor: const Color(0xFF06B6D4),
                          secondaryColor: const Color(0xFF22D3EE),
                          trend: '+1.3%',
                          trendValue: 1.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Charts Section
                  Text(
                    'Analytics & Insights',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Revenue vs Expenses Chart
                  ModernChartCard(
                    title: 'Revenue vs Expenses',
                    subtitle: 'Last 7 days performance',
                    primaryColor: const Color(0xFF3B82F6),
                    actions: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '7D',
                          style: TextStyle(
                            color: const Color(0xFF3B82F6),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                    child: SizedBox(
                      height: 320,
                      child: _buildRevenueExpenseChart(dashboardController),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Stock Movement Chart
                  ModernChartCard(
                    title: 'Stock Movements',
                    subtitle: 'Inventory changes over time',
                    primaryColor: const Color(0xFF8B5CF6),
                    actions: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B5CF6).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '7D',
                          style: TextStyle(
                            color: const Color(0xFF8B5CF6),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                    child: SizedBox(
                      height: 320,
                      child: _buildStockMovementChart(dashboardController),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Stock Alerts
                  StockAlertCard(
                    lowStockCount: dashboardController.lowStockItems.value,
                    overstockCount: dashboardController.overstockItems.value,
                  ),
                  const SizedBox(height: 100), // Bottom padding
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildRevenueExpenseChart(DashboardController controller) {
    // Generate sample data for demonstration
    final sampleRevenueData = [
      85000,
      92000,
      88000,
      105000,
      98000,
      112000,
      105000,
    ];
    final sampleExpenseData = [
      75000,
      82000,
      78000,
      95000,
      88000,
      102000,
      95000,
    ];

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: 120000,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 20000,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1);
          },
          getDrawingVerticalLine: (value) {
            return FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                if (value >= 1000) {
                  return Text(
                    'PKR ${(value / 1000).toStringAsFixed(0)}K',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }
                return Text(
                  'PKR ${value.toInt()}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final date = DateTime.now().subtract(
                  Duration(days: 6 - value.toInt()),
                );
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '${date.day}/${date.month}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: sampleRevenueData.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value.toDouble());
            }).toList(),
            isCurved: true,
            color: const Color(0xFF10B981),
            barWidth: 4,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 6,
                  color: const Color(0xFF10B981),
                  strokeWidth: 3,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF10B981).withOpacity(0.1),
            ),
          ),
          LineChartBarData(
            spots: sampleExpenseData.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value.toDouble());
            }).toList(),
            isCurved: true,
            color: const Color(0xFFEF4444),
            barWidth: 4,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 6,
                  color: const Color(0xFFEF4444),
                  strokeWidth: 3,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFFEF4444).withOpacity(0.1),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.grey[800]!,
            tooltipRoundedRadius: 8,
            tooltipPadding: const EdgeInsets.all(8),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((touchedSpot) {
                return LineTooltipItem(
                  touchedSpot.barIndex == 0 ? 'Revenue' : 'Expenses',
                  TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: '\nPKR ${touchedSpot.y.toInt()}',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStockMovementChart(DashboardController controller) {
    // Generate sample stock movement data
    final sampleStockData = [45, 52, 38, 67, 41, 58, 49];

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 80.0,
        minY: 0,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.grey[800]!,
            tooltipRoundedRadius: 8,
            tooltipPadding: const EdgeInsets.all(8),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                'Stock Movement\n${rod.toY.toInt()} units',
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              interval: 10,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final date = DateTime.now().subtract(
                  Duration(days: 6 - value.toInt()),
                );
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '${date.day}/${date.month}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 10,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1);
          },
          getDrawingVerticalLine: (value) {
            return FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1);
          },
        ),
        barGroups: sampleStockData.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.toDouble(),
                color: const Color(0xFF8B5CF6),
                width: 24,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
