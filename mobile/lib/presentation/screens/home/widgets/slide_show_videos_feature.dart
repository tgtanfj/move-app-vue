import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/data/models/video_model.dart';
import 'package:move_app/presentation/components/video_poster.dart';
import 'package:move_app/presentation/screens/home/widgets/video_feature_description.dart';
import 'package:move_app/presentation/screens/video_detail/page/video_detail_page.dart';
import 'package:move_app/utils/util_number_format.dart';

class SlideShowVideosFeature extends StatefulWidget {
  final List<VideoModel> listVideo;

  const SlideShowVideosFeature({super.key, required this.listVideo});

  @override
  State<SlideShowVideosFeature> createState() => _SlideShowVideosFeatureState();
}

class _SlideShowVideosFeatureState extends State<SlideShowVideosFeature> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return ImageSlideshow(
      initialPage: 0,
      autoPlayInterval: 3000,
      isLoop: true,
      onPageChanged: (value) {},
      indicatorColor: AppColors.black,
      indicatorBackgroundColor: AppColors.graniteGray,
      height: height * 0.45,
      children: List.generate(widget.listVideo.length, (index) {
        return SizedBox(
          width: MediaQuery.of(context).size.width - 40.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VideoPoster(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoDetailPage(
                      videoId: widget.listVideo[index].id ?? 0,
                    ),
                  ),
                ),
                height: height * 0.21,
                isViewText: true,
                image: widget.listVideo[index].thumbnailURL ?? '',
                numberOfViews: widget.listVideo[index].numberOfViews
                        ?.toCompactViewCount() ??
                    '',
                duration: widget.listVideo[index].durationsVideo
                        ?.toDurationFormat() ??
                    '',
              ),
              const SizedBox(
                height: 4.0,
              ),
              VideoFeatureDescription(
                channelModel: widget.listVideo[index].channel,
                videoModel: widget.listVideo[index],
                category: widget.listVideo[index].categories,
                onTapToVideoDetail: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoDetailPage(
                      videoId: widget.listVideo[index].id ?? 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
