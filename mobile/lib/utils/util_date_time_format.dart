import 'package:intl/intl.dart';
import 'package:move_app/constants/constants.dart';

class UtilDateTimeFormat{
  String formatDateMonthYear(DateTime? date) {
    if (date != null) {
      return DateFormat(Constants.dayMonthYear).format(date!);
    }
    return Constants.noDateFormat;
  }

  String formatMonthDateYear(DateTime? date) {
    if (date != null) {
      return DateFormat(Constants.monthDayYear).format(date!);
    }
    return Constants.noDateFormat;
  }

  String formatTime(DateTime? date) {
    if (date != null) {
      return DateFormat(Constants.timeFormat).format(date!);
    }
    return Constants.noDateFormat;
  }
}