import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/screens/auth/login/bloc/login_bloc.dart';
import 'package:move_app/presentation/screens/auth/login/bloc/login_state.dart';
import 'package:move_app/presentation/screens/auth/login/widgets/custom_button.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {},
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return Center(
              child: ElevatedButton(
                onPressed: () async {
                  await _showDialog(context);
                },
                child: const Text('Open Popup'),
              ),
            );
          },
        ));
  }

  Future _showDialog(BuildContext context) {
    bool isVisible = false;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return Dialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomButton(
                      onTap: () {},
                      borderRadius: 8.0,
                      prefix: SvgPicture.asset(
                          AppIcons.googleLogo.svgAssetPath),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 16),
                      title: AppConstants.loginWithGoogle,
                      titleStyle: AppTextStyles.montserratStyle.bold16Black,
                      backgroundColor: AppColors.white,
                    ),
                    const SizedBox(height: 12),
                    CustomButton(
                      onTap: () {},
                      borderRadius: 8.0,
                      prefix: SvgPicture.asset(
                          AppIcons.facebookLogo.svgAssetPath),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 16),
                      title: AppConstants.loginWithFacebook,
                      titleStyle: AppTextStyles.montserratStyle.bold16Black,
                      backgroundColor: AppColors.white,
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      children: [
                        Expanded(child: Divider(thickness: 1)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(AppConstants.or),
                        ),
                        Expanded(child: Divider(thickness: 1)),
                      ],
                    ),
                    isVisible
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppConstants.email,
                          style: AppTextStyles.montserratStyle.regular16Black,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: AppColors.gray),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: AppColors.tiffanyBlue, width: 1.0),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          AppConstants.password,
                          style: AppTextStyles.montserratStyle.regular16Black,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(Icons.visibility,
                              ),
                              onPressed: () {},
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: AppColors.gray),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: AppColors.tiffanyBlue, width: 1.0),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppConstants.forgotPassword,
                          style: AppTextStyles.montserratStyle
                              .regular14TiffanyBlue,
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                            title: AppConstants.login,
                            titleStyle: AppTextStyles.montserratStyle
                                .bold16White,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: AppColors.grey,
                            onTap: () {}
                        ),
                      ],
                    )
                        : TextButton(
                      onPressed: () {
                        setState(() {
                          isVisible = true;
                        });
                      },
                      child: Center(
                        child: Text(
                          AppConstants.loginWithEmail,
                          style: AppTextStyles.montserratStyle
                              .bold14TiffanyBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}