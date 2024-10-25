import 'package:intl/intl.dart';

class UtilDateTimeFormat{
  String formatDateMonthYear(DateTime? date) {
    if (date != null) {
      return DateFormat('dd MMM yyyy').format(date!);
    }
    return "No date to format";
  }

  String formatMonthDateYear(DateTime? date) {
    if (date != null) {
      return DateFormat('MMMM dd yyyy').format(date!);
    }
    return "No date to format";
  }

  String formatTime(DateTime? date) {
    if (date != null) {
      return DateFormat('hh:mm:ss a').format(date!);
    }
    return "No time to format";
  }
}