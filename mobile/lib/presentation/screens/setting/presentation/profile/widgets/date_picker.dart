import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/presentation/components/custom_button.dart';

class DatePicker extends StatelessWidget {
  final DateTime? date;
  final Function(DateTime) onDateChanged;

  const DatePicker({
    super.key,
    required this.date,
    required this.onDateChanged,
  });

  void _showDatePicker(BuildContext context,
      {required CupertinoDatePickerMode mode,
      required ValueChanged<DateTime> onDateTimeChanged}) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: AppColors.white,
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
            minimumYear: 1959,
            maximumYear: 2011,
            initialDateTime:
                date != null && date!.year <= 2011 ? date : DateTime(2011),
            mode: mode,
            use24hFormat: true,
            onDateTimeChanged: onDateTimeChanged,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.85,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            flex: 4,
            child: CustomButton(
              isExpanded: false,
              mainAxisSize: MainAxisSize.max,
              contentAlignment: MainAxisAlignment.spaceBetween,
              title: date == null ? 'DD' : date!.day.toString().padLeft(2, '0'),
              titleStyle: AppTextStyles.montserratStyle.regular16Black,
              suffix: SvgPicture.asset(AppIcons.dropdown.svgAssetPath),
              borderColor: AppColors.chineseSilver,
              onTap: () => _showDatePicker(context,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: onDateChanged),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            flex: 4,
            child: CustomButton(
              isExpanded: false,
              mainAxisSize: MainAxisSize.max,
              contentAlignment: MainAxisAlignment.spaceBetween,
              title:
                  date == null ? 'MM' : date!.month.toString().padLeft(2, '0'),
              titleStyle: AppTextStyles.montserratStyle.regular16Black,
              suffix: SvgPicture.asset(AppIcons.dropdown.svgAssetPath),
              borderColor: AppColors.chineseSilver,
              onTap: () => _showDatePicker(context,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: onDateChanged),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            flex: 5,
            child: CustomButton(
              isExpanded: false,
              mainAxisSize: MainAxisSize.max,
              contentAlignment: MainAxisAlignment.spaceBetween,
              title:
                  date == null ? 'YYYY' : date!.year.toString().padLeft(2, '0'),
              titleStyle: AppTextStyles.montserratStyle.regular16Black,
              suffix: SvgPicture.asset(AppIcons.dropdown.svgAssetPath),
              borderColor: AppColors.chineseSilver,
              onTap: () => _showDatePicker(context,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: onDateChanged),
            ),
          ),
        ],
      ),
    );
  }
}
