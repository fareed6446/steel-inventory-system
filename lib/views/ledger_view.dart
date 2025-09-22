import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/ledger_controller.dart';
import '../models/ledger_person.dart';
import '../models/ledger_transaction.dart';
import '../core/theme_constants.dart';
import '../widgets/ledger_dialogs.dart';

class LedgerView extends StatelessWidget {
  const LedgerView({super.key});

  @override
  Widget build(BuildContext context) {
    final LedgerController controller = Get.find<LedgerController>();

    return Scaffold(
      backgroundColor: ThemeConstants.backgroundSecondary,
      body: Padding(
        padding: ThemeConstants.sectionPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Sidebar - Persons List
            _buildPersonsSidebar(context, controller),

            const SizedBox(width: 16),

            // Right Content - Ledger Details
            Expanded(child: _buildLedgerContent(context, controller)),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonsSidebar(
    BuildContext context,
    LedgerController controller,
  ) {
    return Container(
      width: 350,
      decoration: ThemeConstants.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: ThemeConstants.cardPadding,
            decoration: BoxDecoration(
              color: ThemeConstants.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: ThemeConstants.getIconContainerDecoration(
                    ThemeConstants.primary,
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_outlined,
                    color: ThemeConstants.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ledger System', style: ThemeConstants.titleMedium),
                      Text('Account Statements', style: ThemeConstants.caption),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _showAddPersonDialog(context, controller),
                  icon: const Icon(Icons.add, size: 20),
                  tooltip: 'Add New Person',
                ),
              ],
            ),
          ),

          // Search and Filter
          Padding(
            padding: ThemeConstants.cardPadding,
            child: Column(
              children: [
                // Search Field
                TextField(
                  decoration: ThemeConstants.inputDecoration.copyWith(
                    labelText: 'Search persons',
                    hintText: 'Search by name...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  onChanged: controller.setSearchQuery,
                ),
                const SizedBox(height: 12),

                // Business Type Filter
                Obx(
                  () => DropdownButtonFormField<String>(
                    value: controller.selectedBusinessType.value,
                    decoration: ThemeConstants.inputDecoration.copyWith(
                      labelText: 'Filter by Type',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('All Types')),
                      DropdownMenuItem(
                        value: 'customer',
                        child: Text('Customers'),
                      ),
                      DropdownMenuItem(
                        value: 'supplier',
                        child: Text('Suppliers'),
                      ),
                      DropdownMenuItem(value: 'both', child: Text('Both')),
                    ],
                    onChanged: (value) =>
                        controller.setBusinessTypeFilter(value!),
                  ),
                ),
              ],
            ),
          ),

          // Summary Stats
          Obx(() => _buildSummaryStats(controller)),

          // Persons List
          Expanded(
            child: Obx(() {
              if (controller.isLoadingPersons.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final filteredPersons = controller.filteredPersons;

              if (filteredPersons.isEmpty) {
                return _buildEmptyPersonsState(context, controller);
              }

              return ListView.builder(
                itemCount: filteredPersons.length,
                itemBuilder: (context, index) {
                  final person = filteredPersons[index];

                  return Obx(() {
                    final isSelected =
                        controller.selectedPerson.value?.id == person.id;

                    return _buildPersonListItem(
                      context,
                      controller,
                      person,
                      isSelected,
                    );
                  });
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStats(LedgerController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeConstants.backgroundTertiary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ThemeConstants.borderLight),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Persons:', style: ThemeConstants.caption),
              Text(
                '${controller.totalPersonsCount}',
                style: ThemeConstants.bodyText.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Outstanding:', style: ThemeConstants.caption),
              Text(
                'PKR ${controller.totalOutstandingBalance.toStringAsFixed(0)}',
                style: ThemeConstants.bodyText.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Debt:', style: ThemeConstants.caption),
              Text(
                'PKR ${controller.totalDebt.toStringAsFixed(0)}',
                style: ThemeConstants.bodyText.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPersonListItem(
    BuildContext context,
    LedgerController controller,
    PersonSummary person,
    bool isSelected,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? ThemeConstants.primary.withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? ThemeConstants.primary : Colors.transparent,
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: person.isSupplier && person.isCustomer
              ? Colors.orange.withOpacity(0.2)
              : person.isSupplier
              ? ThemeConstants.purchase.withOpacity(0.2)
              : ThemeConstants.sales.withOpacity(0.2),
          child: Icon(
            person.isSupplier && person.isCustomer
                ? Icons.business_center_outlined
                : person.isSupplier
                ? Icons.business_outlined
                : Icons.person_outline,
            size: 16,
            color: person.isSupplier && person.isCustomer
                ? Colors.orange
                : person.isSupplier
                ? ThemeConstants.purchase
                : ThemeConstants.sales,
          ),
        ),
        title: Text(
          person.name,
          style: ThemeConstants.bodyText.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              person.businessType.toUpperCase(),
              style: ThemeConstants.caption.copyWith(
                color: person.isSupplier && person.isCustomer
                    ? Colors.orange
                    : person.isSupplier
                    ? ThemeConstants.purchase
                    : ThemeConstants.sales,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'PKR ${person.remainingBalance.toStringAsFixed(0)}',
              style: ThemeConstants.caption.copyWith(
                color: person.remainingBalance >= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: Text(
          '${person.transactionCount}',
          style: ThemeConstants.caption,
        ),
        onTap: () => controller.selectPerson(person),
      ),
    );
  }

  Widget _buildEmptyPersonsState(
    BuildContext context,
    LedgerController controller,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.people_outline,
              size: 48,
              color: ThemeConstants.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              'No persons found',
              style: ThemeConstants.titleSmall.copyWith(
                color: ThemeConstants.textTertiary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first person to start managing ledger',
              style: ThemeConstants.caption,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showAddPersonDialog(context, controller),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Person'),
              style: ThemeConstants.primaryButtonStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLedgerContent(
    BuildContext context,
    LedgerController controller,
  ) {
    return Obx(() {
      if (!controller.hasSelectedPerson) {
        return _buildNoSelectionState();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with selected person info
          _buildLedgerHeader(context, controller),

          const SizedBox(height: 16),

          // Summary Cards
          _buildSummaryCards(controller),

          const SizedBox(height: 16),

          // Transactions Table
          Expanded(child: _buildTransactionsTable(context, controller)),
        ],
      );
    });
  }

  Widget _buildNoSelectionState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(48),
        decoration: ThemeConstants.elevatedCardDecoration.copyWith(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 64,
              color: ThemeConstants.textTertiary,
            ),
            const SizedBox(height: 24),
            Text(
              'Select a Person',
              style: ThemeConstants.titleLarge.copyWith(
                color: ThemeConstants.textTertiary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose a person from the list to view their account statement',
              style: ThemeConstants.bodySecondary,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLedgerHeader(BuildContext context, LedgerController controller) {
    final selectedPerson = controller.selectedPerson.value!;

    return Container(
      padding: ThemeConstants.cardPadding,
      decoration: ThemeConstants.elevatedCardDecoration,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: ThemeConstants.getIconContainerDecoration(
              selectedPerson.isSupplier && selectedPerson.isCustomer
                  ? Colors.orange
                  : selectedPerson.isSupplier
                  ? ThemeConstants.purchase
                  : ThemeConstants.sales,
            ),
            child: Icon(
              selectedPerson.isSupplier && selectedPerson.isCustomer
                  ? Icons.business_center_outlined
                  : selectedPerson.isSupplier
                  ? Icons.business_outlined
                  : Icons.person_outline,
              color: selectedPerson.isSupplier && selectedPerson.isCustomer
                  ? Colors.orange
                  : selectedPerson.isSupplier
                  ? ThemeConstants.purchase
                  : ThemeConstants.sales,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(selectedPerson.name, style: ThemeConstants.titleLarge),
                const SizedBox(height: 4),
                Text(
                  '${selectedPerson.businessType.toUpperCase()} • ${selectedPerson.transactionCount} transactions',
                  style: ThemeConstants.bodySecondary,
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => _showAddTransactionDialog(context, controller),
                icon: const Icon(Icons.add),
                tooltip: 'Add Transaction',
              ),
              IconButton(
                onPressed: () =>
                    _showEditPersonDialog(context, controller, selectedPerson),
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit Person',
              ),
              IconButton(
                onPressed: () => controller.refreshAllData(),
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh Data',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(LedgerController controller) {
    return Obx(() {
      final summary = controller.currentPersonSummary.value;
      if (summary == null) {
        return const SizedBox.shrink();
      }

      return Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'Opening Balance',
              'PKR ${summary.openingBalance.toStringAsFixed(0)}',
              Icons.account_balance_outlined,
              Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Total Sales',
              'PKR ${summary.totalSales.toStringAsFixed(0)}',
              Icons.trending_up,
              Colors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Total Purchases',
              'PKR ${summary.totalPurchases.toStringAsFixed(0)}',
              Icons.trending_down,
              Colors.orange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Payments Received',
              'PKR ${summary.totalPaymentsReceived.toStringAsFixed(0)}',
              Icons.arrow_downward,
              Colors.teal,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Payments Given',
              'PKR ${summary.totalPaymentsGiven.toStringAsFixed(0)}',
              Icons.arrow_upward,
              Colors.red,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Remaining Balance',
              'PKR ${summary.remainingBalance.toStringAsFixed(0)}',
              Icons.account_balance_wallet,
              summary.remainingBalance >= 0 ? Colors.green : Colors.red,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: ThemeConstants.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: ThemeConstants.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: ThemeConstants.titleSmall.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsTable(
    BuildContext context,
    LedgerController controller,
  ) {
    return Container(
      decoration: ThemeConstants.cardDecoration,
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ThemeConstants.backgroundTertiary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.table_chart_outlined,
                  size: 20,
                  color: ThemeConstants.primary,
                ),
                const SizedBox(width: 8),
                Text('Transaction History', style: ThemeConstants.titleSmall),
                const Spacer(),
                Obx(
                  () => Text(
                    '${controller.currentPersonTransactionCount} transactions',
                    style: ThemeConstants.caption,
                  ),
                ),
              ],
            ),
          ),

          // Table Content
          Expanded(
            child: Obx(() {
              if (controller.isLoadingTransactions.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final transactions = controller.currentPersonTransactions;

              if (transactions.isEmpty) {
                return _buildEmptyTransactionsState(context, controller);
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width - 400,
                  ),
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(
                      ThemeConstants.backgroundTertiary,
                    ),
                    dataRowHeight: 60,
                    columnSpacing: 20,
                    horizontalMargin: 16,
                    columns: [
                      DataColumn(label: _buildColumnHeader('Date & Time')),
                      DataColumn(label: _buildColumnHeader('Type')),
                      DataColumn(label: _buildColumnHeader('Description')),
                      DataColumn(label: _buildColumnHeader('Reference')),
                      DataColumn(
                        label: _buildColumnHeader('Debit'),
                        numeric: true,
                      ),
                      DataColumn(
                        label: _buildColumnHeader('Credit'),
                        numeric: true,
                      ),
                      DataColumn(
                        label: _buildColumnHeader('Balance'),
                        numeric: true,
                      ),
                      DataColumn(label: _buildColumnHeader('Actions')),
                    ],
                    rows: transactions.map((entry) {
                      return DataRow(
                        cells: [
                          DataCell(_buildDateTimeCell(entry.createdAt)),
                          DataCell(_buildTypeCell(entry)),
                          DataCell(_buildDescriptionCell(entry.description)),
                          DataCell(_buildReferenceCell(entry.referenceNumber)),
                          DataCell(_buildAmountCell(entry.debit, Colors.red)),
                          DataCell(
                            _buildAmountCell(entry.credit, Colors.green),
                          ),
                          DataCell(_buildBalanceCell(entry.runningBalance)),
                          DataCell(
                            _buildActionCell(context, controller, entry),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: ThemeConstants.caption.copyWith(
          fontWeight: FontWeight.bold,
          color: ThemeConstants.textSecondary,
        ),
      ),
    );
  }

  Widget _buildDateTimeCell(DateTime dateTime) {
    return SizedBox(
      width: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            DateFormat('dd/MM/yyyy').format(dateTime),
            style: ThemeConstants.bodyText.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            DateFormat('HH:mm').format(dateTime),
            style: ThemeConstants.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildTypeCell(LedgerEntry entry) {
    return SizedBox(
      width: 120,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _getTypeColor(entry.type).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _getTypeColor(entry.type), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(entry.typeIcon, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                entry.typeDisplayName,
                style: ThemeConstants.caption.copyWith(
                  color: _getTypeColor(entry.type),
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCell(String description) {
    return SizedBox(
      width: 200,
      child: Text(
        description,
        style: ThemeConstants.bodyText,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildReferenceCell(String? referenceNumber) {
    return SizedBox(
      width: 100,
      child: Text(
        referenceNumber ?? '-',
        style: ThemeConstants.bodyText,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildAmountCell(double amount, Color color) {
    if (amount == 0) {
      return const SizedBox(
        width: 100,
        child: Text('-', textAlign: TextAlign.center),
      );
    }

    return SizedBox(
      width: 100,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'PKR ${amount.toStringAsFixed(0)}',
          style: ThemeConstants.bodyText.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildBalanceCell(double balance) {
    final color = balance >= 0 ? Colors.green : Colors.red;

    return SizedBox(
      width: 120,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Text(
          'PKR ${balance.toStringAsFixed(0)}',
          style: ThemeConstants.bodyText.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildActionCell(
    BuildContext context,
    LedgerController controller,
    LedgerEntry entry,
  ) {
    return SizedBox(
      width: 80,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () =>
                _showEditTransactionDialog(context, controller, entry),
            icon: const Icon(Icons.edit_outlined, size: 16),
            tooltip: 'Edit Transaction',
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
          IconButton(
            onPressed: () =>
                _showDeleteTransactionDialog(context, controller, entry),
            icon: const Icon(Icons.delete_outline, size: 16),
            tooltip: 'Delete Transaction',
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTransactionsState(
    BuildContext context,
    LedgerController controller,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 48,
              color: ThemeConstants.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              'No transactions found',
              style: ThemeConstants.titleSmall.copyWith(
                color: ThemeConstants.textTertiary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add the first transaction to start tracking',
              style: ThemeConstants.caption,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showAddTransactionDialog(context, controller),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Transaction'),
              style: ThemeConstants.primaryButtonStyle,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  Color _getTypeColor(String type) {
    switch (type) {
      case 'sale':
        return Colors.green;
      case 'purchase':
        return Colors.orange;
      case 'payment_received':
        return Colors.teal;
      case 'payment_given':
        return Colors.red;
      default:
        return ThemeConstants.textSecondary;
    }
  }

  // ============================================================================
  // DIALOG METHODS
  // ============================================================================

  void _showAddPersonDialog(BuildContext context, LedgerController controller) {
    LedgerDialogs.showAddPersonDialog(context, controller);
  }

  void _showEditPersonDialog(
    BuildContext context,
    LedgerController controller,
    PersonSummary person,
  ) {
    LedgerDialogs.showEditPersonDialog(context, controller, person);
  }

  void _showAddTransactionDialog(
    BuildContext context,
    LedgerController controller,
  ) {
    LedgerDialogs.showAddTransactionDialog(context, controller);
  }

  void _showEditTransactionDialog(
    BuildContext context,
    LedgerController controller,
    LedgerEntry entry,
  ) {
    LedgerDialogs.showEditTransactionDialog(context, controller, entry);
  }

  void _showDeleteTransactionDialog(
    BuildContext context,
    LedgerController controller,
    LedgerEntry entry,
  ) {
    LedgerDialogs.showDeleteTransactionDialog(context, controller, entry);
  }
}
