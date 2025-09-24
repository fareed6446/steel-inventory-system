import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import '../core/theme_constants.dart';
import 'invoice_preview_view.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController =
        Get.find<SettingsController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Settings'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Settings',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                          fontSize: 28,
                        ),
                      ),
                      Text(
                        'Customize your steel factory inventory system',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF8B5CF6),
                              const Color(0xFF7C3AED),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8B5CF6).withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Get.to(() => const InvoicePreviewView());
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.preview_outlined,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Preview Invoice',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              ThemeConstants.primary,
                              ThemeConstants.primary.withOpacity(0.8),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: ThemeConstants.primary.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              settingsController.saveSettings();
                              Get.snackbar(
                                'Success',
                                'Settings saved successfully!',
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.TOP,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.save_outlined,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Save Settings',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
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
              const SizedBox(height: 32),

              // Settings Content
              Column(
                children: [
                  // Invoice Settings
                  _buildSettingsSection(
                    title: 'Invoice Settings',
                    icon: Icons.receipt_long_outlined,
                    children: [
                      _buildInvoiceFormatSettings(settingsController),
                      const SizedBox(height: 16),
                      _buildInvoiceTemplateSettings(settingsController),
                      const SizedBox(height: 16),
                      _buildInvoiceDisplaySettings(settingsController),
                      const SizedBox(height: 16),
                      _buildInvoiceContentSettings(settingsController),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Company Information
                  _buildSettingsSection(
                    title: 'Company Information',
                    icon: Icons.business_outlined,
                    children: [_buildCompanyInfoSettings(settingsController)],
                  ),
                  const SizedBox(height: 24),

                  // Currency & Localization
                  _buildSettingsSection(
                    title: 'Currency & Localization',
                    icon: Icons.language_outlined,
                    children: [
                      _buildCurrencySettings(settingsController),
                      const SizedBox(height: 16),
                      _buildLocalizationSettings(settingsController),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // General Settings
                  _buildSettingsSection(
                    title: 'General Settings',
                    icon: Icons.tune_outlined,
                    children: [_buildGeneralSettings(settingsController)],
                  ),
                  const SizedBox(height: 24),

                  // Invoice Number Settings
                  _buildSettingsSection(
                    title: 'Invoice Number Settings',
                    icon: Icons.confirmation_number_outlined,
                    children: [
                      _buildInvoiceNumberSettings(settingsController),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Page Settings
                  _buildSettingsSection(
                    title: 'Page Settings',
                    icon: Icons.description_outlined,
                    children: [_buildPageSettings(settingsController)],
                  ),
                  const SizedBox(height: 24),

                  // Actions
                  _buildActionsSection(settingsController),
                  const SizedBox(height: 24),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.grey.withOpacity(0.05)],
        ),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: ThemeConstants.primary.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                  child: Icon(icon, color: ThemeConstants.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceFormatSettings(SettingsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Invoice Format', style: ThemeConstants.titleSmall),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.invoiceFormat.value,
                  decoration: ThemeConstants.inputDecoration.copyWith(
                    labelText: 'Page Format',
                  ),
                  items: ['A4', 'A3', 'Letter', 'Legal']
                      .map(
                        (format) => DropdownMenuItem(
                          value: format,
                          child: Text(format),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.invoiceFormat.value = value;
                      controller.pageSize.value = value;
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.pageOrientation.value,
                  decoration: ThemeConstants.inputDecoration.copyWith(
                    labelText: 'Orientation',
                  ),
                  items: ['Portrait', 'Landscape']
                      .map(
                        (orientation) => DropdownMenuItem(
                          value: orientation,
                          child: Text(orientation),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.pageOrientation.value = value;
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInvoiceTemplateSettings(SettingsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Invoice Template', style: ThemeConstants.titleSmall),
        const SizedBox(height: 8),
        Obx(
          () => DropdownButtonFormField<String>(
            value: controller.invoiceTemplate.value,
            decoration: ThemeConstants.inputDecoration.copyWith(
              labelText: 'Template Style',
            ),
            items: ['Modern', 'Classic', 'Minimal', 'Professional']
                .map(
                  (template) => DropdownMenuItem(
                    value: template,
                    child: Text(template),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                controller.invoiceTemplate.value = value;
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInvoiceDisplaySettings(SettingsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Display Settings', style: ThemeConstants.titleSmall),
        const SizedBox(height: 8),
        Obx(
          () => SwitchListTile(
            title: const Text('Show Company Logo'),
            subtitle: const Text('Display company logo on invoices'),
            value: controller.showCompanyLogo.value,
            onChanged: (value) {
              controller.showCompanyLogo.value = value;
            },
            activeColor: ThemeConstants.primary,
          ),
        ),
        Obx(
          () => SwitchListTile(
            title: const Text('Show Terms & Conditions'),
            subtitle: const Text('Display terms and conditions on invoices'),
            value: controller.showTermsAndConditions.value,
            onChanged: (value) {
              controller.showTermsAndConditions.value = value;
            },
            activeColor: ThemeConstants.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildInvoiceContentSettings(SettingsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Content Settings', style: ThemeConstants.titleSmall),
        const SizedBox(height: 8),
        Obx(
          () => TextFormField(
            initialValue: controller.invoiceFooter.value,
            decoration: ThemeConstants.inputDecoration.copyWith(
              labelText: 'Invoice Footer',
              hintText: 'Enter footer text for invoices',
            ),
            maxLines: 3,
            onChanged: (value) {
              controller.invoiceFooter.value = value;
            },
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => TextFormField(
            initialValue: controller.invoiceHeader.value,
            decoration: ThemeConstants.inputDecoration.copyWith(
              labelText: 'Invoice Header',
              hintText: 'Enter header text for invoices',
            ),
            maxLines: 3,
            onChanged: (value) {
              controller.invoiceHeader.value = value;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyInfoSettings(SettingsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Company Details', style: ThemeConstants.titleSmall),
        const SizedBox(height: 8),
        Obx(
          () => TextFormField(
            initialValue: controller.companyName.value,
            decoration: ThemeConstants.inputDecoration.copyWith(
              labelText: 'Company Name',
            ),
            onChanged: (value) {
              controller.companyName.value = value;
            },
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => TextFormField(
            initialValue: controller.companyAddress.value,
            decoration: ThemeConstants.inputDecoration.copyWith(
              labelText: 'Company Address',
            ),
            maxLines: 3,
            onChanged: (value) {
              controller.companyAddress.value = value;
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Obx(
                () => TextFormField(
                  initialValue: controller.companyPhone.value,
                  decoration: ThemeConstants.inputDecoration.copyWith(
                    labelText: 'Phone Number',
                  ),
                  onChanged: (value) {
                    controller.companyPhone.value = value;
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Obx(
                () => TextFormField(
                  initialValue: controller.companyEmail.value,
                  decoration: ThemeConstants.inputDecoration.copyWith(
                    labelText: 'Email Address',
                  ),
                  onChanged: (value) {
                    controller.companyEmail.value = value;
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCurrencySettings(SettingsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Currency Settings', style: ThemeConstants.titleSmall),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.currency.value,
                  decoration: ThemeConstants.inputDecoration.copyWith(
                    labelText: 'Currency',
                  ),
                  items: ['USD', 'EUR', 'GBP', 'INR', 'PKR']
                      .map(
                        (currency) => DropdownMenuItem(
                          value: currency,
                          child: Text(currency),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.currency.value = value;
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Obx(
                () => TextFormField(
                  initialValue: controller.currencySymbol.value,
                  decoration: ThemeConstants.inputDecoration.copyWith(
                    labelText: 'Currency Symbol',
                  ),
                  onChanged: (value) {
                    controller.currencySymbol.value = value;
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocalizationSettings(SettingsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Localization', style: ThemeConstants.titleSmall),
        const SizedBox(height: 8),
        Obx(
          () => DropdownButtonFormField<String>(
            value: controller.language.value,
            decoration: ThemeConstants.inputDecoration.copyWith(
              labelText: 'Language',
            ),
            items: ['English', 'Spanish', 'French', 'German', 'Chinese']
                .map(
                  (language) => DropdownMenuItem(
                    value: language,
                    child: Text(language),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                controller.language.value = value;
              }
            },
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => DropdownButtonFormField<String>(
            value: controller.dateFormat.value,
            decoration: ThemeConstants.inputDecoration.copyWith(
              labelText: 'Date Format',
            ),
            items: ['MM/DD/YYYY', 'DD/MM/YYYY', 'YYYY-MM-DD']
                .map(
                  (format) => DropdownMenuItem(
                    value: format,
                    child: Text(format),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                controller.dateFormat.value = value;
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGeneralSettings(SettingsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('General Preferences', style: ThemeConstants.titleSmall),
        const SizedBox(height: 8),
        Obx(
          () => SwitchListTile(
            title: const Text('Auto Backup'),
            subtitle: const Text('Automatically backup data'),
            value: controller.autoBackup.value,
            onChanged: (value) {
              controller.autoBackup.value = value;
            },
            activeColor: ThemeConstants.primary,
          ),
        ),
        Obx(
          () => SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Use dark theme'),
            value: controller.darkMode.value,
            onChanged: (value) {
              controller.darkMode.value = value;
            },
            activeColor: ThemeConstants.primary,
          ),
        ),
        Obx(
          () => SwitchListTile(
            title: const Text('Notifications'),
            subtitle: const Text('Enable push notifications'),
            value: controller.notifications.value,
            onChanged: (value) {
              controller.notifications.value = value;
            },
            activeColor: ThemeConstants.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildInvoiceNumberSettings(SettingsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Invoice Numbering', style: ThemeConstants.titleSmall),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Obx(
                () => TextFormField(
                  initialValue: controller.invoicePrefix.value,
                  decoration: ThemeConstants.inputDecoration.copyWith(
                    labelText: 'Invoice Prefix',
                    hintText: 'e.g., INV-',
                  ),
                  onChanged: (value) {
                    controller.invoicePrefix.value = value;
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Obx(
                () => TextFormField(
                  initialValue: controller.invoiceStartNumber.value.toString(),
                  decoration: ThemeConstants.inputDecoration.copyWith(
                    labelText: 'Starting Number',
                    hintText: 'e.g., 1001',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    controller.invoiceStartNumber.value = int.tryParse(value) ?? 1;
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(
          () => SwitchListTile(
            title: const Text('Auto-increment Invoice Numbers'),
            subtitle: const Text('Automatically increment invoice numbers'),
            value: controller.autoIncrementInvoice.value,
            onChanged: (value) {
              controller.autoIncrementInvoice.value = value;
            },
            activeColor: ThemeConstants.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildPageSettings(SettingsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Page Settings', style: ThemeConstants.titleSmall),
        const SizedBox(height: 8),
        Obx(
          () => Slider(
            value: controller.pageMargin.value,
            min: 10.0,
            max: 50.0,
            divisions: 8,
            label: '${controller.pageMargin.value.round()}mm',
            onChanged: (value) {
              controller.pageMargin.value = value;
            },
            activeColor: ThemeConstants.primary,
          ),
        ),
        Text(
          'Page Margin: ${controller.pageMargin.value.round()}mm',
          style: ThemeConstants.bodySecondary,
        ),
        const SizedBox(height: 16),
        Text(
          'Header Height: ${controller.headerHeight.value.round()}px',
          style: ThemeConstants.bodySecondary,
        ),
        Obx(
          () => Slider(
            value: controller.headerHeight.value,
            min: 50.0,
            max: 200.0,
            divisions: 15,
            label: '${controller.headerHeight.value.round()}px',
            onChanged: (value) {
              controller.headerHeight.value = value;
            },
            activeColor: ThemeConstants.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionsSection(SettingsController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.grey.withOpacity(0.05)],
        ),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.red.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(Icons.warning_outlined, color: Colors.red, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'Danger Zone',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.red,
                          Colors.red.withOpacity(0.8),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          _showResetDialog(context, controller);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.restore_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Reset to Defaults',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.orange,
                          Colors.orange.withOpacity(0.8),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          _showExportDialog(context, controller);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.download_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Export Settings',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
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
    );
  }

  void _showResetDialog(BuildContext context, SettingsController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text(
          'Are you sure you want to reset all settings to their default values? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.resetToDefaults();
              Navigator.pop(context);
              Get.snackbar(
                'Success',
                'Settings have been reset to defaults!',
                backgroundColor: Colors.green,
                colorText: Colors.white,
                snackPosition: SnackPosition.TOP,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showExportDialog(BuildContext context, SettingsController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Settings'),
        content: const Text(
          'This feature will be available in the next update. For now, your settings are automatically saved locally.',
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