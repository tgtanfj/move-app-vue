import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/repositories/forgot_password_repository.dart';
import 'package:move_app/presentation/components/app_bar_widget.dart';
import 'package:move_app/presentation/components/custom_button.dart';
import 'package:move_app/presentation/screens/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:move_app/presentation/screens/forgot_password/bloc/forgot_password_state.dart';

class VerificationFailed extends StatefulWidget {
  const VerificationFailed({super.key});

  @override
  State<VerificationFailed> createState() => _VerificationFailedState();
}

class _VerificationFailedState extends State<VerificationFailed> {
  final ForgotPasswordRepository forgotPasswordRepository =
      ForgotPasswordRepository();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordBloc(forgotPasswordRepository),
      child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
          builder: (context, state) {
        // double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        double screenWidth = MediaQuery.of(context).size.width - 40;
        return Scaffold(
          appBar: const AppBarWidget(),
          backgroundColor: AppColors.white,
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Stack(
              children: [
                Center(
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    color: AppColors.transparent,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      width: screenWidth,
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Constants.verificationFailed,
                            style: AppTextStyles.montserratStyle.bold16Black,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            Constants.yourAccountVerificationHasExpired,
                            style: AppTextStyles.montserratStyle.regular14Black,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            child: CustomButton(
                              title: Constants.backToHome,
                              titleStyle:
                                  AppTextStyles.montserratStyle.bold16White,
                              backgroundColor: AppColors.tiffanyBlue,
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
