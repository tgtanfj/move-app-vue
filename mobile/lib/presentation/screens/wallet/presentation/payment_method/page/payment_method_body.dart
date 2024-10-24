import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/custom_button.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_method/presentation/page/payment_details_page.dart';

class PaymentMethodBody extends StatefulWidget {
  final bool? showCardHolder;
  const PaymentMethodBody({super.key, this.showCardHolder});

  @override
  State<PaymentMethodBody> createState() => _PaymentMethodBodyState();
}

class _PaymentMethodBodyState extends State<PaymentMethodBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 134;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            Constants.yourPaymentMethod,
            style: AppTextStyles.montserratStyle.bold16Black,
          ),
          Container(
            padding: const EdgeInsets.only(top: 200),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.showCardHolder ?? false) ...[
                  Text(
                    Constants.cardNumber,
                    style: AppTextStyles.montserratStyle.regular16Black
                        .copyWith(fontStyle: FontStyle.italic),
                  ),
                ] else ...[
                  Text(
                    Constants.noPaymentMethod,
                    style: AppTextStyles.montserratStyle.bold16black,
                  ),
                  Text(
                    Constants.youDoNotHaveSavedPayment,
                    style: AppTextStyles.montserratStyle.regular16Black
                        .copyWith(fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomButton(
                    title: Constants.setUpPaymentMethod,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const PaymentDetailsPage()));
                    },
                    titleStyle: AppTextStyles.montserratStyle.bold16White,
                    backgroundColor: AppColors.tiffanyBlue,
                    width: width,
                  )
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
