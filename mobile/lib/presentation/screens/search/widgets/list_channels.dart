import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/presentation/screens/search/widgets/custom_search_channel.dart';

class ListChannels extends StatefulWidget {
  const ListChannels({super.key});

  @override
  State<ListChannels> createState() => _ListChannelsState();
}

class _ListChannelsState extends State<ListChannels> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 8,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
            onTap: () {}, child: const CustomSearchChannel());
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(width: 12.0);
      },
    );
  }
}
