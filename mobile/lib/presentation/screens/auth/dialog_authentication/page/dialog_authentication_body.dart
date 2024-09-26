import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/presentation/screens/auth/dialog_authentication/bloc/dialog_authentication_bloc.dart';
import 'package:move_app/presentation/screens/auth/dialog_authentication/bloc/dialog_authentication_event.dart';
import 'package:move_app/presentation/screens/auth/dialog_authentication/bloc/dialog_authentication_state.dart';
import 'package:move_app/presentation/screens/auth/login/page/login_page.dart';

import '../../../../../config/theme/app_colors.dart';
import '../../../../../config/theme/app_icons.dart';
import '../../../../../config/theme/app_text_styles.dart';
import '../../../../../constants/constants.dart';

class DialogAuthenticationBody extends StatefulWidget {
  const DialogAuthenticationBody({super.key});

  @override
  State<DialogAuthenticationBody> createState() => _DialogAuthenticationBody();
}

class _DialogAuthenticationBody extends State<DialogAuthenticationBody>{

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DialogAuthenticationBloc, DialogAuthenticationState>(
      builder: (context, state) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header Row with Logo and Close Button
                  Row(
                    children: [
                      Expanded(
                          child:
                          SvgPicture.asset(AppIcons.moveLogo.svgAssetPath)),
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
                  const SizedBox(height: 16),
                  // Login and Signup Tab
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context
                                      .read<DialogAuthenticationBloc>()
                                      .add(ShowLoginPageEvent());
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    Constants.login,
                                    style: state.isShowLoginPage
                                        ? AppTextStyles
                                        .montserratStyle.bold16tiffanyBlue
                                        : AppTextStyles
                                        .montserratStyle.regular16Black,
                                  ),
                                ),
                              ),
                              if (state.isShowLoginPage)
                                Container(
                                  height: 4,
                                  width: 56,
                                  margin: EdgeInsets.only(top: 1),
                                  color: AppColors.tiffanyBlue,
                                )
                            ],
                          ),
                          const SizedBox(width: 30),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context
                                      .read<DialogAuthenticationBloc>()
                                      .add(ShowLoginPageEvent());
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    Constants.signUp,
                                    style: !state.isShowLoginPage
                                        ? AppTextStyles
                                        .montserratStyle.bold16tiffanyBlue
                                        : AppTextStyles
                                        .montserratStyle.regular16Black,
                                  ),
                                ),
                              ),
                              if (!state.isShowLoginPage)
                                Container(
                                  height: 4,
                                  width: 65,
                                  margin: EdgeInsets.only(top: 1),
                                  color: AppColors.tiffanyBlue,
                                )
                            ],
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                              child: Divider(
                                height: 1,
                                color: AppColors.chineseSilver,
                              )),
                          SizedBox(
                            width: 16,
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  state.isShowLoginPage
                      ? const LoginPage()
                      : const Text("Sign up page")
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}