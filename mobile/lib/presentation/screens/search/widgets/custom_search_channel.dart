import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/avatar.dart';

class CustomSearchChannel extends StatefulWidget {
  final String? imageUrl;
  final String? name;
  final String? numberOfFollowers;
  final bool isBlueBadge;
  final bool isPinkBadge;
  final VoidCallback? onTap;

  const CustomSearchChannel({
    super.key,
    this.imageUrl,
    this.name,
    this.numberOfFollowers,
    this.isBlueBadge = false,
    this.isPinkBadge = false,
    this.onTap,
  });

  @override
  State<CustomSearchChannel> createState() => _CustomSearchChannelState();
}

class _CustomSearchChannelState extends State<CustomSearchChannel> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Row(
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
              Row(
                children: [
                  Text(
                    widget.name ?? "",
                    style: AppTextStyles.montserratStyle.regular16Black,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  widget.isBlueBadge
                      ? SvgPicture.asset(AppIcons.blueStick.svgAssetPath)
                      : const SizedBox(),
                  const SizedBox(
                    width: 8,
                  ),
                  widget.isPinkBadge
                      ? SvgPicture.asset(AppIcons.starFlower.svgAssetPath)
                      : const SizedBox(),
                ],
              ),
              Row(
                children: [
                  Text(
                    widget.numberOfFollowers ?? '',
                    style: AppTextStyles.montserratStyle.regular12Black,
                  ),
                  const Text(" "),
                  Text(Constants.followers, style: AppTextStyles.montserratStyle.regular12Black,)
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
