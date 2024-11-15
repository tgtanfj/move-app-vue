import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/models/wallet_argument_model.dart';
import 'package:move_app/presentation/components/app_bar_widget.dart';
import 'package:move_app/presentation/components/custom_section_title.dart';
import 'package:move_app/presentation/components/custom_tab_bar.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_history/page/payment_history_page.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_method/page/payment_method_page.dart';

class WalletBody extends StatefulWidget {
  final WalletArguments? arguments;
  const WalletBody({super.key, this.arguments});

  @override
  State<WalletBody> createState() => _WalletBodyState();
}

class _WalletBodyState extends State<WalletBody> {
  bool isShowSuccessMessage = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final success = widget.arguments;
      if (success?.isTrue == true) {
        setState(() {
          isShowSuccessMessage = true;
        });

        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            isShowSuccessMessage = false;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isShowSuccessMessage)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: AppColors.bubbles,
                    border: Border.all(color: AppColors.tiffanyBlue, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    Constants.setUpPaymentMethodSuccess,
                    style: AppTextStyles.montserratStyle.regular14Black,
                  ),
                ),
              const CustomSectionTitle(title: Constants.wallet),
              Expanded(
                child: CustomTabBar(tabsWithViews: {
                  Constants.paymentMethod:
                      PaymentMethodPage(rep: widget.arguments?.rep),
                  Constants.paymentHistory: const PaymentHistoryPage(),
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
