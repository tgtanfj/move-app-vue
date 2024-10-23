import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/custom_logout_button.dart';
import 'package:move_app/presentation/screens/buy_rep/widgets/with_saved_payment.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_icons.dart';

class CompletePurchaseDialog extends StatefulWidget {
  const CompletePurchaseDialog({super.key});

  @override
  State<CompletePurchaseDialog> createState() => _CompletePurchaseDialogState();
}

class _CompletePurchaseDialogState extends State<CompletePurchaseDialog> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 5),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: screenHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(Constants.completePurchase,
                        style: AppTextStyles.montserratStyle.bold24black),
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
                Text(
                  Constants.orderSummary,
                  style: AppTextStyles.montserratStyle.bold16DarkSilver,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(Constants.rep,
                        style: AppTextStyles.montserratStyle.bold16black),
                    Text(Constants.us,
                        style: AppTextStyles.montserratStyle.regular16Black)
                  ],
                ),
                const SizedBox(height: 4),
                Text(Constants.oneTimeChargeOn,
                    style: AppTextStyles.montserratStyle.regular14sonicSilver),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(Constants.total,
                        style: AppTextStyles.montserratStyle.regular16Black),
                    Text(Constants.us,
                        style: AppTextStyles.montserratStyle.bold16black)
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  Constants.paymentDetails,
                  style: AppTextStyles.montserratStyle.bold16DarkSilver,
                ),
                const SizedBox(height: 12),
                const WithSavedPayment(),
                const SizedBox(height: 24),
                Text.rich(
                  TextSpan(
                    text: Constants.bySubmittingPayment,
                    style: AppTextStyles.montserratStyle.regular14sonicSilver,
                    children: [
                      TextSpan(
                          text: Constants.endUserLicenseAgreement,
                          style: AppTextStyles
                              .montserratStyle.regular14TiffanyBlue),
                      const TextSpan(text: ', '),
                      TextSpan(
                          text: Constants.privacyPolicy,
                          style: AppTextStyles
                              .montserratStyle.regular14TiffanyBlue),
                      const TextSpan(text: Constants.and),
                      TextSpan(
                          text: Constants.refundPolicy,
                          style: AppTextStyles
                              .montserratStyle.regular14TiffanyBlue),
                      const TextSpan(text: '.'),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                Row(children: [
                  InkWell(
                      splashFactory: NoSplash.splashFactory,
                      onTap: () {
                        setState(() {
                          _value = !_value;
                        });
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.tiffanyBlue,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _value
                            ? const Icon(
                                Icons.check,
                                color: AppColors.tiffanyBlue,
                              )
                            : const SizedBox(),
                      )),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      Constants.saveMyPayment,
                      style: AppTextStyles.montserratStyle.regular14sonicSilver,
                    ),
                  ),
                ]),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                        text: TextSpan(
                            text: Constants.total,
                            style: AppTextStyles.montserratStyle.regular16Black,
                            children: [
                          TextSpan(
                              text: ' ${Constants.us}',
                              style: AppTextStyles.montserratStyle.bold16black)
                        ])),
                    const SizedBox(width: 30),
                    CustomLogoutButton(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      backgroundColor: AppColors.tiffanyBlue,
                      title: Constants.payNow,
                      titleStyle: AppTextStyles.montserratStyle.bold16White,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
