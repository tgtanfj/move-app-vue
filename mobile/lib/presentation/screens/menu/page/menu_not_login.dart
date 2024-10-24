import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/custom_button.dart';
import 'package:move_app/presentation/routes/app_routes.dart';
import 'package:move_app/presentation/screens/menu/widget/content_menu.dart';
import 'package:move_app/presentation/screens/menu/widget/more_infomation.dart';

import '../../auth/widgets/dialog_authentication.dart';

class MenuNotLogin extends StatefulWidget {
  final VoidCallback moreButton;
  final bool isMoreEnable;

  const MenuNotLogin(
      {super.key, required this.moreButton, required this.isMoreEnable});

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
            followingButton: () {},
            browseButton: () {},
            walletButton: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const DialogAuthentication();
                },
              );
            },
            settingButton: () {
              Navigator.of(context).pushNamed(AppRoutes.routeProfile);
            },
          ),
          GestureDetector(
            onTap: widget.moreButton,
            child: Row(
              children: [
                Text(
                  Constants.more,
                  style: AppTextStyles.montserratStyle.bold20White,
                ),
                const SizedBox(
                  width: 12.0,
                ),
                SvgPicture.asset(AppIcons.arrowDown.svgAssetPath),
              ],
            ),
          ),
          widget.isMoreEnable
              ? MoreInfomation(faqButton: () {
                  Navigator.of(context).pushNamed(AppRoutes.routeviewFAQs);
                })
              : const SizedBox(),
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
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const DialogAuthentication();
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
