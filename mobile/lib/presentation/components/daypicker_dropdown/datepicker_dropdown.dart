import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';

import '../../../../../config/theme/app_colors.dart';
import 'order_format.dart';

class DropdownDatePicker extends StatefulWidget {
  final TextStyle? textStyle;
  final int? startYear;
  final int? endYear;
  final double width;
  final ValueChanged<String?>? onChangedDay;
  final ValueChanged<String?>? onChangedMonth;
  final ValueChanged<String?>? onChangedYear;
  final String errorDay;
  final String errorMonth;
  final String errorYear;
  final String hintMonth;
  final String hintYear;
  final String hintDay;
  final TextStyle? hintTextStyle;
  final bool isFormValidator;
  final int? selectedDay;
  final int? selectedMonth;
  final int? selectedYear;
  final bool showYear;
  final bool showMonth;
  final bool showDay;
  final OrderFormat dateFormatOrder;

  const DropdownDatePicker({
    super.key,
    this.textStyle,
    this.startYear,
    this.endYear,
    this.width = 12.0,
    this.onChangedDay,
    this.onChangedMonth,
    this.onChangedYear,
    this.errorDay = 'Please select day',
    this.errorMonth = 'Please select month',
    this.errorYear = 'Please select year',
    this.hintMonth = 'MM',
    this.hintDay = 'DD',
    this.hintYear = 'YYYY',
    this.hintTextStyle,
    this.isFormValidator = false,
    this.selectedDay,
    this.selectedMonth,
    this.selectedYear,
    this.showDay = true,
    this.showMonth = true,
    this.showYear = true,
    this.dateFormatOrder = OrderFormat.MDY,
  });

  @override
  State<DropdownDatePicker> createState() => _DropdownDatePickerState();
}

class _DropdownDatePickerState extends State<DropdownDatePicker> {
  var monthselVal = '';
  var dayselVal = '';
  var yearselVal = '';
  int daysIn = 32;
  late List<int> listdates = [];
  late List<int> listyears = [];
  final listMonths = [
    {"id": 1, "value": "January"},
    {"id": 2, "value": "February"},
    {"id": 3, "value": "March"},
    {"id": 4, "value": "April"},
    {"id": 5, "value": "May"},
    {"id": 6, "value": "June"},
    {"id": 7, "value": "July"},
    {"id": 8, "value": "August"},
    {"id": 9, "value": "September"},
    {"id": 10, "value": "October"},
    {"id": 11, "value": "November"},
    {"id": 12, "value": "December"}
  ];

  @override
  void initState() {
    super.initState();
    dayselVal = widget.selectedDay != null ? widget.selectedDay.toString() : '';
    monthselVal =
        widget.selectedMonth != null ? widget.selectedMonth.toString() : '';
    yearselVal =
        widget.selectedYear != null ? widget.selectedYear.toString() : '';
    listdates = List<int>.generate(daysIn, (index) => index + 1);
    listyears = List<int>.generate(
      (widget.endYear ?? DateTime.now().year) - (widget.startYear ?? 1900) + 1,
      (index) => (widget.startYear ?? 1900) + index,
    ).reversed.toList();
  }

  void monthSelected(String? value) {
    widget.onChangedMonth?.call(value);
    monthselVal = value ?? '';
    int days = daysInMonth(
      yearselVal == '' ? DateTime.now().year : int.parse(yearselVal),
      int.parse(value ?? '1'),
    );
    listdates = List<int>.generate(days, (index) => index + 1);
    checkDates(days);
    update();
  }

  void checkDates(int days) {
    if (dayselVal != '') {
      if (int.parse(dayselVal) > days) {
        dayselVal = '';
        widget.onChangedDay?.call(days.toString());
        update();
      }
    }
  }

  int daysInMonth(int year, int month) {
    DateTime lastDayOfMonth = DateTime(year, month + 1, 0);
    return lastDayOfMonth.day;
  }

  void daysSelected(String? value) {
    widget.onChangedDay?.call(value);
    dayselVal = value ?? '';
    update();
  }

  void yearsSelected(String? value) {
    widget.onChangedYear?.call(value);
    yearselVal = value ?? '';
    if (monthselVal != '') {
      int days = daysInMonth(
        yearselVal == '' ? DateTime.now().year : int.parse(yearselVal),
        int.parse(monthselVal),
      );
      listdates = List<int>.generate(days, (index) => index + 1);
      checkDates(days);
      update();
    }
    update();
  }

