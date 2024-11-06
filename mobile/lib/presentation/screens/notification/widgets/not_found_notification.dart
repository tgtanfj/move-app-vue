import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/app_bar_widget.dart';
import 'package:move_app/presentation/components/custom_button.dart';
import 'package:move_app/presentation/routes/app_routes.dart';

class NotFoundNotification extends StatefulWidget {
  const NotFoundNotification({super.key});

  @override
  State<NotFoundNotification> createState() => _NotFoundNotificationState();
}

class _NotFoundNotificationState extends State<NotFoundNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        prefixButton: () {
          Navigator.of(context).pop();
        },
      ),
      backgroundColor: AppColors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${Constants.notiNotFound}\n",
                style: AppTextStyles.montserratStyle.bold16Black,
              ),
              Text(
                Constants.notiNotFoundSuff,
                style: AppTextStyles.montserratStyle.regular14Black,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                title: Constants.goToHome,
                titleStyle: AppTextStyles.montserratStyle.bold14White,
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.home,
                    (route) => false,
                  );
                },
                width: 120,
                padding: const EdgeInsets.all(5),
                backgroundColor: AppColors.tiffanyBlue,
              )
            ],
          ),
        ),
      ),
    );
  }
}
