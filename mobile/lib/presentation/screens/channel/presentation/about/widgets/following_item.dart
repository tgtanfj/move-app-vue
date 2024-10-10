import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';

import '../../../../../../config/theme/app_icons.dart';
import '../../../../../../config/theme/app_images.dart';
import '../../../../../../data/models/following_channel_model.dart';

class FollowingItem extends StatelessWidget {
  final FollowingChannelModel followingChannel;

  const FollowingItem({super.key, required this.followingChannel});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipOval(
          child: Image.network(
            followingChannel.image ?? '',
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                AppImages.defaultAvatar.webpAssetPath,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(followingChannel.name ?? '',
                style: AppTextStyles.montserratStyle.regular20Black),
            const SizedBox(width: 7),
            followingChannel.isBlueBadge ?? false
                ? SvgPicture.asset(
                    AppIcons.blueCheckCircle.svgAssetPath,
                    width: 16,
                    height: 16,
                  )
                : const SizedBox(),
            const SizedBox(width: 7),
            followingChannel.isPinkBadge ?? false
                ? SvgPicture.asset(
                    AppIcons.starFlower.svgAssetPath,
                    width: 16,
                    height: 16,
                  )
                : const SizedBox(),
          ],
        ),
        const SizedBox(height: 15),
        Text(
          '${followingChannel.numberOfFollowers ?? 0} ${Constants.followers}',
          style: AppTextStyles.montserratStyle.regular13GraniteGray,
        )
      ],
    );
  }
}
