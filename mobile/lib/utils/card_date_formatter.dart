import 'package:flutter/services.dart';

class CardDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (newText.length > 4) {
      return oldValue;
    }
    if (newText.length == 1 &&
        int.tryParse(newText) != null &&
        newText != '0' &&
        oldValue.text.isEmpty &&
        newText != '1') {
      newText = '0$newText';
    }
    if (newText.length >= 2) {
      int month = int.tryParse(newText.substring(0, 2)) ?? 0;
      if (month > 12) {
        newText = '01${newText.substring(2)}';
      }
    }
    StringBuffer newTextBuffer = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      if (i == 2) {
        newTextBuffer.write('/');
      }
      newTextBuffer.write(newText[i]);
    }

    int selectionIndex = newTextBuffer.length;
    return TextEditingValue(
      text: newTextBuffer.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
