import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';

class GenderRadioItem extends StatelessWidget {
  final String title;
  final dynamic groupValue;
  final dynamic value;
  final Function(dynamic) onChanged;

  const GenderRadioItem({
    super.key,
    required this.value,
    required this.groupValue,
    required this.title,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Row(
        children: [
          _customRadioButton(context),
          const SizedBox(width: 8),
          Text(
            title,
            style: AppTextStyles.montserratStyle.regular16Black,
          ),
        ],
      ),
    );
  }

  Widget _customRadioButton(BuildContext context) {
    bool isSelected = value == groupValue;

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: isSelected ? AppColors.tiffanyBlue : AppColors.chineseSilver,
        ),
      ),
      child: Center(
        child: isSelected
            ? Padding(
                padding: const EdgeInsets.all(6),
                child: ClipOval(
                  child: Container(
                    color: AppColors.tiffanyBlue,
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
