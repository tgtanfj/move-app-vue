import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_images.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/app_bar_widget.dart';
import 'package:move_app/presentation/components/custom_tab_bar.dart';
import 'package:move_app/presentation/screens/view_channel_profile/bloc/view_channel_profile_bloc.dart';
import 'package:move_app/presentation/screens/view_channel_profile/bloc/view_channel_profile_event.dart';
import 'package:move_app/presentation/screens/view_channel_profile/bloc/view_channel_profile_state.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../data/services/launch_service.dart';
import '../presentation/about/page/about_page.dart';

class ViewChannelProfileBody extends StatefulWidget {
  const ViewChannelProfileBody({super.key});

  @override
  State<ViewChannelProfileBody> createState() => _ViewChannelProfileBodyState();
}

class _ViewChannelProfileBodyState extends State<ViewChannelProfileBody> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ViewChannelProfileBloc, ViewChannelProfileState>(
        listener: (context, state) {
      state.status == ViewChannelProfileStatus.processing
          ? EasyLoading.show()
          : EasyLoading.dismiss();
    }, child: BlocBuilder<ViewChannelProfileBloc, ViewChannelProfileState>(
            builder: (context, state) {
      return Scaffold(
        appBar: const AppBarWidget(),
        backgroundColor: AppColors.white,
        body: SafeArea(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipOval(
                    child: Image.network(
                      state.channel?.image ?? '',
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          AppImages.defaultAvatar.webpAssetPath,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              state.channel?.name ?? '',
                              style:
                                  AppTextStyles.montserratStyle.regular20Black,
                            ),
                            SizedBox(
                                width: state.channel?.isBlueBadge ?? false
                                    ? 7
                                    : 0),
                            state.channel?.isBlueBadge ?? false
                                ? SvgPicture.asset(
                                    AppIcons.blueStick.svgAssetPath,
                                    width: 16,
                                    height: 16,
                                  )
                                : const SizedBox(),
                            SizedBox(
                                width: state.channel?.isPinkBadge ?? false
                                    ? 7
                                    : 0),
                            state.channel?.isBlueBadge ?? false
                                ? SvgPicture.asset(
                                    AppIcons.starFlower.svgAssetPath,
                                    width: 16,
                                    height: 16,
                                  )
                                : const SizedBox(),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${state.channel?.numberOfFollowed ?? 0} ${Constants.followers}',
                          style: AppTextStyles
                              .montserratStyle.regular14graniteGray,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: SvgPicture.asset(
                      state.channel?.isFollowed ?? false
                          ? AppIcons.fillHeart.svgAssetPath
                          : AppIcons.heart.svgAssetPath,
                      width: 20,
                      height: 18,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: CustomTabBar(
                labelPadding: const EdgeInsets.fromLTRB(16, 0, 20, 0),
                dividerColor: AppColors.chineseSilver,
                tabsWithViews: {
                  Constants.videos: const SizedBox(),
                  Constants.about: AboutPage(
                    channelName: state.channel?.name,
                    channelBio: state.channel?.bio,
                    socialNetworks: state.channel?.socialLinks,
                    followingChannels: state.channel?.followingChannels,
                    onTapFollowingChannel: (id) {
                      context
                          .read<ViewChannelProfileBloc>()
                          .add(ViewChannelProfileFollowingItemSelectEvent(id));
                    },
                    onTapSocialNetwork: (url) {
                      openExternalApplication(url);
                    },
                  ),
                },
              ),
            ),
          ],
        )),
      );
    }));
  }
}
