import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final Color? backgroundColor;
  final bool isEnabled;
  final Widget? prefix;
  final Widget? suffix;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextAlign? textAlign;
  final Color? borderColor;
  final int? maxLines;
  final TextOverflow? textOverflow;
  final bool? softWrap;
  final MainAxisAlignment? contentAlignment;
  final MainAxisSize? mainAxisSize;
  final bool isExpanded;
  final double? width;
  final double? height;
  final SizedBox? sizedBox;

  const CustomButton({
    super.key,
    this.title = '',
    this.titleStyle,
    this.backgroundColor = Colors.white,
    this.isEnabled = true,
    this.prefix,
    this.suffix,
    this.onTap,
    this.onLongPress,
    this.borderRadius = 8,
    this.padding,
    this.textAlign,
    this.borderColor,
    this.maxLines,
    this.textOverflow,
    this.softWrap,
    this.contentAlignment,
    this.mainAxisSize,
    this.isExpanded = true,
    this.width,
    this.height,
    this.sizedBox,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isEnabled ? onTap : null,
      onLongPress: isEnabled ? onLongPress : null,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: width,
        height: height,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
        decoration: BoxDecoration(
            color: isEnabled ? backgroundColor : AppColors.spanishGray,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: borderColor ?? AppColors.tiffanyBlue)),
        child: Row(
          mainAxisSize: mainAxisSize ?? MainAxisSize.min,
          mainAxisAlignment: contentAlignment ?? MainAxisAlignment.center,
          children: [
            if (prefix != null) prefix!,
            sizedBox ?? const SizedBox(),
            isExpanded
                ? Expanded(
                    child: Text(
                      title,
                      style: titleStyle ?? const TextStyle(color: Colors.white),
                      textAlign: textAlign ?? TextAlign.center,
                    ),
                  )
                : Text(
                    title,
                    style: titleStyle ?? const TextStyle(color: Colors.white),
                    textAlign: textAlign ?? TextAlign.center,
                  ),
            if (suffix != null) suffix!,
          ],
        ),
      ),
    );
  }
}
