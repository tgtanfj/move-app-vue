import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';

class CustomDropdownWithIcon extends StatelessWidget {
  final List<(int, String)> items;
  final int? initialValue;
  final String? hintText;
  final TextStyle? hintTextStyle;
  final Function(int? value) onChanged;
  final String? message;

  const CustomDropdownWithIcon({
    super.key,
    required this.items,
    this.initialValue,
    this.hintText,
    this.hintTextStyle,
    required this.onChanged,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ButtonTheme(
          alignedDropdown: true,
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<int>(
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: AppColors.white,
                  border: Border.all(
                    color: AppColors.tiffanyBlue,
                    width: 1.0,
                  ),
                ),
                offset: const Offset(0, -4),
                maxHeight: 300,
                elevation: 0,
                scrollbarTheme: ScrollbarThemeData(
                  radius: const Radius.circular(8.0),
                  thickness: WidgetStateProperty.all<double>(6),
                  thumbVisibility: WidgetStateProperty.all<bool>(true),
                ),
              ),
              value: (initialValue != null &&
                      items.any((item) => item.$1 == initialValue))
                  ? initialValue
                  : null,
              hint: Text(
                hintText ?? '',
                style: hintTextStyle ??
                    AppTextStyles.montserratStyle.medium16TiffanyBlue,
              ),
              buttonStyleData: ButtonStyleData(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: AppColors.tiffanyBlue,
                    width: 1.0,
                  ),
                ),
              ),
              isExpanded: true,
              iconStyleData: IconStyleData(
                icon: SvgPicture.asset(
                  AppIcons.dropdown.svgAssetPath,
                  height: 7.29,
                  width: 12,
                ),
              ),
              selectedItemBuilder: (BuildContext context) {
                return items.map<Widget>((item) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item.$2,
                      style: AppTextStyles.montserratStyle.medium16TiffanyBlue,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList();
              },
              items: items.map<DropdownMenuItem<int>>((item) {
                return DropdownMenuItem<int>(
                  value: item.$1,
                  child: Text(
                    item.$2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: item.$1 == initialValue
                        ? AppTextStyles.montserratStyle.bold16TiffanyBlue
                        : AppTextStyles.montserratStyle.regular16TiffanyBlue,
                  ),
                );
              }).toList(),
              menuItemStyleData: const MenuItemStyleData(height: 40),
              onChanged: (int? newValue) {
                onChanged(newValue);
              },
            ),
          ),
        ),
      ],
    );
  }
}
