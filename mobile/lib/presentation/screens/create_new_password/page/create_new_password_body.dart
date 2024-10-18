import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/repositories/forgot_password_repository.dart';
import 'package:move_app/presentation/components/app_bar_widget.dart';
import 'package:move_app/presentation/components/custom_button.dart';
import 'package:move_app/presentation/components/custom_edit_text.dart';
import 'package:move_app/presentation/screens/create_new_password/bloc/create_new_password_bloc.dart';
import 'package:move_app/presentation/screens/create_new_password/bloc/create_new_password_event.dart';
import 'package:move_app/presentation/screens/create_new_password/bloc/create_new_password_state.dart';
import 'package:move_app/presentation/screens/forgot_password/page/password_reset_successful.dart';
import 'package:move_app/presentation/screens/forgot_password/page/verification_failed.dart';

class CreateNewPasswordBody extends StatefulWidget {
  final String? token;
  final ForgotPasswordRepository forgotPasswordRepository;

  const CreateNewPasswordBody({
    super.key,
    this.token,
    required this.forgotPasswordRepository,
  });
  @override
  State<CreateNewPasswordBody> createState() => _CreateNewPasswordBodyState();
}

class _CreateNewPasswordBodyState extends State<CreateNewPasswordBody> {


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BlocConsumer<CreatePasswordBloc, CreateNewPasswordState>(
        listener: (context, state) {
          if (state.isPasswordResetSuccessful) {
            Navigator.of(context).pop();
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const PasswordResetSuccessful();
                });
          } else if (state.errorMessage.isNotEmpty) {
            Navigator.of(context).pop();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const VerificationFailed();
              },
            );
          }
        },
        builder: (context, state) {
          double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
          double screenWidth = MediaQuery.of(context).size.width - 40;
          return Scaffold(
            appBar: const AppBarWidget(
              isEnableIcon: false,
            ),
            backgroundColor: AppColors.white,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Material(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ]),
                      width: screenWidth,
                      margin: EdgeInsets.only(bottom: keyboardHeight),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Constants.createNewPassword,
                              style: AppTextStyles.montserratStyle.bold16Black,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              Constants.textInstruction,
                              style:
                                  AppTextStyles.montserratStyle.regular14Black,
                            ),
                            const SizedBox(height: 20),
                            CustomEditText(
                              initialValue: state.newPassword,
                              title: Constants.newPassword,
                              inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                              isPasswordInput: true,
                              maxLength: 32,
                              borderColor: state.isShowValidationError &&
                                      (!state.isPasswordValid ||
                                          !state.doPasswordsMatch)
                                  ? AppColors.brinkPink
                                  : AppColors.chineseSilver,
                              onChanged: (value) {
                                context
                                    .read<CreatePasswordBloc>()
                                    .add(CreateNewPasswordChangedEvent(value));
                              },
                              isShowMessage: state.isShowValidationError &&
                                  !state.isPasswordValid,
                              preMessage: Constants.errorMessageNewPassword,
                            ),
                            const SizedBox(height: 16),
                            CustomEditText(
                              initialValue: state.confirmNewPassword,
                              title: Constants.confirmNewPassword,
                              inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                              maxLength: 32,
                              borderColor: state.isShowValidationError &&
                                      (!state.isPasswordValid ||
                                          !state.doPasswordsMatch)
                                  ? AppColors.brinkPink
                                  : AppColors.chineseSilver,
                              onChanged: (value) {
                                context.read<CreatePasswordBloc>().add(
                                    CreateConfirmPasswordChangedEvent(value));
                              },
                              isPasswordInput: true,
                              isShowMessage: state.isShowValidationError &&
                                  (!state.isPasswordValid ||
                                      !state.doPasswordsMatch),
                              preMessage: Constants.errorMessageConfirmPassword,
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: CustomButton(
                                title: Constants.confirm,
                                isEnabled: state.newPassword.isNotEmpty &&
                                    state.confirmNewPassword.isNotEmpty,
                                borderColor: state.newPassword.isNotEmpty &&
                                        state.confirmNewPassword.isNotEmpty
                                    ? AppColors.tiffanyBlue
                                    : AppColors.chineseSilver,
                                backgroundColor: state.newPassword.isNotEmpty &&
                                        state.confirmNewPassword.isNotEmpty
                                    ? AppColors.tiffanyBlue
                                    : AppColors.spanishGray,
                                titleStyle: state.newPassword.isNotEmpty &&
                                        state.confirmNewPassword.isNotEmpty
                                    ? AppTextStyles.montserratStyle.bold16White
                                    : AppTextStyles.montserratStyle
                                        .bold16chineseSilverGray,
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  context
                                      .read<CreatePasswordBloc>()
                                      .add(CreateNewPasswordSubmittedEvent());
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
