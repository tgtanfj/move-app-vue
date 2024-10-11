import 'package:flutter/material.dart';
import 'package:move_app/data/models/following_channel_model.dart';
import 'package:move_app/presentation/screens/channel/presentation/about/widgets/following_item.dart';

class FollowingWidget extends StatelessWidget {
  final List<FollowingChannelModel> followingChannels;

  const FollowingWidget({super.key, required this.followingChannels});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: List.generate(followingChannels.length, (index) {
        return Center(
            child: FollowingItem(
          followingChannel: followingChannels[index],
        ));
      }),
    );
  }
}