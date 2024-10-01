import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_images.dart';

class HorizontalDivider extends StatelessWidget {
  const HorizontalDivider({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Image.asset(
        AppImages.headlineFull.webpAssetPath,
      ),
    );
  }
}
