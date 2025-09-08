import 'package:intl/intl.dart';

class Formatters {
  static String formateDate(DateTime? date) {
    date ??= DateTime.now();
    return DateFormat("dd-MMM-yyyy").format(date);
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'en_US', symbol: "GHC")
        .format(amount);
  }

  static String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length == 10) {
      return '(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, 6)} ${phoneNumber.substring(6)}';
    }
    return phoneNumber;
  }
}
