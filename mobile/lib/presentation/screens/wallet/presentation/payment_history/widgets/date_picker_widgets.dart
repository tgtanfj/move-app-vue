import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:move_app/config/theme/app_text_styles.dart';

import '../../../../../../config/theme/app_colors.dart';

class DatePickerWidgets extends StatefulWidget {
  final Function(DateRangePickerSelectionChangedArgs)? selectedDate;

  const DatePickerWidgets({
    super.key,
    this.selectedDate,
  });

  @override
  State<DatePickerWidgets> createState() => _DatePickerWidgetsState();
}

class _DatePickerWidgetsState extends State<DatePickerWidgets> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.3,
      width: MediaQuery.sizeOf(context).width * 0.8,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: AppColors.tiffanyBlue, width: 2)),
      child: SfDateRangePicker(
        onSelectionChanged: widget.selectedDate,
        selectionMode: DateRangePickerSelectionMode.single,
        todayHighlightColor: AppColors.tiffanyBlue,
        initialSelectedDate: DateTime.now(),
        backgroundColor: AppColors.white,
        selectionColor: AppColors.tiffanyBlue,
        headerHeight: 60,
        showNavigationArrow: true,
        headerStyle: DateRangePickerHeaderStyle(
          backgroundColor: AppColors.white,
          textAlign: TextAlign.center,
          textStyle: AppTextStyles.montserratStyle.bold14Black,
        ),
      ),
    );
  }
}
