import 'package:flutter/material.dart';
import 'package:move_app/presentation/components/video_poster.dart';
import 'package:move_app/presentation/screens/home/widgets/video_may_u_like_description.dart';
import 'package:move_app/presentation/screens/search/widgets/search_result_video.dart';

import '../../home/widgets/video_feature_description.dart';

class ListSearchResultVideo extends StatefulWidget {
  const ListSearchResultVideo({super.key});

  @override
  State<ListSearchResultVideo> createState() => _ListSearchResultVideoState();
}

class _ListSearchResultVideoState extends State<ListSearchResultVideo> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => const SearchResultVideo(),
        separatorBuilder: (context, index) => const SizedBox(
              height: 20.0,
            ),
        itemCount: 8);
  }
}
