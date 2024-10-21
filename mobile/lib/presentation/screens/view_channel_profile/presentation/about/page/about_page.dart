import 'package:flutter/material.dart';
import 'package:move_app/data/models/channel_model.dart';

import '../../../../../../data/models/social_network_model.dart';
import 'about_body.dart';

class AboutPage extends StatelessWidget {
  final String? channelName;
  final String? channelBio;
  final List<SocialNetworkModel>? socialNetworks;
  final List<ChannelModel>? followingChannels;
  final Function(int)? onTapFollowingChannel;
  final Function(String)? onTapSocialNetwork;

  const AboutPage({
    super.key,
    this.channelName,
    this.channelBio,
    this.socialNetworks,
    this.followingChannels,
    this.onTapFollowingChannel,
    this.onTapSocialNetwork,
  });

  @override
  Widget build(BuildContext context) {
    return AboutBody(
      channelName: channelName,
      channelBio: channelBio,
      socialNetworks: socialNetworks,
      followingChannels: followingChannels,
      onTapFollowingChannel: onTapFollowingChannel,
      onTapSocialNetwork: onTapSocialNetwork,
    );
  }
}
