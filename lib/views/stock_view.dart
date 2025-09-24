import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/stock_controller.dart';
import '../controllers/product_controller.dart';
import '../models/product.dart';
import '../models/stock.dart';
import '../widgets/summary_card.dart';
import '../core/theme_constants.dart';

class StockView extends StatelessWidget {
  const StockView({super.key});

  @override
  Widget build(BuildContext context) {
    final StockController stockController = Get.find<StockController>();
    final ProductController productController = Get.find<ProductController>();

    // Load data when view is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      stockController.loadStock();
      productController.loadProducts();
    });

    return Scaffold(
      backgroundColor: ThemeConstants.backgroundSecondary,
      appBar: AppBar(
        title: const Text('Stock Management'),
        backgroundColor: ThemeConstants.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Get.offAllNamed('/main');
            },
          ),
        ],
      ),
      body: Padding(
        padding: ThemeConstants.sectionPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              padding: ThemeConstants.cardPadding,
              decoration: ThemeConstants.elevatedCardDecoration.copyWith(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: ThemeConstants.getIconContainerDecoration(
                      ThemeConstants.stock,
                    ),
                    child: Icon(
                      Icons.warehouse_outlined,
                      color: ThemeConstants.stock,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stock Management',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Monitor your steel factory inventory levels',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showAdjustStockDialog(context);
                    },
                    icon: const Icon(Icons.edit, size: 20),
                    label: const Text('Adjust Stock'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Content Section
            Expanded(
              child: Obx(() {
                if (stockController.isLoading.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.orange[600],
                          strokeWidth: 3,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Loading stock data...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (stockController.stockItems.isEmpty &&
                    !stockController.isLoading.value) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(60),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: Icon(
                            Icons.warehouse_outlined,
                            size: 80,
                            color: Colors.orange[400],
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          'No stock items yet',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Add products to start tracking your inventory levels',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton.icon(
                          onPressed: () {
                            _showAdjustStockDialog(context);
                          },
                          icon: const Icon(Icons.add, size: 24),
                          label: const Text('Add First Stock Item'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return _buildStockContent(context);
              }),
            ),

            // Summary Cards at the bottom
            const SizedBox(height: 24),
            Obx(() {
              final StockController stockController =
                  Get.find<StockController>();
              return _buildSummaryCards(stockController);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStockContent(BuildContext context) {
    final StockController stockController = Get.find<StockController>();
    return Column(
      children: [
        // Stock Table
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Table Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[200]!, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        color: Colors.orange[700],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Current Stock Levels',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[800],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                // Data Table
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.maxFinite,
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(
                          Colors.grey[100],
                        ),
                        headingRowHeight: 60,
                        dataRowHeight: 70,
                        columnSpacing: 16,
                        horizontalMargin: 16,
                        columns: [
                          DataColumn(
                            label: _buildColumnHeader(
                              'Product',
                              Icons.inventory_2_outlined,
                            ),
                          ),
                          DataColumn(
                            label: _buildColumnHeader(
                              'Current Stock',
                              Icons.scale_outlined,
                            ),
                          ),
                          DataColumn(
                            label: _buildColumnHeader(
                              'Available',
                              Icons.check_circle_outline,
                            ),
                          ),
                          DataColumn(
                            label: _buildColumnHeader(
                              'Min Level',
                              Icons.warning_outlined,
                            ),
                          ),
                          DataColumn(
                            label: _buildColumnHeader(
                              'Max Level',
                              Icons.trending_up_outlined,
                            ),
                          ),
                          DataColumn(
                            label: _buildColumnHeader(
                              'Status',
                              Icons.info_outline,
                            ),
                          ),
                          DataColumn(
                            label: _buildColumnHeader(
                              'Actions',
                              Icons.more_vert_outlined,
                            ),
                          ),
                        ],
                        rows: _buildDataTableRows(
                          context,
                          stockController.stockItems,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(StockController stockController) {
    final lowStockCount = stockController.stockItems
        .where((s) => s.isLowStock)
        .length;
    final overstockCount = stockController.stockItems
        .where((s) => s.isOverstocked)
        .length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SummaryCard(
            title: 'Total Items',
            value: stockController.stockItems.length.toString(),
            icon: Icons.inventory_2_outlined,
            color: Colors.orange,
          ),
          const SizedBox(width: 16),
          SummaryCard(
            title: 'Low Stock',
            value: lowStockCount.toString(),
            icon: Icons.warning_outlined,
            color: Colors.red,
          ),
          const SizedBox(width: 16),
          SummaryCard(
            title: 'Overstock',
            value: overstockCount.toString(),
            icon: Icons.trending_up_outlined,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildColumnHeader(String title, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildProductCell(Stock stock) {
    final ProductController productController = Get.find<ProductController>();
    final Product? product = productController.getProductById(stock.productId);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product?.name ?? 'Unknown',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        Text(
          product?.category ?? '',
          style: TextStyle(color: Colors.grey[600], fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildQuantityCell(double quantity, String unit) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          quantity.toStringAsFixed(0),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(unit, style: TextStyle(color: Colors.grey[600], fontSize: 11)),
      ],
    );
  }

  Widget _buildStatusCell(Stock stock) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (stock.isLowStock) {
      statusColor = Colors.red;
      statusText = 'LOW STOCK';
      statusIcon = Icons.warning;
    } else if (stock.isOverstocked) {
      statusColor = Colors.orange;
      statusText = 'OVERSTOCK';
      statusIcon = Icons.trending_up;
    } else {
      statusColor = Colors.green;
      statusText = 'NORMAL';
      statusIcon = Icons.check_circle;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Text(
            statusText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  List<DataRow> _buildDataTableRows(
    BuildContext context,
    List<Stock> stockItems,
  ) {
    final ProductController productController = Get.find<ProductController>();

    return stockItems.map((stock) {
      final product = productController.getProductById(stock.productId);
      return DataRow(
        cells: [
          DataCell(_buildProductCell(stock)),
          DataCell(
            _buildQuantityCell(stock.currentQuantity, product?.unit ?? ''),
          ),
          DataCell(
            _buildQuantityCell(stock.availableQuantity, product?.unit ?? ''),
          ),
          DataCell(
            _buildQuantityCell(stock.minimumStockLevel, product?.unit ?? ''),
          ),
          DataCell(
            _buildQuantityCell(stock.maximumStockLevel, product?.unit ?? ''),
          ),
          DataCell(_buildStatusCell(stock)),
          DataCell(_buildActionCell(context, stock)),
        ],
      );
    }).toList();
  }

  Widget _buildActionCell(BuildContext context, Stock stock) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: Icon(Icons.edit_outlined, size: 16, color: Colors.blue[700]),
            onPressed: () {
              _showUpdateStockLevelsDialog(context, stock);
            },
          ),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: Icon(
              Icons.history_outlined,
              size: 16,
              color: Colors.green[700],
            ),
            onPressed: () {
              _showStockMovementHistory(context, stock.productId);
            },
          ),
        ),
      ],
    );
  }

  void _showAdjustStockDialog(BuildContext context) {
    final StockController stockController = Get.find<StockController>();
    final ProductController productController = Get.find<ProductController>();
    final quantityController = TextEditingController();
    final reasonController = TextEditingController();
    final notesController = TextEditingController();
    String? selectedProductId;
    bool isAddition = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Adjust Stock'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedProductId,
                  decoration: const InputDecoration(labelText: 'Product'),
                  items: productController.products.map((product) {
                    return DropdownMenuItem(
                      value: product.id,
                      child: Text(product.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedProductId = value;
                    });
                  },
                ),
                TextField(
                  controller: quantityController,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                ),
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: isAddition,
                      onChanged: (value) {
                        setState(() {
                          isAddition = value!;
                        });
                      },
                    ),
                    const Text('Add Stock'),
                    Radio<bool>(
                      value: false,
                      groupValue: isAddition,
                      onChanged: (value) {
                        setState(() {
                          isAddition = value!;
                        });
                      },
                    ),
                    const Text('Remove Stock'),
                  ],
                ),
                TextField(
                  controller: reasonController,
                  decoration: const InputDecoration(labelText: 'Reason'),
                ),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'Notes'),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedProductId == null) {
                  Get.snackbar('Error', 'Please select a product');
                  return;
                }

                final quantity =
                    double.tryParse(quantityController.text) ?? 0.0;
                final adjustedQuantity = isAddition ? quantity : -quantity;

                final success = await stockController.adjustStock(
                  productId: selectedProductId!,
                  quantity: adjustedQuantity,
                  reason: reasonController.text,
                  notes: notesController.text,
                );

                if (success) {
                  Navigator.pop(context);
                  Get.snackbar('Success', 'Stock adjusted successfully');
                } else {
                  Get.snackbar('Error', stockController.errorMessage.value);
                }
              },
              child: const Text('Adjust'),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateStockLevelsDialog(BuildContext context, Stock stock) {
    final StockController stockController = Get.find<StockController>();
    final minLevelController = TextEditingController(
      text: stock.minimumStockLevel.toString(),
    );
    final maxLevelController = TextEditingController(
      text: stock.maximumStockLevel.toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Stock Levels'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: minLevelController,
              decoration: const InputDecoration(
                labelText: 'Minimum Stock Level',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: maxLevelController,
              decoration: const InputDecoration(
                labelText: 'Maximum Stock Level',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await stockController.updateStockLevels(
                productId: stock.productId,
                minimumLevel: double.tryParse(minLevelController.text) ?? 0.0,
                maximumLevel: double.tryParse(maxLevelController.text) ?? 0.0,
              );

              if (success) {
                Navigator.pop(context);
                Get.snackbar('Success', 'Stock levels updated successfully');
              } else {
                Get.snackbar('Error', stockController.errorMessage.value);
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showStockMovementHistory(BuildContext context, String productId) {
    final StockController stockController = Get.find<StockController>();
    stockController.loadStockMovementsByProduct(productId);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stock Movement History'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: Obx(() {
            final movements = stockController.getMovementsByProduct(productId);

            if (movements.isEmpty) {
              return const Center(child: Text('No movements found'));
            }

            return ListView.builder(
              itemCount: movements.length,
              itemBuilder: (context, index) {
                final movement = movements[index];
                return ListTile(
                  leading: Icon(
                    movement.isInbound
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    color: movement.isInbound ? Colors.green : Colors.red,
                  ),
                  title: Text(movement.reason),
                  subtitle: Text(
                    '${movement.quantity} units - ${movement.movementDate.toString().split(' ')[0]}',
                  ),
                  trailing: Text(movement.transactionType.toUpperCase()),
                );
              },
            );
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
