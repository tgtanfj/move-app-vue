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
  final VoidCallback? onChannelTap;

  const CustomSearchChannel({
    super.key,
    this.imageUrl,
    this.name,
    this.numberOfFollowers,
    this.isBlueBadge = false,
    this.onChannelTap,
  });

  @override
  State<CustomSearchChannel> createState() => _CustomSearchChannelState();
}

class _CustomSearchChannelState extends State<CustomSearchChannel> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onChannelTap,
      child: Row(
        children: [
          Avatar(
            imageUrl: widget.imageUrl ?? "",
            widthAvatar: 72,
            heightAvatar: 72,
            radiusAvatar: 50,
          ),
          const SizedBox(
            width: 22,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.name ?? "",
                        style: AppTextStyles.montserratStyle.regular16Black,
                        softWrap: true,
                      ),
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
                  ],
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: widget.numberOfFollowers ?? '',
                        style: AppTextStyles.montserratStyle.regular12Black,
                      ),
                      TextSpan(
                        text: " ${Constants.followers}",
                        style: AppTextStyles.montserratStyle.regular12Black,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
