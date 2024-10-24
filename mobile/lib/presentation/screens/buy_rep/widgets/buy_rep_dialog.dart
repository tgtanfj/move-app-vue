import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/data_sources/dummy_data.dart';
import 'package:move_app/presentation/screens/buy_rep/widgets/rep_item.dart';

class BuyRepDialog extends StatelessWidget {
  final bool isBack;

  const BuyRepDialog({super.key, this.isBack = false});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: AppColors.white,
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
                    isBack
                        ? Row(
                            children: [
                              InkWell(
                                onTap: () {},
                                child: SvgPicture.asset(
                                  AppIcons.arrowLeft.svgAssetPath,
                                  width: 10,
                                  height: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                Constants.back,
                                style: AppTextStyles
                                    .montserratStyle.regular14Black,
                              )
                            ],
                          )
                        : const SizedBox(),
                    SizedBox(height: isBack ? 10 : 0),
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
                            text: Constants.rep,
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
                return RepItem(
                  rep: reps[index],
                  onRepSelect: () {},
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: reps.length,
            ),
          ],
        ),
      ),
    );
  }
}