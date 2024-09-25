import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Ensure you're importing this correctly
import 'package:move_app/config/theme/app_text_styles.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_icons.dart';

class CustomDropdownButton extends StatefulWidget {
  final List<String>? labels;
  final String? initialValue;
  final String? hintText;
  final TextStyle? hintTextStyle;

  const CustomDropdownButton({
    super.key,
    this.labels,
    this.initialValue,
    this.hintText,
    this.hintTextStyle,
  });

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue ?? widget.labels?.first;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedValue,
      hint: Text(widget.hintText ?? '',
          style: widget.hintTextStyle ??
              AppTextStyles.montserratStyle.regular16Black),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: AppColors.chineseSilver,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: AppColors.chineseSilver,
            width: 1.0,
          ),
        ),
      ),
      icon: SvgPicture.asset(
        AppIcons.dropdown.svgAssetPath,
        height: 7.29,
        width: 12,
      ),
      items: widget.labels?.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedValue = newValue;
        });
      },
    );
  }
}
