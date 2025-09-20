import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import '../core/theme_constants.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController =
        Get.find<SettingsController>();

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
                      Icons.settings_outlined,
                      color: ThemeConstants.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Settings', style: ThemeConstants.titleLarge),
                        const SizedBox(height: 4),
                        Text(
                          'Customize your steel factory inventory system',
                          style: ThemeConstants.bodySecondary,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      settingsController.saveSettings();
                    },
                    icon: const Icon(Icons.save, size: 20),
                    label: const Text('Save Settings'),
                    style: ThemeConstants.primaryButtonStyle,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Settings Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
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
              ),
            ),
          ],
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
      padding: ThemeConstants.cardPadding,
      decoration: ThemeConstants.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: ThemeConstants.primary, size: 24),
              const SizedBox(width: 12),
              Text(title, style: ThemeConstants.titleMedium),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
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
                  value: controller.invoiceOrientation.value,
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
                      controller.invoiceOrientation.value = value;
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
            items: ['Standard', 'Modern', 'Classic', 'Minimal']
                .map(
                  (template) =>
                      DropdownMenuItem(value: template, child: Text(template)),
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
        Text('Display Options', style: ThemeConstants.titleSmall),
        const SizedBox(height: 8),
        Obx(
          () => Column(
            children: [
              SwitchListTile(
                title: const Text('Show Company Logo'),
                subtitle: const Text('Display company logo on invoices'),
                value: controller.showCompanyLogo.value,
                onChanged: (value) {
                  controller.showCompanyLogo.value = value;
                },
                activeColor: ThemeConstants.primary,
              ),
              SwitchListTile(
                title: const Text('Show Company Address'),
                subtitle: const Text('Display company address on invoices'),
                value: controller.showCompanyAddress.value,
                onChanged: (value) {
                  controller.showCompanyAddress.value = value;
                },
                activeColor: ThemeConstants.primary,
              ),
              SwitchListTile(
                title: const Text('Show Company Phone'),
                subtitle: const Text('Display company phone on invoices'),
                value: controller.showCompanyPhone.value,
                onChanged: (value) {
                  controller.showCompanyPhone.value = value;
                },
                activeColor: ThemeConstants.primary,
              ),
              SwitchListTile(
                title: const Text('Show Company Email'),
                subtitle: const Text('Display company email on invoices'),
                value: controller.showCompanyEmail.value,
                onChanged: (value) {
                  controller.showCompanyEmail.value = value;
                },
                activeColor: ThemeConstants.primary,
              ),
              SwitchListTile(
                title: const Text('Show Terms & Conditions'),
                subtitle: const Text(
                  'Display terms and conditions on invoices',
                ),
                value: controller.showTermsAndConditions.value,
                onChanged: (value) {
                  controller.showTermsAndConditions.value = value;
                },
                activeColor: ThemeConstants.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInvoiceContentSettings(SettingsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Invoice Content', style: ThemeConstants.titleSmall),
        const SizedBox(height: 8),
        Obx(
          () => Column(
            children: [
              TextField(
                controller: TextEditingController(
                  text: controller.invoiceHeader.value,
                ),
                decoration: ThemeConstants.inputDecoration.copyWith(
                  labelText: 'Invoice Header Text',
                  hintText: 'Enter custom header text',
                ),
                maxLines: 2,
                onChanged: (value) {
                  controller.invoiceHeader.value = value;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: TextEditingController(
                  text: controller.invoiceFooter.value,
                ),
                decoration: ThemeConstants.inputDecoration.copyWith(
                  labelText: 'Invoice Footer Text',
                  hintText: 'Enter custom footer text',
                ),
                maxLines: 2,
                onChanged: (value) {
                  controller.invoiceFooter.value = value;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyInfoSettings(SettingsController controller) {
    return Obx(
      () => Column(
        children: [
          TextField(
            controller: TextEditingController(
              text: controller.companyName.value,
            ),
            decoration: ThemeConstants.inputDecoration.copyWith(
              labelText: 'Company Name',
            ),
            onChanged: (value) {
              controller.companyName.value = value;
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: TextEditingController(
              text: controller.companyAddress.value,
            ),
            decoration: ThemeConstants.inputDecoration.copyWith(
              labelText: 'Company Address',
            ),
            maxLines: 3,
            onChanged: (value) {
              controller.companyAddress.value = value;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: TextEditingController(
                    text: controller.companyPhone.value,
                  ),
                  decoration: ThemeConstants.inputDecoration.copyWith(
                    labelText: 'Phone Number',
                  ),
                  onChanged: (value) {
                    controller.companyPhone.value = value;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: TextEditingController(
                    text: controller.companyEmail.value,
                  ),
                  decoration: ThemeConstants.inputDecoration.copyWith(
                    labelText: 'Email Address',
                  ),
                  onChanged: (value) {
                    controller.companyEmail.value = value;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: TextEditingController(
                    text: controller.companyWebsite.value,
                  ),
                  decoration: ThemeConstants.inputDecoration.copyWith(
                    labelText: 'Website',
                  ),
                  onChanged: (value) {
                    controller.companyWebsite.value = value;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: TextEditingController(
                    text: controller.companyTaxNumber.value,
                  ),
                  decoration: ThemeConstants.inputDecoration.copyWith(
                    labelText: 'Tax Number',
                  ),
                  onChanged: (value) {
                    controller.companyTaxNumber.value = value;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: TextEditingController(
              text: controller.companyRegistrationNumber.value,
            ),
            decoration: ThemeConstants.inputDecoration.copyWith(
              labelText: 'Registration Number',
            ),
            onChanged: (value) {
              controller.companyRegistrationNumber.value = value;
            },
          ),
        ],
      ),
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
                  items: ['PKR', 'USD', 'EUR', 'GBP', 'INR']
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
                      // Update symbol based on currency
                      switch (value) {
                        case 'PKR':
                          controller.currencySymbol.value = '₨';
                          break;
                        case 'USD':
                          controller.currencySymbol.value = '\$';
                          break;
                        case 'EUR':
                          controller.currencySymbol.value = '€';
                          break;
                        case 'GBP':
                          controller.currencySymbol.value = '£';
                          break;
                        case 'INR':
                          controller.currencySymbol.value = '₹';
                          break;
                      }
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Obx(
                () => TextField(
                  controller: TextEditingController(
                    text: controller.currencySymbol.value,
                  ),
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
        Text('Localization Settings', style: ThemeConstants.titleSmall),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.dateFormat.value,
                  decoration: ThemeConstants.inputDecoration.copyWith(
                    labelText: 'Date Format',
                  ),
                  items: ['DD/MM/YYYY', 'MM/DD/YYYY', 'YYYY-MM-DD']
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
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.timeFormat.value,
                  decoration: ThemeConstants.inputDecoration.copyWith(
                    labelText: 'Time Format',
                  ),
                  items: ['12 Hour', '24 Hour']
                      .map(
                        (format) => DropdownMenuItem(
                          value: format,
                          child: Text(format),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.timeFormat.value = value;
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(
          () => DropdownButtonFormField<String>(
            value: controller.language.value,
            decoration: ThemeConstants.inputDecoration.copyWith(
              labelText: 'Language',
            ),
            items: ['English', 'Urdu', 'Arabic']
                .map(
                  (language) =>
                      DropdownMenuItem(value: language, child: Text(language)),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                controller.language.value = value;
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGeneralSettings(SettingsController controller) {
    return Obx(
      () => Column(
        children: [
          SwitchListTile(
            title: const Text('Auto Backup'),
            subtitle: const Text('Automatically backup data'),
            value: controller.autoBackup.value,
            onChanged: (value) {
              controller.autoBackup.value = value;
            },
            activeColor: ThemeConstants.primary,
          ),
          SwitchListTile(
            title: const Text('Notifications'),
            subtitle: const Text('Enable system notifications'),
            value: controller.notifications.value,
            onChanged: (value) {
              controller.notifications.value = value;
            },
            activeColor: ThemeConstants.primary,
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Use dark theme'),
            value: controller.darkMode.value,
            onChanged: (value) {
              controller.darkMode.value = value;
            },
            activeColor: ThemeConstants.primary,
          ),
          SwitchListTile(
            title: const Text('Show Tutorial'),
            subtitle: const Text('Show tutorial on startup'),
            value: controller.showTutorial.value,
            onChanged: (value) {
              controller.showTutorial.value = value;
            },
            activeColor: ThemeConstants.primary,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Backup Frequency: ${controller.backupFrequency.value} days',
                ),
              ),
              Slider(
                value: controller.backupFrequency.value.toDouble(),
                min: 1,
                max: 30,
                divisions: 29,
                activeColor: ThemeConstants.primary,
                onChanged: (value) {
                  controller.backupFrequency.value = value.round();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceNumberSettings(SettingsController controller) {
    return Obx(
      () => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: TextEditingController(
                    text: controller.invoicePrefix.value,
                  ),
                  decoration: ThemeConstants.inputDecoration.copyWith(
                    labelText: 'Invoice Prefix',
                  ),
                  onChanged: (value) {
                    controller.invoicePrefix.value = value;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: TextEditingController(
                    text: controller.salePrefix.value,
                  ),
                  decoration: ThemeConstants.inputDecoration.copyWith(
                    labelText: 'Sale Prefix',
                  ),
                  onChanged: (value) {
                    controller.salePrefix.value = value;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: TextEditingController(
                    text: controller.purchasePrefix.value,
                  ),
                  decoration: ThemeConstants.inputDecoration.copyWith(
                    labelText: 'Purchase Prefix',
                  ),
                  onChanged: (value) {
                    controller.purchasePrefix.value = value;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: TextEditingController(
                    text: controller.invoiceStartNumber.value.toString(),
                  ),
                  decoration: ThemeConstants.inputDecoration.copyWith(
                    labelText: 'Start Number',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    controller.invoiceStartNumber.value =
                        int.tryParse(value) ?? 1;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Auto Increment Invoice Numbers'),
            subtitle: const Text('Automatically increment invoice numbers'),
            value: controller.autoIncrementInvoice.value,
            onChanged: (value) {
              controller.autoIncrementInvoice.value = value;
            },
            activeColor: ThemeConstants.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildPageSettings(SettingsController controller) {
    return Obx(
      () => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: controller.pageSize.value,
                  decoration: ThemeConstants.inputDecoration.copyWith(
                    labelText: 'Page Size',
                  ),
                  items: ['A4', 'A3', 'Letter', 'Legal']
                      .map(
                        (size) =>
                            DropdownMenuItem(value: size, child: Text(size)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.pageSize.value = value;
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: controller.pageOrientation.value,
                  decoration: ThemeConstants.inputDecoration.copyWith(
                    labelText: 'Page Orientation',
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
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Page Margin: ${controller.pageMargin.value.toInt()}px',
                    ),
                    Slider(
                      value: controller.pageMargin.value,
                      min: 10,
                      max: 50,
                      divisions: 40,
                      activeColor: ThemeConstants.primary,
                      onChanged: (value) {
                        controller.pageMargin.value = value;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Header Height: ${controller.headerHeight.value.toInt()}px',
                    ),
                    Slider(
                      value: controller.headerHeight.value,
                      min: 50,
                      max: 200,
                      divisions: 150,
                      activeColor: ThemeConstants.primary,
                      onChanged: (value) {
                        controller.headerHeight.value = value;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              Text('Footer Height: ${controller.footerHeight.value.toInt()}px'),
              Slider(
                value: controller.footerHeight.value,
                min: 20,
                max: 100,
                divisions: 80,
                activeColor: ThemeConstants.primary,
                onChanged: (value) {
                  controller.footerHeight.value = value;
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection(SettingsController controller) {
    return Container(
      padding: ThemeConstants.cardPadding,
      decoration: ThemeConstants.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.build_outlined,
                color: ThemeConstants.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text('Actions', style: ThemeConstants.titleMedium),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Get.dialog(
                      AlertDialog(
                        title: const Text('Reset Settings'),
                        content: const Text(
                          'Are you sure you want to reset all settings to default values? This action cannot be undone.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              controller.resetToDefaults();
                              Get.back();
                            },
                            child: const Text('Reset'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.restore),
                  label: const Text('Reset to Defaults'),
                  style: ThemeConstants.secondaryButtonStyle,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement export settings functionality
                    Get.snackbar(
                      'Info',
                      'Export settings functionality coming soon',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Export Settings'),
                  style: ThemeConstants.primaryButtonStyle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implement import settings functionality
                    Get.snackbar(
                      'Info',
                      'Import settings functionality coming soon',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  icon: const Icon(Icons.upload),
                  label: const Text('Import Settings'),
                  style: ThemeConstants.secondaryButtonStyle,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement preview invoice functionality
                    Get.snackbar(
                      'Info',
                      'Invoice preview functionality coming soon',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  icon: const Icon(Icons.preview),
                  label: const Text('Preview Invoice'),
                  style: ThemeConstants.getModuleButtonStyle('purchase'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
