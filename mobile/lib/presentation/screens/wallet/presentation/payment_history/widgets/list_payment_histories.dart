import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_text_styles.dart';

class ListPaymentHistories extends StatelessWidget {
  final String? date;
  final String? productName;
  final String? time;

  const ListPaymentHistories({
    super.key,
    this.date,
    this.productName,
    this.time,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            paymentHistoryWidgets(
              date ?? "22 Oct 2024",
              productName ?? "300 Reps",
              time ?? "05:10:58",
            ),
            const Divider(
              height: 1,
            ),
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 12.0);
      },
    );
  }

  Widget paymentHistoryWidgets(
      String? date, String? productName, String? time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 17),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Text(
                date ?? "",
                style: AppTextStyles.montserratStyle.regular14Grey,
              )),
          Expanded(
            flex: 1,
            child: Text(
              time ?? "",
              style: AppTextStyles.montserratStyle.regular14Grey,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              productName ?? "",
              style: AppTextStyles.montserratStyle.bold14Black,
            ),
          ),
        ],
      ),
    );
  }
}
