import 'package:flutter/services.dart';

class CardDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String newTextFiltered = newValue.text.replaceAll(RegExp(r'\D'), '');
    int offset = 0;

    if (newTextFiltered.isNotEmpty) {
      int firstDigit = int.parse(newTextFiltered[0]);

      if (firstDigit == 0 && newTextFiltered.length > 1) {
        int secondDigit = int.parse(newTextFiltered[1]);
        if (secondDigit == 0) {
          return oldValue;
        }
      }

      if (newTextFiltered.length >= 2) {
        int month = int.parse(newTextFiltered.substring(0, 2));
        if (month > 12) {
          return oldValue;
        }
      }
    }

    final StringBuffer newTextBuffer = StringBuffer();

    for (int i = 0; i < newTextFiltered.length; i++) {
      if (i == 2) {
        newTextBuffer.write('/');
        offset++;
      }
      newTextBuffer.write(newTextFiltered[i]);
    }

    final int selectionIndexFromRight =
        (newValue.text.length - newValue.selection.end)
            .clamp(0, newTextBuffer.length);

    return TextEditingValue(
      text: newTextBuffer.toString(),
      selection: TextSelection.collapsed(
          offset: (newTextBuffer.length - selectionIndexFromRight + offset)
              .clamp(0, newTextBuffer.length)),
    );
  }
}
