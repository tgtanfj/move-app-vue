import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/custom_button.dart';
import 'package:move_app/presentation/routes/app_routes.dart';
import 'package:move_app/presentation/screens/auth/widgets/dialog_authentication.dart';
import 'package:move_app/presentation/screens/menu/widget/content_menu.dart';

class MenuNotLogin extends StatefulWidget {
  final VoidCallback moreButton;
  final bool isMoreEnable;
  final bool isStateAtCurrentPage;

  const MenuNotLogin(
      {super.key,
      required this.moreButton,
      required this.isMoreEnable,
      required this.isStateAtCurrentPage});

  @override
  State<MenuNotLogin> createState() => _MenuNotLoginState();
}

class _MenuNotLoginState extends State<MenuNotLogin> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          const SizedBox(
            height: 8.0,
          ),
          ContentMenu(
            walletButton: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const DialogAuthentication();
                },
              );
            },
            settingButton: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const DialogAuthentication();
                },
              );
            },
            faqsButton: () {
              Navigator.of(context).pushNamed(AppRoutes.routeviewFAQs);
            },
          ),
          const SizedBox(
            height: 40.0,
          ),
          CustomButton(
            padding: EdgeInsets.zero,
            backgroundColor: AppColors.black,
            borderColor: AppColors.black,
            borderRadius: 0,
            titleStyle: AppTextStyles.montserratStyle.bold20White,
            textAlign: TextAlign.start,
            onTap: () {
              widget.isStateAtCurrentPage
                  ? Navigator.of(context).pop()
                  : Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.home,
                      arguments: false,
                    );
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogAuthentication(
                    isStayOnPage: widget.isStateAtCurrentPage,
                  );
                },
              );
            },
            title: Constants.loginMenu,
          ),
        ],
      ),
    );
  }
}
