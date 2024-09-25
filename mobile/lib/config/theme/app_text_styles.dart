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
  static TextStyle customMontserratStyle(double size,
      Color color,
      FontWeight fontWeight,) {
    return TextStyle(
      fontFamily: AppFontFamily.montserrat.name,
      color: color,
      fontWeight: fontWeight,
      fontSize: size,
    );
  }

  final regular12White =
  customMontserratStyle(12, Colors.white, AppFontWeight.regular.weight);
  final regular16Black = customMontserratStyle(
      16, Colors.black, AppFontWeight.regular.weight);
  final bold16Black = customMontserratStyle(
      16, Colors.black, AppFontWeight.bold.weight);
  final bold16tiffanyBlue = customMontserratStyle(
      16, AppColors.tiffanyBlue, AppFontWeight.bold.weight);
  final bold16White = customMontserratStyle(
      16, Colors.white, AppFontWeight.bold.weight);
  final bold16Grey = customMontserratStyle(
      16, Colors.grey, AppFontWeight.bold.weight);
  final regular14tiffanyBlue = customMontserratStyle(
      14, AppColors.tiffanyBlue, AppFontWeight.regular.weight);
  final regular14sonicSilver = customMontserratStyle(
      14, AppColors.sonicSilver, AppFontWeight.regular.weight);
  final regular14Black = customMontserratStyle(
      14, Colors.black, AppFontWeight.regular.weight);
  final regular14BrinkPink = customMontserratStyle(
      14, AppColors.brinkPink, AppFontWeight.regular.weight);
  final bold14tiffanyBlue = customMontserratStyle(
      14, AppColors.tiffanyBlue, AppFontWeight.bold.weight);
}