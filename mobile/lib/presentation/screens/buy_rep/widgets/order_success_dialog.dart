import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';

import '../../../../config/theme/app_icons.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../constants/constants.dart';
import '../../../components/custom_button.dart';

class OrderSuccessDialog extends StatelessWidget {
  const OrderSuccessDialog({super.key});

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Constants.orderSuccess,
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
              '${Constants.yourPurchaseOf} ${Constants.rep} ${Constants.isSuccessful}',
              style: AppTextStyles.montserratStyle.regular16DarkSilver,
            ),
            const SizedBox(height: 10),
            CustomButton(
              backgroundColor: AppColors.tiffanyBlue,
              title: Constants.okay,
              titleStyle: AppTextStyles.montserratStyle.bold16White,
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
