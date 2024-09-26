import 'package:flutter/cupertino.dart';

import '../../../../../config/theme/app_text_styles.dart';

class TitleEditTextReferral extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final TextStyle? titleStyle;
  final TextStyle? subTitleStyle;
  final VoidCallback? onClickSubTitle;

  const TitleEditTextReferral(
      {super.key,
      this.title,
      this.subTitle,
      this.titleStyle,
      this.subTitleStyle,
      this.onClickSubTitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title ?? "",
          style: titleStyle ?? AppTextStyles.montserratStyle.regular16Black,
        ),
        GestureDetector(
          onTap: onClickSubTitle,
          child: Text(
            subTitle ?? "",
            style: subTitleStyle,
          ),
        )
      ],
    );
  }
}
