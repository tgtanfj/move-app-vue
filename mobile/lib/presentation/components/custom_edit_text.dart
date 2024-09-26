import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';

class CustomEditText extends StatelessWidget {
  final String title;
  final String message;
  final TextStyle? textStyle;
  final ValueChanged<String>? onChanged;
  final TextCapitalization? textCapitalization;
  final TextInputType? textInputType;
  final Color backgroundColor;
  final Color borderColor;
  final Color? backgroundColorMessage;
  final double? height;
  final int? maxLength;
  final bool isShowText, isShowMessage;
  final Widget? suffix;

  const CustomEditText(
      {super.key,
        this.textStyle,
        this.onChanged,
        this.textCapitalization,
        this.textInputType,
        this.backgroundColor = Colors.white,
        this.height ,
        this.title ="",
        this.maxLength = 255,
        this.isShowText = false,
        this.suffix,
        this.message = "",
        this.borderColor = AppColors.chineseSilver,
        this.isShowMessage = false,
        this.backgroundColorMessage = AppColors.lavenderBlush});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title.isNotEmpty ?
        Text(
          title ?? "",
          style: AppTextStyles.montserratStyle.regular16Black,
          textAlign: TextAlign.left,
        ): SizedBox(),
        SizedBox(
          height: 4,
        ),
        SizedBox(
          height: height,
          child: TextField(
            style: textStyle ?? AppTextStyles.montserratStyle.regular14Black,
            onChanged: onChanged,
            autofocus: false,
            textCapitalization: textCapitalization ?? TextCapitalization.none,
            keyboardType: textInputType ?? TextInputType.text,
            decoration: InputDecoration(
              counterText: "",
                fillColor: backgroundColor,
                filled: true,
                suffixIcon: suffix != null ? Container(child: suffix) : null,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 11.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: AppColors.spanishGray),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: AppColors.chineseSilver),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: AppColors.tiffanyBlue)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: borderColor))),
            maxLength: maxLength,
            obscureText: isShowText,
          ),
        ),
        Visibility(
          visible: isShowMessage,
          child: Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: backgroundColorMessage,
              border: Border.all(width: 1, color: borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message,
              style: AppTextStyles.montserratStyle.regular14Black,
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      ],
    );
  }
}