extension UtilDateTime on DateTime {
  String timeAgo() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return "Most recent (Within 24 hours)";
      } else {
        return "Posted ${difference.inHours} hours ago";
      }
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
      return "Posted ${(difference.inDays / 365).round()} years ago";
    }
  }
}
