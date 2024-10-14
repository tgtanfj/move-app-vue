import 'package:flutter/material.dart';
import 'package:move_app/presentation/screens/search/widgets/search_result_video.dart';

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
        itemBuilder: (context, index) => const SearchResultVideo(
              id: 2,
              avatarUrl: '',
              posterUrl: '',
              viewCount: '',
              duration: '',
              isBlueBage: false,
              isPinkBadge: true,
            ),
        separatorBuilder: (context, index) => const SizedBox(
              height: 20.0,
            ),
        itemCount: 8);
  }
}
