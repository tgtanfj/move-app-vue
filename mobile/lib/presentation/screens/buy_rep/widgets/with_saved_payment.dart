import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_icons.dart';

class WithSavedPayment extends StatelessWidget {
  const WithSavedPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            masterCard(),
            Text(
              Constants.visaEndingWith,
              style: AppTextStyles.montserratStyle.regular16Black,
            ),
          ],
        ),
        InkWell(
            onTap: () {},
            child: Text(
              Constants.change,
              style: AppTextStyles.montserratStyle.regular16tiffanyBlue,
            ))
      ],
    );
  }

  Widget masterCard() {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
          height: 25,
          width: 34,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.chineseSilver,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: SvgPicture.asset(
            AppIcons.masterCard.svgAssetPath,
          )),
    );
  }
}
