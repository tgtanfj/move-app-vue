import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';

class ProcessingPaymentDialog extends StatelessWidget {
  const ProcessingPaymentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 66, 16, 0),
        child: SizedBox(
          width: screenWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                AppIcons.creditCard.svgAssetPath,
                width: 42,
                height: 32,
              ),
              const SizedBox(height: 12),
              Text(
                Constants.processingPayment,
                style: AppTextStyles.montserratStyle.bold16TiffanyBlue,
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  Constants.cancel,
                  style: AppTextStyles.montserratStyle.regular16tiffanyBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
