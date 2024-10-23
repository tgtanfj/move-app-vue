import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_history/bloc/payment_history_bloc.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_history/bloc/payment_history_event.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_history/widgets/date_picker_widgets.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../../../config/theme/app_colors.dart';
import '../../../../../components/custom_button.dart';
import '../bloc/payment_history_state.dart';
import '../widgets/list_payment_histories.dart';
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
  return " ";
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
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                Constants.productName,
                                style:
                                    AppTextStyles.montserratStyle.medium12Grey,
                              ),
                            )),
                        Text(
                          Constants.qty,
                          style: AppTextStyles.montserratStyle.medium12Grey,
                        ),
                      ],
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
              if (state.isPickedStartDate == true)
                Positioned(
                  top: 90,
                  left: 0,
                  child: Card(
                    elevation: 6,
                    color: AppColors.white,
                    child: DatePickerWidgets(
                      selectedDate: (startDate) {
                        context.read<PaymentHistoryBloc>().add(
                            PaymentHistorySelectionStartDateEvent(
                                startDate: startDate.value));
                      },
                    ),
                  ),
                ),
              if (state.isPickedEndDate == true)
                Positioned(
                  top: 90,
                  right: 0,
                  child: Card(
                      elevation: 6,
                      color: AppColors.white,
                      child: DatePickerWidgets(
                        selectedDate: (endDate) {
                          context.read<PaymentHistoryBloc>().add(
                              PaymentHistorySelectionEndDateEvent(
                                  endDate: endDate.value));
                        },
                      )),
                ),
            ],
          );
        },
      ),
    );
  }
}
