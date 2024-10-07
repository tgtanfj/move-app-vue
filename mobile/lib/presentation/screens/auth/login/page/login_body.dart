import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/custom_edit_text.dart';
import 'package:move_app/presentation/screens/auth/login/bloc/login_bloc.dart';
import 'package:move_app/presentation/screens/auth/login/bloc/login_state.dart';
import 'package:move_app/presentation/screens/forgot_password/page/forgot_password/forgot_password_page.dart';
import 'package:move_app/presentation/screens/home/page/home_body.dart';

import '../../../../components/custom_button.dart';
import '../../widgets/divider_authentication.dart';
import '../bloc/login_event.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          Fluttertoast.showToast(msg: Constants.loginSuccessful);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomeBody(),
            ),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomButton(
                      onTap: () async {
                        context.read<LoginBloc>().add(LoginWithGoogleEvent());
                      },
                      borderRadius: 8.0,
                      prefix:
                          SvgPicture.asset(AppIcons.googleLogo.svgAssetPath),
                      title: Constants.loginWithGoogle,
                      titleStyle: AppTextStyles.montserratStyle.bold16Black,
                      backgroundColor: Colors.white,
                      borderColor: AppColors.chineseSilver),
                  const SizedBox(height: 12),
                  CustomButton(
                    onTap: () {
                      context.read<LoginBloc>().add(LoginWithFacebookEvent());
                    },
                    borderRadius: 8.0,
                    prefix:
                        SvgPicture.asset(AppIcons.facebookLogo.svgAssetPath),
                    title: Constants.loginWithFacebook,
                    titleStyle: AppTextStyles.montserratStyle.bold16Black,
                    backgroundColor: Colors.white,
                    borderColor: AppColors.chineseSilver,
                  ),
                  const SizedBox(height: 12),
                  const DividerAuthentication(),
                  const SizedBox(height: 15),
                  state.isVisible
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomEditText(
                              title: Constants.email,
                              maxLength: 255,
                              onChanged: (email) {
                                context.read<LoginBloc>().add(
                                      LoginChangeEmailPasswordEvent(
                                        email: email,
                                        password: state.password,
                                      ),
                                    );
                              },
                              isShowMessage: state.isShowEmailMessage,
                              textStyle: state.isShowEmailMessage
                                  ? AppTextStyles
                                      .montserratStyle.regular14BrinkPink
                                  : AppTextStyles
                                      .montserratStyle.regular14Black,
                              borderColor: AppColors.brinkPink,
                              cursorColor: state.isShowEmailMessage
                                  ? AppColors.brinkPink
                                  : AppColors.tiffanyBlue,
                              preMessage: state.messageInputEmail,
                            ),
                            const SizedBox(height: 12),
                            CustomEditText(
                              title: Constants.password,
                              isPasswordInput: true,
                              maxLength: 32,
                              onChanged: (password) {
                                context.read<LoginBloc>().add(
                                      LoginChangeEmailPasswordEvent(
                                        email: state.email,
                                        password: password,
                                      ),
                                    );
                              },
                              isShowMessage: state.isShowPasswordMessage,
                              textStyle: state.isShowPasswordMessage
                                  ? AppTextStyles
                                      .montserratStyle.regular14BrinkPink
                                  : AppTextStyles
                                      .montserratStyle.regular14Black,
                              borderColor: AppColors.brinkPink,
                              cursorColor: state.isShowPasswordMessage
                                  ? AppColors.brinkPink
                                  : AppColors.tiffanyBlue,
                              preMessage: state.messageInputPassword,
                            ),
                            const SizedBox(height: 8),
                            CustomButton(
                              title: Constants.forgotPassword,
                              titleStyle: AppTextStyles
                                  .montserratStyle.regular14TiffanyBlue,
                              borderColor: AppColors.white,
                              textAlign: TextAlign.left,
                              padding: EdgeInsets.zero,
                              onTap: () {
                                Navigator.of(context).pop();
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const ForgotPasswordPage();
                                    });
                              },
                            ),
                            const SizedBox(height: 20),
                            CustomButton(
                              title: Constants.logIn,
                              titleStyle:
                                  AppTextStyles.montserratStyle.bold16White,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: state.isEnabled
                                  ? AppColors.tiffanyBlue
                                  : AppColors.spanishGray,
                              borderColor: state.isEnabled
                                  ? AppColors.tiffanyBlue
                                  : AppColors.spanishGray,
                              onTap: state.isEnabled
                                  ? () {
                                      context.read<LoginBloc>().add(
                                            LoginWithEmailPasswordEvent(),
                                          );
                                    }
                                  : null,
                            ),
                          ],
                        )
                      : InkWell(
                          onTap: () {
                            context
                                .read<LoginBloc>()
                                .add(LoginWithEmailVisibleEvent());
                          },
                          highlightColor: Colors.transparent,
                          child: Center(
                            child: Text(
                              Constants.loginWithEmail,
                              style: AppTextStyles
                                  .montserratStyle.bold14tiffanyBlue,
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
