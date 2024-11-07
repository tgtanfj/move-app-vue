import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_images.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/app_bar_widget.dart';
import 'package:move_app/presentation/components/custom_tab_bar.dart';
import 'package:move_app/presentation/routes/app_routes.dart';
import 'package:move_app/presentation/screens/view_channel_profile/bloc/view_channel_profile_bloc.dart';
import 'package:move_app/presentation/screens/view_channel_profile/bloc/view_channel_profile_event.dart';
import 'package:move_app/presentation/screens/view_channel_profile/bloc/view_channel_profile_state.dart';
import 'package:move_app/presentation/screens/view_channel_profile/page/view_channel_profile_page.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/videos/page/videos_page.dart';
import 'package:move_app/utils/util_number_format.dart';

import '../../../../data/data_sources/local/shared_preferences.dart';
import '../../../../data/services/launch_service.dart';
import '../../auth/widgets/dialog_authentication.dart';
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
      if (state.channelId == null) {
        return const SizedBox();
      }
      return Scaffold(
        appBar: AppBarWidget(
          prefixButton: () {
            Navigator.pushNamed(context, AppRoutes.routeMenu, arguments: true);
          },
        ),
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
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          runSpacing: 4,
                          children: [
                            RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: state.channel?.name ?? '',
                                    style: AppTextStyles
                                        .montserratStyle.regular20Black,
                                  ),
                                  if (state.channel?.isBlueBadge ?? false)
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.baseline,
                                      baseline: TextBaseline.alphabetic,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 7),
                                        child: SvgPicture.asset(
                                          AppIcons.blueCheckCircle.svgAssetPath,
                                          width: 16,
                                          height: 16,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${state.channel?.numberOfFollowers?.toCompactViewCount() ?? 0} ${Constants.followers}',
                          style: AppTextStyles
                              .montserratStyle.regular14graniteGray,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: InkWell(
                        splashFactory: NoSplash.splashFactory,
                        onTap: () {
                          if (SharedPrefer.sharedPrefer
                              .getUserToken()
                              .isEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const DialogAuthentication(
                                  isStayOnPage: true,
                                );
                              },
                            ).then((value){if (context.mounted) {
                              Navigator.pushReplacement(
                                  context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                        ViewChannelProfilePage(
                                          idChannel: state.channelId ?? 0,
                                        ),
                                  ));
                            }});
                          } else {
                            context.read<ViewChannelProfileBloc>().add(
                                ViewChannelProfileFollowChannelEvent(
                                    state.channel?.id ?? 0));
                          }
                        },
                        child: (state.channel?.isFollowed == null &&
                                state.channel?.canFollow == null)
                            ? SvgPicture.asset(
                                AppIcons.heart.svgAssetPath,
                                width: 20,
                                height: 18,
                              )
                            : state.channel?.canFollow ?? false
                                ? SvgPicture.asset(
                                    state.channel?.isFollowed ?? false
                                        ? AppIcons.fillHeart.svgAssetPath
                                        : AppIcons.heart.svgAssetPath,
                                    width: 20,
                                    height: 18,
                                  )
                                : const SizedBox()),
                  )
                ],
              ),
            ),
            Expanded(
              child: CustomTabBar(
                labelPadding: const EdgeInsets.fromLTRB(16, 0, 20, 0),
                dividerColor: AppColors.chineseSilver,
                tabsWithViews: {
                  Constants.videos: VideosPage(
                    videos: state.videos,
                    channelId: state.channelId ?? 0,
                  ),
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
