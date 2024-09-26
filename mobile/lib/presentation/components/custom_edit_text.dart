import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_colors.dart';

import '../../config/theme/app_text_styles.dart';

class CustomEditText extends StatefulWidget {
  final String title;
  final String mainMessage;
  final TextStyle? textStyle;
  final ValueChanged<String>? onChanged;
  final TextCapitalization? textCapitalization;
  final TextInputType? textInputType;
  final Color backgroundColor;
  final Color borderColor;
  final Color? backgroundColorMessage;
  final double? height;
  final int? maxLength;
  final bool isPasswordInput, isShowMessage;
  final Widget? suffix;
  final TextEditingController? controller;
  final Color? cursorColor;
  final String preMessage;
  final String sufMessage;

  const CustomEditText({
    super.key,
    this.textStyle,
    this.onChanged,
    this.textCapitalization,
    this.textInputType,
    this.backgroundColor = Colors.white,
    this.height = 48,
    this.title = '',
    this.maxLength = 255,
    this.isPasswordInput = false,
    this.suffix,
    this.mainMessage = "",
    this.borderColor = Colors.grey,
    this.isShowMessage = false,
    this.backgroundColorMessage = AppColors.lavenderBlush,
    this.controller,
    this.cursorColor,
    this.preMessage = "",
    this.sufMessage = "",
  });

  @override
  State<CustomEditText> createState() => _CustomEditTextState();
}

class _CustomEditTextState extends State<CustomEditText> {
  late bool isTextVisible;

  @override
  void initState() {
    super.initState();
    isTextVisible = !widget.isPasswordInput;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.title.isNotEmpty
            ? Text(
                widget.title,
                style: AppTextStyles.montserratStyle.regular16Black,
                textAlign: TextAlign.left,
              )
            : const SizedBox(),
        SizedBox(
          height: widget.title.isNotEmpty ? 4 : 0,
        ),
        const SizedBox(
          height: 4,
        ),
        SizedBox(
          height: widget.height,
          child: TextField(
            style: widget.textStyle ??
                AppTextStyles.montserratStyle.regular14Black,
            onChanged: widget.onChanged,
            controller: widget.controller,
            autofocus: false,
            cursorColor: widget.cursorColor ?? AppColors.tiffanyBlue,
            textCapitalization:
                widget.textCapitalization ?? TextCapitalization.none,
            keyboardType: widget.textInputType ?? TextInputType.text,
            obscureText: widget.isPasswordInput ? !isTextVisible : false,
            decoration: InputDecoration(
              counterText: "",
              fillColor: widget.backgroundColor,
              filled: true,
              suffixIcon: widget.isPasswordInput
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          isTextVisible = !isTextVisible;
                        });
                      },
                      child: Icon(
                        isTextVisible ? Icons.visibility : Icons.visibility_off,
                        color: AppColors.graniteGray,
                      ),
                    )
                  : widget.suffix,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 11.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: AppColors.chineseSilver),
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
                  borderSide: BorderSide(color: widget.borderColor)),
            ),
            maxLength: widget.maxLength,
          ),
        ),
        Visibility(
          visible: widget.isShowMessage,
          child: Container(
            width: MediaQuery.of(context).size.width - 64,
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.backgroundColorMessage,
              border: Border.all(width: 1, color: widget.borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: widget.preMessage,
                style: AppTextStyles.montserratStyle.regular14Black,
                children: [
                  TextSpan(
                    text: widget.mainMessage,
                    style: AppTextStyles.montserratStyle.bold14Black,
                  ),
                  TextSpan(
                    text: widget.sufMessage,
                    style: AppTextStyles.montserratStyle.regular14Black,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
