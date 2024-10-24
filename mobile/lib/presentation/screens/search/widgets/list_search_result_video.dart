import 'package:flutter/material.dart';
import 'package:move_app/data/models/channel_model.dart';
import 'package:move_app/data/models/video_model.dart';
import 'package:move_app/presentation/components/video_poster.dart';
import 'package:move_app/utils/util_number_format.dart';

import '../../home/widgets/video_feature_description.dart';

class ListSearchResultVideo extends StatelessWidget {
  final List<VideoModel>? videoList;
  final List<ChannelModel>? channelList;
  final Function? onTap;
  final VoidCallback? tapToVideoDetail;

  const ListSearchResultVideo({
    super.key,
    required this.videoList,
    required this.channelList,
    this.tapToVideoDetail,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: videoList?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
          width: MediaQuery.of(context).size.width - 40.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VideoPoster(
                onTap: tapToVideoDetail,
                duration:
                    videoList?[index].durationsVideo?.toDurationFormat() ??
                        '00:00',
                height: MediaQuery.of(context).size.height * 0.21,
                isViewText: true,
                image: videoList?[index].urlS3,
                numberOfViews: videoList?[index].numberOfViews.toString(),
              ),
              const SizedBox(
                height: 4.0,
              ),
              VideoFeatureDescription(
                onTapToVideoDetail: () => onTap,
                videoModel: videoList?[index],
                channelModel: videoList?[index].channel,
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        height: 20.0,
      ),
    );
  }
}
