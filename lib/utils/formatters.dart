import 'package:intl/intl.dart';

class Formatters {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: 'PKR ',
    decimalDigits: 2,
  );

  static final NumberFormat _numberFormat = NumberFormat.decimalPattern();

  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm');
  static final DateFormat _timeFormat = DateFormat('HH:mm');

  // Currency formatting
  static String formatCurrency(double amount) {
    return _currencyFormat.format(amount);
  }

  // Number formatting
  static String formatNumber(double number) {
    return _numberFormat.format(number);
  }

  // Date formatting
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime);
  }

  static String formatTime(DateTime time) {
    return _timeFormat.format(time);
  }

  // Custom formatting
  static String formatQuantity(double quantity, String unit) {
    return '${formatNumber(quantity)} $unit';
  }

  static String formatPercentage(double percentage) {
    return '${formatNumber(percentage)}%';
  }

  static String formatStockLevel(double current, double min, double max) {
    return '${formatNumber(current)} / ${formatNumber(min)} - ${formatNumber(max)}';
  }

  // Validation helpers
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    return RegExp(r'^\+?[\d\s\-\(\)]{10,}$').hasMatch(phone);
  }

  static bool isValidQuantity(String quantity) {
    final parsed = double.tryParse(quantity);
    return parsed != null && parsed > 0;
  }

  static bool isValidPrice(String price) {
    final parsed = double.tryParse(price);
    return parsed != null && parsed >= 0;
  }
}
