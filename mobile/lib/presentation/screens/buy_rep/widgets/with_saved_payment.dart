import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/models/card_model.dart';
import 'package:move_app/data/models/rep_model.dart';
import 'package:move_app/data/models/wallet_argument_model.dart';
import 'package:move_app/presentation/screens/buy_rep/widgets/card_item.dart';
import 'package:move_app/presentation/screens/wallet/page/wallet_page.dart';
import 'package:move_app/utils/card_number_formatter.dart';

class WithSavedPayment extends StatelessWidget {
  final RepModel? rep;
  final CardModel? card;

  const WithSavedPayment({super.key, this.card, this.rep});

  @override
  Widget build(BuildContext context) {
    CardType cardType =
        CardType.values.firstWhere((e) => e.name == card?.brand);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CardItem(cardType: cardType),
            const SizedBox(width: 8),
            Text.rich(TextSpan(
                text:
                    '${CardNumberValidator.getCardName(cardType)} ${Constants.endingWith} ',
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WalletPage(
                          walletArguments:
                              WalletArguments(rep: rep, isTrue: false))));
            },
            child: Text(
              Constants.change,
              style: AppTextStyles.montserratStyle.regular16tiffanyBlue,
            ))
      ],
    );
  }
}
