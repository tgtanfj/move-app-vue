import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/custom_button.dart';

class ContentMenu extends StatefulWidget {
  final VoidCallback walletButton;
  final VoidCallback settingButton;
  final VoidCallback faqsButton;

  const ContentMenu({
    super.key,
    required this.walletButton,
    required this.settingButton,
    required this.faqsButton,
  });

  @override
  State<ContentMenu> createState() => _ContentMenuState();
}

class _ContentMenuState extends State<ContentMenu> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        CustomButton(
          padding: EdgeInsets.zero,
          backgroundColor: AppColors.black,
          borderColor: AppColors.black,
          borderRadius: 0,
          titleStyle: AppTextStyles.montserratStyle.bold20White,
          textAlign: TextAlign.start,
          onTap: widget.walletButton,
          title: '${Constants.wallet}(0 REP\$)',
        ),
        const SizedBox(
          height: 24.0,
        ),
        CustomButton(
          padding: EdgeInsets.zero,
          backgroundColor: AppColors.black,
          borderColor: AppColors.black,
          borderRadius: 0,
          titleStyle: AppTextStyles.montserratStyle.bold20White,
          textAlign: TextAlign.start,
          onTap: widget.settingButton,
          title: Constants.setting,
        ),
        const SizedBox(
          height: 24.0,
        ),
        CustomButton(
          padding: EdgeInsets.zero,
          backgroundColor: AppColors.black,
          borderColor: AppColors.black,
          borderRadius: 0,
          titleStyle: AppTextStyles.montserratStyle.bold20White,
          textAlign: TextAlign.start,
          onTap: widget.faqsButton,
          title: Constants.faq,
        ),
      ],
    );
  }
}
