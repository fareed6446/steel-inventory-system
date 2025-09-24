import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import '../core/theme_constants.dart';

class InvoicePreviewView extends StatefulWidget {
  const InvoicePreviewView({super.key});

  @override
  State<InvoicePreviewView> createState() => _InvoicePreviewViewState();
}

class _InvoicePreviewViewState extends State<InvoicePreviewView>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date, String format) {
    switch (format) {
      case 'DD/MM/YYYY':
        return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      case 'MM/DD/YYYY':
        return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
      case 'YYYY-MM-DD':
        return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      default:
        return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }
  }

  Color _getTemplatePrimaryColor(String template) {
    switch (template) {
      case 'Modern':
        return ThemeConstants.primary;
      case 'Classic':
        return const Color(0xFF8B4513); // Brown
      case 'Minimal':
        return const Color(0xFF2D3748); // Dark gray
      case 'Professional':
        return const Color(0xFF1E40AF); // Blue
      default:
        return ThemeConstants.primary;
    }
  }

  TextStyle _getTemplateTitleStyle(String template) {
    switch (template) {
      case 'Modern':
        return const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1F2937),
        );
      case 'Classic':
        return const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Color(0xFF8B4513),
        );
      case 'Minimal':
        return const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w300,
          color: Color(0xFF2D3748),
        );
      case 'Professional':
        return const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E40AF),
        );
      default:
        return const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1F2937),
        );
    }
  }

  Widget _buildTemplateHeader(SettingsController controller) {
    switch (controller.invoiceTemplate.value) {
      case 'Modern':
        return _buildModernHeader(controller);
      case 'Classic':
        return _buildClassicHeader(controller);
      case 'Minimal':
        return _buildMinimalHeader(controller);
      case 'Professional':
        return _buildProfessionalHeader(controller);
      default:
        return _buildModernHeader(controller);
    }
  }

  Widget _buildModernHeader(SettingsController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.companyName.value,
              style: _getTemplateTitleStyle(controller.invoiceTemplate.value),
            ),
            const SizedBox(height: 8),
            if (controller.showCompanyAddress.value)
              Text(
                controller.companyAddress.value,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            if (controller.showCompanyPhone.value)
              Text(
                'Phone: ${controller.companyPhone.value}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            if (controller.showCompanyEmail.value)
              Text(
                'Email: ${controller.companyEmail.value}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            if (controller.companyWebsite.value.isNotEmpty)
              Text(
                'Website: ${controller.companyWebsite.value}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _getTemplatePrimaryColor(
                  controller.invoiceTemplate.value,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'INVOICE',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Invoice #: ${controller.invoicePrefix.value}-${controller.invoiceStartNumber.value.toString().padLeft(3, '0')}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Date: ${_formatDate(DateTime.now(), controller.dateFormat.value)}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildClassicHeader(SettingsController controller) {
    return Column(
      children: [
        // Classic centered header with decorative border
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(
              color: _getTemplatePrimaryColor(controller.invoiceTemplate.value),
              width: 3,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                controller.companyName.value,
                style: _getTemplateTitleStyle(controller.invoiceTemplate.value),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                height: 2,
                width: 100,
                color: _getTemplatePrimaryColor(
                  controller.invoiceTemplate.value,
                ),
              ),
              const SizedBox(height: 12),
              if (controller.showCompanyAddress.value)
                Text(
                  controller.companyAddress.value,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              if (controller.showCompanyPhone.value)
                Text(
                  'Phone: ${controller.companyPhone.value}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              if (controller.showCompanyEmail.value)
                Text(
                  'Email: ${controller.companyEmail.value}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Invoice details in classic style
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getTemplatePrimaryColor(
                  controller.invoiceTemplate.value,
                ).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    'INVOICE',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _getTemplatePrimaryColor(
                        controller.invoiceTemplate.value,
                      ),
                    ),
                  ),
                  Text(
                    '#${controller.invoicePrefix.value}-${controller.invoiceStartNumber.value.toString().padLeft(3, '0')}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getTemplatePrimaryColor(
                  controller.invoiceTemplate.value,
                ).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    'DATE',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _getTemplatePrimaryColor(
                        controller.invoiceTemplate.value,
                      ),
                    ),
                  ),
                  Text(
                    _formatDate(DateTime.now(), controller.dateFormat.value),
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMinimalHeader(SettingsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Minimal clean header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.companyName.value,
                    style: _getTemplateTitleStyle(
                      controller.invoiceTemplate.value,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (controller.showCompanyAddress.value)
                    Text(
                      controller.companyAddress.value,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  if (controller.showCompanyPhone.value)
                    Text(
                      controller.companyPhone.value,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  if (controller.showCompanyEmail.value)
                    Text(
                      controller.companyEmail.value,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'INVOICE',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey[400],
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${controller.invoicePrefix.value}-${controller.invoiceStartNumber.value.toString().padLeft(3, '0')}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  _formatDate(DateTime.now(), controller.dateFormat.value),
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(height: 1, color: Colors.grey[300]),
      ],
    );
  }

  Widget _buildProfessionalHeader(SettingsController controller) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getTemplatePrimaryColor(
              controller.invoiceTemplate.value,
            ).withOpacity(0.1),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getTemplatePrimaryColor(
            controller.invoiceTemplate.value,
          ).withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          // Company info with icon
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getTemplatePrimaryColor(
                          controller.invoiceTemplate.value,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.business,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        controller.companyName.value,
                        style: _getTemplateTitleStyle(
                          controller.invoiceTemplate.value,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (controller.showCompanyAddress.value)
                  _buildInfoRow(
                    Icons.location_on,
                    controller.companyAddress.value,
                  ),
                if (controller.showCompanyPhone.value)
                  _buildInfoRow(Icons.phone, controller.companyPhone.value),
                if (controller.showCompanyEmail.value)
                  _buildInfoRow(Icons.email, controller.companyEmail.value),
              ],
            ),
          ),
          // Invoice details in professional card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'INVOICE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getTemplatePrimaryColor(
                      controller.invoiceTemplate.value,
                    ),
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${controller.invoicePrefix.value}-${controller.invoiceStartNumber.value.toString().padLeft(3, '0')}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(DateTime.now(), controller.dateFormat.value),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildTemplateTable(SettingsController controller) {
    switch (controller.invoiceTemplate.value) {
      case 'Modern':
        return _buildModernTable(controller);
      case 'Classic':
        return _buildClassicTable(controller);
      case 'Minimal':
        return _buildMinimalTable(controller);
      case 'Professional':
        return _buildProfessionalTable(controller);
      default:
        return _buildModernTable(controller);
    }
  }

  Widget _buildModernTable(SettingsController controller) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Description',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      fontSize: 14,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Qty',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Rate',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Amount',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          // Table Rows
          _buildTableRow(
            'Steel Beams - Grade A',
            '50',
            '${controller.currencySymbol.value} 125.00',
            '${controller.currencySymbol.value} 6,250.00',
          ),
          _buildTableRow(
            'Steel Plates - 10mm',
            '25',
            '${controller.currencySymbol.value} 85.00',
            '${controller.currencySymbol.value} 2,125.00',
          ),
          _buildTableRow(
            'Steel Rods - 12mm',
            '100',
            '${controller.currencySymbol.value} 45.00',
            '${controller.currencySymbol.value} 4,500.00',
          ),
          _buildTableRow(
            'Steel Pipes - 6 inch',
            '30',
            '${controller.currencySymbol.value} 95.00',
            '${controller.currencySymbol.value} 2,850.00',
          ),
        ],
      ),
    );
  }

  Widget _buildClassicTable(SettingsController controller) {
    return Column(
      children: [
        // Classic table with thick borders
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: _getTemplatePrimaryColor(controller.invoiceTemplate.value),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              // Header with classic styling
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _getTemplatePrimaryColor(
                    controller.invoiceTemplate.value,
                  ).withOpacity(0.1),
                  border: Border(
                    bottom: BorderSide(
                      color: _getTemplatePrimaryColor(
                        controller.invoiceTemplate.value,
                      ),
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'DESCRIPTION',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getTemplatePrimaryColor(
                            controller.invoiceTemplate.value,
                          ),
                          fontSize: 14,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'QTY',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getTemplatePrimaryColor(
                            controller.invoiceTemplate.value,
                          ),
                          fontSize: 14,
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'RATE',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getTemplatePrimaryColor(
                            controller.invoiceTemplate.value,
                          ),
                          fontSize: 14,
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'AMOUNT',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getTemplatePrimaryColor(
                            controller.invoiceTemplate.value,
                          ),
                          fontSize: 14,
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              // Rows with classic styling
              _buildClassicTableRow(
                'Steel Beams - Grade A',
                '50',
                '${controller.currencySymbol.value} 125.00',
                '${controller.currencySymbol.value} 6,250.00',
                controller,
              ),
              _buildClassicTableRow(
                'Steel Plates - 10mm',
                '25',
                '${controller.currencySymbol.value} 85.00',
                '${controller.currencySymbol.value} 2,125.00',
                controller,
              ),
              _buildClassicTableRow(
                'Steel Rods - 12mm',
                '100',
                '${controller.currencySymbol.value} 45.00',
                '${controller.currencySymbol.value} 4,500.00',
                controller,
              ),
              _buildClassicTableRow(
                'Steel Pipes - 6 inch',
                '30',
                '${controller.currencySymbol.value} 95.00',
                '${controller.currencySymbol.value} 2,850.00',
                controller,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMinimalTable(SettingsController controller) {
    return Column(
      children: [
        // Minimal clean table
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            children: [
              // Minimal header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Description',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.grey[600],
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Qty',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.grey[600],
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Rate',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.grey[600],
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Amount',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.grey[600],
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              // Minimal rows
              _buildMinimalTableRow(
                'Steel Beams - Grade A',
                '50',
                '${controller.currencySymbol.value} 125.00',
                '${controller.currencySymbol.value} 6,250.00',
              ),
              _buildMinimalTableRow(
                'Steel Plates - 10mm',
                '25',
                '${controller.currencySymbol.value} 85.00',
                '${controller.currencySymbol.value} 2,125.00',
              ),
              _buildMinimalTableRow(
                'Steel Rods - 12mm',
                '100',
                '${controller.currencySymbol.value} 45.00',
                '${controller.currencySymbol.value} 4,500.00',
              ),
              _buildMinimalTableRow(
                'Steel Pipes - 6 inch',
                '30',
                '${controller.currencySymbol.value} 95.00',
                '${controller.currencySymbol.value} 2,850.00',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfessionalTable(SettingsController controller) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          // Professional header with gradient
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getTemplatePrimaryColor(
                    controller.invoiceTemplate.value,
                  ).withOpacity(0.1),
                  _getTemplatePrimaryColor(
                    controller.invoiceTemplate.value,
                  ).withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Description',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _getTemplatePrimaryColor(
                        controller.invoiceTemplate.value,
                      ),
                      fontSize: 14,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Qty',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _getTemplatePrimaryColor(
                        controller.invoiceTemplate.value,
                      ),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Rate',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _getTemplatePrimaryColor(
                        controller.invoiceTemplate.value,
                      ),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Amount',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _getTemplatePrimaryColor(
                        controller.invoiceTemplate.value,
                      ),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          // Professional rows
          _buildProfessionalTableRow(
            'Steel Beams - Grade A',
            '50',
            '${controller.currencySymbol.value} 125.00',
            '${controller.currencySymbol.value} 6,250.00',
            controller,
          ),
          _buildProfessionalTableRow(
            'Steel Plates - 10mm',
            '25',
            '${controller.currencySymbol.value} 85.00',
            '${controller.currencySymbol.value} 2,125.00',
            controller,
          ),
          _buildProfessionalTableRow(
            'Steel Rods - 12mm',
            '100',
            '${controller.currencySymbol.value} 45.00',
            '${controller.currencySymbol.value} 4,500.00',
            controller,
          ),
          _buildProfessionalTableRow(
            'Steel Pipes - 6 inch',
            '30',
            '${controller.currencySymbol.value} 95.00',
            '${controller.currencySymbol.value} 2,850.00',
            controller,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController =
        Get.find<SettingsController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Invoice Preview'),
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
            icon: const Icon(Icons.print_outlined),
            onPressed: () {
              _showPrintDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              _showShareDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              children: [
                // Preview Controls
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white, Colors.grey.withOpacity(0.05)],
                    ),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ThemeConstants.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: ThemeConstants.primary.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.preview_outlined,
                          color: ThemeConstants.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Invoice Preview',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                    fontSize: 18,
                                  ),
                            ),
                            Text(
                              'Preview your invoice before printing or sharing',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color(0xFF10B981),
                                  const Color(0xFF059669),
                                ],
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () {
                                  _showPrintDialog(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.print_outlined,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Print',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color(0xFF3B82F6),
                                  const Color(0xFF2563EB),
                                ],
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () {
                                  _showShareDialog(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.share_outlined,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Share',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Invoice Preview
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _buildInvoicePreview(settingsController),
                  ),
                ),
                const SizedBox(height: 100), // Bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInvoicePreview(SettingsController controller) {
    return Obx(
      () => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Template-based Header
            _buildTemplateHeader(controller),
            const SizedBox(height: 40),

            // Bill To Section
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bill To:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ABC Construction Company',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      Text(
                        '456 Construction Ave',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      Text(
                        'Building City, State 67890',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      Text(
                        'Phone: +1 (555) 987-6543',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Payment Terms:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Net 30 Days',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Due Date:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      Text(
                        _formatDate(
                          DateTime.now().add(const Duration(days: 30)),
                          controller.dateFormat.value,
                        ),
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Template-based Items Table
            _buildTemplateTable(controller),
            const SizedBox(height: 20),

            // Totals
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 150,
                          child: Text(
                            'Subtotal:',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Text(
                            '${controller.currencySymbol.value} 15,725.00',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 150,
                          child: Text(
                            'Tax (8%):',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Text(
                            '${controller.currencySymbol.value} 1,258.00',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _getTemplatePrimaryColor(
                          controller.invoiceTemplate.value,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _getTemplatePrimaryColor(
                            controller.invoiceTemplate.value,
                          ).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 150,
                            child: Text(
                              'Total:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _getTemplatePrimaryColor(
                                  controller.invoiceTemplate.value,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Text(
                              '${controller.currencySymbol.value} 16,983.00',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _getTemplatePrimaryColor(
                                  controller.invoiceTemplate.value,
                                ),
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Footer
            if (controller.invoiceFooter.value.isNotEmpty ||
                controller.showTermsAndConditions.value)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    if (controller.invoiceFooter.value.isNotEmpty)
                      Text(
                        controller.invoiceFooter.value,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                    if (controller.invoiceFooter.value.isNotEmpty &&
                        controller.showTermsAndConditions.value)
                      const SizedBox(height: 8),
                    if (controller.showTermsAndConditions.value) ...[
                      Text(
                        'Payment Terms: Net 30 Days',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'For any questions regarding this invoice, please contact us at ${controller.companyEmail.value}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableRow(
    String description,
    String qty,
    String rate,
    String amount,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.2))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              description,
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
          ),
          Expanded(
            child: Text(
              qty,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              rate,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            child: Text(
              amount,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassicTableRow(
    String description,
    String qty,
    String rate,
    String amount,
    SettingsController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: _getTemplatePrimaryColor(
              controller.invoiceTemplate.value,
            ).withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              qty,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              rate,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            child: Text(
              amount,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMinimalTableRow(
    String description,
    String qty,
    String rate,
    String amount,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              description,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Expanded(
            child: Text(
              qty,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              rate,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            child: Text(
              amount,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalTableRow(
    String description,
    String qty,
    String rate,
    String amount,
    SettingsController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              qty,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              rate,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            child: Text(
              amount,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  void _showPrintDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Print Invoice'),
        content: const Text(
          'This feature will be available in the next update. For now, you can take a screenshot or use your browser\'s print function.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showShareDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Invoice'),
        content: const Text(
          'This feature will be available in the next update. For now, you can take a screenshot and share it manually.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
