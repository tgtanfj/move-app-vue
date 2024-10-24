import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/app_bar_widget.dart';
import 'package:move_app/presentation/components/custom_section_title.dart';
import 'package:move_app/presentation/components/custom_tab_bar.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_method/page/payment_method_page.dart';

class WalletBody extends StatefulWidget {
  final bool? showCardHoder;
  const WalletBody({super.key, this.showCardHoder});

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
                  Constants.paymentMethod: PaymentMethodPage(),
                  Constants.paymentHistory: SizedBox(),
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
