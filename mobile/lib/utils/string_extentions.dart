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

  String shorten() {
    if (this != null) {
      if (this!.contains("less than")) {
        return this!.replaceAll("less than", "<");
      } else if (this!.contains("more than")) {
        return this!.replaceAll("more than", ">");
      }
    }
    return this ?? '';
  }

  String? capitalizeFirstLetter() {
    if (this == null || this!.isEmpty) return this;
    return '${this![0].toUpperCase()}${this!.substring(1)}';
  }
}
