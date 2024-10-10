import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_images.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/models/following_channel_model.dart';
import 'package:move_app/data/models/social_network_model.dart';
import 'package:move_app/presentation/screens/channel/presentation/about/widgets/following_widget.dart';
import 'package:move_app/presentation/screens/channel/presentation/about/widgets/social_network_widget.dart';

class AboutBody extends StatelessWidget {
  const AboutBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
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
                        '${Constants.about} dianeTV',
                        style: AppTextStyles.montserratStyle.bold18White,
                      ),
                      Text(
                        Constants.goodNews,
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
              SocialNetworkWidget(socialNetworks: [
                SocialNetworkModel(name: Constants.facebook, link: ''),
                SocialNetworkModel(name: Constants.twitter, link: ''),
                SocialNetworkModel(name: Constants.youtube, link: ''),
              ]),
              const SizedBox(height: 32),
              Text(
                'dianeTV ${Constants.isFollowing}',
                style: AppTextStyles.montserratStyle.bold18black,
              ),
              FollowingWidget(
                followingChannels: [
                  FollowingChannelModel(
                      id: 1,
                      name: 'dianeTV',
                      image: AppImages.defaultAvatar.webpAssetPath,
                      isBlueBadge: true,
                      isPinkBadge: true,
                      numberOfFollowers: 10355),
                  FollowingChannelModel(
                      id: 1,
                      name: 'dianeTV',
                      image: AppImages.defaultAvatar.webpAssetPath,
                      isBlueBadge: true,
                      isPinkBadge: false,
                      numberOfFollowers: 10355),
                  FollowingChannelModel(
                      id: 1,
                      name: 'dianeTV',
                      image: AppImages.defaultAvatar.webpAssetPath,
                      isBlueBadge: false,
                      isPinkBadge: false,
                      numberOfFollowers: 10355),
                  FollowingChannelModel(
                      id: 1,
                      name: 'dianeTV',
                      image: AppImages.defaultAvatar.webpAssetPath,
                      isBlueBadge: true,
                      isPinkBadge: false,
                      numberOfFollowers: 10355),
                  FollowingChannelModel(
                      id: 1,
                      name: 'dianeTV',
                      image: AppImages.defaultAvatar.webpAssetPath,
                      isBlueBadge: true,
                      isPinkBadge: false,
                      numberOfFollowers: 10355),
                ],
              ),
            ],
          )),
    );
  }
}
