import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/presentation/components/avatar.dart';

class CustomSearchChannel extends StatefulWidget {
  const CustomSearchChannel({super.key});

  @override
  State<CustomSearchChannel> createState() => _CustomSearchChannelState();
}

class _CustomSearchChannelState extends State<CustomSearchChannel> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Avatar(
            imageUrl:
                "https://i.pinimg.com/736x/0d/64/98/0d64989794b1a4c9d89bff571d3d5842.jpg",
            widthAvatar: 72,
            heightAvatar: 72,
            radiusAvatar: 50),
        const SizedBox(
          width: 22,
        ),
        Column(
          children: [
            Text(
              "Jensen94",
              style: AppTextStyles.montserratStyle.regular16Black,
            ),
            Text(
              "810 followers",
              style: AppTextStyles.montserratStyle.regular12Black,
            ),
          ],
        ),
        const SizedBox(
          width: 8,
        ),
        SvgPicture.asset(AppIcons.blueStick.svgAssetPath),
      ],
    );
  }
}
