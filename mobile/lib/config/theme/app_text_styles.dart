import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_colors.dart';

enum AppFontFamily { montserrat }

enum AppFontWeight { regular, medium, semiBold, bold }

extension AppFontFamilyDefault on AppFontFamily {
  String get name {
    switch (this) {
      case AppFontFamily.montserrat:
        return 'Montserrat';
    }
  }
}

extension MontserratFontWeight on AppFontWeight {
  FontWeight get weight {
    switch (this) {
      case AppFontWeight.regular:
        return FontWeight.w400;
      case AppFontWeight.medium:
        return FontWeight.w500;
      case AppFontWeight.semiBold:
        return FontWeight.w600;
      case AppFontWeight.bold:
        return FontWeight.w700;
    }
  }
}

class AppTextStyles {
  const AppTextStyles._();

  static MontserratStyles montserratStyle = MontserratStyles();
}

class MontserratStyles {
  static TextStyle customMontserratStyle(
    double size,
    Color color,
    FontWeight fontWeight,
  ) {
    return TextStyle(
      fontFamily: AppFontFamily.montserrat.name,
      color: color,
      fontWeight: fontWeight,
      fontSize: size,
    );
  }

  final regular12White =
      customMontserratStyle(12, AppColors.white, AppFontWeight.regular.weight);
  final regular12Black =
      customMontserratStyle(12, AppColors.black, AppFontWeight.regular.weight);
  final bold12Black =
      customMontserratStyle(12, AppColors.black, AppFontWeight.bold.weight);
  final regular16Black =
      customMontserratStyle(16, Colors.black, AppFontWeight.regular.weight);
  final regular16TiffanyBlue = customMontserratStyle(
      16, AppColors.tiffanyBlue, AppFontWeight.regular.weight);
  final regular16BrinkPink = customMontserratStyle(
      16, AppColors.brinkPink, AppFontWeight.regular.weight);
  final bold16Black =
      customMontserratStyle(16, Colors.black, AppFontWeight.bold.weight);
  final bold16tiffanyBlue = customMontserratStyle(
      16, AppColors.tiffanyBlue, AppFontWeight.bold.weight);
  final bold16White =
      customMontserratStyle(16, Colors.white, AppFontWeight.bold.weight);
  final bold16Grey =
      customMontserratStyle(16, Colors.grey, AppFontWeight.bold.weight);

  final regular14tiffanyBlue = customMontserratStyle(
      14, AppColors.tiffanyBlue, AppFontWeight.regular.weight);
  final regular14sonicSilver = customMontserratStyle(
      14, AppColors.sonicSilver, AppFontWeight.regular.weight);
  final regular14Black =
      customMontserratStyle(14, Colors.black, AppFontWeight.regular.weight);
  final regular14BrinkPink = customMontserratStyle(
      14, AppColors.brinkPink, AppFontWeight.regular.weight);
  final bold14tiffanyBlue = customMontserratStyle(
      14, AppColors.tiffanyBlue, AppFontWeight.bold.weight);
  final bold16chineseSilverGray = customMontserratStyle(
      16, AppColors.chineseSilver, AppFontWeight.bold.weight);
  final bold14Black =
      customMontserratStyle(14, AppColors.black, AppFontWeight.bold.weight);
  final bold14White =
      customMontserratStyle(14, AppColors.white, AppFontWeight.bold.weight);
  final regular14TiffanyBlue = customMontserratStyle(
      14, AppColors.tiffanyBlue, AppFontWeight.regular.weight);
  final bold16TiffanyBlue = customMontserratStyle(
      16, AppColors.tiffanyBlue, AppFontWeight.bold.weight);
  final bold20Black =
      customMontserratStyle(20, AppColors.black, AppFontWeight.bold.weight);
  final bold23White =
      customMontserratStyle(23, AppColors.white, AppFontWeight.bold.weight);
  final bold20black =
      customMontserratStyle(20, AppColors.black, AppFontWeight.bold.weight);
  final bold12White =
      customMontserratStyle(12, AppColors.white, AppFontWeight.bold.weight);
  final bold18black =
      customMontserratStyle(18, AppColors.black, AppFontWeight.bold.weight);
  final bold16black =
      customMontserratStyle(16, AppColors.black, AppFontWeight.bold.weight);
  final regular14graniteGray = customMontserratStyle(
      14, AppColors.graniteGray, AppFontWeight.regular.weight);
  final bold10darkCharcoal = customMontserratStyle(
      10, AppColors.darkCharcoal, AppFontWeight.bold.weight);
  final regular18tiffanyBlue = customMontserratStyle(
      18, AppColors.tiffanyBlue, AppFontWeight.regular.weight);
  final bold17White =
      customMontserratStyle(17, AppColors.white, AppFontWeight.bold.weight);
  final bold20White =
      customMontserratStyle(20, AppColors.white, AppFontWeight.bold.weight);
  final regular16White =
      customMontserratStyle(16, AppColors.white, AppFontWeight.regular.weight);
  final medium16TiffanyBlue = customMontserratStyle(
      16, AppColors.tiffanyBlue, AppFontWeight.medium.weight);

  final semiBold14Rajah =
      customMontserratStyle(14, AppColors.rajah, AppFontWeight.semiBold.weight);
  final regular14GraniteGray = customMontserratStyle(
      14, AppColors.graniteGray, AppFontWeight.regular.weight);
  final semiBold16black =
      customMontserratStyle(16, AppColors.black, AppFontWeight.semiBold.weight);
  final semiBold16Grey =
      customMontserratStyle(16, Colors.grey, AppFontWeight.semiBold.weight);
  final regular20Black =
      customMontserratStyle(20, AppColors.black, AppFontWeight.regular.weight);
  final bold18White =
      customMontserratStyle(18, AppColors.white, AppFontWeight.bold.weight);
  final regular13GraniteGray = customMontserratStyle(
      13, AppColors.graniteGray, AppFontWeight.regular.weight);
  final regular16tiffanyBlue = customMontserratStyle(
      16, AppColors.tiffanyBlue, AppFontWeight.regular.weight);
  final bold24black =
      customMontserratStyle(24, AppColors.black, AppFontWeight.bold.weight);
  final regular16DarkSilver = customMontserratStyle(
      16, AppColors.darkSilver, AppFontWeight.regular.weight);
  final regular14Grey = customMontserratStyle(
      14, Colors.grey, AppFontWeight.regular.weight);
  final medium12Grey = customMontserratStyle(
      12, Colors.grey, AppFontWeight.medium.weight);
  final regular12Grey = customMontserratStyle(
      12, Colors.grey, AppFontWeight.regular.weight);
}
