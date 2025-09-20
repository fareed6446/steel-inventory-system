import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/parties_controller.dart';
import '../models/party.dart';
import '../core/theme_constants.dart';
import 'party_details_view.dart';

class PartiesView extends StatelessWidget {
  const PartiesView({super.key});

  @override
  Widget build(BuildContext context) {
    final PartiesController partiesController = Get.find<PartiesController>();

    // Load data when view is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      partiesController.loadParties();
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
                      ThemeConstants.primary,
                    ),
                    child: Icon(
                      Icons.people_outline,
                      color: ThemeConstants.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Parties Management',
                          style: ThemeConstants.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Manage suppliers and customers with transaction history',
                          style: ThemeConstants.bodySecondary,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showAddPartyDialog(context);
                    },
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text('Add Party'),
                    style: ThemeConstants.primaryButtonStyle,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Filters and Search
            Container(
              padding: ThemeConstants.cardPadding,
              decoration: ThemeConstants.cardDecoration,
              child: Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => DropdownButtonFormField<String>(
                        value: partiesController.selectedPartyType.value,
                        decoration: ThemeConstants.inputDecoration.copyWith(
                          labelText: 'Filter by Type',
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'all',
                            child: Text('All Parties'),
                          ),
                          DropdownMenuItem(
                            value: 'supplier',
                            child: Text('Suppliers'),
                          ),
                          DropdownMenuItem(
                            value: 'customer',
                            child: Text('Customers'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            partiesController.setPartyTypeFilter(value);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      decoration: ThemeConstants.inputDecoration.copyWith(
                        labelText: 'Search parties',
                        hintText: 'Search by name, email, or phone',
                        prefixIcon: const Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        partiesController.setSearchQuery(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Summary Cards
            Obx(() => _buildSummaryCards(partiesController)),
            const SizedBox(height: 24),

            // Content Section
            Expanded(
              child: Obx(() {
                if (partiesController.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: ThemeConstants.primary,
                    ),
                  );
                }

                final filteredParties = partiesController.filteredParties;

                if (filteredParties.isEmpty) {
                  return _buildEmptyState(context, partiesController);
                }

                return _buildPartiesTable(
                  context,
                  partiesController,
                  filteredParties,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(PartiesController controller) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: ThemeConstants.cardPadding,
            decoration: ThemeConstants.cardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.business_outlined,
                      color: ThemeConstants.purchase,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text('Suppliers', style: ThemeConstants.titleSmall),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${controller.suppliersCount}',
                  style: ThemeConstants.titleLarge.copyWith(
                    color: ThemeConstants.purchase,
                  ),
                ),
                Text(
                  'PKR ${controller.totalSuppliersBalance.toStringAsFixed(0)}',
                  style: ThemeConstants.bodySecondary,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: ThemeConstants.cardPadding,
            decoration: ThemeConstants.cardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      color: ThemeConstants.sales,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text('Customers', style: ThemeConstants.titleSmall),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${controller.customersCount}',
                  style: ThemeConstants.titleLarge.copyWith(
                    color: ThemeConstants.sales,
                  ),
                ),
                Text(
                  'PKR ${controller.totalCustomersBalance.toStringAsFixed(0)}',
                  style: ThemeConstants.bodySecondary,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: ThemeConstants.cardPadding,
            decoration: ThemeConstants.cardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      color: ThemeConstants.stock,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text('Total Balance', style: ThemeConstants.titleSmall),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'PKR ${(controller.totalSuppliersBalance + controller.totalCustomersBalance).toStringAsFixed(0)}',
                  style: ThemeConstants.titleLarge.copyWith(
                    color: ThemeConstants.stock,
                  ),
                ),
                Text('Net position', style: ThemeConstants.bodySecondary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, PartiesController controller) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: ThemeConstants.elevatedCardDecoration.copyWith(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: ThemeConstants.getIconContainerDecoration(
                ThemeConstants.primary,
              ).copyWith(borderRadius: BorderRadius.circular(50)),
              child: Icon(
                Icons.people_outline,
                size: 48,
                color: ThemeConstants.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text('No parties found', style: ThemeConstants.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Start by adding your first supplier or customer',
              style: ThemeConstants.bodySecondary,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                _showAddPartyDialog(context);
              },
              icon: const Icon(Icons.add),
              label: const Text('Add First Party'),
              style: ThemeConstants.primaryButtonStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartiesTable(
    BuildContext context,
    PartiesController controller,
    List<Party> parties,
  ) {
    return Container(
      decoration: ThemeConstants.cardDecoration,
      child: SingleChildScrollView(
        // scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width - 280,
          ),
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(
              ThemeConstants.background,
            ),
            dataRowHeight: 50,
            columnSpacing: 10,
            horizontalMargin: 10,
            columns: [
              DataColumn(
                label: _buildColumnHeader('Party Name'),
                numeric: false,
              ),
              DataColumn(label: _buildColumnHeader('Type'), numeric: false),
              DataColumn(label: _buildColumnHeader('Category'), numeric: false),
              DataColumn(label: _buildColumnHeader('Contact'), numeric: false),
              DataColumn(label: _buildColumnHeader('Balance'), numeric: true),
              DataColumn(
                label: _buildColumnHeader('Transactions'),
                numeric: true,
              ),
              DataColumn(label: _buildColumnHeader('Status'), numeric: false),
              DataColumn(label: _buildColumnHeader('Actions'), numeric: false),
            ],
            rows: parties.map((party) {
              final balance = controller.getBalanceForParty(party.id);
              final transactions = controller.getTransactionsForParty(party.id);

              return DataRow(
                cells: [
                  DataCell(
                    _buildPartyNameCell(context, party),
                    showEditIcon: false,
                  ),
                  DataCell(_buildTypeCell(party), showEditIcon: false),
                  DataCell(_buildCategoryCell(party), showEditIcon: false),
                  DataCell(_buildContactCell(party), showEditIcon: false),
                  DataCell(_buildBalanceCell(balance), showEditIcon: false),
                  DataCell(
                    _buildTransactionCountCell(transactions.length),
                    showEditIcon: false,
                  ),
                  DataCell(_buildStatusCell(party), showEditIcon: false),
                  DataCell(
                    _buildActionCell(context, controller, party),
                    showEditIcon: false,
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildColumnHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: ThemeConstants.caption.copyWith(
          fontWeight: FontWeight.bold,
          color: ThemeConstants.textSecondary,
        ),
      ),
    );
  }

  Widget _buildPartyNameCell(BuildContext context, Party party) {
    return SizedBox(
      // width: 180,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PartyDetailsView(party: party),
          ),
        ),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                party.name,
                style: ThemeConstants.bodyText.copyWith(
                  fontWeight: FontWeight.w600,
                  color: ThemeConstants.primary,
                ),
                maxLines: 1,
                // overflow: TextOverflow.ellipsis,
              ),
              if (party.address != null) ...[
                const SizedBox(height: 2),
                Text(
                  party.address!,
                  style: ThemeConstants.caption,
                  maxLines: 1,
                  // overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeCell(Party party) {
    return SizedBox(
      // width: 100,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: party.type == 'supplier'
              ? ThemeConstants.purchase.withOpacity(0.1)
              : ThemeConstants.sales.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: party.type == 'supplier'
                ? ThemeConstants.purchase
                : ThemeConstants.sales,
            width: 1,
          ),
        ),
        child: Text(
          party.type.toUpperCase(),
          style: ThemeConstants.caption.copyWith(
            color: party.type == 'supplier'
                ? ThemeConstants.purchase
                : ThemeConstants.sales,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildCategoryCell(Party party) {
    return SizedBox(
      // width: 100,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            party.partyCategory == 'company'
                ? Icons.business_outlined
                : Icons.person_outline,
            size: 16,
            color: ThemeConstants.textSecondary,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              party.partyCategory == 'company' ? 'Company' : 'Person',
              style: ThemeConstants.caption,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCell(Party party) {
    return SizedBox(
      // width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (party.email != null) ...[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.email_outlined,
                  size: 14,
                  color: ThemeConstants.textSecondary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    party.email!,
                    style: ThemeConstants.caption,
                    maxLines: 1,
                    // overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          if (party.phone != null) ...[
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.phone_outlined,
                  size: 14,
                  color: ThemeConstants.textSecondary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    party.phone!,
                    style: ThemeConstants.caption,
                    maxLines: 1,
                    // overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          if (party.email == null && party.phone == null)
            Text(
              'No contact info',
              style: ThemeConstants.caption.copyWith(
                color: ThemeConstants.textTertiary,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBalanceCell(PartyBalance? balance) {
    if (balance == null) {
      return SizedBox(
        width: 200,
        child: Text(
          'PKR 0',
          style: ThemeConstants.bodyText.copyWith(
            color: ThemeConstants.textTertiary,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    final isPositive = balance.currentBalance >= 0;
    return SizedBox(
      width: 200,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isPositive
              ? Colors.green.withOpacity(0.1)
              : Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'PKR ${balance.currentBalance.toStringAsFixed(0)}',
          style: ThemeConstants.bodyText.copyWith(
            color: isPositive ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildTransactionCountCell(int count) {
    return SizedBox(
      width: 80,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: ThemeConstants.backgroundTertiary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '$count',
          style: ThemeConstants.bodyText.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildStatusCell(Party party) {
    return SizedBox(
      width: 80,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: party.isActive
              ? Colors.green.withOpacity(0.1)
              : Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          party.isActive ? 'Active' : 'Inactive',
          style: ThemeConstants.caption.copyWith(
            color: party.isActive ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildActionCell(
    BuildContext context,
    PartiesController controller,
    Party party,
  ) {
    return SizedBox(
      width: 120,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PartyDetailsView(party: party),
              ),
            ),
            icon: const Icon(Icons.visibility_outlined),
            color: ThemeConstants.textSecondary,
            tooltip: 'View Details',
            iconSize: 24,
          ),
          IconButton(
            onPressed: () => _showPaymentDialog(context, controller, party),
            icon: const Icon(Icons.payment_outlined),
            color: ThemeConstants.textSecondary,
            tooltip: 'Add Payment',
            iconSize: 24,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  _showEditPartyDialog(context, controller, party);
                  break;
                case 'delete':
                  _showDeleteConfirmation(context, controller, party);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined),
                    SizedBox(width: 8),
                    Text('Edit Party'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline),
                    SizedBox(width: 8),
                    Text('Delete'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddPartyDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    final cityController = TextEditingController();
    final countryController = TextEditingController();
    final taxNumberController = TextEditingController();
    final registrationNumberController = TextEditingController();
    final contactPersonController = TextEditingController();
    final notesController = TextEditingController();
    final openingBalanceController = TextEditingController();

    String selectedType = 'customer';
    String selectedCategory = 'company';
    String selectedCurrency = 'PKR';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add New Party'),
          content: SizedBox(
            width: 600,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Basic Information
                    Text('Basic Information', style: ThemeConstants.titleSmall),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: nameController,
                            decoration: ThemeConstants.inputDecoration.copyWith(
                              labelText: 'Party Name *',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Party name is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedType,
                            decoration: ThemeConstants.inputDecoration.copyWith(
                              labelText: 'Type *',
                            ),
                            items: [
                              DropdownMenuItem(
                                value: 'supplier',
                                child: Text('Supplier'),
                              ),
                              DropdownMenuItem(
                                value: 'customer',
                                child: Text('Customer'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedType = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedCategory,
                            decoration: ThemeConstants.inputDecoration.copyWith(
                              labelText: 'Category *',
                            ),
                            items: [
                              DropdownMenuItem(
                                value: 'company',
                                child: Text('Company'),
                              ),
                              DropdownMenuItem(
                                value: 'person',
                                child: Text('Person'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedCategory = value!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: emailController,
                            decoration: ThemeConstants.inputDecoration.copyWith(
                              labelText: 'Email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: phoneController,
                            decoration: ThemeConstants.inputDecoration.copyWith(
                              labelText: 'Phone',
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: cityController,
                            decoration: ThemeConstants.inputDecoration.copyWith(
                              labelText: 'City',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: addressController,
                      decoration: ThemeConstants.inputDecoration.copyWith(
                        labelText: 'Address',
                      ),
                      maxLines: 2,
                    ),

                    const SizedBox(height: 24),
                    Text(
                      'Business Information',
                      style: ThemeConstants.titleSmall,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: taxNumberController,
                            decoration: ThemeConstants.inputDecoration.copyWith(
                              labelText: 'Tax Number',
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: registrationNumberController,
                            decoration: ThemeConstants.inputDecoration.copyWith(
                              labelText: 'Registration Number',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: contactPersonController,
                      decoration: ThemeConstants.inputDecoration.copyWith(
                        labelText: 'Contact Person',
                      ),
                    ),

                    const SizedBox(height: 24),
                    Text(
                      'Financial Information',
                      style: ThemeConstants.titleSmall,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: openingBalanceController,
                            decoration: ThemeConstants.inputDecoration.copyWith(
                              labelText: 'Opening Balance',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedCurrency,
                            decoration: ThemeConstants.inputDecoration.copyWith(
                              labelText: 'Currency',
                            ),
                            items: ['PKR', 'USD', 'EUR', 'GBP', 'INR']
                                .map(
                                  (currency) => DropdownMenuItem(
                                    value: currency,
                                    child: Text(currency),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCurrency = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: notesController,
                      decoration: ThemeConstants.inputDecoration.copyWith(
                        labelText: 'Notes',
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final party = Party(
                    name: nameController.text,
                    type: selectedType,
                    partyCategory: selectedCategory,
                    email: emailController.text.isNotEmpty
                        ? emailController.text
                        : null,
                    phone: phoneController.text.isNotEmpty
                        ? phoneController.text
                        : null,
                    address: addressController.text.isNotEmpty
                        ? addressController.text
                        : null,
                    city: cityController.text.isNotEmpty
                        ? cityController.text
                        : null,
                    country: countryController.text.isNotEmpty
                        ? countryController.text
                        : null,
                    taxNumber: taxNumberController.text.isNotEmpty
                        ? taxNumberController.text
                        : null,
                    registrationNumber:
                        registrationNumberController.text.isNotEmpty
                        ? registrationNumberController.text
                        : null,
                    contactPerson: contactPersonController.text.isNotEmpty
                        ? contactPersonController.text
                        : null,
                    notes: notesController.text.isNotEmpty
                        ? notesController.text
                        : null,
                    openingBalance:
                        double.tryParse(openingBalanceController.text) ?? 0.0,
                    currency: selectedCurrency,
                  );

                  Get.find<PartiesController>().addParty(party);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add Party'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditPartyDialog(
    BuildContext context,
    PartiesController controller,
    Party party,
  ) {
    // Similar to add dialog but pre-filled with party data
    // Implementation would be similar to _showAddPartyDialog
    Get.snackbar(
      'Info',
      'Edit party functionality coming soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showPaymentDialog(
    BuildContext context,
    PartiesController controller,
    Party party,
  ) {
    final formKey = GlobalKey<FormState>();
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    final invoiceNumberController = TextEditingController();
    final notesController = TextEditingController();

    String paymentType = party.type == 'supplier'
        ? 'payment_made'
        : 'payment_received';

    // Get current balance for reference
    final balance = controller.getBalanceForParty(party.id);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.payment_outlined,
                color: ThemeConstants.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(child: Text('Add Payment - ${party.name}')),
            ],
          ),
          content: SizedBox(
            width: 500,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Party Info Card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ThemeConstants.backgroundTertiary,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: party.type == 'supplier'
                              ? ThemeConstants.purchase
                              : ThemeConstants.sales,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            party.partyCategory == 'company'
                                ? Icons.business_outlined
                                : Icons.person_outline,
                            color: party.type == 'supplier'
                                ? ThemeConstants.purchase
                                : ThemeConstants.sales,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  party.name,
                                  style: ThemeConstants.bodyText.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  party.type.toUpperCase(),
                                  style: ThemeConstants.caption.copyWith(
                                    color: party.type == 'supplier'
                                        ? ThemeConstants.purchase
                                        : ThemeConstants.sales,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (balance != null) ...[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Current Balance',
                                  style: ThemeConstants.caption,
                                ),
                                Text(
                                  'PKR ${balance.currentBalance.toStringAsFixed(0)}',
                                  style: ThemeConstants.bodyText.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: balance.currentBalance >= 0
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Payment Type
                    Text('Payment Type', style: ThemeConstants.titleSmall),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: paymentType,
                      decoration: ThemeConstants.inputDecoration.copyWith(
                        labelText: 'Select Payment Type',
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'payment_received',
                          child: Row(
                            children: [
                              Icon(
                                Icons.arrow_downward,
                                color: Colors.green,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text('Payment Received'),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'payment_made',
                          child: Row(
                            children: [
                              Icon(
                                Icons.arrow_upward,
                                color: Colors.red,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text('Payment Made'),
                            ],
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          paymentType = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Amount
                    Text('Amount', style: ThemeConstants.titleSmall),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: amountController,
                      decoration: ThemeConstants.inputDecoration.copyWith(
                        labelText: 'Amount in PKR *',
                        prefixText: 'PKR ',
                      ),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Amount is required';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Invalid amount';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Amount must be greater than 0';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Description
                    Text('Description', style: ThemeConstants.titleSmall),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: descriptionController,
                      decoration: ThemeConstants.inputDecoration.copyWith(
                        labelText: 'Payment Description *',
                        hintText:
                            'e.g., Payment for steel rods, Monthly payment, etc.',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Description is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Invoice Number
                    Text(
                      'Reference Information',
                      style: ThemeConstants.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: invoiceNumberController,
                      decoration: ThemeConstants.inputDecoration.copyWith(
                        labelText: 'Invoice/Reference Number',
                        hintText: 'Optional reference number',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Notes
                    TextFormField(
                      controller: notesController,
                      decoration: ThemeConstants.inputDecoration.copyWith(
                        labelText: 'Additional Notes',
                        hintText:
                            'Any additional information about this payment',
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  controller.addPaymentTransaction(
                    partyId: party.id,
                    amount: double.parse(amountController.text),
                    type: paymentType,
                    description: descriptionController.text,
                    invoiceNumber: invoiceNumberController.text.isNotEmpty
                        ? invoiceNumberController.text
                        : null,
                    notes: notesController.text.isNotEmpty
                        ? notesController.text
                        : null,
                  );
                  Navigator.of(context).pop();
                }
              },
              icon: const Icon(Icons.payment, size: 18),
              label: const Text('Add Payment'),
              style: ThemeConstants.primaryButtonStyle,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    PartiesController controller,
    Party party,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Party'),
        content: Text(
          'Are you sure you want to delete "${party.name}"? This action cannot be undone and will also delete all related transactions.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteParty(party.id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
