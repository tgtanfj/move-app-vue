import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/presentation/screens/auth/sign_up/page/sign_up_page.dart';

import '../../../components/custom_tab_bar.dart';

class DialogAuthentication extends StatelessWidget {
  const DialogAuthentication({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(child: SvgPicture.asset(AppIcons.moveLogo.svgAssetPath)),
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(
                    AppIcons.close.svgAssetPath,
                    height: 16,
                    width: 16,
                  )),
              SizedBox(
                width: 16,
              )
            ],
          ),
          const SizedBox(height: 22),
          const Expanded(
            child: CustomTabBar(
              tabAlignment: TabAlignment.center,
              dividerHeight: 1,
              dividerColor: AppColors.chineseSilver,
              tabBarPadding: EdgeInsets.zero,
              tabsWithViews: {
                Constants.login: SizedBox.shrink(),
                Constants.signUp: SignUpPage()
              },
            ),
          ),
        ],
      ),
    );
  }
}
