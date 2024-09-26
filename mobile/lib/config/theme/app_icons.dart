enum AppIcons {
  moveLogo,
  facebookLogo,
  googleLogo,
  close

}

extension AppIconsExtension on AppIcons {
  String get svgAssetPath {
    return 'assets/icons/ic_${name.toString().replaceAllMapped(RegExp(r'[A-Z]'), (match) => '_${match.group(0)}').toLowerCase()}.svg';
  }

  String get pngAssetPath {
    return 'assets/icons/ic_${name.toString().replaceAllMapped(RegExp(r'[A-Z]'), (match) => '_${match.group(0)}').toLowerCase()}.png';
  }
}