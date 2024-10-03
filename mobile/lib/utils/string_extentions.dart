extension OptionalStringExtension on String? {
  bool get isNullOrEmpty {
    if (this == null || this!.isEmpty) {
      return true;
    }
    return false;
  }

  bool get hasValue {
    if (this != null && this!.isNotEmpty) {
      return true;
    }
    return false;
  }

  String truncateWithEllipsis(int numberOfChars) {
    if (this != null) {
      return (this!.length <= numberOfChars)
          ? this!
          : '${this!.substring(0, numberOfChars)}...';
    }
    return '';
  }
}
