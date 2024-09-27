import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/custom_button.dart';

class PasswordResetSuccessful extends StatelessWidget {
  const PasswordResetSuccessful({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width - 40;
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
                width: screenWidth,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Constants.passwordResetSuccessful,
                      style: AppTextStyles.montserratStyle.bold16Black,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      Constants.goodNews,
                      style: AppTextStyles.montserratStyle.regular14Black,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      child: CustomButton(
                        title: Constants.login,
                        titleStyle: AppTextStyles.montserratStyle.bold16White,
                        backgroundColor: AppColors.tiffanyBlue,
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
