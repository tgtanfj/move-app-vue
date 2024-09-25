import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/custom_edit_text.dart';
import 'package:move_app/presentation/screens/auth/sign_up/bloc/sign_up_bloc.dart';
import 'package:move_app/presentation/screens/auth/sign_up/bloc/sign_up_state.dart';
import 'package:move_app/presentation/screens/auth/widgets/custom_divider_with.dart';

import '../../../../components/custom_button.dart';
import '../bloc/sign_up_event.dart';

class SignUpBody extends StatefulWidget {
  const SignUpBody({super.key});

  @override
  State<SignUpBody> createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomButton(
                  iconPath: AppIcons.googleLogo.svgAssetPath,
                  title: Constants.signUpWithGoogle,
                  onTap: () {},
                  marginBottom: 8,
                ),
                CustomButton(
                  iconPath: AppIcons.facebookLogo.svgAssetPath,
                  title: Constants.signUpWithFaceBook,
                  onTap: () {},
                  marginBottom: 21,
                ),
                const CustomDividerWith(),
                const SizedBox(
                  height: 15,
                ),
                Visibility(
                  visible: !state.isClickSignUpWithEmail,
                  child: GestureDetector(
                    onTap: () {
                      context
                          .read<SignUpBloc>()
                          .add(SignUpClickSignUpWithEmailEvent());
                    },
                    child: Text(
                      Constants.signUpWithEmail,
                      style: AppTextStyles.montserratStyle.bold14tiffanyBlue,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                Visibility(
                    visible: state.isClickSignUpWithEmail,
                    child: Column(
                      children: [
                        CustomEditText(
                          title: Constants.email,
                          onChanged: (value) {
                            context
                                .read<SignUpBloc>()
                                .add(SignUpEmailChangedEvent(value));
                          },
                        ),
                        CustomEditText(
                          title: Constants.password,
                          isShowText: !state.isShowPassword,
                          maxLength: 8,
                          onChanged: (value) {
                            context
                                .read<SignUpBloc>()
                                .add(SignUpPasswordChangedEvent(value));
                          },
                          suffix: GestureDetector(
                            onTap: () {
                              context
                                  .read<SignUpBloc>()
                                  .add(SignUpClickShowPasswordEvent());
                            },
                            child: state.isShowPassword
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                          ),
                        ),
                        CustomEditText(
                          title: Constants.confirmPassword,
                          isShowText: !state.isShowConfirmPassword,
                          onChanged: (value) {
                            context.read<SignUpBloc>().add(
                                SignUpConfirmPasswordChangedEvent(value));
                          },
                          maxLength: 8,
                          suffix: GestureDetector(
                            onTap: () {
                              context
                                  .read<SignUpBloc>()
                                  .add(SignUpClickShowConfirmPasswordEvent());
                            },
                            child: state.isShowConfirmPassword
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                          ),
                        ),
                        CustomEditText(
                          title: Constants.referralCode,
                          textCapitalization: TextCapitalization.characters,
                          textInputType: TextInputType.text,
                          maxLength: 6,
                          onChanged: (value) {
                            context
                                .read<SignUpBloc>()
                                .add(SignUpReferralCodeChangedEvent(value));
                          },
                          marginBottom: 17,
                        ),
                        RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            style:
                                AppTextStyles.montserratStyle.regular14Black,
                            children: [
                              const TextSpan(
                                  text: Constants.byClickingSignUp),
                              TextSpan(
                                text: Constants.termsOfService,
                                style: AppTextStyles
                                    .montserratStyle.regular14tiffanyBlue,
                              ),
                              const TextSpan(
                                text: Constants.and,
                              ),
                              TextSpan(
                                text: Constants.privacyNotice,
                                style: AppTextStyles
                                    .montserratStyle.regular14tiffanyBlue,
                              ),
                              const TextSpan(
                                text: '.',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 23,
                        ),
                        CustomButton(
                          title: Constants.signUp,
                          textStyle:
                              AppTextStyles.montserratStyle.bold16White,
                          backgroundColor: state.email.isNotEmpty &&
                                  state.password.isNotEmpty &&
                                  state.confirmPassword.isNotEmpty &&
                                  state.referralCode.isNotEmpty
                              ? AppColors.tiffanyBlue
                              : AppColors.spanishGray,
                          onTap: () {},
                        ),
                      ],
                    ))
              ],
            ),
          ),
        );
      },
    ));
  }
}
