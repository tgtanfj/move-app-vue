import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/repositories/auth_repository.dart';
import 'package:move_app/data/repositories/user_repository.dart';
import 'package:move_app/presentation/components/custom_edit_text.dart';
import 'package:move_app/presentation/screens/auth/login/bloc/login_bloc.dart';
import 'package:move_app/presentation/screens/auth/login/bloc/login_state.dart';
import 'package:move_app/presentation/screens/auth/sign_up/page/sign_up_body.dart';
import 'package:move_app/presentation/screens/home/page/home_body.dart';

import '../../../../components/custom_button.dart';
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
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomeBody(
                authRepository: AuthenticationRepository(),
              ),
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
                            CustomEditText(
                              title: Constants.email,
                              onChanged: (email) {
                                context.read<LoginBloc>().add(
                                    LoginChangeEmailPasswordEvent(
                                        email: email,
                                        password: state.password));
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
                            Text(
                              Constants.forgotPassword,
                              style: AppTextStyles
                                  .montserratStyle.regular14tiffanyBlue,
                            ),
                            const SizedBox(height: 20),
                            CustomButton(
                              title: Constants.login,
                              titleStyle:
                                  AppTextStyles.montserratStyle.bold16White,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: state.isEnabled
                                  ? AppColors.tiffanyBlue
                                  : AppColors.spanishGray,
                              borderColor: AppColors.spanishGray,
                              onTap: () {
                                context.read<LoginBloc>().add(
                                      LoginWithEmailPasswordEvent(),
                                    );
                              },
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
