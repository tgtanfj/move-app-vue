import 'package:flutter/cupertino.dart';

import '../../../components/video_poster.dart';
import '../../home/widgets/video_feature_description.dart';

class SearchResultVideo extends StatelessWidget {
  final int id;
  final String avatarUrl;
  final String posterUrl;
  final String viewCount;
  final String duration;
  final bool isBlueBage;
  final bool isPinkBadge;

  const SearchResultVideo({
    super.key,
    required this.id,
    required this.avatarUrl,
    required this.posterUrl,
    required this.viewCount,
    required this.duration,
    required this.isBlueBage,
    required this.isPinkBadge,
  });

  @override
  Widget build(BuildContext context) {
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
                videoId: id,
                posterUrl: posterUrl,
                viewCount: viewCount,
                duration: duration,
              )),
          const SizedBox(
            height: 4.0,
          ),
          const VideoFeatureDescription(),
        ],
      ),
    );
  }
}
