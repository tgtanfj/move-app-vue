import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:move_app/config/theme/app_text_styles.dart';

class DatePickerWidgets extends StatefulWidget {
  final Function(DateRangePickerSelectionChangedArgs)? selectedDate;
  final DateTime? minDate;
  final DateTime? maxDate;

  const DatePickerWidgets({
    super.key,
    this.selectedDate,
    this.maxDate,
    this.minDate,
  });

  @override
  State<DatePickerWidgets> createState() => _DatePickerWidgetsState();
}

class _DatePickerWidgetsState extends State<DatePickerWidgets> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: AppColors.tiffanyBlue, width: 1.5)),
      child: SfDateRangePicker(
        onSelectionChanged: widget.selectedDate,
        selectionMode: DateRangePickerSelectionMode.single,
        todayHighlightColor: AppColors.tiffanyBlue,
        backgroundColor: AppColors.white,
        selectionColor: AppColors.tiffanyBlue,
        headerHeight: 60,
        maxDate: widget.maxDate,
        minDate: widget.minDate,
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
