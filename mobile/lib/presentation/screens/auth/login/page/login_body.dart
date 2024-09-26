import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/custom_edit_text.dart';
import 'package:move_app/presentation/screens/auth/login/bloc/login_bloc.dart';
import 'package:move_app/presentation/screens/auth/login/bloc/login_state.dart';
import 'package:move_app/presentation/screens/auth/login/widgets/custom_button.dart';

import '../bloc/login_event.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {},
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                children: [
                  CustomButton(
                    onTap: () {},
                    borderRadius: 8.0,
                    prefix: SvgPicture.asset(AppIcons.googleLogo.svgAssetPath),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    title: Constants.loginWithGoogle,
                    titleStyle: AppTextStyles.montserratStyle.bold16Black,
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    onTap: () {},
                    borderRadius: 8.0,
                    prefix:
                        SvgPicture.asset(AppIcons.facebookLogo.svgAssetPath),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    title: Constants.loginWithFacebook,
                    titleStyle: AppTextStyles.montserratStyle.bold16Black,
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Expanded(child: Divider(thickness: 1)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(Constants.or),
                      ),
                      Expanded(child: Divider(thickness: 1)),
                    ],
                  ),
                  state.isVisible
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomEditText(title: Constants.email),
                            const SizedBox(height: 12),
                            Text(
                              Constants.password,
                              style:
                                  AppTextStyles.montserratStyle.regular16Black,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.visibility,
                                  ),
                                  onPressed: () {},
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: AppColors.spanishGray),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: AppColors.tiffanyBlue, width: 1.0),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              Constants.forgotPassword,
                              style: AppTextStyles
                                  .montserratStyle.regular14TiffanyBlue,
                            ),
                            const SizedBox(height: 20),
                            CustomButton(
                                title: Constants.login,
                                titleStyle:
                                    AppTextStyles.montserratStyle.bold16White,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                backgroundColor: AppColors.spanishGray,
                                onTap: () {}),
                          ],
                        )
                      : TextButton(
                          onPressed: () {
                            context
                                .read<LoginBloc>()
                                .add(LoginWithEmailVisibleEvent());
                          },
                          child: Center(
                            child: Text(
                              Constants.loginWithEmail,
                              style: AppTextStyles
                                  .montserratStyle.bold14TiffanyBlue,
                            ),
                          ),
                        ),
                  
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
