import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_text_styles.dart';

import '../../../../config/theme/app_icons.dart';

class CustomShareButton extends StatelessWidget {
  final String? title;
  final String? iconPath;
  final VoidCallback? onCopyTap;

  const CustomShareButton({
    super.key,
    this.title,
    this.iconPath,
    this.onCopyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onCopyTap,
          child: SvgPicture.asset(
            iconPath ?? '',
            width: 56,
            height: 56,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          title ?? '',
          style: AppTextStyles.montserratStyle.regular16Black,
        ),
      ],
    );
  }
}
