import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_images.dart';

class HorizontalDivider extends StatelessWidget {
  const HorizontalDivider({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Image.asset(
        width: MediaQuery.of(context).size.width - 0,
        AppImages.headlineFull.webpAssetPath,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
