import 'package:flutter/material.dart';
import 'package:move_app/data/models/video_model.dart';
import 'package:move_app/presentation/components/video_poster.dart';
import 'package:move_app/presentation/screens/home/widgets/video_may_u_like_description.dart';
import 'package:move_app/presentation/screens/video_detail/page/video_detail_page.dart';
import 'package:move_app/presentation/screens/view_channel_profile/page/view_channel_profile_page.dart';
import 'package:move_app/utils/string_extentions.dart';
import 'package:move_app/utils/util_date_time.dart';
import 'package:move_app/utils/util_number_format.dart';

class ListVideosMayULike extends StatefulWidget {
  final List<VideoModel> listMayULikeVideo;
  const ListVideosMayULike({super.key, required this.listMayULikeVideo});

  @override
  State<ListVideosMayULike> createState() => _ListVideosMayULikeState();
}

class _ListVideosMayULikeState extends State<ListVideosMayULike> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 20.0),
        itemBuilder: (context, index) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: VideoPoster(
                    isDurationText: true,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoDetailPage(
                          videoId: widget.listMayULikeVideo[index].id ?? 0,
                        ),
                      ),
                    ),
                    image: widget.listMayULikeVideo[index].thumbnailURL ?? '',
                    numberOfViews: widget.listMayULikeVideo[index].numberOfViews
                            ?.toCompactViewCount() ??
                        '0',
                    duration: widget.listMayULikeVideo[index].durationsVideo
                            ?.toDurationFormat() ??
                        '',
                  ),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Expanded(
                  child: VideoMayULikeDescription(
                    onTapToVideoDetail: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoDetailPage(
                          videoId: widget.listMayULikeVideo[index].id ?? 0,
                        ),
                      ),
                    ),
                    onTapToProfile: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewChannelProfilePage(
                          idChannel:
                              widget.listMayULikeVideo[index].channel?.id ?? 0,
                        ),
                      ),
                    ),
                    avatarUrl:
                        widget.listMayULikeVideo[index].channel?.image ?? '',
                    channelName:
                        widget.listMayULikeVideo[index].channel?.name ?? '',
                    title: widget.listMayULikeVideo[index].title ?? '',
                    workoutLevel: widget.listMayULikeVideo[index].workoutLevel
                            .capitalizeFirstLetter() ??
                        '',
                    createTime:
                        widget.listMayULikeVideo[index].createdAt?.timeAgo() ??
                            '',
                    isBlueBadge:
                        widget.listMayULikeVideo[index].channel?.isBlueBadge ??
                            false,
                    isPinkBadge:
                        widget.listMayULikeVideo[index].channel?.isPinkBadge ??
                            false,
                    duration:
                        widget.listMayULikeVideo[index].duration?.shorten() ??
                            '',
                    ratings: widget.listMayULikeVideo[index].ratings ?? 0,
                  ),
                ),
              ],
            ),
        separatorBuilder: (context, index) => const SizedBox(
              height: 20.0,
            ),
        itemCount: widget.listMayULikeVideo.length);
  }
}
