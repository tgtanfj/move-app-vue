import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/custom_dropdown_button.dart';
import 'package:move_app/presentation/components/custom_edit_text.dart';

class WithoutSavedPayment extends StatelessWidget {
  const WithoutSavedPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Constants.cardholderName,
          style: AppTextStyles.montserratStyle.regular14Black,
        ),
        const CustomEditText(),
        const SizedBox(height: 12),
        Text(
          Constants.country,
          style: AppTextStyles.montserratStyle.regular14Black,
        ),
        const SizedBox(height: 4),
        CustomDropdownButton(onChanged: (value) {}),
        const SizedBox(height: 12),
        Text(
          Constants.cardNumber,
          style: AppTextStyles.montserratStyle.regular14Black,
        ),
        CustomEditText(
          suffix: masterCard(),
        ),
        const SizedBox(height: 12),
        FractionallySizedBox(
          child: Row(
            children: [
              Flexible(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(Constants.expiryDate,
                      style: AppTextStyles.montserratStyle.regular14Black),
                  const CustomEditText(
                    hintText: Constants.mmyy,
                  ),
                ],
              )),
              const SizedBox(width: 8),
              Flexible(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Row(
                      children: [
                        Text(Constants.cvv2,
                            style:
                                AppTextStyles.montserratStyle.regular14Black),
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return cvv2Explain();
                              },
                            );
                          },
                          child: SvgPicture.asset(
                              AppIcons.question.svgAssetPath,
                              width: 18,
                              height: 18),
                        )
                      ],
                    ),
                    const CustomEditText(),
                  ])),
            ],
          ),
        ),
      ],
    );
  }

  Widget masterCard() {
    return Padding(
      padding: const EdgeInsets.all(12),
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

  Widget cvv2Explain() {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Text(
          Constants.cvv2Explain,
          style: AppTextStyles.montserratStyle.regular14Black,
        ),
      ),
    );
  }
}
