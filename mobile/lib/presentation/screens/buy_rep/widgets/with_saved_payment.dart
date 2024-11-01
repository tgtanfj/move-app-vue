import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/models/card_model.dart';
import 'package:move_app/presentation/screens/wallet/page/wallet_body.dart';

class WithSavedPayment extends StatelessWidget {
  final CardModel? card;

  const WithSavedPayment({super.key, this.card});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            masterCard(),
            Text.rich(TextSpan(
                text: '${card?.brand} ${Constants.endingWith} ',
                style: AppTextStyles.montserratStyle.regular16Black,
                children: [
                  TextSpan(
                    text: '${card?.last4}',
                    style: AppTextStyles.montserratStyle.bold16black,
                  )
                ]))
          ],
        ),
        InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const WalletBody()));
            },
            child: Text(
              Constants.change,
              style: AppTextStyles.montserratStyle.regular16tiffanyBlue,
            ))
      ],
    );
  }

  Widget masterCard() {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
          height: 25,
          width: 34,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.chineseSilver,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: SvgPicture.asset(
            AppIcons.masterCard.svgAssetPath,
          )),
    );
  }
}
