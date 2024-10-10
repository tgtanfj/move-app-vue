import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';

class CustomDropdownWithIcon extends StatelessWidget {
  final List<dynamic>? items;
  final int? initialValue;
  final String? hintText;
  final TextStyle? hintTextStyle;
  final Function(int? value) onChanged;
  final String? message;

  const CustomDropdownWithIcon({
    super.key,
    this.items,
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
                elevation: 0,
                scrollbarTheme: ScrollbarThemeData(
                  radius: const Radius.circular(8.0),
                  thickness: WidgetStateProperty.all<double>(6),
                  thumbVisibility: WidgetStateProperty.all<bool>(true),
                ),
              ),
              value: (initialValue != null &&
                      items != null &&
                      items!.any((item) => item['id'] == initialValue))
                  ? initialValue
                  : null,
              hint: Text(
                hintText ?? 'Select',
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
                return items?.map<Widget>((item) {
                      return Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item['title'],
                          style:
                              AppTextStyles.montserratStyle.medium16TiffanyBlue,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList() ??
                    [];
              },
              items: items?.asMap().entries.map<DropdownMenuItem<int>>((entry) {
                int index = entry.key;
                var item = entry.value;

                return DropdownMenuItem<int>(
                  value: item['id'],
                  child: Text(
                    item['title'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: index == 0
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
