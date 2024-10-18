import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';

class ThanksRateDialog extends StatelessWidget {
  const ThanksRateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Constants.rateThanksTitle,
                  style: AppTextStyles.montserratStyle.bold20Black,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(
                    AppIcons.close.svgAssetPath,
                    width: 18,
                    height: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              Constants.rateThanksContent,
              style: AppTextStyles.montserratStyle.regular16DarkSilver,
            ),
          ],
        ),
      ),
    );
  }
}
