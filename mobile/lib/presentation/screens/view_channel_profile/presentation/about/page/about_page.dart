import 'package:flutter/material.dart';

import '../../../../../../data/models/following_channel_model.dart';
import '../../../../../../data/models/social_network_model.dart';
import 'about_body.dart';

class AboutPage extends StatelessWidget {
  final String? channelName;
  final String? channelBio;
  final List<SocialNetworkModel>? socialNetworks;
  final List<FollowingChannelModel>? followingChannels;

  const AboutPage(
      {super.key,
      this.channelName,
      this.channelBio,
      this.socialNetworks,
      this.followingChannels});

  @override
  Widget build(BuildContext context) {
    return AboutBody(
      channelName: channelName,
      channelBio: channelBio,
      socialNetworks: socialNetworks,
      followingChannels: followingChannels,
    );
  }
}
