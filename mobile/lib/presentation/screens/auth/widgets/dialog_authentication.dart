import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/screens/auth/login/page/login_page.dart';
import 'package:move_app/presentation/screens/auth/sign_up/page/sign_up_page.dart';
import 'package:move_app/presentation/screens/auth/widgets/custom_expandable_page_view.dart';

import '../../../../../config/theme/app_colors.dart';

class DialogAuthentication extends StatelessWidget {
  const DialogAuthentication({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                      child: SvgPicture.asset(AppIcons.moveLogo.svgAssetPath)),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      AppIcons.close.svgAssetPath,
                      height: 16,
                      width: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const CustomExpandablePageView(
                dividerColor: AppColors.chineseSilver,
                tabBarPadding: EdgeInsets.symmetric(horizontal: 16),
                tabAlignment: TabAlignment.center,
                tabsWithViews: {
                  Constants.login: LoginPage(),
                  Constants.signUp: SignUpPage()
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
