import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/presentation/components/custom_logout_button.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_icons.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../constants/constants.dart';

class PermissionRequiredDialog extends StatelessWidget {
  const PermissionRequiredDialog({super.key});

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
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: ClipOval(
                        child: Container(
                          padding: const EdgeInsets.only(left: 20),
                          width: 160,
                          height: 160,
                          color: AppColors.black,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              menuItem(text: Constants.favorites),
                              const Divider(
                                  color: AppColors.darkSilver, height: 0.5),
                              menuItem(text: Constants.blockPopUps),
                              const Divider(
                                  color: AppColors.darkSilver, height: 0.5),
                              menuItem(text: Constants.downloads),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
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
            Text(
              Constants.permissionRequired,
              style: AppTextStyles.montserratStyle.bold16Black,
            ),
            const SizedBox(height: 8),
            Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                text: Constants.pleaseAllowPopUP,
                style: AppTextStyles.montserratStyle.regular14Black,
                children: [
                  TextSpan(
                      text: Constants.settings,
                      style: AppTextStyles.montserratStyle.bold14Black),
                  TextSpan(
                      text: Constants.appAndSelect,
                      style: AppTextStyles.montserratStyle.regular14Black),
                  TextSpan(
                      text: Constants.safari,
                      style: AppTextStyles.montserratStyle.bold14Black),
                  const TextSpan(text: '. '),
                  TextSpan(
                      text: Constants.finallyTurnOn,
                      style: AppTextStyles.montserratStyle.regular14Black),
                  TextSpan(
                      text: Constants.blockPopUps,
                      style: AppTextStyles.montserratStyle.bold14Black),
                  const TextSpan(text: '.'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            CustomLogoutButton(
              padding: const EdgeInsets.symmetric(horizontal: 77, vertical: 10),
              backgroundColor: AppColors.tiffanyBlue,
              title: Constants.close,
              titleStyle: AppTextStyles.montserratStyle.bold16White,
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget menuItem({required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: const TextStyle(color: AppColors.white, fontSize: 16),
      ),
    );
  }
}
