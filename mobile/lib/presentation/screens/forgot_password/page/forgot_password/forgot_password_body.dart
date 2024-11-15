import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/custom_button.dart';
import 'package:move_app/presentation/components/custom_edit_text.dart';
import 'package:move_app/presentation/screens/auth/widgets/dialog_authentication.dart';
import 'package:move_app/presentation/screens/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:move_app/presentation/screens/forgot_password/bloc/forgot_password_event.dart';
import 'package:move_app/presentation/screens/forgot_password/bloc/forgot_password_state.dart';

class ForgotPasswordBody extends StatefulWidget {
  const ForgotPasswordBody({super.key});

  @override
  State<ForgotPasswordBody> createState() => _ForgotPasswordBodyState();
}

class _ForgotPasswordBodyState extends State<ForgotPasswordBody> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
          builder: (context, state) {
        double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        double screenWidth = MediaQuery.of(context).size.width - 40;
        final bool hasError = state.errorMessage.isNotEmpty;
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Material(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.only(bottom: keyboardHeight),
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Constants.resetPassword,
                          style: AppTextStyles.montserratStyle.bold16Black,
                        ),
                        const SizedBox(height: 16),
                        CustomEditText(
                          key: Key(state.errorMessage),
                          title: Constants.enterEmailAddress,
                          titleStyle:
                              AppTextStyles.montserratStyle.regular14Black,
                          isPasswordInput: false,
                          initialValue: state.email,
                          onChanged: (email) {
                            context
                                .read<ForgotPasswordBloc>()
                                .add(ForgotPasswordEmailChangedEvent(email));
                          },
                          onLostFocus:  (email) {
                            context
                                .read<ForgotPasswordBloc>()
                                .add(ForgotPasswordEmailChangedEvent(email.trim()));
                          },
                          preMessage: hasError
                              ? state.isEmailValid
                                  ? Constants.theEmail
                                  : Constants.invalidEmail
                              : Constants.weSentAnEmailTo,
                          mainMessage: state.isEmailSent
                              ? state.email
                              : state.isEmailValid
                                  ? state.email
                                  : "",
                          sufMessage: hasError
                              ? state.isEmailValid
                                  ? Constants.isNotFound
                                  : ""
                              : Constants.clickTheLinkToReset,
                          isShowMessage: state.isShowEmailMessage,
                          backgroundColorMessage: hasError
                              ? AppColors.lavenderBlush
                              : AppColors.bubbles,
                          borderColor: hasError
                              ? AppColors.brinkPink
                              : AppColors.tiffanyBlue,
                          cursorColor: hasError
                              ? AppColors.brinkPink
                              : AppColors.tiffanyBlue,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          child: CustomButton(
                            borderColor: state.email.isNotEmpty
                                ? (state.isEmailSent &&
                                        state.remainingSeconds > 0
                                    ? AppColors.spanishGray
                                    : AppColors.tiffanyBlue)
                                : AppColors.spanishGray,
                            isEnabled: state.email.isNotEmpty &&
                                (state.isEmailSent
                                    ? state.remainingSeconds == 0
                                    : true),
                            onTap: state.email.isNotEmpty &&
                                    (state.isEmailSent
                                        ? state.remainingSeconds == 0
                                        : !state.isEmailSent)
                                ? () {
                                    FocusScope.of(context).unfocus();
                                    context.read<ForgotPasswordBloc>().add(
                                        ForgotPasswordSubmittedEvent(
                                            state.email));
                                  }
                                : null,
                            title: state.isEmailSent
                                ? (state.remainingSeconds > 0
                                    ? '${Constants.resendTheLink} (${state.remainingSeconds}s)'
                                    : Constants.resendTheLink)
                                : Constants.sendPasswordResetEmail,
                            titleStyle: state.email.isNotEmpty
                                ? (state.isEmailSent &&
                                        state.remainingSeconds > 0
                                    ? AppTextStyles
                                        .montserratStyle.bold16chineseSilverGray
                                    : AppTextStyles.montserratStyle.bold16White)
                                : AppTextStyles
                                    .montserratStyle.bold16chineseSilverGray,
                            backgroundColor: state.email.isNotEmpty
                                ? (state.isEmailSent
                                    ? (state.remainingSeconds > 0
                                        ? AppColors.spanishGray
                                        : AppColors.tiffanyBlue)
                                    : AppColors.tiffanyBlue)
                                : AppColors.spanishGray,
                            maxLines: 1,
                            textOverflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ),
                        const SizedBox(height: 10),
                        CustomButton(
                          title: Constants.backToLoginPage,
                          titleStyle: AppTextStyles
                              .montserratStyle.regular14TiffanyBlue,
                          borderColor: AppColors.white,
                          onTap: () {
                            Navigator.of(context).pop();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const DialogAuthentication();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
