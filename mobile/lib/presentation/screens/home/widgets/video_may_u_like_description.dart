import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/avatar.dart';
import 'package:move_app/presentation/components/badges.dart';
import 'package:move_app/presentation/components/star_and_text.dart';
import 'package:move_app/presentation/components/type_label.dart';

class VideoMayULikeDescription extends StatelessWidget {
  final String avatarUrl;
  final String channelName;
  final String title;
  final String workoutLevel;
  final String createTime;
  final bool isBlueBadge;
  final bool isPinkBadge;
  final double ratings;
  final String duration;
  final VoidCallback onTapToVideoDetail;
  final VoidCallback onTapToProfile;
  const VideoMayULikeDescription({
    super.key,
    required this.avatarUrl,
    required this.channelName,
    required this.title,
    required this.workoutLevel,
    required this.createTime,
    required this.isBlueBadge,
    required this.isPinkBadge,
    required this.ratings,
    required this.duration,
    required this.onTapToVideoDetail,
    required this.onTapToProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40.0,
          child: Row(
            children: [
              GestureDetector(
                onTap: onTapToProfile,
                child: Avatar(
                    heightAvatar: 31.0,
                    widthAvatar: 31.0,
                    radiusAvatar: 27.0,
                    imageUrl: avatarUrl),
              ),
              Flexible(
                child: GestureDetector(
                  onTap: onTapToVideoDetail,
                  child: Text(
                    channelName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: AppTextStyles.montserratStyle.regular14graniteGray,
                  ),
                ),
              ),
              const SizedBox(
                width: 5.0,
              ),
              Badges(
                isBlueBadge: isBlueBadge,
                isPinkBadge: isPinkBadge,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 4.0,
        ),
        Row(
          children: [
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.montserratStyle.regular14graniteGray,
              ),
            ),
            const SizedBox(
              width: 5.0,
            ),
            StarAndText(
              ratings: ratings,
              textStyle: AppTextStyles.montserratStyle.bold14Black,
            ),
          ],
        ),
        const SizedBox(
          height: 4.0,
        ),
        GestureDetector(
          onTap: onTapToVideoDetail,
          child: Row(children: [
            Expanded(
              child: Text(
                '$channelName • $createTime',
                style: AppTextStyles.montserratStyle.regular14graniteGray,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ]),
        ),
        const SizedBox(
          height: 4.0,
        ),
        Row(
          children: [
            TypeLabel(
              typeLabel: Constants.intermediate == workoutLevel
                  ? Constants.interm
                  : workoutLevel,
            ),
            const SizedBox(
              width: 3.0,
            ),
            TypeLabel(typeLabel: duration),
          ],
        )
      ],
    );
  }
}
