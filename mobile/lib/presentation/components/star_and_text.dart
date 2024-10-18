import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_icons.dart';

class StarAndText extends StatelessWidget {
  final TextStyle textStyle;
  final double ratings;
  const StarAndText(
      {super.key, required this.textStyle, required this.ratings});

  @override
  Widget build(BuildContext context) {
    return ratings >= 1
        ? Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SvgPicture.asset(AppIcons.star.svgAssetPath),
              const SizedBox(
                width: 7.0,
              ),
              Text(
                ratings.toString(),
                style: textStyle,
              ),
            ],
          )
        : const SizedBox();
  }
}
