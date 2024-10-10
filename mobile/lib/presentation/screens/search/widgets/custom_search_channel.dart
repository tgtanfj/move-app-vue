import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_images.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/presentation/components/avatar.dart';

class CustomSearchChannel extends StatefulWidget {
  final String? imageUrl;
  final String? name;
  final String? numberOfFollowers;
  final bool isBlueBadge;
  final bool isPinkBadge;

  const CustomSearchChannel({
    super.key,
    this.imageUrl,
    this.name,
    this.numberOfFollowers,
    this.isBlueBadge = false,
    this.isPinkBadge = false,
  });

  @override
  State<CustomSearchChannel> createState() => _CustomSearchChannelState();
}

class _CustomSearchChannelState extends State<CustomSearchChannel> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Avatar(
            imageUrl: widget.imageUrl ?? "",
            widthAvatar: 72,
            heightAvatar: 72,
            radiusAvatar: 50),
        const SizedBox(
          width: 22,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.name ?? "",
              style: AppTextStyles.montserratStyle.regular16Black,
            ),
            Text(
              widget.numberOfFollowers ?? '',
              style: AppTextStyles.montserratStyle.regular12Black,
            ),
          ],
        ),
        const SizedBox(
          width: 8,
        ),
        Column(
          children: [
            widget.isBlueBadge
                ? SvgPicture.asset(AppIcons.blueStick.svgAssetPath)
                : const SizedBox(),
            const SizedBox(height: 16,)
          ],
        )
      ],
    );
  }
}
