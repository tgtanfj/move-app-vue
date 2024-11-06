import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/models/rep_model.dart';
import 'package:move_app/presentation/components/custom_button.dart';

class RepItem extends StatelessWidget {
  final RepModel rep;
  final VoidCallback onSelectRep;

  const RepItem({
    super.key,
    required this.rep,
    required this.onSelectRep,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            flex: 7,
            child: Text(
              '${rep.numberOfREPs} ${Constants.rep}',
              style: AppTextStyles.montserratStyle.bold16black,
            ),
          ),
          Flexible(
            flex: 3,
            child: CustomButton(
              onTap: onSelectRep,
              padding: const EdgeInsets.symmetric(vertical: 10),
              title: '${Constants.us}${rep.price}',
              titleStyle: AppTextStyles.montserratStyle.bold16White,
              backgroundColor: AppColors.tiffanyBlue,
            ),
          ),
        ],
      ),
    );
  }
}
