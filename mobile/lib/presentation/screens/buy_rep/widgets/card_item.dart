import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/utils/card_number_formatter.dart';

class CardItem extends StatelessWidget {
  final CardType cardType;

  const CardItem({super.key, required this.cardType});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: cardType == CardType.unknown
            ? const SizedBox()
            : SvgPicture.asset(CardNumberValidator.getCardIcon(cardType)));
  }
}
