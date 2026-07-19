import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  // Adjust locale/symbol to match your store's currency (e.g. EGP).
  static final NumberFormat _format = NumberFormat.currency(
    locale: 'en_US',
    symbol: '',
    decimalDigits: 2,
  );

  static String format(double amount) => _format.format(amount).trim();
}
