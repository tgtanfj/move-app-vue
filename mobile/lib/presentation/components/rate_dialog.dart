import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_icons.dart';
import '../../config/theme/app_text_styles.dart';
import '../../constants/constants.dart';
import 'custom_button.dart';

class RateDialog extends StatefulWidget {
  final int rateSelected;
  const RateDialog({super.key, required this.rateSelected});

  @override
  State<RateDialog> createState() => _RateDialogState();
}

class _RateDialogState extends State<RateDialog> {
  late int rating;
  @override
  void initState() {
    rating = widget.rateSelected;
    super.initState();
  }

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
                  Constants.rateTheVideo,
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
              Constants.rateQuestion,
              style: AppTextStyles.montserratStyle.regular16DarkSilver,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (int index = 0; index < 5; index++)
                  IconButton(
                    icon: index < rating
                        ? SvgPicture.asset(
                            AppIcons.rateStarFill.svgAssetPath,
                            width: 32,
                            height: 32,
                          )
                        : SvgPicture.asset(
                            AppIcons.rateStar.svgAssetPath,
                            width: 32,
                            height: 32,
                          ),
                    onPressed: () {
                      setState(() {
                        rating = index + 1;
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 10),
            CustomButton(
              isEnabled: rating != 0 && rating != widget.rateSelected,
              title: Constants.submit,
              titleStyle: AppTextStyles.montserratStyle.bold16White,
              borderColor: rating != 0 && rating != widget.rateSelected
                  ? AppColors.tiffanyBlue
                  : AppColors.spanishGray,
              backgroundColor: rating != 0 && rating != widget.rateSelected
                  ? AppColors.tiffanyBlue
                  : AppColors.spanishGray,
              onTap: () {
                Navigator.pop(context, rating);
              },
            )
          ],
        ),
      ),
    );
  }
}
