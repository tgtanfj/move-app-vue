import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';

class PaymentMethodNotEmpty extends StatefulWidget {
  const PaymentMethodNotEmpty({super.key});

  @override
  State<PaymentMethodNotEmpty> createState() =>
      _PaymentMethodNotEmptyState();
}

class _PaymentMethodNotEmptyState extends State<PaymentMethodNotEmpty> {
  @override
  Widget build(BuildContext context) {
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
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD6D5D5).withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 6,
                    offset: const Offset(-3, 3),
                  ),
                  BoxShadow(
                    color: const Color(0xFFD6D5D5).withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 6,
                    offset: const Offset(3, 3),
                  ),
                ]),
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(
                    'Cardholder Name',
                    style: AppTextStyles.montserratStyle.regular12Black,
                  ),
                  Expanded(child: Container()),
                  Text(
                    'Edit',
                    style: AppTextStyles.montserratStyle.regular14TiffanyBlue,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    'Remove',
                    style: AppTextStyles.montserratStyle.regular14BrinkPink,
                  ),
                ]),
                Text(
                  'Phillip Giggs',
                  style: AppTextStyles.montserratStyle.regular18Black,
                ),
                const SizedBox(height: 16),
                Text(
                  'Card number',
                  style: AppTextStyles.montserratStyle.regular12Black,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 25,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(4.0),
                          ),
                          border: Border.all(
                            color: AppColors.chineseSilver,
                            width: 1,
                          )),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        child: SvgPicture.asset(
                          AppIcons.visa.svgAssetPath,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      '**** **** **** 1234',
                      style: AppTextStyles.montserratStyle.regular18Black,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
