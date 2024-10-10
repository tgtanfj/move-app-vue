  import 'package:flutter/material.dart';
  import 'package:move_app/data/models/channel_model.dart';
  import 'package:move_app/data/models/video_model.dart';
  import 'package:move_app/presentation/components/video_poster.dart';

  import '../../home/widgets/video_feature_description.dart';

  class ListSearchResultVideo extends StatelessWidget {
    final List<VideoModel>? videoList;
    final List<ChannelModel>? channelList;
    final Function? onTap;

    const ListSearchResultVideo({
      super.key,
      required this.videoList,
      required this.channelList,
      this.onTap,
    });

    @override
    Widget build(BuildContext context) {
      return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: videoList?.length??0,
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              width: MediaQuery.of(context).size.width - 40.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                      onTap: () {},
                      child: VideoPoster(
                        height: MediaQuery.of(context).size.height * 0.21,
                        isLargePoster: true,
                        image: videoList?[index].urlS3,
                        numberOfViews: videoList?[index].numberOfViews,
                      )),
                  const SizedBox(
                    height: 4.0,
                  ),
                  VideoFeatureDescription(
                    onTap: () => onTap,
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
