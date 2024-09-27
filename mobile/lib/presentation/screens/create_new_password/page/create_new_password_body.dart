import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/custom_button.dart';
import 'package:move_app/presentation/components/custom_edit_text.dart';
import 'package:move_app/presentation/screens/create_new_password/bloc/create_new_password_bloc.dart';
import 'package:move_app/presentation/screens/create_new_password/bloc/create_new_password_event.dart';
import 'package:move_app/presentation/screens/create_new_password/bloc/create_new_password_state.dart';
import 'package:move_app/presentation/screens/forgot_password/page/password_reset_successful.dart';

class CreateNewPasswordBody extends StatefulWidget {
  const CreateNewPasswordBody({super.key});

  @override
  State<CreateNewPasswordBody> createState() => _CreateNewPasswordBodyState();
}

class _CreateNewPasswordBodyState extends State<CreateNewPasswordBody> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BlocBuilder<CreatePasswordBloc, CreateNewPasswordState>(
          builder: (context, state) {
        double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        double screenWidth = MediaQuery.of(context).size.width;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.transparent,
              child: Container(
                width: screenWidth * 0.9,
                margin: EdgeInsets.only(bottom: keyboardHeight),
                child: SingleChildScrollView(
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
                          style: AppTextStyles.montserratStyle.regular14Black,
                        ),
                        const SizedBox(height: 20),
                        CustomEditText(
                          title: Constants.newPassword,
                          controller: _passwordController,
                          isPasswordInput: true,
                          maxLength: 32,
                          borderColor: state.showValidationError &&
                                  (!state.isPasswordValid ||
                                      !state.doPasswordsMatch)
                              ? AppColors.brinkPink
                              : AppColors.chineseSilver,
                          onChanged: (value) {
                            context
                                .read<CreatePasswordBloc>()
                                .add(CreateNewPasswordChangedEvent(value));
                          },
                          isShowMessage: state.showValidationError &&
                              !state.isPasswordValid,
                          preMessage: Constants.errorMessageNewPassword,
                        ),
                        const SizedBox(height: 16),
                        CustomEditText(
                          title: Constants.confirmNewPassword,
                          controller: _confirmPasswordController,
                          maxLength: 32,
                          borderColor: state.showValidationError &&
                                  (!state.isPasswordValid ||
                                      !state.doPasswordsMatch)
                              ? AppColors.brinkPink
                              : AppColors.chineseSilver,
                          onChanged: (value) {
                            context
                                .read<CreatePasswordBloc>()
                                .add(CreateConfirmPasswordChangedEvent(value));
                          },
                          isPasswordInput: true,
                          isShowMessage: state.showValidationError &&
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
                                : AppTextStyles
                                    .montserratStyle.bold16chineseSilverGray,
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              context
                                  .read<CreatePasswordBloc>()
                                  .add(CreateNewPasswordSubmittedEvent());
                              if (state.isPasswordValid &&
                                  state.doPasswordsMatch) {
                                Navigator.of(context).pop();
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const PasswordResetSuccessful();
                                    });
                              }
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
        );
      }),
    );
  }
}
