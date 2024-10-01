import 'package:flutter/material.dart';
import 'package:move_app/presentation/components/video_poster.dart';
import 'package:move_app/presentation/screens/home/widgets/video_may_u_like_description.dart';

class ListVideosMayULike extends StatefulWidget {
  const ListVideosMayULike({super.key});

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
                  child: GestureDetector(
                    onTap: () {},
                    child: const VideoPoster(),
                  ),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                const Expanded(child: VideoMayULikeDescription()),
              ],
            ),
        separatorBuilder: (context, index) => const SizedBox(
              height: 20.0,
            ),
        itemCount: 8);
  }
}
