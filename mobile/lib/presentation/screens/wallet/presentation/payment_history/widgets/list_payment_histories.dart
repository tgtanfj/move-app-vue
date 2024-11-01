import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/data/models/payment_model.dart';
import 'package:move_app/utils/util_date_time_format.dart';

class ListPaymentHistories extends StatelessWidget {
  final List<PaymentModel>? paymentHistoryList;

  const ListPaymentHistories({
    super.key,
    this.paymentHistoryList,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.57,
      child: ListView.separated(
        itemCount: paymentHistoryList?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: paymentHistoryWidgets(
                          UtilDateTimeFormat().formatMonthDateYear(
                              DateTime.parse(paymentHistoryList?[index]
                                      .createdAt
                                      .toString() ??
                                  "")),
                          AppTextStyles.montserratStyle.regular14Grey)),
                  Expanded(
                      flex: 1,
                      child: paymentHistoryWidgets(
                          UtilDateTimeFormat().formatTime(DateTime.parse(
                              paymentHistoryList?[index].createdAt.toString() ??
                                  "")),
                          AppTextStyles.montserratStyle.regular14Grey)),
                  Expanded(
                    flex: 1,
                    child: paymentHistoryWidgets(
                        "${paymentHistoryList?[index].repsPackage?.numberOfREPs.toString()} REPs",
                        AppTextStyles.montserratStyle.bold14Black),
                  ),
                ],
              ),
              const Divider(
                height: 1,
              )
            ],
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 12.0);
        },
      ),
    );
  }

  Widget paymentHistoryWidgets(String? title, TextStyle? titleStyle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 17),
      child: Text(
        title ?? "",
        style: titleStyle,
      ),
    );
  }
}
