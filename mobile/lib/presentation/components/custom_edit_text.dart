import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:move_app/config/theme/app_colors.dart';

import '../../config/theme/app_text_styles.dart';

class CustomEditText extends StatefulWidget {
  final String title;
  final String mainMessage;
  final TextStyle? textStyle;
  final TextStyle? titleStyle;
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
  final Color? cursorColor;
  final String preMessage;
  final String sufMessage;
  final bool? enable;
  final double? widthMessage;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onSubmitted;
  final String? initialValue;
  final Function(String)? onLostFocus;

  const CustomEditText({
    super.key,
    this.textStyle,
    this.titleStyle,
    this.onChanged,
    this.textCapitalization,
    this.textInputType,
    this.backgroundColor = Colors.white,
    this.height,
    this.title = '',
    this.maxLength = 255,
    this.isPasswordInput = false,
    this.suffix,
    this.mainMessage = "",
    this.borderColor = Colors.grey,
    this.isShowMessage = false,
    this.backgroundColorMessage = AppColors.lavenderBlush,
    this.cursorColor,
    this.preMessage = "",
    this.sufMessage = "",
    this.inputFormatters,
    this.enable,
    this.widthMessage,
    this.onSubmitted,
    this.initialValue,
    this.onLostFocus,
  });

  @override
  State<CustomEditText> createState() => _CustomEditTextState();
}

class _CustomEditTextState extends State<CustomEditText> {
  late bool isTextVisible;
  late TextEditingController controller;
  late FocusNode focusNode = FocusNode();

  @override
  void initState() {
    isTextVisible = !widget.isPasswordInput;
    focusNode.addListener(_onFocusChange);
    controller = TextEditingController(text: widget.initialValue ?? "");
    super.initState();
  }

  void _onFocusChange() {
    if (!focusNode.hasFocus) {
      String trimmedText = controller.text.trim();
      if (trimmedText != controller.text) {
        controller.text = trimmedText;
        controller.selection = TextSelection.fromPosition(
            TextPosition(offset: trimmedText.length));
      }
      widget.onLostFocus?.call(trimmedText);
    }
  }

  @override
  void dispose() {
    focusNode.removeListener(_onFocusChange);
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.title.isNotEmpty
            ? Text(
                widget.title,
                style: widget.titleStyle ??
                    AppTextStyles.montserratStyle.regular16Black,
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
            enabled: widget.enable ?? true,
            style: widget.textStyle ??
                AppTextStyles.montserratStyle.regular14Black,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            controller: controller,
            focusNode: focusNode,
            autofocus: false,
            cursorColor: widget.cursorColor ?? AppColors.tiffanyBlue,
            textCapitalization:
                widget.textCapitalization ?? TextCapitalization.none,
            keyboardType: widget.textInputType ?? TextInputType.text,
            obscureText: widget.isPasswordInput ? !isTextVisible : false,
            inputFormatters: [
              if (widget.inputFormatters != null) ...widget.inputFormatters!,
            ],
            decoration: InputDecoration(
              counterText: "",
              fillColor: widget.enable == false
                  ? AppColors.cultured
                  : widget.backgroundColor,
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
                borderSide: BorderSide(
                    color: widget.isShowMessage
                        ? widget.borderColor
                        : AppColors.chineseSilver),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                    color: widget.isShowMessage
                        ? widget.borderColor
                        : AppColors.chineseSilver),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                      color: widget.isShowMessage
                          ? widget.borderColor
                          : AppColors.tiffanyBlue)),
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
            width:
                widget.widthMessage ?? MediaQuery.of(context).size.width - 64,
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
