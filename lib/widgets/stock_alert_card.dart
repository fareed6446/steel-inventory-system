import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockAlertCard extends StatelessWidget {
  final int lowStockCount;
  final int overstockCount;

  const StockAlertCard({
    super.key,
    required this.lowStockCount,
    required this.overstockCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange[600],
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Stock Alerts',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildAlertItem(
                    context,
                    'Low Stock',
                    lowStockCount,
                    Colors.red,
                    Icons.trending_down,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildAlertItem(
                    context,
                    'Overstock',
                    overstockCount,
                    Colors.orange,
                    Icons.trending_up,
                  ),
                ),
              ],
            ),
            if (lowStockCount > 0 || overstockCount > 0) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to stock management screen
                    Get.toNamed('/stock');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('View Stock Details'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAlertItem(
    BuildContext context,
    String title,
    int count,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$count items',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
