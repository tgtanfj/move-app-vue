import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:move_app/config/theme/app_text_styles.dart';

class CustomButton extends StatelessWidget {
  final String? iconPath;
  final String title;
  final Color backgroundColor;
  final VoidCallback onTap;
  final TextStyle? textStyle;
  final double marginBottom;

  const CustomButton(
      {super.key,
      this.iconPath,
      required this.title,
      required this.onTap,
      this.backgroundColor = Colors.white,
      this.textStyle,
      this.marginBottom = 8});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: backgroundColor,
                border: Border.all(
                  width: 1,
                  color: Colors.grey,
                )),
            child: Row(
              children: [
                iconPath?.isNotEmpty == true
                    ? SvgPicture.asset(iconPath?? "")
                    : const SizedBox.shrink(),
                Expanded(
                  child: Text(
                    title,
                    style:
                        textStyle ?? AppTextStyles.montserratStyle.bold16Black,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: marginBottom,
          )
        ],
      ),
    );
  }
}
