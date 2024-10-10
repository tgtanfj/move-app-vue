import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/presentation/screens/home/widgets/video_feature_description.dart';
import 'package:move_app/presentation/components/video_poster.dart';


class SlideShowVideosFeature extends StatefulWidget {
  final List<String> listVideo;

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
      children: List.generate(5, (index) {
        return SizedBox(
          width: MediaQuery.of(context).size.width - 40.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VideoPoster(
                height: height * 0.21,
                isLargePoster: true,
              ),
              const SizedBox(
                height: 4.0,
              ),
              const VideoFeatureDescription(),
            ],
          ),
        );
      }),
    );
  }
}
