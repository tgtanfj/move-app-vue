import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/custom_button.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_history/bloc/payment_history_bloc.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_history/bloc/payment_history_event.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_history/bloc/payment_history_state.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_history/widgets/date_picker_widgets.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_history/widgets/list_payment_histories.dart';
import 'package:move_app/utils/util_date_time_format.dart';

class PaymentHistoryBody extends StatefulWidget {
  const PaymentHistoryBody({super.key});

  @override
  State<PaymentHistoryBody> createState() => _PaymentHistoryBodyState();
}

class _PaymentHistoryBodyState extends State<PaymentHistoryBody>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<PaymentHistoryBloc, PaymentHistoryState>(
      listener: (context, state) {
        (state.status == PaymentHistoryStatus.processing)
            ? EasyLoading.show()
            : EasyLoading.dismiss();
      },
      child: BlocBuilder<PaymentHistoryBloc, PaymentHistoryState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              context
                  .read<PaymentHistoryBloc>()
                  .add(PaymentHistoryOnTapOutSideEvent());
              FocusScope.of(context).unfocus();
            },
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 19),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Constants.startDate,
                                    style: AppTextStyles
                                        .montserratStyle.bold12Black,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  CustomButton(
                                    title: UtilDateTimeFormat()
                                        .formatDateMonthYear(state.startDate),
                                    titleStyle: AppTextStyles
                                        .montserratStyle.medium16TiffanyBlue,
                                    onTap: () {
                                      context.read<PaymentHistoryBloc>().add(
                                          PaymentHistoryOnTapStartDateEvent());
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
                                    style: AppTextStyles
                                        .montserratStyle.bold12Black,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  CustomButton(
                                    title: UtilDateTimeFormat()
                                        .formatDateMonthYear(state.endDate),
                                    titleStyle: AppTextStyles
                                        .montserratStyle.medium16TiffanyBlue,
                                    onTap: () {
                                      context.read<PaymentHistoryBloc>().add(
                                          PaymentHistoryOnTapEndDateEvent());
                                    },
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      (state.paymentHistoryList != null &&
                              state.paymentHistoryList!.isNotEmpty)
                          ? Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            Constants.date,
                                            style: AppTextStyles
                                                .montserratStyle.medium12Grey,
                                          )),
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            Constants.time,
                                            style: AppTextStyles
                                                .montserratStyle.medium12Grey,
                                          )),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          Constants.productName,
                                          style: AppTextStyles
                                              .montserratStyle.medium12Grey,
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
                                  ListPaymentHistories(
                                    paymentHistoryList:
                                        state.paymentHistoryList,
                                  ),
                                  SizedBox(
                                    height: 30,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: RichText(
                                              text: TextSpan(children: [
                                            TextSpan(
                                              text: (state.paymentHistoryList !=
                                                          null && state.paymentHistoryList!.length > 1)
                                                  ? "${state.startResult}-${state.endResult}"
                                                  : "${state.startResult}",
                                              style: AppTextStyles
                                                  .montserratStyle.bold14Grey,
                                            ),
                                            TextSpan(
                                              text:
                                                  " of ${state.totalResult?.totalResult} result",
                                              style: AppTextStyles
                                                  .montserratStyle
                                                  .regular14Grey,
                                            ),
                                          ])),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                context
                                                    .read<PaymentHistoryBloc>()
                                                    .add(
                                                        PaymentHistoryLoadPreviousPageEvent());
                                              },
                                              icon: const Icon(
                                                  Icons.navigate_before),
                                              color: (state.currentPage !=
                                                          null &&
                                                      state.currentPage! <= 1)
                                                  ? AppColors.spanishGray
                                                  : AppColors.tiffanyBlue,
                                              padding: EdgeInsets.zero,
                                            ),
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () {
                                                context
                                                    .read<PaymentHistoryBloc>()
                                                    .add(
                                                        PaymentHistoryLoadMorePageEvent());
                                              },
                                              icon: const Icon(
                                                  Icons.navigate_next),
                                              color: state.currentPage ==
                                                      state.totalResult
                                                          ?.totalPages
                                                  ? AppColors.spanishGray
                                                  : AppColors.tiffanyBlue,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    Constants.noPaymentHistory,
                                    style: AppTextStyles
                                        .montserratStyle.bold16Black,
                                  ),
                                  Text(
                                    textAlign: TextAlign.center,
                                    Constants.haveNotPurchased,
                                    style: AppTextStyles
                                        .montserratStyle.regular16Black
                                        .copyWith(fontStyle: FontStyle.italic),
                                  )
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
                if (state.isPickedStartDate)
                  _buildDatePicker(
                    isPicked: true,
                    right: 22,
                    left: 0,
                    maxDate: DateTime.now(),
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
                    maxDate: (state.startDate != null &&
                            state.startDate!
                                .add(const Duration(days: 365))
                                .isBefore(DateTime.now()))
                        ? state.startDate!.add(const Duration(days: 365))
                        : DateTime.now(),
                    minDate: state.startDate,
                    onDateSelected: (endDate) {
                      context.read<PaymentHistoryBloc>().add(
                          PaymentHistorySelectionEndDateEvent(
                              endDate: endDate));
                    },
                  )
              ],
            ),
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
    DateTime? maxDate,
    DateTime? minDate,
  }) {
    return Positioned(
      top: 90,
      left: left,
      right: right,
      child: Card(
        elevation: 6,
        child: DatePickerWidgets(
          selectedDate: (date) => onDateSelected(date.value),
          minDate: minDate,
          maxDate: maxDate,
        ),
      ),
    );
  }
}
