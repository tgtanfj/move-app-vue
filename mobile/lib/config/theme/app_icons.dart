enum AppIcons {
  moveLogo,
  search,
  drawer,
  moveWhiteTextLogo,
  blueStick,
  starFlower,
  star,
  eye,
  facebookLogo,
  googleLogo,
  close,
  password,
  radioSelected,
  radio,
  dropdown,
  rep,
  notification,
  arrowUp,
  arrowDown,
  addVideo,
  closeWhite,
  faqs,
  closeCircle,
  back
}

extension AppIconsExtension on AppIcons {
  String get svgAssetPath {
    return 'assets/icons/ic_${name.toString().replaceAllMapped(RegExp(r'[A-Z]'), (match) => '_${match.group(0)}').toLowerCase()}.svg';
  }

  String get pngAssetPath {
    return 'assets/icons/ic_${name.toString().replaceAllMapped(RegExp(r'[A-Z]'), (match) => '_${match.group(0)}').toLowerCase()}.png';
  }
}
