import 'package:flutter/material.dart';
import 'package:move_app/data/models/channel_model.dart';
import 'package:move_app/data/models/thumbnails_model.dart';
import 'package:move_app/data/models/video_model.dart';
import 'package:move_app/presentation/components/video_poster.dart';
import 'package:move_app/presentation/screens/home/widgets/video_feature_description.dart';
import 'package:move_app/presentation/screens/video_detail/page/video_detail_page.dart';
import 'package:move_app/utils/util_number_format.dart';

class ListSearchResultVideo extends StatelessWidget {
  final List<VideoModel>? videoList;
  final List<ChannelModel>? channelList;

  const ListSearchResultVideo({
    super.key,
    this.videoList,
    this.channelList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: videoList?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoDetailPage(
                  videoId: videoList?[index].id ?? 0,
                ),
              ),
            );
          },
          child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width - 40.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VideoPoster(
                  duration:
                      videoList?[index].durationsVideo?.toDurationFormat() ??
                          '00:00',
                  height: MediaQuery.of(context).size.height * 0.21,
                  isViewText: true,
                  isDurationText: true,
                  image: videoList?[index].thumbnailsModel?.firstOrNull?.image,
                  numberOfViews: videoList?[index].numberOfViews?.toCompactViewCount(),
                ),
                const SizedBox(
                  height: 4.0,
                ),
                VideoFeatureDescription(
                  videoModel: videoList?[index],
                  channelModel: videoList?[index].channel,
                  category: videoList?[index].categories,
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        height: 20.0,
      ),
    );
  }
}
