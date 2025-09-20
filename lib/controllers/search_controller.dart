import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSearchController extends GetxController {
  final TextEditingController searchTextController = TextEditingController();
  final RxString searchText = ''.obs;
  final RxBool isSearching = false.obs;
  Timer? _debounceTimer;

  // Debounce duration in milliseconds
  static const int debounceDuration = 300;

  @override
  void onInit() {
    super.onInit();
    // Listen to text changes
    searchTextController.addListener(_onTextChanged);
  }

  @override
  void onClose() {
    searchTextController.dispose();
    _debounceTimer?.cancel();
    super.onClose();
  }

  void _onTextChanged() {
    final text = searchTextController.text;

    // Cancel previous timer
    _debounceTimer?.cancel();

    // Start new debounced timer
    _debounceTimer = Timer(const Duration(milliseconds: debounceDuration), () {
      // Trigger search callback if set
      if (_onSearchCallback != null) {
        _onSearchCallback!(text);
      }
    });
  }

  // Callback function for search
  Function(String)? _onSearchCallback;

  // Set search callback
  void setSearchCallback(Function(String) callback) {
    _onSearchCallback = callback;
  }

  // Clear search
  void clearSearch() {
    searchTextController.clear();
    _debounceTimer?.cancel();
    // Trigger search callback to update filtered results
    if (_onSearchCallback != null) {
      _onSearchCallback!('');
    }
  }

  // Get search text
  String get searchQuery => searchTextController.text.toLowerCase().trim();

  // Check if search is active
  bool get hasSearchQuery => searchTextController.text.trim().isNotEmpty;

  // Generic search function for any list
  List<T> searchList<T>(List<T> items, String Function(T) getSearchableText) {
    if (!hasSearchQuery) {
      return items;
    }

    return items.where((item) {
      final searchableText = getSearchableText(item).toLowerCase();
      return searchableText.contains(searchQuery);
    }).toList();
  }

  // Search purchases by invoice number or supplier name
  List<T> searchPurchases<T>(
    List<T> purchases,
    String Function(T) getInvoiceNumber,
    String Function(T) getSupplierName,
  ) {
    if (!hasSearchQuery) {
      return purchases;
    }

    return purchases.where((purchase) {
      final invoiceNumber = getInvoiceNumber(purchase).toLowerCase();
      final supplierName = getSupplierName(purchase).toLowerCase();

      return invoiceNumber.contains(searchQuery) ||
          supplierName.contains(searchQuery);
    }).toList();
  }

  // Search products by name or category
  List<T> searchProducts<T>(
    List<T> products,
    String Function(T) getName,
    String Function(T) getCategory,
  ) {
    if (!hasSearchQuery) {
      return products;
    }

    return products.where((product) {
      final name = getName(product).toLowerCase();
      final category = getCategory(product).toLowerCase();

      return name.contains(searchQuery) || category.contains(searchQuery);
    }).toList();
  }

  // Search sales by invoice number or customer name
  List<T> searchSales<T>(
    List<T> sales,
    String Function(T) getInvoiceNumber,
    String Function(T) getCustomerName,
  ) {
    if (!hasSearchQuery) {
      return sales;
    }

    return sales.where((sale) {
      final invoiceNumber = getInvoiceNumber(sale).toLowerCase();
      final customerName = getCustomerName(sale).toLowerCase();

      return invoiceNumber.contains(searchQuery) ||
          customerName.contains(searchQuery);
    }).toList();
  }
}
