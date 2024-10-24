import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/custom_button.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_history/bloc/payment_history_bloc.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_history/bloc/payment_history_event.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_history/bloc/payment_history_state.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_history/widgets/date_picker_widgets.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_history/widgets/list_payment_histories.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class PaymentHistoryBody extends StatefulWidget {
  const PaymentHistoryBody({super.key});

  @override
  State<PaymentHistoryBody> createState() => _PaymentHistoryBodyState();
}

String formatDate(DateTime? date) {
  if (date != null) {
    return DateFormat('dd MMM yyyy').format(date!);
  }
  return "No date to format";
}

class _PaymentHistoryBodyState extends State<PaymentHistoryBody> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentHistoryBloc, PaymentHistoryState>(
      listener: (context, state) {},
      child: BlocBuilder<PaymentHistoryBloc, PaymentHistoryState>(
        builder: (context, state) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 19),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Constants.startDate,
                                style:
                                    AppTextStyles.montserratStyle.bold12Black,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              CustomButton(
                                title: formatDate(state.startDate),
                                titleStyle: AppTextStyles
                                    .montserratStyle.medium16TiffanyBlue,
                                onTap: () {
                                  context.read<PaymentHistoryBloc>().add(
                                      PaymentHistorySelectionStartDateEvent());
                                },
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Constants.endDate,
                                style:
                                    AppTextStyles.montserratStyle.bold12Black,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              CustomButton(
                                title: formatDate(state.endDate),
                                titleStyle: AppTextStyles
                                    .montserratStyle.medium16TiffanyBlue,
                                onTap: () {
                                  context.read<PaymentHistoryBloc>().add(
                                      PaymentHistorySelectionEndDateEvent());
                                },
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                            flex: 1,
                            child: Text(
                              Constants.date,
                              style: AppTextStyles.montserratStyle.medium12Grey,
                            )),
                        Expanded(
                            flex: 1,
                            child: Text(
                              Constants.time,
                              style: AppTextStyles.montserratStyle.medium12Grey,
                            )),
                        Expanded(
                          flex: 1,
                          child: Text(
                            Constants.productName,
                            style: AppTextStyles.montserratStyle.medium12Grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    const Divider(
                      height: 1,
                    ),
                    const Expanded(child: ListPaymentHistories()),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                              text: "1-10",
                              style: AppTextStyles.montserratStyle.bold16Black,
                            ),
                            TextSpan(
                              text: " of 300 result",
                              style:
                                  AppTextStyles.montserratStyle.regular16Black,
                            ),
                          ])),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.navigate_before),
                              color: AppColors.tiffanyBlue,
                              padding: EdgeInsets.zero,
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {},
                              icon: const Icon(Icons.navigate_next),
                              color: AppColors.tiffanyBlue,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              if (state.isPickedStartDate)
                _buildDatePicker(
                  isPicked: true,
                  right: 22,
                  left: 0,
                  onDateSelected: (startDate) {
                    context.read<PaymentHistoryBloc>().add(
                          PaymentHistorySelectionStartDateEvent(
                              startDate: startDate),
                        );
                  },
                ),
              if (state.isPickedEndDate)
                _buildDatePicker(
                  isPicked: true,
                  left: 22,
                  right: 0,
                  onDateSelected: (endDate) {
                    context.read<PaymentHistoryBloc>().add(
                        PaymentHistorySelectionEndDateEvent(endDate: endDate));
                  },
                )
            ],
          );
        },
      ),
    );
  }

  Positioned _buildDatePicker({
    required bool isPicked,
    double? left,
    double? right,
    required Function(DateTime) onDateSelected,
  }) {
    return Positioned(
      top: 90,
      left: left,
      right: right,
      child: Card(
        elevation: 6,
        child: DatePickerWidgets(
          selectedDate: (date) => onDateSelected(date.value),
        ),
      ),
    );
  }
}
