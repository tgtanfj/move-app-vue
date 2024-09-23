import 'package:flutter/material.dart';

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
  customMontserratStyle(12, Colors.white, AppFontWeight.regular.weight);
}