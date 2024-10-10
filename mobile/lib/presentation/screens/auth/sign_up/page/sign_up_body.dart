import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
import '../../otp/page/otp_verification_page.dart';
import '../bloc/sign_up_event.dart';

class SignUpBody extends StatefulWidget {
  const SignUpBody({super.key});

  @override
  State<SignUpBody> createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!focusNode.hasFocus) {
      setState(() {
        controller.text = controller.text.trim();
      });
      context
          .read<SignUpBloc>()
          .add(SignUpValuesChangedEvent(email: controller.text.trim()));
    }
  }

  @override
  void dispose() {
    focusNode.removeListener(_onFocusChange);
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<SignUpBloc, SignUpState>(listener: (context, state) {
      if (state.status == SignUpStatus.success) {
        Navigator.of(context).pop();
      }
      if (state.status == SignUpStatus.loading) {
        EasyLoading.show();
      } else {
        EasyLoading.dismiss();
      }
      if (state.status == SignUpStatus.goOn) {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return OtpVerificationPage(userModel: state.userModel);
          },
        );
      }
    }, child: BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                CustomButton(
                  prefix: SvgPicture.asset(AppIcons.googleLogo.svgAssetPath),
                  title: Constants.signUpWithGoogle,
                  titleStyle: AppTextStyles.montserratStyle.bold16Black,
                  borderColor: AppColors.chineseSilver,
                  padding: const EdgeInsets.only(top: 13, bottom: 14, left: 12),
                  onTap: () {
                    context.read<SignUpBloc>().add(SignUpWithGoogleEvent());
                  },
                ),
                const SizedBox(height: 8),
                CustomButton(
                  prefix: SvgPicture.asset(AppIcons.facebookLogo.svgAssetPath),
                  title: Constants.signUpWithFaceBook,
                  titleStyle: AppTextStyles.montserratStyle.bold16Black,
                  borderColor: AppColors.chineseSilver,
                  padding: const EdgeInsets.only(top: 13, bottom: 14, left: 12),
                  onTap: () {
                    context.read<SignUpBloc>().add(SignUpWithFacebookEvent());
                  },
                ),
                const SizedBox(height: 11),
                const DividerAuthentication(),
                const SizedBox(height: 14),
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
                        isShowMessage: state.isShowEmailMessage,
                        textStyle: state.isShowEmailMessage
                            ? AppTextStyles.montserratStyle.regular14BrinkPink
                            : AppTextStyles.montserratStyle.regular14Black,
                        borderColor: AppColors.brinkPink,
                        controller: controller,
                        cursorColor: state.isShowEmailMessage
                            ? AppColors.brinkPink
                            : AppColors.tiffanyBlue,
                        preMessage: state.messageInputEmail,
                        maxLength: 255,
                        focusNode: focusNode,
                        onChanged: (value) {
                          context
                              .read<SignUpBloc>()
                              .add(SignUpValuesChangedEvent(email: value));
                        },
                        onSubmitted: (value) {
                          context.read<SignUpBloc>().add(
                              SignUpValuesChangedEvent(email: value.trim()));
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomEditText(
                        title: Constants.password,
                        isPasswordInput: true,
                        isShowMessage: state.isShowPasswordMessage,
                        textStyle: state.isShowPasswordMessage
                            ? AppTextStyles.montserratStyle.regular14BrinkPink
                            : AppTextStyles.montserratStyle.regular14Black,
                        borderColor: AppColors.brinkPink,
                        cursorColor: state.isShowPasswordMessage
                            ? AppColors.brinkPink
                            : AppColors.tiffanyBlue,
                        preMessage: state.messageInputPassword,
                        maxLength: 32,
                        onChanged: (value) {
                          context.read<SignUpBloc>().add(
                              SignUpValuesChangedEvent(password: value.trim()));
                        },
                        inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                      ),
                      const SizedBox(height: 10),
                      CustomEditText(
                        title: Constants.confirmPassword,
                        isPasswordInput: true,
                        textStyle: state.isShowConfirmPasswordMessage
                            ? AppTextStyles.montserratStyle.regular14BrinkPink
                            : AppTextStyles.montserratStyle.regular14Black,
                        isShowMessage: state.isShowConfirmPasswordMessage,
                        borderColor: AppColors.brinkPink,
                        cursorColor: state.isShowConfirmPasswordMessage
                            ? AppColors.brinkPink
                            : AppColors.tiffanyBlue,
                        preMessage: state.messageInputConfirmPassword,
                        inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                        onChanged: (value) {
                          context.read<SignUpBloc>().add(
                              SignUpValuesChangedEvent(
                                  confirmPassword: value.trim()));
                        },
                        maxLength: 32,
                      ),
                      const SizedBox(height: 10),
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
                        textStyle: state.isShowReferralCodeMessage
                            ? AppTextStyles.montserratStyle.regular14BrinkPink
                            : AppTextStyles.montserratStyle.regular14Black,
                        borderColor: AppColors.brinkPink,
                        cursorColor: state.isShowReferralCodeMessage
                            ? AppColors.brinkPink
                            : AppColors.tiffanyBlue,
                        isShowMessage: state.isShowReferralCodeMessage,
                        preMessage: state.messageInputReferralCode,
                        maxLength: 8,
                        onChanged: (value) {
                          context.read<SignUpBloc>().add(
                              SignUpValuesChangedEvent(
                                  referralCode: value.trim()));
                        },
                      ),
                      const SizedBox(height: 17),
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
                            const TextSpan(text: Constants.and),
                            TextSpan(
                              text: Constants.privacyNotice,
                              style: AppTextStyles
                                  .montserratStyle.regular14tiffanyBlue,
                            ),
                            const TextSpan(text: '.'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 23),
                      CustomButton(
                        title: Constants.signUp,
                        titleStyle: AppTextStyles.montserratStyle.bold16White,
                        borderColor: state.isEnableSignUp
                            ? AppColors.tiffanyBlue
                            : AppColors.spanishGray,
                        backgroundColor: state.isEnableSignUp
                            ? AppColors.tiffanyBlue
                            : AppColors.spanishGray,
                        onTap: state.isEnableSignUp
                            ? () {
                                FocusScope.of(context).unfocus();
                                context
                                    .read<SignUpBloc>()
                                    .add(SignUpWithEmailSubmitEvent());
                              }
                            : null,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    ));
  }

  @override
  bool get wantKeepAlive => true;
}
