import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/custom_button.dart';

class VerificationFailed extends StatelessWidget {
  final double _dialogWidth = 374.0;
  const VerificationFailed({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Stack(
        children: [
          Center(
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: AppColors.white,
              child: Container(
                padding: const EdgeInsets.all(16),
                width: _dialogWidth,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Constants.verificationFailed,
                      style: AppTextStyles.montserratStyle.bold16Black,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      Constants.yourAccountVerificationHasExpired,
                      style: AppTextStyles.montserratStyle.regular14Black,
                    ),
                    const SizedBox(height: 16),
                    RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: Constants.resendVerificationEmail,
                            style: AppTextStyles
                                .montserratStyle.regular14TiffanyBlue
                                .copyWith(decoration: TextDecoration.underline),
                            children: [
                              TextSpan(
                                  text: "to",
                                  style: AppTextStyles
                                      .montserratStyle.regular14Black),
                              TextSpan(
                                  text: "p.giggs@email.com.",
                                  style: AppTextStyles
                                      .montserratStyle.bold14Black),
                            ])),
                    const SizedBox(height: 24),
                    SizedBox(
                      child: CustomButton(
                        title: Constants.backToHome,
                        titleStyle:
                            AppTextStyles.montserratStyle.regular14Black,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
