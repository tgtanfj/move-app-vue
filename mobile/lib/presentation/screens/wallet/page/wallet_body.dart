import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_history/page/payment_history_body.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_history/page/payment_history_page.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../constants/constants.dart';
import '../../../components/app_bar_widget.dart';
import '../../../components/custom_section_title.dart';
import '../../../components/custom_tab_bar.dart';

class WalletBody extends StatefulWidget {
  const WalletBody({super.key});

  @override
  State<WalletBody> createState() => _WalletBodyState();
}

class _WalletBodyState extends State<WalletBody> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSectionTitle(title: Constants.wallet),
              Expanded(
                child: CustomTabBar(tabsWithViews: {
                  Constants.paymentMethod: SizedBox(),
                  Constants.paymentHistory: PaymentHistoryPage(),
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}