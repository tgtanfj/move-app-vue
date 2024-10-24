import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/avatar.dart';
import 'package:move_app/presentation/components/badges.dart';
import 'package:move_app/presentation/components/custom_button.dart';
import 'package:move_app/presentation/routes/app_routes.dart';
import 'package:move_app/presentation/screens/buy_rep/page/buy_rep_page.dart';
import 'package:move_app/presentation/screens/menu/widget/content_menu.dart';
import 'package:move_app/presentation/screens/menu/widget/more_infomation.dart';

import '../../../components/logout_dialog.dart';

class MenuHadLogin extends StatefulWidget {
  final VoidCallback moreButton;
  final bool isMoreEnable;
  final VoidCallback logoutSuccessEvent;

  final String avatarPath;
  final String userName;
  final bool isBlueBadge;
  final bool isPinkBadge;

  const MenuHadLogin({
    super.key,
    required this.logoutSuccessEvent,
    required this.moreButton,
    required this.isMoreEnable,
    required this.avatarPath,
    required this.userName,
    required this.isBlueBadge,
    required this.isPinkBadge,
  });

  @override
  State<MenuHadLogin> createState() => _MenuHadLoginState();
}

class _MenuHadLoginState extends State<MenuHadLogin> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Row(
            children: [
              Avatar(
                  heightAvatar: 40.0,
                  widthAvatar: 40.0,
                  radiusAvatar: 32.0,
                  imageUrl: widget.avatarPath),
              const SizedBox(
                width: 8.0,
              ),
              Text(
                widget.userName,
                style: AppTextStyles.montserratStyle.bold17White,
              ),
              Badges(
                isBlueBadge: widget.isBlueBadge,
                isPinkBadge: widget.isPinkBadge,
              ),
            ],
          ),
          const SizedBox(
            height: 8.0,
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const BuyRepPage();
                  });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              decoration: BoxDecoration(
                color: AppColors.tiffanyBlue,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Wrap(
                  children: [
                    SvgPicture.asset(AppIcons.rep.svgAssetPath),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      Constants.getRep$,
                      style: AppTextStyles.montserratStyle.bold16White,
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: AppColors.white,
          ),
          const SizedBox(
            height: 20.0,
          ),
          ContentMenu(
            followingButton: () {},
            browseButton: () {},
            walletButton: () {},
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
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return LogoutDialog(yesButton: widget.logoutSuccessEvent);
                },
              );
            },
            title: Constants.logout,
          ),
        ],
      ),
    );
  }
}
