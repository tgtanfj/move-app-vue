import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_images.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/models/channel_model.dart';
import 'package:move_app/utils/util_number_format.dart';

class FollowingItem extends StatelessWidget {
  final ChannelModel followingChannel;
  final VoidCallback onTap;

  const FollowingItem({
    super.key,
    required this.followingChannel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
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
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 4,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: followingChannel.name ?? '',
                      style: AppTextStyles.montserratStyle.regular20Black,
                    ),
                    if (followingChannel.isBlueBadge)
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 7),
                          child: SvgPicture.asset(
                            AppIcons.blueCheckCircle.svgAssetPath,
                            width: 16,
                            height: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            '${followingChannel.numberOfFollowers?.toCompactViewCount() ?? 0} ${Constants.followers}',
            style: AppTextStyles.montserratStyle.regular13GraniteGray,
          )
        ],
      ),
    );
  }
}
