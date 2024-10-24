import 'package:flutter/material.dart';
import 'package:move_app/data/models/channel_model.dart';
import 'package:move_app/presentation/screens/search/widgets/custom_search_channel.dart';
import 'package:move_app/presentation/screens/view_channel_profile/page/view_channel_profile_page.dart';

class ListChannels extends StatelessWidget {
  final List<ChannelModel> channelList;

  const ListChannels({super.key, required this.channelList});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: (channelList.length < 8) ? channelList.length : 8,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
            child: CustomSearchChannel(
          onChannelTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewChannelProfilePage(
                    idChannel: channelList[index].id ?? 0),
              ),
            );
          },
              imageUrl: channelList[index].image,
              name: channelList[index].name,
              numberOfFollowers:
              channelList[index].numberOfFollowers.toString(),
              isBlueBadge: channelList[index].isBlueBadge,
              isPinkBadge: channelList[index].isPinkBadge,
        ));
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(width: 12.0);
      },
    );
  }
}
