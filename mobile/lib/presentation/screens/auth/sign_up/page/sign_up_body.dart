import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/custom_edit_text.dart';
import 'package:move_app/presentation/screens/auth/sign_up/bloc/sign_up_bloc.dart';
import 'package:move_app/presentation/screens/auth/sign_up/bloc/sign_up_state.dart';
import 'package:move_app/presentation/screens/auth/sign_up/widgets/title_edit_text_referral.dart';
import 'package:move_app/presentation/screens/auth/widgets/divider_authentication.dart';

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
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomButton(
                  prefix: SvgPicture.asset(AppIcons.googleLogo.svgAssetPath),
                  title: Constants.signUpWithGoogle,
                  titleStyle: AppTextStyles.montserratStyle.bold16Black,
                  borderColor: AppColors.chineseSilver,
                  onTap: () {
                    context.read<SignUpBloc>().add(SignUpWithGoogleEvent());
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomButton(
                  prefix: SvgPicture.asset(AppIcons.facebookLogo.svgAssetPath),
                  title: Constants.signUpWithFaceBook,
                  titleStyle: AppTextStyles.montserratStyle.bold16Black,
                  borderColor: AppColors.chineseSilver,
                  onTap: () {
                    context.read<SignUpBloc>().add(SignUpWithFacebookEvent());
                  },
                ),
                const SizedBox(
                  height: 11,
                ),
                const DividerAuthentication(),
                const SizedBox(
                  height: 14,
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
                      Constants.signUpWithEmail.toUpperCase(),
                      style: AppTextStyles.montserratStyle.bold14tiffanyBlue,
                    ),
                  ),
                ),
                Visibility(
                    visible: state.isClickSignUpWithEmail,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomEditText(
                          title: Constants.email,
                          onChanged: (value) {
                            context
                                .read<SignUpBloc>()
                                .add(SignUpValuesChangedEvent(email: value));
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                        CustomEditText(
                          title: Constants.password,
                          isPasswordInput:true,
                          maxLength: 32,
                          onChanged: (value) {
                            context
                                .read<SignUpBloc>()
                                .add(SignUpValuesChangedEvent(password: value));
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomEditText(
                          title: Constants.confirmPassword,
                          isPasswordInput: true,
                          onChanged: (value) {
                            context
                                .read<SignUpBloc>()
                                .add(SignUpValuesChangedEvent(confirmPassword: value));
                          },
                          maxLength: 32,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TitleEditTextReferral(
                          title: Constants.referralCode,
                          subTitle: Constants.optional,
                          subTitleStyle: AppTextStyles
                              .montserratStyle.regular16Black
                              .copyWith(fontStyle: FontStyle.italic),

                        ),
                        CustomEditText(
                          textCapitalization: TextCapitalization.characters,
                          textInputType: TextInputType.text,
                          maxLength: 6,
                          onChanged: (value) {
                            context
                                .read<SignUpBloc>()
                                .add(SignUpValuesChangedEvent(referralCode: value));
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            style: AppTextStyles
                                .montserratStyle.regular14sonicSilver,
                            children: [
                              const TextSpan(text: Constants.byClickingSignUp),
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
                          titleStyle: AppTextStyles.montserratStyle.bold16White,
                          borderColor: state.isEnableSignUp
                              ? AppColors.tiffanyBlue
                              : AppColors.spanishGray,
                          backgroundColor: state.isEnableSignUp
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
    );
  }
}
