import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/parties_controller.dart';
import '../models/party.dart';
import '../core/theme_constants.dart';

class PartyDetailsView extends StatelessWidget {
  final Party party;

  const PartyDetailsView({super.key, required this.party});

  @override
  Widget build(BuildContext context) {
    final PartiesController partiesController = Get.find<PartiesController>();
    final balance = partiesController.getBalanceForParty(party.id);
    final transactions = partiesController.getTransactionsForParty(party.id);

    return Scaffold(
      backgroundColor: ThemeConstants.backgroundSecondary,
      appBar: AppBar(
        title: Text('${party.name} - Details'),
        backgroundColor: ThemeConstants.primary,
        foregroundColor: ThemeConstants.textInverse,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: ThemeConstants.sectionPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Party Header Card
            _buildPartyHeaderCard(party, balance),
            const SizedBox(height: 24),

            // Financial Summary Cards
            if (balance != null) ...[
              _buildFinancialSummaryCards(balance),
              const SizedBox(height: 24),
            ],

            // Transaction History
            _buildTransactionHistorySection(transactions),
            const SizedBox(height: 24),

            // Party Information
            _buildPartyInformationCard(party),
          ],
        ),
      ),
    );
  }

  Widget _buildPartyHeaderCard(Party party, PartyBalance? balance) {
    return Container(
      padding: ThemeConstants.cardPadding,
      decoration: ThemeConstants.elevatedCardDecoration,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: ThemeConstants.getIconContainerDecoration(
              party.type == 'supplier'
                  ? ThemeConstants.purchase
                  : ThemeConstants.sales,
            ),
            child: Icon(
              party.partyCategory == 'company'
                  ? Icons.business_outlined
                  : Icons.person_outline,
              color: party.type == 'supplier'
                  ? ThemeConstants.purchase
                  : ThemeConstants.sales,
              size: 32,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  party.name,
                  style: ThemeConstants.titleLarge.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: party.type == 'supplier'
                            ? ThemeConstants.purchase.withOpacity(0.1)
                            : ThemeConstants.sales.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: party.type == 'supplier'
                              ? ThemeConstants.purchase
                              : ThemeConstants.sales,
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
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: ThemeConstants.backgroundTertiary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        party.partyCategory == 'company' ? 'Company' : 'Person',
                        style: ThemeConstants.caption.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (party.email != null || party.phone != null) ...[
                  Row(
                    children: [
                      if (party.email != null) ...[
                        Icon(
                          Icons.email_outlined,
                          size: 16,
                          color: ThemeConstants.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(party.email!, style: ThemeConstants.bodyText),
                        const SizedBox(width: 16),
                      ],
                      if (party.phone != null) ...[
                        Icon(
                          Icons.phone_outlined,
                          size: 16,
                          color: ThemeConstants.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(party.phone!, style: ThemeConstants.bodyText),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (balance != null) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Current Balance', style: ThemeConstants.caption),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: balance.currentBalance >= 0
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: balance.currentBalance >= 0
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  child: Text(
                    'PKR ${balance.currentBalance.toStringAsFixed(0)}',
                    style: ThemeConstants.titleMedium.copyWith(
                      color: balance.currentBalance >= 0
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFinancialSummaryCards(PartyBalance balance) {
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
                      Icons.shopping_cart_outlined,
                      color: ThemeConstants.purchase,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text('Total Purchases', style: ThemeConstants.titleSmall),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'PKR ${balance.totalPurchases.toStringAsFixed(0)}',
                  style: ThemeConstants.titleLarge.copyWith(
                    color: ThemeConstants.purchase,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${balance.transactionCount} transactions',
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
                      Icons.sell_outlined,
                      color: ThemeConstants.sales,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text('Total Sales', style: ThemeConstants.titleSmall),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'PKR ${balance.totalSales.toStringAsFixed(0)}',
                  style: ThemeConstants.titleLarge.copyWith(
                    color: ThemeConstants.sales,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('Revenue generated', style: ThemeConstants.bodySecondary),
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
                    Text('Opening Balance', style: ThemeConstants.titleSmall),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'PKR ${balance.openingBalance.toStringAsFixed(0)}',
                  style: ThemeConstants.titleLarge.copyWith(
                    color: ThemeConstants.stock,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('Initial amount', style: ThemeConstants.bodySecondary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionHistorySection(List<PartyTransaction> transactions) {
    return Container(
      padding: ThemeConstants.cardPadding,
      decoration: ThemeConstants.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history, color: ThemeConstants.primary, size: 24),
              const SizedBox(width: 12),
              Text('Transaction History', style: ThemeConstants.titleMedium),
              const Spacer(),
              Text(
                '${transactions.length} transactions',
                style: ThemeConstants.bodySecondary,
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (transactions.isEmpty)
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: ThemeConstants.backgroundTertiary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
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
                      'Transactions will appear here when purchases or sales are made',
                      style: ThemeConstants.bodySecondary,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            ...transactions.map(
              (transaction) => _buildTransactionCard(transaction),
            ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(PartyTransaction transaction) {
    Color transactionColor;
    IconData transactionIcon;
    String transactionLabel;

    switch (transaction.transactionType) {
      case 'purchase':
        transactionColor = ThemeConstants.purchase;
        transactionIcon = Icons.shopping_cart_outlined;
        transactionLabel = 'PURCHASE';
        break;
      case 'sale':
        transactionColor = ThemeConstants.sales;
        transactionIcon = Icons.sell_outlined;
        transactionLabel = 'SALE';
        break;
      case 'payment_received':
        transactionColor = Colors.green;
        transactionIcon = Icons.arrow_downward;
        transactionLabel = 'PAYMENT RECEIVED';
        break;
      case 'payment_made':
        transactionColor = Colors.red;
        transactionIcon = Icons.arrow_upward;
        transactionLabel = 'PAYMENT MADE';
        break;
      default:
        transactionColor = ThemeConstants.textSecondary;
        transactionIcon = Icons.receipt_outlined;
        transactionLabel = 'TRANSACTION';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeConstants.backgroundTertiary,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: transactionColor, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: transactionColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(transactionIcon, color: transactionColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transactionLabel,
                      style: ThemeConstants.caption.copyWith(
                        color: transactionColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      transaction.description,
                      style: ThemeConstants.bodyText.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'PKR ${transaction.amount.toStringAsFixed(0)}',
                    style: ThemeConstants.titleMedium.copyWith(
                      color: transactionColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat(
                      'MMM dd, yyyy',
                    ).format(transaction.transactionDate),
                    style: ThemeConstants.caption,
                  ),
                ],
              ),
            ],
          ),
          if (transaction.invoiceNumber != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.receipt_outlined,
                  size: 14,
                  color: ThemeConstants.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Invoice: ${transaction.invoiceNumber}',
                  style: ThemeConstants.caption,
                ),
              ],
            ),
          ],
          if (transaction.notes != null && transaction.notes!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ThemeConstants.background,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 14,
                    color: ThemeConstants.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      transaction.notes!,
                      style: ThemeConstants.caption,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPartyInformationCard(Party party) {
    return Container(
      padding: ThemeConstants.cardPadding,
      decoration: ThemeConstants.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: ThemeConstants.primary, size: 24),
              const SizedBox(width: 12),
              Text('Party Information', style: ThemeConstants.titleMedium),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow('Party Name', party.name),
          _buildInfoRow('Type', party.type.toUpperCase()),
          _buildInfoRow(
            'Category',
            party.partyCategory == 'company' ? 'Company' : 'Person',
          ),
          if (party.email != null) _buildInfoRow('Email', party.email!),
          if (party.phone != null) _buildInfoRow('Phone', party.phone!),
          if (party.address != null) _buildInfoRow('Address', party.address!),
          if (party.city != null) _buildInfoRow('City', party.city!),
          if (party.country != null) _buildInfoRow('Country', party.country!),
          if (party.taxNumber != null)
            _buildInfoRow('Tax Number', party.taxNumber!),
          if (party.registrationNumber != null)
            _buildInfoRow('Registration Number', party.registrationNumber!),
          if (party.contactPerson != null)
            _buildInfoRow('Contact Person', party.contactPerson!),
          if (party.notes != null) _buildInfoRow('Notes', party.notes!),
          _buildInfoRow('Status', party.isActive ? 'Active' : 'Inactive'),
          _buildInfoRow(
            'Created',
            DateFormat('MMM dd, yyyy').format(party.createdAt),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: ThemeConstants.bodyText.copyWith(
                fontWeight: FontWeight.w600,
                color: ThemeConstants.textSecondary,
              ),
            ),
          ),
          Expanded(child: Text(value, style: ThemeConstants.bodyText)),
        ],
      ),
    );
  }
}
