import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/models/channel_model.dart';
import 'package:move_app/data/models/social_network_model.dart';
import 'package:move_app/utils/string_extentions.dart';

import '../widgets/following_widget.dart';
import '../widgets/social_network_widget.dart';

class AboutBody extends StatelessWidget {
  final String? channelName;
  final String? channelBio;
  final List<SocialNetworkModel>? socialNetworks;
  final List<ChannelModel>? followingChannels;
  final Function(int)? onTapFollowingChannel;
  final Function(String)? onTapSocialNetwork;

  const AboutBody({
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
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$channelName',
                        style: AppTextStyles.montserratStyle.bold18White,
                      ),
                      Text(
                        (channelBio?.isNullOrEmpty ?? true)
                            ? Constants.noInformationFound
                            : '$channelBio',
                        style: AppTextStyles.montserratStyle.regular16White,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                Constants.socialNetwork,
                style: AppTextStyles.montserratStyle.bold18black,
              ),
              const SizedBox(height: 12),
              socialNetworks?.isEmpty ?? true
                  ? Text(
                      Constants.noSocialNetworkFound,
                      style: AppTextStyles.montserratStyle.regular16Black
                          .copyWith(fontStyle: FontStyle.italic),
                    )
                  : SocialNetworkWidget(
                      socialNetworks: socialNetworks ?? [],
                      onTapSocialNetwork: onTapSocialNetwork,
                    ),
              const SizedBox(height: 32),
              followingChannels?.isEmpty ?? true
                  ? const SizedBox()
                  : Text(
                      '$channelName ${Constants.isFollowing}',
                      style: AppTextStyles.montserratStyle.bold18black,
                    ),
              FollowingWidget(
                followingChannels: followingChannels ?? [],
                onTapFollowingChannel: onTapFollowingChannel,
              ),
            ],
          )),
    );
  }
}
