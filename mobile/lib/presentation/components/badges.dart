import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_icons.dart';

class Badges extends StatelessWidget {
  const Badges({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        const SizedBox(
          width: 3.0,
        ),
        SvgPicture.asset(AppIcons.blueStick.svgAssetPath),
        const SizedBox(
          width: 3.0,
        ),
        SvgPicture.asset(AppIcons.starFlower.svgAssetPath),
      ],
    );
  }
}
