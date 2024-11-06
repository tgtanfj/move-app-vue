import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/models/wallet_argument_model.dart';
import 'package:move_app/presentation/components/custom_button.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_details/page/payment_details_page.dart';

class PaymentMethodEmpty extends StatefulWidget {
  final WalletArguments? walletArguments;
  const PaymentMethodEmpty({super.key, this.walletArguments});

  @override
  State<PaymentMethodEmpty> createState() => _PaymentMethodEmptyState();
}

class _PaymentMethodEmptyState extends State<PaymentMethodEmpty> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 134;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              Constants.yourPaymentMethod,
              style: AppTextStyles.montserratStyle.bold16Black,
            ),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                                builder: (context) => PaymentDetailsPage(
                                    walletArguments: widget.walletArguments)));
                      },
                      titleStyle: AppTextStyles.montserratStyle.bold16White,
                      backgroundColor: AppColors.tiffanyBlue,
                      width: width,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
