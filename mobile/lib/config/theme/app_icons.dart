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
  filterList,
  like,
  likeFiled,
  dislike,
  dislikeFilled,
  moveReps,
  dots,
  arrowUpTiffany,
  arrowDownTiffany,
  repsSender,
  verify,
  locReps,
  next,
  heart,
  fillHeart,
  more,
  youtubeLogo,
  twitterLogo,
  blueCheckCircle,
  instagram,
  closeCircle,
  back,
  arrowRight,
  arrowRightTiffany,
  dotsTiffany,
  heartTiffany,
  filter,
  arrowWhiteLeft,
  rateStar,
  rateStarFill,
  copied
}

extension AppIconsExtension on AppIcons {
  String get svgAssetPath {
    return 'assets/icons/ic_${name.toString().replaceAllMapped(RegExp(r'[A-Z]'), (match) => '_${match.group(0)}').toLowerCase()}.svg';
  }

  String get pngAssetPath {
    return 'assets/icons/ic_${name.toString().replaceAllMapped(RegExp(r'[A-Z]'), (match) => '_${match.group(0)}').toLowerCase()}.png';
  }
}
