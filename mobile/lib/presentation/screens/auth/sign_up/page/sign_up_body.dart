import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/custom_edit_text.dart';
import 'package:move_app/presentation/screens/auth/sign_up/bloc/sign_up_bloc.dart';
import 'package:move_app/presentation/screens/auth/sign_up/bloc/sign_up_state.dart';

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
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomEditText(
                        title: Constants.email,
                        initialValue: state.inputEmail,
                        isShowMessage: state.isShowEmailMessage,
                        textStyle: state.isShowEmailMessage
                            ? AppTextStyles.montserratStyle.regular14BrinkPink
                            : AppTextStyles.montserratStyle.regular14Black,
                        borderColor: AppColors.brinkPink,
                        cursorColor: state.isShowEmailMessage
                            ? AppColors.brinkPink
                            : AppColors.tiffanyBlue,
                        preMessage: state.messageInputEmail,
                        maxLength: 255,
                        onChanged: (email) {
                          context
                              .read<SignUpBloc>()
                              .add(SignUpValuesChangedEvent(email: email));
                        },
                        onLostFocus: (email) {
                          context.read<SignUpBloc>().add(
                              SignUpValuesChangedEvent(email: email.trim()));
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomEditText(
                        title: Constants.password,
                        initialValue: state.inputPassword,
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
                          context
                              .read<SignUpBloc>()
                              .add(SignUpValuesChangedEvent(password: value));
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s'))
                        ],
                      ),
                      const SizedBox(height: 10),
                      CustomEditText(
                        title: Constants.confirmPassword,
                        initialValue: state.inputConfirmPassword,
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
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s'))
                        ],
                        onChanged: (value) {
                          context.read<SignUpBloc>().add(
                              SignUpValuesChangedEvent(confirmPassword: value));
                        },
                        maxLength: 32,
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
                  )
                ],
              ),
            ),
          ),
        );
      },
    ));
  }

  @override
  bool get wantKeepAlive => true;
}
