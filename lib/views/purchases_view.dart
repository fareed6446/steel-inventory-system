import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../controllers/purchase_controller.dart';
import '../controllers/product_controller.dart';
import '../models/purchase.dart';
import '../models/product.dart';
import '../widgets/summary_card.dart';
import '../core/theme_constants.dart';

class PurchasesView extends StatelessWidget {
  const PurchasesView({super.key});

  @override
  Widget build(BuildContext context) {
    final PurchaseController purchaseController =
        Get.find<PurchaseController>();
    final ProductController productController = Get.find<ProductController>();

    // Load data when view is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      purchaseController.loadPurchases();
      productController.loadProducts();
    });
    return Scaffold(
      backgroundColor: ThemeConstants.backgroundSecondary,
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
                      ThemeConstants.purchase,
                    ),
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      color: ThemeConstants.purchase,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Purchase Management',
                          style: ThemeConstants.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Manage your steel factory purchases',
                          style: ThemeConstants.bodySecondary,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showAddPurchaseDialog(context);
                    },
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text('Add Purchase'),
                    style: ThemeConstants.getModuleButtonStyle('purchase'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Content Section
            Expanded(
              child: Obx(() {
                if (purchaseController.isLoading.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: ThemeConstants.purchase,
                          strokeWidth: 3,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Loading purchases...',
                          style: ThemeConstants.bodyText,
                        ),
                      ],
                    ),
                  );
                }

                if (purchaseController.purchases.isEmpty &&
                    !purchaseController.isLoading.value) {
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.all(40),
                      decoration: ThemeConstants.elevatedCardDecoration
                          .copyWith(borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration:
                                ThemeConstants.getIconContainerDecoration(
                                  ThemeConstants.purchase,
                                ).copyWith(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                            child: Icon(
                              Icons.shopping_cart_outlined,
                              size: 48,
                              color: ThemeConstants.purchase,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'No purchases yet',
                            style: ThemeConstants.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start by adding your first purchase',
                            style: ThemeConstants.bodySecondary,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              _showAddPurchaseDialog(context);
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Add First Purchase'),
                            style: ThemeConstants.getModuleButtonStyle(
                              'purchase',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return _buildPurchaseContent(context);
              }),
            ),

            // Summary Cards at the bottom
            const SizedBox(height: 24),
            Obx(() {
              final PurchaseController purchaseController =
                  Get.find<PurchaseController>();
              return _buildSummaryCards(purchaseController);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPurchaseContent(BuildContext context) {
    final PurchaseController purchaseController =
        Get.find<PurchaseController>();
    return Column(
      children: [
        // Purchase Table
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
                    color: Colors.blue[50],
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
                        Icons.receipt_long,
                        color: Colors.blue[700],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Purchase History',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
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
                              'Date',
                              Icons.calendar_today_outlined,
                            ),
                          ),
                          DataColumn(
                            label: _buildColumnHeader(
                              'Invoice #',
                              Icons.receipt_outlined,
                            ),
                          ),
                          DataColumn(
                            label: _buildColumnHeader(
                              'Supplier',
                              Icons.business_outlined,
                            ),
                          ),
                          DataColumn(
                            label: _buildColumnHeader(
                              'Product',
                              Icons.inventory_2_outlined,
                            ),
                          ),
                          DataColumn(
                            label: _buildColumnHeader(
                              'Quantity',
                              Icons.scale_outlined,
                            ),
                          ),
                          DataColumn(
                            label: _buildColumnHeader(
                              'Unit Price',
                              Icons.attach_money_outlined,
                            ),
                          ),
                          DataColumn(
                            label: _buildColumnHeader(
                              'Total Amount',
                              Icons.account_balance_wallet_outlined,
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
                          purchaseController.purchases,
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

  Widget _buildSummaryCards(PurchaseController purchaseController) {
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
            title: 'Total Purchases',
            value: purchaseController.purchases.length.toString(),
            icon: Icons.shopping_cart_outlined,
            color: Colors.blue,
          ),
          const SizedBox(width: 16),
          SummaryCard(
            title: 'Total Amount',
            value:
                'PKR ${purchaseController.purchases.fold<double>(0.0, (sum, purchase) => sum + purchase.totalAmount).toStringAsFixed(0)}',
            icon: Icons.account_balance_wallet_outlined,
            color: Colors.green,
          ),
          const SizedBox(width: 16),
          SummaryCard(
            title: 'Completed',
            value: purchaseController.purchases
                .where((p) => p.status == 'completed')
                .length
                .toString(),
            icon: Icons.check_circle_outline,
            color: Colors.orange,
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

  Widget _buildDateCell(DateTime date) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(
          '${date.year}',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildInvoiceCell(String invoiceNumber) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        invoiceNumber,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.blue[700],
        ),
      ),
    );
  }

  Widget _buildSupplierCell(Purchase purchase) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          purchase.supplierName,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        Text(
          purchase.supplierContact,
          style: TextStyle(color: Colors.grey[600], fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildProductCell(Purchase purchase) {
    final ProductController productController = Get.find<ProductController>();
    final Product? product = productController.getProductById(
      purchase.productId,
    );
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

  Widget _buildQuantityCell(Purchase purchase) {
    final ProductController productController = Get.find<ProductController>();
    final Product? product = productController.getProductById(
      purchase.productId,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          purchase.quantity.toStringAsFixed(0),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(
          product?.unit ?? '',
          style: TextStyle(color: Colors.grey[600], fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildPriceCell(double price) {
    return Text(
      'PKR ${price.toStringAsFixed(2)}',
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
    );
  }

  Widget _buildTotalCell(double total) {
    return Text(
      'PKR ${total.toStringAsFixed(2)}',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Colors.green,
      ),
    );
  }

  Widget _buildStatusCell(String status) {
    final isCompleted = status == 'completed';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.green : Colors.orange,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCompleted ? Icons.check_circle : Icons.pending,
            color: Colors.white,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            status.toUpperCase(),
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
    List<Purchase> purchases,
  ) {
    return purchases.map((purchase) {
      return DataRow(
        cells: [
          DataCell(_buildDateCell(purchase.purchaseDate)),
          DataCell(_buildInvoiceCell(purchase.invoiceNumber)),
          DataCell(_buildSupplierCell(purchase)),
          DataCell(_buildProductCell(purchase)),
          DataCell(_buildQuantityCell(purchase)),
          DataCell(_buildPriceCell(purchase.unitPrice)),
          DataCell(_buildTotalCell(purchase.totalAmount)),
          DataCell(_buildStatusCell(purchase.status)),
          DataCell(_buildActionCell(context, purchase)),
        ],
      );
    }).toList();
  }

  Widget _buildActionCell(BuildContext context, Purchase purchase) {
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
              Get.snackbar(
                'Info',
                'Edit functionality will be implemented',
                backgroundColor: Colors.blue[50],
                colorText: Colors.blue[800],
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: Icon(Icons.delete_outline, size: 16, color: Colors.red[700]),
            onPressed: () {
              _showDeleteConfirmation(context, purchase);
            },
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, Purchase purchase) {
    final PurchaseController controller = Get.find<PurchaseController>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Purchase'),
        content: Text('Are you sure you want to delete this purchase?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await controller.deletePurchase(purchase.id);
              if (success) {
                Navigator.pop(context);
                Get.snackbar('Success', 'Purchase deleted successfully');
              } else {
                Get.snackbar('Error', controller.errorMessage.value);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddPurchaseDialog(BuildContext context) {
    final PurchaseController purchaseController =
        Get.find<PurchaseController>();
    final ProductController productController = Get.find<ProductController>();
    final supplierNameController = TextEditingController();
    final supplierContactController = TextEditingController();
    final quantityController = TextEditingController();
    final unitPriceController = TextEditingController();
    final invoiceNumberController = TextEditingController();

    // Auto-generate simple invoice number
    final now = DateTime.now();
    final invoiceNumber =
        'INV-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    invoiceNumberController.text = invoiceNumber;
    final notesController = TextEditingController();
    String? selectedProductId;
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add New Purchase',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 16),

                // Form Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Product Selection Section
                        _buildSectionHeader('Product Selection'),
                        const SizedBox(height: 16),
                        Obx(
                          () => DropdownButtonFormField<String>(
                            value: selectedProductId,
                            decoration: const InputDecoration(
                              labelText: 'Select Product *',
                              border: OutlineInputBorder(),
                              hintText: 'Choose a product to purchase',
                            ),
                            items: productController.products.isEmpty
                                ? [
                                    DropdownMenuItem(
                                      value: 'no-products',
                                      child: Text(
                                        'No products available - Add products first',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ]
                                : productController.products.map((product) {
                                    return DropdownMenuItem(
                                      value: product.id,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(product.name),
                                          Text(
                                            '${product.category} • ${product.unit}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                            onChanged: productController.products.isEmpty
                                ? null
                                : (value) {
                                    setState(() {
                                      selectedProductId = value;
                                    });
                                  },
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value == 'no-products') {
                                return 'Please select a product';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Supplier Information Section
                        _buildSectionHeader('Supplier Information'),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: supplierNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Supplier Name *',
                                  border: OutlineInputBorder(),
                                  hintText: 'e.g., ABC Steel Company',
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: supplierContactController,
                                decoration: const InputDecoration(
                                  labelText: 'Supplier Contact *',
                                  border: OutlineInputBorder(),
                                  hintText: 'Phone, Email, or Contact Person',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Purchase Details Section
                        _buildSectionHeader('Purchase Details'),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: quantityController,
                                decoration: const InputDecoration(
                                  labelText: 'Quantity *',
                                  border: OutlineInputBorder(),
                                  hintText: '100',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    // Trigger rebuild to update total amount display
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: unitPriceController,
                                decoration: const InputDecoration(
                                  labelText: 'Unit Price *',
                                  border: OutlineInputBorder(),
                                  hintText: '25.50',
                                  prefixText: 'PKR ',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    // Trigger rebuild to update total amount display
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Amount:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue[800],
                                ),
                              ),
                              Text(
                                'PKR ${((double.tryParse(quantityController.text) ?? 0.0) * (double.tryParse(unitPriceController.text) ?? 0.0)).toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Additional Information Section
                        _buildSectionHeader('Additional Information'),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: invoiceNumberController,
                                decoration: const InputDecoration(
                                  labelText: 'Invoice Number *',
                                  border: OutlineInputBorder(),
                                  hintText: 'Auto-generated invoice number',
                                  suffixIcon: Icon(Icons.edit, size: 20),
                                  helperText: 'Auto-generated, click to edit',
                                ),
                                readOnly: false,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: selectedDate,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime.now(),
                                  );
                                  if (date != null) {
                                    setState(() {
                                      selectedDate = date;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_today, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Purchase Date: ${selectedDate.toString().split(' ')[0]}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: notesController,
                          decoration: const InputDecoration(
                            labelText: 'Notes',
                            border: OutlineInputBorder(),
                            hintText: 'Additional notes about this purchase',
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),

                // Action Buttons
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () async {
                        // Validation
                        if (productController.products.isEmpty) {
                          Get.snackbar(
                            'Error',
                            'No products available. Please add products first.',
                          );
                          return;
                        }

                        if (selectedProductId == null ||
                            selectedProductId == 'no-products') {
                          Get.snackbar('Error', 'Please select a product');
                          return;
                        }

                        if (supplierNameController.text.isEmpty ||
                            supplierContactController.text.isEmpty ||
                            quantityController.text.isEmpty ||
                            unitPriceController.text.isEmpty ||
                            invoiceNumberController.text.isEmpty) {
                          Get.snackbar(
                            'Error',
                            'Please fill in all required fields (*)',
                          );
                          return;
                        }

                        final purchase = Purchase(
                          id: const Uuid().v4(),
                          productId: selectedProductId!,
                          supplierName: supplierNameController.text,
                          supplierContact: supplierContactController.text,
                          quantity:
                              double.tryParse(quantityController.text) ?? 0.0,
                          unitPrice:
                              double.tryParse(unitPriceController.text) ?? 0.0,
                          totalAmount:
                              (double.tryParse(quantityController.text) ??
                                  0.0) *
                              (double.tryParse(unitPriceController.text) ??
                                  0.0),
                          purchaseDate: selectedDate,
                          invoiceNumber: invoiceNumberController.text,
                          status: 'completed',
                          notes: notesController.text,
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                        );

                        final success = await purchaseController.addPurchase(
                          purchase,
                        );

                        if (success) {
                          Navigator.pop(context);
                          Get.snackbar(
                            'Success',
                            'Purchase added successfully',
                          );
                        } else {
                          Get.snackbar(
                            'Error',
                            purchaseController.errorMessage.value.isNotEmpty
                                ? purchaseController.errorMessage.value
                                : 'Failed to add purchase',
                          );
                        }
                      },
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text('Add Purchase'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.blue,
      ),
    );
  }
}
