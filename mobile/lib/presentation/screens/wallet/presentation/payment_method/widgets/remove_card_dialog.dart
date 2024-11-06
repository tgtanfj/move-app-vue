import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/custom_button.dart';

class RemoveCardDialog extends StatelessWidget {
  final VoidCallback yesCallback;

  const RemoveCardDialog({super.key, required this.yesCallback});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Constants.removeCard,
                  style: AppTextStyles.montserratStyle.bold16Black,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(
                    AppIcons.close.svgAssetPath,
                    width: 16,
                    height: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              Constants.confirmRemoveCard,
              style: AppTextStyles.montserratStyle.regular14Black,
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                CustomButton(
                  onTap: yesCallback,
                  title: Constants.remove,
                  titleStyle: AppTextStyles.montserratStyle.bold16White,
                  backgroundColor: AppColors.tiffanyBlue,
                  borderColor: AppColors.tiffanyBlue,
                ),
                const SizedBox(height: 8.0),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    Constants.cancel,
                    style: AppTextStyles.montserratStyle.regular16TiffanyBlue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
