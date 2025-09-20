import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  // Invoice Settings
  final RxString invoiceFormat = 'A4'.obs;
  final RxString invoiceOrientation = 'Portrait'.obs;
  final RxString invoiceTemplate = 'Standard'.obs;
  final RxBool showCompanyLogo = true.obs;
  final RxBool showCompanyAddress = true.obs;
  final RxBool showCompanyPhone = true.obs;
  final RxBool showCompanyEmail = true.obs;
  final RxBool showTermsAndConditions = true.obs;
  final RxString invoiceFooter = ''.obs;
  final RxString invoiceHeader = ''.obs;

  // Company Information
  final RxString companyName = 'Steel Factory Ltd.'.obs;
  final RxString companyAddress = 'Industrial Area, City, Country'.obs;
  final RxString companyPhone = '+1 234 567 8900'.obs;
  final RxString companyEmail = 'info@steelfactory.com'.obs;
  final RxString companyWebsite = 'www.steelfactory.com'.obs;
  final RxString companyTaxNumber = 'TAX123456789'.obs;
  final RxString companyRegistrationNumber = 'REG987654321'.obs;

  // Currency and Localization
  final RxString currency = 'PKR'.obs;
  final RxString currencySymbol = '₨'.obs;
  final RxString dateFormat = 'DD/MM/YYYY'.obs;
  final RxString timeFormat = '24 Hour'.obs;
  final RxString language = 'English'.obs;

  // General Settings
  final RxBool autoBackup = true.obs;
  final RxBool notifications = true.obs;
  final RxBool darkMode = false.obs;
  final RxInt backupFrequency = 7.obs; // days
  final RxBool showTutorial = true.obs;

  // Invoice Number Settings
  final RxString invoicePrefix = 'INV'.obs;
  final RxString salePrefix = 'SALE'.obs;
  final RxString purchasePrefix = 'PUR'.obs;
  final RxBool autoIncrementInvoice = true.obs;
  final RxInt invoiceStartNumber = 1.obs;

  // Page Settings
  final RxDouble pageMargin = 20.0.obs;
  final RxDouble headerHeight = 100.0.obs;
  final RxDouble footerHeight = 50.0.obs;
  final RxString pageSize = 'A4'.obs;
  final RxString pageOrientation = 'Portrait'.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Invoice Settings
      invoiceFormat.value = prefs.getString('invoice_format') ?? 'A4';
      invoiceOrientation.value =
          prefs.getString('invoice_orientation') ?? 'Portrait';
      invoiceTemplate.value = prefs.getString('invoice_template') ?? 'Standard';
      showCompanyLogo.value = prefs.getBool('show_company_logo') ?? true;
      showCompanyAddress.value = prefs.getBool('show_company_address') ?? true;
      showCompanyPhone.value = prefs.getBool('show_company_phone') ?? true;
      showCompanyEmail.value = prefs.getBool('show_company_email') ?? true;
      showTermsAndConditions.value =
          prefs.getBool('show_terms_conditions') ?? true;
      invoiceFooter.value = prefs.getString('invoice_footer') ?? '';
      invoiceHeader.value = prefs.getString('invoice_header') ?? '';

      // Company Information
      companyName.value =
          prefs.getString('company_name') ?? 'Steel Factory Ltd.';
      companyAddress.value =
          prefs.getString('company_address') ??
          'Industrial Area, City, Country';
      companyPhone.value =
          prefs.getString('company_phone') ?? '+1 234 567 8900';
      companyEmail.value =
          prefs.getString('company_email') ?? 'info@steelfactory.com';
      companyWebsite.value =
          prefs.getString('company_website') ?? 'www.steelfactory.com';
      companyTaxNumber.value =
          prefs.getString('company_tax_number') ?? 'TAX123456789';
      companyRegistrationNumber.value =
          prefs.getString('company_registration_number') ?? 'REG987654321';

      // Currency and Localization
      currency.value = prefs.getString('currency') ?? 'PKR';
      currencySymbol.value = prefs.getString('currency_symbol') ?? '₨';
      dateFormat.value = prefs.getString('date_format') ?? 'DD/MM/YYYY';
      timeFormat.value = prefs.getString('time_format') ?? '24 Hour';
      language.value = prefs.getString('language') ?? 'English';

      // General Settings
      autoBackup.value = prefs.getBool('auto_backup') ?? true;
      notifications.value = prefs.getBool('notifications') ?? true;
      darkMode.value = prefs.getBool('dark_mode') ?? false;
      backupFrequency.value = prefs.getInt('backup_frequency') ?? 7;
      showTutorial.value = prefs.getBool('show_tutorial') ?? true;

      // Invoice Number Settings
      invoicePrefix.value = prefs.getString('invoice_prefix') ?? 'INV';
      salePrefix.value = prefs.getString('sale_prefix') ?? 'SALE';
      purchasePrefix.value = prefs.getString('purchase_prefix') ?? 'PUR';
      autoIncrementInvoice.value =
          prefs.getBool('auto_increment_invoice') ?? true;
      invoiceStartNumber.value = prefs.getInt('invoice_start_number') ?? 1;

      // Page Settings
      pageMargin.value = prefs.getDouble('page_margin') ?? 20.0;
      headerHeight.value = prefs.getDouble('header_height') ?? 100.0;
      footerHeight.value = prefs.getDouble('footer_height') ?? 50.0;
      pageSize.value = prefs.getString('page_size') ?? 'A4';
      pageOrientation.value = prefs.getString('page_orientation') ?? 'Portrait';
    } catch (e) {
      print('Error loading settings: $e');
    }
  }

  Future<void> saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Invoice Settings
      await prefs.setString('invoice_format', invoiceFormat.value);
      await prefs.setString('invoice_orientation', invoiceOrientation.value);
      await prefs.setString('invoice_template', invoiceTemplate.value);
      await prefs.setBool('show_company_logo', showCompanyLogo.value);
      await prefs.setBool('show_company_address', showCompanyAddress.value);
      await prefs.setBool('show_company_phone', showCompanyPhone.value);
      await prefs.setBool('show_company_email', showCompanyEmail.value);
      await prefs.setBool(
        'show_terms_conditions',
        showTermsAndConditions.value,
      );
      await prefs.setString('invoice_footer', invoiceFooter.value);
      await prefs.setString('invoice_header', invoiceHeader.value);

      // Company Information
      await prefs.setString('company_name', companyName.value);
      await prefs.setString('company_address', companyAddress.value);
      await prefs.setString('company_phone', companyPhone.value);
      await prefs.setString('company_email', companyEmail.value);
      await prefs.setString('company_website', companyWebsite.value);
      await prefs.setString('company_tax_number', companyTaxNumber.value);
      await prefs.setString(
        'company_registration_number',
        companyRegistrationNumber.value,
      );

      // Currency and Localization
      await prefs.setString('currency', currency.value);
      await prefs.setString('currency_symbol', currencySymbol.value);
      await prefs.setString('date_format', dateFormat.value);
      await prefs.setString('time_format', timeFormat.value);
      await prefs.setString('language', language.value);

      // General Settings
      await prefs.setBool('auto_backup', autoBackup.value);
      await prefs.setBool('notifications', notifications.value);
      await prefs.setBool('dark_mode', darkMode.value);
      await prefs.setInt('backup_frequency', backupFrequency.value);
      await prefs.setBool('show_tutorial', showTutorial.value);

      // Invoice Number Settings
      await prefs.setString('invoice_prefix', invoicePrefix.value);
      await prefs.setString('sale_prefix', salePrefix.value);
      await prefs.setString('purchase_prefix', purchasePrefix.value);
      await prefs.setBool('auto_increment_invoice', autoIncrementInvoice.value);
      await prefs.setInt('invoice_start_number', invoiceStartNumber.value);

      // Page Settings
      await prefs.setDouble('page_margin', pageMargin.value);
      await prefs.setDouble('header_height', headerHeight.value);
      await prefs.setDouble('footer_height', footerHeight.value);
      await prefs.setString('page_size', pageSize.value);
      await prefs.setString('page_orientation', pageOrientation.value);

      Get.snackbar(
        'Success',
        'Settings saved successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save settings: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void resetToDefaults() {
    // Invoice Settings
    invoiceFormat.value = 'A4';
    invoiceOrientation.value = 'Portrait';
    invoiceTemplate.value = 'Standard';
    showCompanyLogo.value = true;
    showCompanyAddress.value = true;
    showCompanyPhone.value = true;
    showCompanyEmail.value = true;
    showTermsAndConditions.value = true;
    invoiceFooter.value = '';
    invoiceHeader.value = '';

    // Company Information
    companyName.value = 'Steel Factory Ltd.';
    companyAddress.value = 'Industrial Area, City, Country';
    companyPhone.value = '+1 234 567 8900';
    companyEmail.value = 'info@steelfactory.com';
    companyWebsite.value = 'www.steelfactory.com';
    companyTaxNumber.value = 'TAX123456789';
    companyRegistrationNumber.value = 'REG987654321';

    // Currency and Localization
    currency.value = 'PKR';
    currencySymbol.value = '₨';
    dateFormat.value = 'DD/MM/YYYY';
    timeFormat.value = '24 Hour';
    language.value = 'English';

    // General Settings
    autoBackup.value = true;
    notifications.value = true;
    darkMode.value = false;
    backupFrequency.value = 7;
    showTutorial.value = true;

    // Invoice Number Settings
    invoicePrefix.value = 'INV';
    salePrefix.value = 'SALE';
    purchasePrefix.value = 'PUR';
    autoIncrementInvoice.value = true;
    invoiceStartNumber.value = 1;

    // Page Settings
    pageMargin.value = 20.0;
    headerHeight.value = 100.0;
    footerHeight.value = 50.0;
    pageSize.value = 'A4';
    pageOrientation.value = 'Portrait';
  }

  // Helper methods for invoice generation
  String generateInvoiceNumber(String type) {
    final prefix = type == 'sale'
        ? salePrefix.value
        : type == 'purchase'
        ? purchasePrefix.value
        : invoicePrefix.value;
    final date = DateTime.now();
    final dateStr =
        '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';
    return '$prefix-$dateStr';
  }

  Map<String, dynamic> getInvoiceSettings() {
    return {
      'format': invoiceFormat.value,
      'orientation': invoiceOrientation.value,
      'template': invoiceTemplate.value,
      'pageSize': pageSize.value,
      'pageOrientation': pageOrientation.value,
      'margin': pageMargin.value,
      'headerHeight': headerHeight.value,
      'footerHeight': footerHeight.value,
      'showCompanyLogo': showCompanyLogo.value,
      'showCompanyAddress': showCompanyAddress.value,
      'showCompanyPhone': showCompanyPhone.value,
      'showCompanyEmail': showCompanyEmail.value,
      'showTermsAndConditions': showTermsAndConditions.value,
      'footer': invoiceFooter.value,
      'header': invoiceHeader.value,
    };
  }

  Map<String, dynamic> getCompanyInfo() {
    return {
      'name': companyName.value,
      'address': companyAddress.value,
      'phone': companyPhone.value,
      'email': companyEmail.value,
      'website': companyWebsite.value,
      'taxNumber': companyTaxNumber.value,
      'registrationNumber': companyRegistrationNumber.value,
    };
  }
}
