import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';

class GiftRepsSuccessDialog extends StatelessWidget {
  final int amount;
  const GiftRepsSuccessDialog({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
            Text(Constants.donateSuccess,
                style: AppTextStyles.montserratStyle.bold20black),
            const SizedBox(height: 10),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: Constants.youHaveDonated,
                    style: AppTextStyles.montserratStyle.regular16Black,
                  ),
                  TextSpan(
                    text: amount.toString(),
                    style: AppTextStyles.montserratStyle.regular16Black,
                  ),
                  TextSpan(
                    text: Constants.rep$Successfully,
                    style: AppTextStyles.montserratStyle.regular16Black,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
