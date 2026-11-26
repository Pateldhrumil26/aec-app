import 'package:intl/intl.dart';

class AppFormatters {
  static final DateFormat _shortDate = DateFormat('dd MMM yyyy');
  static final DateFormat _dateTime = DateFormat('dd MMM yyyy, hh:mm a');
  static final DateFormat _timeOnly = DateFormat('hh:mm a');

  static String date(DateTime dt) => _shortDate.format(dt);
  static String dateTime(DateTime dt) => _dateTime.format(dt);
  static String time(DateTime dt) => _timeOnly.format(dt);
  static String currency(double amount) => rupee(amount, decimal: false);

  // Indian Rupee currency format (e.g., ₹27,04,518.70 or ₹6,16,432)
  static String rupee(double amount, {bool decimal = true}) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: decimal ? 2 : 0,
    );
    return formatter.format(amount);
  }

  // Compact Indian Currency (e.g., ₹27.05 L or ₹12.50 Cr)
  static String compactRupee(double amount) {
    if (amount >= 10000000) {
      return '₹${(amount / 10000000).toStringAsFixed(2)} Cr';
    } else if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(2)} L';
    } else if (amount >= 1000) {
      return '₹${(amount / 1000).toStringAsFixed(1)} K';
    }
    return '₹${amount.toStringAsFixed(0)}';
  }

  static String formatSeconds(int totalSeconds) {
    final hours = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}
