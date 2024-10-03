import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/custom_button.dart';

class MoreInfomation extends StatefulWidget {
  final VoidCallback? faqButton;

  const MoreInfomation({
    super.key,
    this.faqButton,
  });

  @override
  State<MoreInfomation> createState() => _MoreInfomationState();
}

class _MoreInfomationState extends State<MoreInfomation> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 17.0),
      child: CustomButton(
        padding: EdgeInsets.zero,
        backgroundColor: AppColors.black,
        borderColor: AppColors.black,
        borderRadius: 0,
        titleStyle: AppTextStyles.montserratStyle.regular16White,
        textAlign: TextAlign.start,
        onTap: widget.faqButton,
        title: Constants.faq,
      ),
    );
  }
}
