import 'package:intl/intl.dart';

class AppFormat {
  static String money(double value) => '₹${value.toStringAsFixed(2)}';
  static String date(DateTime value) => DateFormat('dd MMM yyyy').format(value);
}
