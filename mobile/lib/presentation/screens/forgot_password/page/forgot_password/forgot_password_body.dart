import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/custom_button.dart';
import 'package:move_app/presentation/components/custom_edit_text.dart';
import 'package:move_app/presentation/screens/create_new_password/page/create_new_password_page.dart';
import 'package:move_app/presentation/screens/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:move_app/presentation/screens/forgot_password/bloc/forgot_password_event.dart';
import 'package:move_app/presentation/screens/forgot_password/bloc/forgot_password_state.dart';

class ForgotPasswordBody extends StatefulWidget {
  const ForgotPasswordBody({super.key});

  @override
  State<ForgotPasswordBody> createState() => _ForgotPasswordBodyState();
}

class _ForgotPasswordBodyState extends State<ForgotPasswordBody> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
          builder: (context, state) {
        double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        double screenWidth = MediaQuery.of(context).size.width - 40;
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.only(bottom: keyboardHeight),
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20.0),
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
                          title: Constants.enterEmailAddress,
                          controller: _emailController,
                          isPasswordInput: false,
                          onChanged: (email) {
                            context
                                .read<ForgotPasswordBloc>()
                                .add(ForgotPasswordEmailChanged(email));
                          },
                          preMessage: Constants.weSentAnEmailTo,
                          mainMessage: "janedoe@email.com",
                          sufMessage: Constants.clickTheLinkToReset,
                          isShowMessage: state.isEmailSent ? true : false,
                          backgroundColorMessage: AppColors.bubbles,
                          borderColor: AppColors.tiffanyBlue,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          child: CustomButton(
                            borderColor: state.isEmailValid
                                ? AppColors.tiffanyBlue
                                : AppColors.spanishGray,
                            isEnabled: state.isEmailValid,
                            onTap: state.isEmailValid
                                ? () {
                                    FocusScope.of(context).unfocus();
                                    context
                                        .read<ForgotPasswordBloc>()
                                        .add(ForgotPasswordSubmitted());
                                  }
                                : null,
                            title: state.isEmailSent
                                ? Constants.resendTheLink
                                : Constants.sendPasswordResetEmail,
                            titleStyle: state.isEmailValid
                                ? AppTextStyles.montserratStyle.bold16White
                                : AppTextStyles
                                    .montserratStyle.bold16chineseSilverGray,
                            backgroundColor: state.isEmailValid
                                ? AppColors.tiffanyBlue
                                : AppColors.spanishGray,
                            maxLines: 1,
                            textOverflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            title: Constants.backToLoginPage,
                            titleStyle: AppTextStyles
                                .montserratStyle.regular14TiffanyBlue,
                            borderColor: AppColors.white,
                            onTap: () {
                              Navigator.of(context).pop();
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const CreateNewPasswordPage();
                                  });
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
