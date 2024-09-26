import 'package:flutter/material.dart';

import '../../../../../config/theme/app_colors.dart';
import '../../../../../config/theme/app_text_styles.dart';

class CustomButton extends StatefulWidget {
  final String? title;
  final TextStyle? titleStyle;
  final Color backgroundColor;
  final Color disableBackgroundColor;
  final VoidCallback? onTap;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final Widget? suffix;
  final Widget? prefix;
  final bool isEnabled;

  const CustomButton({
    super.key,
    this.title,
    this.titleStyle,
    this.backgroundColor = AppColors.tiffanyBlue,
    this.disableBackgroundColor = AppColors.tiffanyBlue,
    this.onTap,
    this.borderRadius = 8.0,
    this.padding,
    this.suffix,
    this.prefix,
    this.isEnabled = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: widget.padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            width: 1,
            color: AppColors.spanishGray,
          ),
          color: widget.isEnabled == true
              ? widget.disableBackgroundColor
              : widget.backgroundColor,
        ),
        child: Center(
          child: Row(
            children: [
              if (widget.prefix != null) ...[
                widget.prefix!,
              ],
              Expanded(
                child: Center(
                  child: Text(widget.title ?? '',
                      style: widget.titleStyle ??
                          AppTextStyles.montserratStyle.regular12White),
                ),
              ),
              if (widget.suffix != null) ...[widget.suffix!]
            ],
          ),
        ),
      ),
    );
  }
}
