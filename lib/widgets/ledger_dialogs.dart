import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/ledger_controller.dart';
import '../models/ledger_person.dart';
import '../models/ledger_transaction.dart';
import '../core/theme_constants.dart';

/// Collection of dialogs for the Ledger System
class LedgerDialogs {
  // ============================================================================
  // ADD PERSON DIALOG
  // ============================================================================

  static void showAddPersonDialog(
    BuildContext context,
    LedgerController controller,
  ) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final openingBalanceController = TextEditingController(text: '0');
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();

    String selectedBusinessType = 'customer';
    String selectedCurrency = 'PKR';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.person_add, color: ThemeConstants.primary),
              const SizedBox(width: 8),
              const Text('Add New Person'),
            ],
          ),
          content: SizedBox(
            width: 500,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Basic Information
                    Text('Basic Information', style: ThemeConstants.titleSmall),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: nameController,
                      decoration: ThemeConstants.inputDecoration.copyWith(
                        labelText: 'Person/Company Name *',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedBusinessType,
                            decoration: ThemeConstants.inputDecoration.copyWith(
                              labelText: 'Business Type *',
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'customer',
                                child: Text('Customer'),
                              ),
                              DropdownMenuItem(
                                value: 'supplier',
                                child: Text('Supplier'),
                              ),
                              DropdownMenuItem(
                                value: 'both',
                                child: Text('Both'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedBusinessType = value!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedCurrency,
                            decoration: ThemeConstants.inputDecoration.copyWith(
                              labelText: 'Currency',
                            ),
                            items: ['PKR', 'USD', 'EUR', 'GBP']
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
                      controller: openingBalanceController,
                      decoration: ThemeConstants.inputDecoration.copyWith(
                        labelText: 'Opening Balance',
                      ),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (double.tryParse(value) == null) {
                            return 'Invalid amount';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Contact Information
                    Text(
                      'Contact Information',
                      style: ThemeConstants.titleSmall,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: emailController,
                      decoration: ThemeConstants.inputDecoration.copyWith(
                        labelText: 'Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: phoneController,
                      decoration: ThemeConstants.inputDecoration.copyWith(
                        labelText: 'Phone',
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: addressController,
                      decoration: ThemeConstants.inputDecoration.copyWith(
                        labelText: 'Address',
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
                  final person = LedgerPerson(
                    name: nameController.text.trim(),
                    openingBalance:
                        double.tryParse(openingBalanceController.text) ?? 0.0,
                    currency: selectedCurrency,
                    businessType: selectedBusinessType,
                    contactInfo: {
                      if (emailController.text.isNotEmpty)
                        'email': emailController.text.trim(),
                      if (phoneController.text.isNotEmpty)
                        'phone': phoneController.text.trim(),
                      if (addressController.text.isNotEmpty)
                        'address': addressController.text.trim(),
                    },
                  );

                  controller.addPerson(person);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add Person'),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // ADD TRANSACTION DIALOG
  // ============================================================================

  static void showAddTransactionDialog(
    BuildContext context,
    LedgerController controller,
  ) {
    if (controller.selectedPerson.value == null) return;

    final formKey = GlobalKey<FormState>();
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    final referenceController = TextEditingController();

    String selectedType = 'sale';
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.receipt_long, color: ThemeConstants.primary),
              const SizedBox(width: 8),
              Text(
                'Add Transaction - ${controller.selectedPerson.value!.name}',
              ),
            ],
          ),
          content: SizedBox(
            width: 500,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Transaction Type
                    Text(
                      'Transaction Details',
                      style: ThemeConstants.titleSmall,
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedType,
                            decoration: ThemeConstants.inputDecoration.copyWith(
                              labelText: 'Transaction Type *',
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'sale',
                                child: Text('Sale'),
                              ),
                              DropdownMenuItem(
                                value: 'purchase',
                                child: Text('Purchase'),
                              ),
                              DropdownMenuItem(
                                value: 'payment_received',
                                child: Text('Payment Received'),
                              ),
                              DropdownMenuItem(
                                value: 'payment_given',
                                child: Text('Payment Given'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedType = value!;
                              });
                            },
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: ThemeConstants.borderLight,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 16,
                                    color: ThemeConstants.textSecondary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    DateFormat(
                                      'dd/MM/yyyy',
                                    ).format(selectedDate),
                                    style: ThemeConstants.bodyText,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: amountController,
                      decoration: ThemeConstants.inputDecoration.copyWith(
                        labelText: 'Amount *',
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

                    TextFormField(
                      controller: descriptionController,
                      decoration: ThemeConstants.inputDecoration.copyWith(
                        labelText: 'Description *',
                        hintText: 'Enter transaction description',
                      ),
                      maxLines: 2,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Description is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: referenceController,
                      decoration: ThemeConstants.inputDecoration.copyWith(
                        labelText: 'Reference Number',
                        hintText: 'Invoice number, receipt number, etc.',
                      ),
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
                  final transaction = LedgerTransaction(
                    personId: controller.selectedPerson.value!.id,
                    type: selectedType,
                    amount: double.parse(amountController.text),
                    description: descriptionController.text.trim(),
                    referenceNumber: referenceController.text.trim().isEmpty
                        ? null
                        : referenceController.text.trim(),
                    transactionDate: selectedDate,
                  );

                  controller.addTransaction(transaction);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add Transaction'),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // EDIT PERSON DIALOG
  // ============================================================================

  static void showEditPersonDialog(
    BuildContext context,
    LedgerController controller,
    PersonSummary person,
  ) {
    // TODO: Implement edit person dialog
    Get.snackbar(
      'Info',
      'Edit person dialog coming soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // ============================================================================
  // EDIT TRANSACTION DIALOG
  // ============================================================================

  static void showEditTransactionDialog(
    BuildContext context,
    LedgerController controller,
    LedgerEntry entry,
  ) {
    // TODO: Implement edit transaction dialog
    Get.snackbar(
      'Info',
      'Edit transaction dialog coming soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // ============================================================================
  // DELETE CONFIRMATION DIALOGS
  // ============================================================================

  static void showDeletePersonDialog(
    BuildContext context,
    LedgerController controller,
    PersonSummary person,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Person'),
        content: Text(
          'Are you sure you want to delete "${person.name}"? This action cannot be undone and will also delete all related transactions.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deletePerson(person.id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  static void showDeleteTransactionDialog(
    BuildContext context,
    LedgerController controller,
    LedgerEntry entry,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: Text(
          'Are you sure you want to delete this transaction? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteTransaction(entry.transactionId);
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
