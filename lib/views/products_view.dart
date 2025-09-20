import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../controllers/product_controller.dart';
import '../models/product.dart';
import '../widgets/summary_card.dart';
import '../core/theme_constants.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find<ProductController>();

    // Load data when view is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
                      ThemeConstants.products,
                    ),
                    child: Icon(
                      Icons.inventory_2_outlined,
                      color: ThemeConstants.products,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Products Management',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Manage your steel factory product catalog',
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
                      _showAddProductDialog(context);
                    },
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text('Add Product'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[600],
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
                if (productController.isLoading.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.purple[600],
                          strokeWidth: 3,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Loading products...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (productController.products.isEmpty &&
                    !productController.isLoading.value) {
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
                            color: Colors.purple[50],
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: Icon(
                            Icons.inventory_2_outlined,
                            size: 80,
                            color: Colors.purple[400],
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          'No products yet',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Add your first steel product to start building your catalog',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton.icon(
                          onPressed: () {
                            _showAddProductDialog(context);
                          },
                          icon: const Icon(Icons.add, size: 24),
                          label: const Text('Add First Product'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple[600],
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

                return _buildProductsContent(context);
              }),
            ),

            // Summary Cards at the bottom
            const SizedBox(height: 24),
            Obx(() {
              final ProductController productController =
                  Get.find<ProductController>();
              return _buildSummaryCards(productController);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsContent(BuildContext context) {
    final ProductController productController = Get.find<ProductController>();
    return Column(
      children: [
        // Products Table
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
                    color: Colors.purple[50],
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
                        Icons.list_alt_outlined,
                        color: Colors.purple[700],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Product Catalog',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple[800],
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
                              'Product Name',
                              Icons.inventory_2_outlined,
                            ),
                          ),
                          DataColumn(
                            label: _buildColumnHeader(
                              'Category',
                              Icons.category_outlined,
                            ),
                          ),
                          DataColumn(
                            label: _buildColumnHeader(
                              'Grade',
                              Icons.star_outline,
                            ),
                          ),
                          DataColumn(
                            label: _buildColumnHeader(
                              'Unit',
                              Icons.scale_outlined,
                            ),
                          ),
                          DataColumn(
                            label: _buildColumnHeader(
                              'Created',
                              Icons.calendar_today_outlined,
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
                          productController.products,
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

  Widget _buildSummaryCards(ProductController productController) {
    final categories = productController.products
        .map((p) => p.category)
        .toSet()
        .length;
    final recentProducts = productController.products
        .where(
          (p) => p.createdAt.isAfter(
            DateTime.now().subtract(const Duration(days: 30)),
          ),
        )
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
            title: 'Total Products',
            value: productController.products.length.toString(),
            icon: Icons.inventory_2_outlined,
            color: Colors.purple,
          ),
          const SizedBox(width: 16),
          SummaryCard(
            title: 'Categories',
            value: categories.toString(),
            icon: Icons.category_outlined,
            color: Colors.blue,
          ),
          const SizedBox(width: 16),
          SummaryCard(
            title: 'Recent (30d)',
            value: recentProducts.toString(),
            icon: Icons.new_releases_outlined,
            color: Colors.green,
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

  Widget _buildProductNameCell(Product product) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        if (product.description.isNotEmpty)
          Text(
            product.description,
            style: TextStyle(color: Colors.grey[600], fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }

  Widget _buildCategoryCell(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.purple[700],
        ),
      ),
    );
  }

  Widget _buildGradeCell(String grade) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        grade,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.orange[700],
        ),
      ),
    );
  }

  Widget _buildUnitCell(String unit) {
    return Text(
      unit,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
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

  List<DataRow> _buildDataTableRows(
    BuildContext context,
    List<Product> products,
  ) {
    return products.map((product) {
      return DataRow(
        cells: [
          DataCell(_buildProductNameCell(product)),
          DataCell(_buildCategoryCell(product.category)),
          DataCell(_buildGradeCell(product.grade)),
          DataCell(_buildUnitCell(product.unit)),
          DataCell(_buildDateCell(product.createdAt)),
          DataCell(_buildActionCell(context, product)),
        ],
      );
    }).toList();
  }

  Widget _buildActionCell(BuildContext context, Product product) {
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
              _showEditProductDialog(context, product);
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
              _showDeleteConfirmation(context, product);
            },
          ),
        ),
      ],
    );
  }

  void _showAddProductDialog(BuildContext context) {
    final ProductController controller = Get.find<ProductController>();
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final categoryController = TextEditingController();
    final unitController = TextEditingController();
    final weightController = TextEditingController();
    final lengthController = TextEditingController();
    final widthController = TextEditingController();
    final thicknessController = TextEditingController();
    final gradeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
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
                    'Add New Steel Product',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                      // Basic Information Section
                      _buildSectionHeader('Basic Information'),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                labelText: 'Product Name *',
                                border: OutlineInputBorder(),
                                hintText: 'e.g., I-Beam 200x100x5.5',
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: categoryController,
                              decoration: const InputDecoration(
                                labelText: 'Category *',
                                border: OutlineInputBorder(),
                                hintText: 'e.g., Beams, Plates, Bars',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                          hintText: 'Product description and specifications',
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 24),

                      // Physical Properties Section
                      _buildSectionHeader('Physical Properties'),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: weightController,
                              decoration: const InputDecoration(
                                labelText: 'Weight (kg)',
                                border: OutlineInputBorder(),
                                hintText: '25.5',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: lengthController,
                              decoration: const InputDecoration(
                                labelText: 'Length (mm)',
                                border: OutlineInputBorder(),
                                hintText: '6000',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: widthController,
                              decoration: const InputDecoration(
                                labelText: 'Width (mm)',
                                border: OutlineInputBorder(),
                                hintText: '200',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: thicknessController,
                              decoration: const InputDecoration(
                                labelText: 'Thickness (mm)',
                                border: OutlineInputBorder(),
                                hintText: '5.5',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Specifications Section
                      _buildSectionHeader('Specifications'),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: unitController.text.isEmpty
                                  ? null
                                  : unitController.text,
                              decoration: const InputDecoration(
                                labelText: 'Unit *',
                                border: OutlineInputBorder(),
                                hintText: 'Select unit',
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'pieces',
                                  child: Text('Pieces'),
                                ),
                                DropdownMenuItem(
                                  value: 'kg',
                                  child: Text('Kilograms (kg)'),
                                ),
                                DropdownMenuItem(
                                  value: 'tons',
                                  child: Text('Tons'),
                                ),
                                DropdownMenuItem(
                                  value: 'sqm',
                                  child: Text('Square Meters (sqm)'),
                                ),
                                DropdownMenuItem(
                                  value: 'cbm',
                                  child: Text('Cubic Meters (cbm)'),
                                ),
                                DropdownMenuItem(
                                  value: 'meters',
                                  child: Text('Meters'),
                                ),
                                DropdownMenuItem(
                                  value: 'feet',
                                  child: Text('Feet'),
                                ),
                                DropdownMenuItem(
                                  value: 'inches',
                                  child: Text('Inches'),
                                ),
                                DropdownMenuItem(
                                  value: 'sheets',
                                  child: Text('Sheets'),
                                ),
                                DropdownMenuItem(
                                  value: 'rolls',
                                  child: Text('Rolls'),
                                ),
                                DropdownMenuItem(
                                  value: 'bundles',
                                  child: Text('Bundles'),
                                ),
                                DropdownMenuItem(
                                  value: 'coils',
                                  child: Text('Coils'),
                                ),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  unitController.text = value;
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a unit';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: gradeController,
                              decoration: const InputDecoration(
                                labelText: 'Grade *',
                                border: OutlineInputBorder(),
                                hintText: 'S275, S355, B500C',
                              ),
                            ),
                          ),
                        ],
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
                      if (nameController.text.isEmpty ||
                          categoryController.text.isEmpty ||
                          unitController.text.isEmpty ||
                          gradeController.text.isEmpty) {
                        Get.snackbar(
                          'Error',
                          'Please fill in all required fields (*)',
                        );
                        return;
                      }

                      final product = Product(
                        id: const Uuid().v4(),
                        name: nameController.text,
                        description: descriptionController.text,
                        category: categoryController.text,
                        unit: unitController.text,
                        weight: double.tryParse(weightController.text),
                        length: double.tryParse(lengthController.text),
                        width: double.tryParse(widthController.text),
                        thickness: double.tryParse(thicknessController.text),
                        grade: gradeController.text,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      );

                      final success = await controller.addProduct(product);
                      if (success) {
                        Navigator.pop(context);
                        Get.snackbar('Success', 'Product added successfully');
                      } else {
                        Get.snackbar(
                          'Error',
                          controller.errorMessage.value.isNotEmpty
                              ? controller.errorMessage.value
                              : 'Failed to add product',
                        );
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Product'),
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

  void _showEditProductDialog(BuildContext context, Product product) {
    // Similar to add dialog but with pre-filled values
    Get.snackbar('Info', 'Edit functionality will be implemented');
  }

  void _showDeleteConfirmation(BuildContext context, Product product) {
    final ProductController controller = Get.find<ProductController>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await controller.deleteProduct(product.id);
              if (success) {
                Navigator.pop(context);
                Get.snackbar('Success', 'Product deleted successfully');
              } else {
                Get.snackbar(
                  'Error',
                  controller.errorMessage.value.isNotEmpty
                      ? controller.errorMessage.value
                      : 'Failed to add product',
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
