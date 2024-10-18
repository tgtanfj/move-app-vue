import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_icons.dart';

class Badges extends StatelessWidget {
  final bool isBlueBadge;
  final bool isPinkBadge;

  const Badges(
      {super.key, required this.isBlueBadge, required this.isPinkBadge});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        const SizedBox(
          width: 3.0,
        ),
        isBlueBadge
            ? SvgPicture.asset(AppIcons.blueStick.svgAssetPath)
            : const SizedBox(),
        const SizedBox(
          width: 3.0,
        ),
        isPinkBadge
            ? SvgPicture.asset(AppIcons.starFlower.svgAssetPath)
            : const SizedBox(),
      ],
    );
  }
}
