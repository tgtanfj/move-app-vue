import '../constants/constants.dart';

extension UtilDateTime on DateTime {
  String getTimeDifference() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.isNegative) {
      return Constants.justNow;
    }

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} ${difference.inSeconds == 1 ? Constants.secondAgo : Constants.secondsAgo}';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? Constants.minuteAgo : Constants.minutesAgo}';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${difference.inHours == 1 ? Constants.hourAgo : Constants.hoursAgo}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${difference.inDays == 1 ? Constants.dayAgo : Constants.daysAgo}';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? Constants.weekAgo : Constants.weeksAgo}';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? Constants.monthAgo : Constants.monthsAgo}';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? Constants.yeasAgo : Constants.yeasAgo}';
    }
  }
  String timeAgo() {
      final now = DateTime.now();
      final difference = now.difference(this);
      if (difference.inDays == 0) {
          return "Most recent";
      } else if (difference.inDays == 1) {
          return "Posted a day ago";
      } else if (difference.inDays <= 6) {
          return "Posted ${difference.inDays} days ago";
      } else if (difference.inDays == 7) {
          return "A week ago";
      } else if (difference.inDays < 30) {
          return "Posted ${(difference.inDays / 7).round()} weeks ago";
      } else if (difference.inDays < 365) {
          return "A month ago";
      } else {
          return "Posted ${(difference.inDays / 365).round()} year(s) ago";
      }
  }
}
