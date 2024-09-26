import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_images.dart';
import 'package:move_app/config/theme/app_text_styles.dart';

class CustomSectionTitle extends StatelessWidget {
  final String title;

  const CustomSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: AppTextStyles.montserratStyle.bold20Black,
        ),
        const SizedBox(width: 20),
        Expanded(
          child: ClipRRect(
              child: Image.asset(
            AppImages.headline.webpAssetPath,
            fit: BoxFit.cover,
          )),
        ),
      ],
    );
  }
}
