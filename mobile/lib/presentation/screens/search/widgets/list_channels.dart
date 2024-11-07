import 'package:flutter/material.dart';
import 'package:move_app/data/models/channel_model.dart';
import 'package:move_app/presentation/screens/search/widgets/custom_search_channel.dart';
import 'package:move_app/presentation/screens/view_channel_profile/page/view_channel_profile_page.dart';
import 'package:move_app/utils/util_number_format.dart';

class ListChannels extends StatelessWidget {
  final List<ChannelModel> channelList;

  const ListChannels({super.key, required this.channelList});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: channelList.length,
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
              channelList[index].numberOfFollowers?.toCompactViewCount(),
              isBlueBadge: channelList[index].isBlueBadge,
        ));
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(width: 12.0);
      },
    );
  }
}
