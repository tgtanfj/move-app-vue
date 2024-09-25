import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../constants/constants.dart';

class DividerAuthentication extends StatelessWidget {
  const DividerAuthentication({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
            child: Divider(
          height: 1,
          color: AppColors.sonicSilver,
        )),
        SizedBox(
          width: 12,
        ),
        Text(Constants.or),
        SizedBox(
          width: 12,
        ),
        Expanded(
            child: Divider(
          height: 1,
          color: AppColors.sonicSilver,
        )),
      ],
    );
  }
}
