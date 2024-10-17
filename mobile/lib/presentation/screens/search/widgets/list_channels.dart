import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/data/models/channel_model.dart';
import 'package:move_app/presentation/screens/search/widgets/custom_search_channel.dart';

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
            onTap: () {},
            child: CustomSearchChannel(
              imageUrl: channelList[index].image,
              name: channelList[index].name,
              numberOfFollowers: channelList[index].numberOfFollowers,
              isBlueBadge: channelList[index].isBlueBadge,
            ));
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(width: 12.0);
      },
    );
  }
}
