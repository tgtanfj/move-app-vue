import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/models/rep_model.dart';
import 'package:move_app/presentation/components/custom_button.dart';

import '../../../../config/theme/app_icons.dart';
import '../../../../data/data_sources/dummy_data.dart';

class BuyRepDialog extends StatelessWidget {
  const BuyRepDialog({super.key});

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Constants.buyREP,
                      style: AppTextStyles.montserratStyle.bold24black,
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        text: Constants.youHave,
                        style: AppTextStyles.montserratStyle.regular16Black,
                        children: [
                          TextSpan(
                            text: 'REP\$',
                            style: AppTextStyles.montserratStyle.bold16black,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      Constants.priceUSD,
                      style: AppTextStyles.montserratStyle.regular16DarkSilver,
                    ),
                  ],
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
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return repItem(reps[index], () {});
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: reps.length,
            ),
          ],
        ),
      ),
    );
  }

  Widget repItem(RepModel rep, VoidCallback onRepSelect) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            flex: 7,
            child: Text(
              '${rep.rep} ${Constants.rep}',
              style: AppTextStyles.montserratStyle.bold16black,
            ),
          ),
          Flexible(
            flex: 3,
            child: CustomButton(
              onTap: onRepSelect,
              padding: const EdgeInsets.symmetric(vertical: 10),
              title: '${Constants.us}${rep.price}',
              titleStyle: AppTextStyles.montserratStyle.bold16White,
              backgroundColor: AppColors.tiffanyBlue,
            ),
          ),
        ],
      ),
    );
  }
}
