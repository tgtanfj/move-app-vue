import 'package:flutter/cupertino.dart';

import '../../../../../config/theme/app_text_styles.dart';

class TitleVerificationCode extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final TextStyle? titleStyle;
  final TextStyle? subTitleStyle;
  final VoidCallback? onTapSubTitle;

  const TitleVerificationCode(
      {super.key,
      this.title,
      this.subTitle,
      this.titleStyle,
      this.subTitleStyle,
      this.onTapSubTitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title ?? "",
          style:  AppTextStyles.montserratStyle.regular16Black,
        ),
        const Text("("),
        GestureDetector(
          onTap: onTapSubTitle,
          child: Text(
            subTitle ?? "",
            style: AppTextStyles.montserratStyle.regular14tiffanyBlue,
          ),
        ),
        const Text(")"),
      ],
    );
  }
}
