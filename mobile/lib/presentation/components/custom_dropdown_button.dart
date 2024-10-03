import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Đảm bảo đã nhập đúng thư viện này
import 'package:move_app/config/theme/app_text_styles.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_icons.dart';

class CustomDropdownButton extends StatelessWidget {
  final List<dynamic>? items;
  final int? initialValue;
  final String? hintText;
  final TextStyle? hintTextStyle;
  final Function(int? value) onChanged;

  const CustomDropdownButton({
    super.key,
    this.items,
    this.initialValue,
    this.hintText,
    this.hintTextStyle,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<int>(
          dropdownColor: AppColors.white,
          value: (initialValue != null &&
                  items != null &&
                  items!.any((item) => item['id'] == initialValue))
              ? initialValue
              : null,
          hint: Text(
            hintText ?? '',
            style:
                hintTextStyle ?? AppTextStyles.montserratStyle.regular16Black,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(right: 8.0),
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
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.tiffanyBlue,
                width: 1.0,
              ),
            ),
          ),
          isExpanded: true,
          icon: SvgPicture.asset(
            AppIcons.dropdown.svgAssetPath,
            height: 7.29,
            width: 12,
          ),
          items: items?.map<DropdownMenuItem<int>>((item) {
            return DropdownMenuItem<int>(
              value: item['id'],
              child: Text(
                item['name'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.montserratStyle.regular16Black,
              ),
            );
          }).toList(),
          menuMaxHeight: 250,
          onChanged: (int? newValue) {
            onChanged(newValue);
          },
        ),
      ),
    );
  }
}
