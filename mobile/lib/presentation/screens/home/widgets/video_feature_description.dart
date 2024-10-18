import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/data/models/category_model.dart';
import 'package:move_app/data/models/channel_model.dart';
import 'package:move_app/data/models/video_model.dart';
import 'package:move_app/presentation/components/avatar.dart';
import 'package:move_app/presentation/components/badges.dart';
import 'package:move_app/presentation/components/star_and_text.dart';
import 'package:move_app/presentation/components/type_label.dart';
import 'package:move_app/presentation/screens/view_channel_profile/page/view_channel_profile_page.dart';
import 'package:move_app/utils/string_extentions.dart';
import 'package:move_app/utils/util_date_time.dart';

class VideoFeatureDescription extends StatefulWidget {
  final ChannelModel? channelModel;
  final VideoModel? videoModel;
  final CategoryModel? category;
  final VoidCallback onTapToVideoDetail;
  const VideoFeatureDescription({
    super.key,
    this.channelModel,
    this.videoModel,
    this.category,
    required this.onTapToVideoDetail,
  });

  @override
  State<VideoFeatureDescription> createState() =>
      _VideoFeatureDescriptionState();
}

class _VideoFeatureDescriptionState extends State<VideoFeatureDescription> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewChannelProfilePage(
                    idChannel: widget.channelModel?.id ?? 0,
                  ),
                ),
              ),
              child: Avatar(
                heightAvatar: 40.0,
                widthAvatar: 40.0,
                radiusAvatar: 32.0,
                imageUrl: widget.channelModel?.image ?? "",
              ),
            ),
            const SizedBox(
              width: 13.0,
            ),
            Expanded(
              child: GestureDetector(
                onTap: widget.onTapToVideoDetail,
                child: Text(
                  widget.videoModel?.title ?? "",
                  style: AppTextStyles.montserratStyle.bold18black,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            StarAndText(
              ratings: widget.videoModel?.ratings ?? 0.0,
              textStyle: AppTextStyles.montserratStyle.bold16black,
            ),
            const SizedBox(
              width: 8.0,
            )
          ],
        ),
        GestureDetector(
          onTap: widget.onTapToVideoDetail,
          child: Row(
            children: [
              const SizedBox(
                width: 53.0,
              ),
              Flexible(
                child: Text(
                  widget.channelModel?.name ?? "",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: AppTextStyles.montserratStyle.regular14graniteGray,
                ),
              ),
              Badges(
                isBlueBadge: widget.channelModel?.isBlueBadge ?? false,
                isPinkBadge: widget.channelModel?.isPinkBadge ?? false,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: widget.onTapToVideoDetail,
          child: Row(
            children: [
              const SizedBox(
                width: 53.0,
              ),
              Text(
                (widget.videoModel?.createdAt != null)
                    ? '${widget.category?.title} • ${widget.videoModel?.createdAt?.timeAgo()}'
                    : widget.category?.title ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.montserratStyle.regular14graniteGray,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Row(
          children: [
            const SizedBox(
              width: 53.0,
            ),
            TypeLabel(
                typeLabel:
                    widget.videoModel?.workoutLevel?.capitalizeFirstLetter() ??
                        ""),
            const SizedBox(
              width: 9.0,
            ),
            TypeLabel(typeLabel: widget.videoModel?.duration ?? ""),
          ],
        )
      ],
    );
  }
}
