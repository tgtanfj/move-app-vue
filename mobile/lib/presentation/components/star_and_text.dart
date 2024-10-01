import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_icons.dart';


class StarAndText extends StatelessWidget {
  final TextStyle textStyle;
  const StarAndText({super.key, required this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        SvgPicture.asset(AppIcons.star.svgAssetPath),
        const SizedBox(
          width: 7.0,
        ),
        Text(
          '4.5',
          style: textStyle,
        ),
      ],
    );
  }
}
