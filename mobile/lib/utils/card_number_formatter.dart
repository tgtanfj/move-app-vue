import 'package:flutter/services.dart';
import 'package:move_app/config/theme/app_icons.dart';

enum CardType {
  visa,
  mastercard,
  unknown,
}

class CardNumberValidator {
  static var visaRegex = RegExp(r'^4[0-9]{0,15}$');
  static var mastercardRegex = RegExp(r'^5(?:[1-5][0-9]{0,14})?$');

  static CardType getCardType(String cardNumber) {
    if (cardNumber.isEmpty) return CardType.unknown;
    if (visaRegex.hasMatch(cardNumber)) {
      return CardType.visa;
    } else if (mastercardRegex.hasMatch(cardNumber)) {
      return CardType.mastercard;
    } else {
      return CardType.unknown;
    }
  }

  static String getCardIcon(CardType cardType) {
    switch (cardType) {
      case CardType.visa:
        return AppIcons.visaCard.svgAssetPath;
      case CardType.mastercard:
        return AppIcons.masterCard.svgAssetPath;
      case CardType.unknown:
      default:
        return '';
    }
  }

  static String getCardName(CardType cardType) {
    switch (cardType) {
      case CardType.visa:
        return 'Visa';
      case CardType.mastercard:
        return 'Master card';
      case CardType.unknown:
      default:
        return '';
    }
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}
