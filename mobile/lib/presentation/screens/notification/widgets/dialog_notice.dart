import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/custom_button.dart';

import '../../../../config/theme/app_icons.dart';

class DialogNotice extends StatelessWidget {
  const DialogNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: SvgPicture.asset(
                    AppIcons.close.svgAssetPath,
                    height: 16,
                    width: 16,
                  )),
              const SizedBox(height: 22),
              Text(
                Constants.loginToWebsite,
                style: AppTextStyles.montserratStyle.bold16Black,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 22,
              ),
              CustomButton(
                  title: Constants.okay,
                  titleStyle: AppTextStyles.montserratStyle.bold16White,
                  backgroundColor: AppColors.tiffanyBlue,
                  onTap: () {
                    Navigator.of(context).pop();
                  })
            ],
          ),
        ),
      ),
    );
  }
}
