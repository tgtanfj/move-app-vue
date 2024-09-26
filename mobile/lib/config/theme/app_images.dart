enum AppImages {
  hiitCategory,
  headline,
}

extension AppImagesExtension on AppImages {
  String get pngAssetPath {
    return 'assets/images/img_${name.toString().replaceAllMapped(RegExp(r'[A-Z]'), (match) => '_${match.group(0)}').toLowerCase()}.png';
  }

  String get webpAssetPath {
    return 'assets/images/img_${name.toString().replaceAllMapped(RegExp(r'[A-Z]'), (match) => '_${match.group(0)}').toLowerCase()}.webp';
  }
}
