import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/repositories/auth_repository.dart';
import 'package:move_app/presentation/components/custom_button.dart';

import 'custom_logout_button.dart';

class LogoutDialog extends StatelessWidget {
  final VoidCallback yesButton;

  const LogoutDialog({super.key, required this.yesButton});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.logout,
                  color: AppColors.tiffanyBlue,
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  Constants.logout,
                  style: AppTextStyles.montserratStyle.bold16Black,
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              Constants.confirmLogout,
              style: AppTextStyles.montserratStyle.regular16Black,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomLogoutButton(
                  onTap: () async {
                    await AuthRepository().logOut();
                    yesButton();
                    Navigator.of(context).pop();
                  },
                  title: Constants.yes,
                  titleStyle: AppTextStyles.montserratStyle.regular14Black,
                  backgroundColor: AppColors.tiffanyBlue,
                  borderColor: AppColors.chineseSilver,
                ),
                const SizedBox(
                  width: 8.0,
                ),
                CustomLogoutButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  title: Constants.no,
                  titleStyle: AppTextStyles.montserratStyle.regular14Black,
                  backgroundColor: AppColors.chineseSilver,
                  borderColor: AppColors.chineseSilver,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
