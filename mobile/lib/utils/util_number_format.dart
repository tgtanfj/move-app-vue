import 'package:intl/intl.dart';

extension UtilNumberFormat on int {
  String toCompactViewCount() {
    if (this >= 1000000000) {
      return "${(this / 1000000000).toStringAsFixed(1)}B";
    } else if (this >= 1000000) {
      return "${(this / 1000000).toStringAsFixed(1)}M";
    } else if (this >= 1000) {
      return "${(this / 1000).toStringAsFixed(1)}K";
    } else {
      return toString();
    }
  }
  String toDurationFormat() {
    int hours = this ~/ 3600;            
    int minutes = (this % 3600) ~/ 60;   
    int seconds = this % 60;             

    String minutesStr = minutes < 10 ? '0$minutes' : '$minutes'; 
    String secondsStr = seconds < 10 ? '0$seconds' : '$seconds';

    if (hours > 0) {
      return '$hours:$minutesStr:$secondsStr'; 
    } else {
      return '$minutes:$secondsStr'; 
    }
  }

  static String formatWithCommas(num value) {
    final formatter = NumberFormat('#,###');
    return formatter.format(value);
  }
}
