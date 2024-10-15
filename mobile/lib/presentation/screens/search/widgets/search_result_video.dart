import 'package:flutter/cupertino.dart';

import '../../../components/video_poster.dart';
import '../../home/widgets/video_feature_description.dart';

class SearchResultVideo extends StatelessWidget {
  const SearchResultVideo({super.key});

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
              videoId: 0,
              posterUrl: '',
              viewCount: '',
              duration: '',
            ),
          ),
          const SizedBox(
            height: 4.0,
          ),
        ],
      ),
    );
  }
}
