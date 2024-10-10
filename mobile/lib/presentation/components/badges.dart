import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/data/models/channel_model.dart';

class Badges extends StatelessWidget {
  final ChannelModel? channelModel;
  const Badges({super.key, this.channelModel});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        const SizedBox(
          width: 3.0,
        ),
        channelModel?.isBlueBadge == true ?
        SvgPicture.asset(AppIcons.blueStick.svgAssetPath):const SizedBox(),
        const SizedBox(
          width: 3.0,
        ),
        channelModel?.isPinkBadge == true ?
        SvgPicture.asset(AppIcons.starFlower.svgAssetPath) : const SizedBox(),
      ],
    );
  }
}
