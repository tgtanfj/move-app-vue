import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_text_styles.dart';

class TypeLabel extends StatelessWidget {
  final String typeLabel;
  const TypeLabel({super.key, required this.typeLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9.0),
      height: 26.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13.0),
        color: AppColors.chineseSilver,
      ),
      child: Center(
        child: Text(
          typeLabel,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.montserratStyle.bold10darkCharcoal,
        ),
      ),
    );
  }
}
