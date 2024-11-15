import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/custom_button.dart';
import 'package:move_app/presentation/components/custom_edit_text.dart';
import 'package:move_app/presentation/screens/auth/otp/bloc/otp_verification_bloc.dart';
import 'package:move_app/presentation/screens/auth/otp/bloc/otp_verification_event.dart';
import 'package:move_app/presentation/screens/auth/otp/bloc/otp_verification_state.dart';
import 'package:move_app/presentation/screens/home/page/home_page.dart';
import '../../../../../config/theme/app_colors.dart';
import '../../../../../config/theme/app_icons.dart';
import '../widgets/title_verification_code.dart';

class OtpVerificationBody extends StatefulWidget {
  const OtpVerificationBody({super.key});

  @override
  State<OtpVerificationBody> createState() => _OtpVerificationBodyState();
}

class _OtpVerificationBodyState extends State<OtpVerificationBody> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OtpVerificationBloc, OtpVerificationState>(
      listener: (context, state) {
        state.status == OtpVerificationStatus.loading
            ? EasyLoading.show()
            : EasyLoading.dismiss();
        if (state.status == OtpVerificationStatus.success) {
          Navigator.of(context).pop();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (Route<dynamic> route) => false,
          );
          Fluttertoast.showToast(msg: Constants.signUpSuccessful);
        }
      },
      builder: (context, state) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Text(
                      Constants.verifyEmail,
                      style: AppTextStyles.montserratStyle.bold16Black,
                    )),
                    const SizedBox(
                      width: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset(
                        AppIcons.close.svgAssetPath,
                        height: 16,
                        width: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    text: Constants.sendCode,
                    style: AppTextStyles.montserratStyle.regular14Black,
                    children: [
                      TextSpan(
                        text: " ${state.userModel?.email}.",
                        style: AppTextStyles.montserratStyle.bold14Black,
                      ),
                      TextSpan(
                        text: " ${Constants.enterCode}",
                        style: AppTextStyles.montserratStyle.regular14Black,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 34,
                ),
                TitleVerificationCode(
                  title: "${Constants.verificationCode} ",
                  titleStyle: AppTextStyles.montserratStyle.regular14Black,
                  subTitle: state.remainingSeconds > 0
                      ? "${state.remainingSeconds}s"
                      : "${Constants.resendCode} ",
                  onTapSubTitle: state.remainingSeconds == 0
                      ? () {
                          context
                              .read<OtpVerificationBloc>()
                              .add(OtpVerificationResendEvent());
                        }
                      : null,
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomEditText(
                  initialValue: state.inputOtpCode,
                  maxLength: 6,
                  textInputType: TextInputType.number,
                  isShowMessage: state.isShowMessageOtp,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  preMessage: state.messageOtp,
                  textStyle: state.isShowMessageOtp
                      ? AppTextStyles.montserratStyle.regular14BrinkPink
                      : AppTextStyles.montserratStyle.regular14Black,
                  borderColor: AppColors.brinkPink,
                  cursorColor: state.isShowMessageOtp
                      ? AppColors.brinkPink
                      : AppColors.tiffanyBlue,
                  onChanged: (value) {
                    context
                        .read<OtpVerificationBloc>()
                        .add(OtpVerificationCodeChangedEvent(value));
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                CustomButton(
                  title: Constants.submit,
                  titleStyle: AppTextStyles.montserratStyle.bold16White,
                  borderColor: state.isEnabledSubmit
                      ? AppColors.tiffanyBlue
                      : AppColors.spanishGray,
                  backgroundColor: state.isEnabledSubmit
                      ? AppColors.tiffanyBlue
                      : AppColors.spanishGray,
                  onTap: state.isEnabledSubmit
                      ? () {
                          FocusScope.of(context).unfocus();
                          context
                              .read<OtpVerificationBloc>()
                              .add(OtpVerificationSubmitEvent());
                        }
                      : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
