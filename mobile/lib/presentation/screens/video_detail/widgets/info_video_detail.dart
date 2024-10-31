import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/data_sources/local/shared_preferences.dart';
import 'package:move_app/data/models/video_model.dart';
import 'package:move_app/presentation/components/avatar.dart';
import 'package:move_app/presentation/components/badges.dart';
import 'package:move_app/presentation/components/custom_button.dart';
import 'package:move_app/presentation/components/star_and_text.dart';
import 'package:move_app/presentation/components/type_label.dart';
import 'package:move_app/presentation/screens/video_detail/widgets/share_video_dialog.dart';
import 'package:move_app/utils/string_extentions.dart';

import '../../auth/widgets/dialog_authentication.dart';

class InfoVideoDetail extends StatefulWidget {
  final VoidCallback viewChanelButton;
  final VoidCallback followButton;
  final VoidCallback giftRepButton;
  final VoidCallback onTapRate;
  final VideoModel? video;
  final VoidCallback facebookButton;
  final VoidCallback twitterButton;
  final VoidCallback copyLinkButton;

  const InfoVideoDetail({
    super.key,
    required this.viewChanelButton,
    required this.followButton,
    required this.giftRepButton,
    required this.facebookButton,
    required this.twitterButton,
    required this.copyLinkButton,
    required this.onTapRate,
    required this.video,
  });

  @override
  State<InfoVideoDetail> createState() => _InfoVideoDetailState();
}

class _InfoVideoDetailState extends State<InfoVideoDetail> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Avatar(
                  imageUrl: widget.video?.channel?.image ?? '',
                  widthAvatar: 48.0,
                  heightAvatar: 48.0,
                  radiusAvatar: 38.0),
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.video?.channel?.name ?? '',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: AppTextStyles.montserratStyle.regular20Black,
                        ),
                      ),
                      Badges(
                        isBlueBadge:
                            widget.video?.channel?.isBlueBadge ?? false,
                        isPinkBadge:
                            widget.video?.channel?.isPinkBadge ?? false,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          '${widget.video?.categories?.title?.capitalizeFirstLetter()} •',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: AppTextStyles
                              .montserratStyle.regular14graniteGray,
                        ),
                      ),
                      StarAndText(
                        ratings: widget.video?.ratings ?? 0.0,
                        textStyle: AppTextStyles.montserratStyle.bold16Black,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
                onTap: widget.followButton,
                child: (widget.video?.channel?.isFollowed == null &&
                        widget.video?.channel?.canFollow == null)
                    ? SvgPicture.asset(
                        AppIcons.heart.svgAssetPath,
                        width: 20,
                        height: 18,
                      )
                    : widget.video?.channel?.canFollow ?? false
                        ? SvgPicture.asset(
                            widget.video?.channel?.isFollowed ?? false
                                ? AppIcons.fillHeart.svgAssetPath
                                : AppIcons.heart.svgAssetPath,
                            width: 20,
                            height: 18,
                          )
                        : const SizedBox()),
            PopupMenuButton<String>(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(16.0), // Set the border radius here
              ),
              offset: const Offset(0, -70),
              iconColor: AppColors.tiffanyBlue,
              onSelected: (value) {},
              itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                PopupMenuItem<String>(
                  value: Constants.rate,
                  onTap: widget.onTapRate,
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        Constants.rate,
                        style: AppTextStyles.montserratStyle.regular16Black,
                      )),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(); // Close the popup
                        },
                        child: SvgPicture.asset(
                            AppIcons.close.svgAssetPath), // Close icon
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: Constants.share,
                  child: Text(Constants.share,
                      style: AppTextStyles.montserratStyle.regular16Black),
                  onTap: () {
                    String token = SharedPrefer.sharedPrefer.getUserToken();
                    if (token.isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ShareVideoDialog(
                            onFacebookTap: (){
                              widget.facebookButton.call();
                            },
                            onTwitterTap: (){
                              widget.twitterButton.call();
                            },
                            onCopyLinkTap: widget.copyLinkButton,
                          );
                        },
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const DialogAuthentication();
                        },
                      );
                    }
                  },
                ),
              ],
              child: SvgPicture.asset(AppIcons
                  .dotsTiffany.svgAssetPath), // This can be any trigger widget
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 64.0,
            ),
            Flexible(
              child: Row(
                children: [
                  TypeLabel(
                    typeLabel: Constants.intermediate ==
                            widget.video?.workoutLevel.capitalizeFirstLetter()
                        ? Constants.interm
                        : widget.video?.workoutLevel.capitalizeFirstLetter() ??
                            '',
                  ),
                  const SizedBox(
                    width: 6.0,
                  ),
                  TypeLabel(typeLabel: widget.video?.duration.shorten() ?? ''),
                ],
              ),
            ),
            CustomButton(
              onTap: widget.giftRepButton,
              isExpanded: false,
              borderRadius: 8.0,
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              backgroundColor: AppColors.tiffanyBlue,
              title: Constants.giftReps,
              titleStyle: AppTextStyles.montserratStyle.bold14White,
              suffix: Wrap(
                children: [
                  const SizedBox(
                    width: 6.0,
                  ),
                  SvgPicture.asset(AppIcons.arrowRight.svgAssetPath),
                ],
              ),
            ),
            const SizedBox(width: 12.0),
          ],
        ),
        const SizedBox(
          height: 14.0,
        ),
        GestureDetector(
          onTap: widget.viewChanelButton,
          child: Row(
            children: [
              const SizedBox(
                width: 12.0,
              ),
              Text(
                "${Constants.view} ${widget.video?.channel?.name}${Constants.s} ${Constants.channel}",
                style: AppTextStyles.montserratStyle.regular16tiffanyBlue,
              ),
              const SizedBox(
                width: 6.0,
              ),
              SvgPicture.asset(AppIcons.arrowRightTiffany.svgAssetPath),
            ],
          ),
        ),
      ],
    );
  }
}