  void update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.dateFormatOrder) {
      case OrderFormat.DMY:
        return mainRow(day: 1, month: 2, year: 3);
      case OrderFormat.MDY:
        return mainRow(day: 2, month: 1, year: 3);
      case OrderFormat.YMD:
        return mainRow(day: 3, month: 2, year: 1);
      case OrderFormat.YDM:
        return mainRow(day: 2, month: 3, year: 1);
      case OrderFormat.MYD:
        return mainRow(day: 3, month: 1, year: 2);
      case OrderFormat.DYM:
        return mainRow(day: 1, month: 3, year: 2);
    }
  }

  Widget mainRow({int day = 2, int month = 1, int year = 3}) {
    return Row(
      children: [
        if (day == 1) dayWidget(),
        if (day == 1) w(widget.width),
        if (month == 1) monthWidget(),
        if (month == 1) w(widget.width),
        if (year == 1) yearWidget(),
        if (year == 1) w(widget.width),
        if (day == 2) dayWidget(),
        if (day == 2) w(widget.width),
        if (month == 2) monthWidget(),
        if (month == 2) w(widget.width),
        if (year == 2) yearWidget(),
        if (year == 2) w(widget.width),
        if (day == 3) dayWidget(),
        if (day == 3) w(widget.width),
        if (month == 3) monthWidget(),
        if (month == 3) w(widget.width),
        if (year == 3) yearWidget(),
        if (year == 3) w(widget.width),
      ],
    );
  }

  Widget mainColumn() {
    return Column(
      children: [
        monthWidget(),
        if (widget.showMonth) w(widget.width),
        dayWidget(),
        if (widget.showDay) w(widget.width),
        yearWidget(),
      ],
    );
  }

  Widget yearWidget() {
    return widget.showYear
        ? Expanded(
            flex: 7,
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButtonHideUnderline(
                child: yearDropdown(),
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  Widget dayWidget() {
    return widget.showDay
        ? Expanded(
            flex: 6,
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButtonHideUnderline(
                child: dayDropdown(),
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  Widget monthWidget() {
    return widget.showMonth
        ? Expanded(
            flex: 6,
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButtonHideUnderline(
                child: monthDropdown(),
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  DropdownButtonFormField<String> monthDropdown() {
    return DropdownButtonFormField<String>(
      dropdownColor: AppColors.white,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(right: 8),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: AppColors.chineseSilver, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: AppColors.tiffanyBlue, width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
      ),
      isExpanded: true,
      hint: Text(widget.hintMonth, style: widget.hintTextStyle),
      icon: SvgPicture.asset(
        AppIcons.dropdown.svgAssetPath,
        width: 12,
        height: 7.29,
      ),
      value: monthselVal.isEmpty ? null : monthselVal,
      onChanged: (value) {
        monthSelected(value);
      },
      validator: (value) {
        return widget.isFormValidator && value == null
            ? widget.errorMonth
            : null;
      },
      items: listMonths.map((item) {
        return DropdownMenuItem<String>(
          value: item["id"].toString(),
          child: Text(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            item["value"].toString(),
            style: widget.textStyle ??
                AppTextStyles.montserratStyle.regular14Black,
          ),
        );
      }).toList(),
    );
  }

  DropdownButtonFormField<String> yearDropdown() {
    return DropdownButtonFormField<String>(
      dropdownColor: AppColors.white,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(right: 8),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: AppColors.chineseSilver, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: AppColors.tiffanyBlue, width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
      ),
      hint: Text(widget.hintYear, style: widget.hintTextStyle),
      isExpanded: true,
      icon: SvgPicture.asset(
        AppIcons.dropdown.svgAssetPath,
        width: 12,
        height: 7.29,
      ),
      value: yearselVal.isEmpty ? null : yearselVal,
      onChanged: (value) {
        yearsSelected(value);
      },
      validator: (value) {
        return widget.isFormValidator && value == null
            ? widget.errorYear
            : null;
      },
      items: listyears.map((item) {
        return DropdownMenuItem<String>(
          value: item.toString(),
          child: Text(
            item.toString(),
            style: widget.textStyle ??
                AppTextStyles.montserratStyle.regular14Black,
          ),
        );
      }).toList(),
    );
  }

  DropdownButtonFormField<String> dayDropdown() {
    return DropdownButtonFormField<String>(
      dropdownColor: AppColors.white,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(right: 8),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: AppColors.chineseSilver, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: AppColors.tiffanyBlue, width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
      ),
      hint: Text(
        widget.hintDay,
        style: widget.hintTextStyle,
      ),
      isExpanded: true,
      icon: SvgPicture.asset(
        AppIcons.dropdown.svgAssetPath,
        width: 12,
        height: 7.29,
      ),
      value: dayselVal.isEmpty ? null : dayselVal,
      onChanged: (value) {
        daysSelected(value);
      },
      validator: (value) {
        return widget.isFormValidator && value == null ? widget.errorDay : null;
      },
      items: listdates.map((item) {
        return DropdownMenuItem<String>(
          value: item.toString(),
          child: Text(
            item.toString(),
            style: widget.textStyle ??
                AppTextStyles.montserratStyle.regular14Black,
          ),
        );
      }).toList(),
    );
  }

  Widget w(double count) => SizedBox(width: count);
}
