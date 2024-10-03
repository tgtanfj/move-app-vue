import 'package:flutter/material.dart';
import 'package:move_app/constants/constants.dart';

import '../../../../../components/custom_radio_item.dart';

enum Gender {
  male,
  female,
  ratherNotSay,
}

class GenderRadioGroup extends StatelessWidget {
  final Gender? selectedGender;
  final ValueChanged<Gender> onChanged;

  const GenderRadioGroup({
    super.key,
    this.selectedGender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomRadioItem(
                value: Gender.male,
                groupValue: selectedGender,
                title: Constants.male,
                onChanged: (value) {
                  onChanged(value);
                },
              ),
            ),
            Expanded(
              child: CustomRadioItem(
                value: Gender.female,
                groupValue: selectedGender,
                title: Constants.female,
                onChanged: (value) {
                  onChanged(value);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        CustomRadioItem(
          value: Gender.ratherNotSay,
          groupValue: selectedGender,
          title: Constants.ratherNotSay,
          onChanged: (value) {
            onChanged(value);
          },
        ),
      ],
    );
  }
}
