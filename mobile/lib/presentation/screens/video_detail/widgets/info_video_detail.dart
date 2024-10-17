import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/avatar.dart';
import 'package:move_app/presentation/components/badges.dart';
import 'package:move_app/presentation/components/custom_button.dart';
import 'package:move_app/presentation/components/star_and_text.dart';
import 'package:move_app/presentation/components/type_label.dart';

class InfoVideoDetail extends StatefulWidget {
  final VoidCallback viewChanelButton;
  final VoidCallback followButton;
  final VoidCallback giftRepButton;
  final VoidCallback onTapRate;

  const InfoVideoDetail({
    super.key,
    required this.viewChanelButton,
    required this.followButton,
    required this.giftRepButton,
    required this.onTapRate,
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Avatar(
                  imageUrl:
                      'https://www.1zoom.me/big2/946/289597-frederika.jpg',
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
                          'dianeTV',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: AppTextStyles.montserratStyle.regular20Black,
                        ),
                      ),
                      const Badges(isBlueBadge: false, isPinkBadge: false,), // TODO : add badge
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          'Just Move • ',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: AppTextStyles
                              .montserratStyle.regular14graniteGray,
                        ),
                      ),
                      StarAndText(
                        ratings: 4.5,
                        textStyle: AppTextStyles.montserratStyle.bold16Black,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
                onTap: widget.followButton,
                child: SvgPicture.asset(AppIcons.heartTiffany.svgAssetPath)),
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
                ),
                PopupMenuItem<String>(
                  value: Constants.reportVideo,
                  child: Text(Constants.reportVideo,
                      style: AppTextStyles.montserratStyle.regular16Black),
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
            const Flexible(
              child: Row(
                children: [
                  TypeLabel(
                    typeLabel: Constants.intermediate ==
                            'Intermediate' // TODO: add type label
                        ? Constants.interm
                        : Constants.intermediate,
                  ),
                  SizedBox(
                    width: 6.0,
                  ),
                  TypeLabel(typeLabel: '<30 mins'), // TODO: add type label
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
                "${Constants.view} dianaTV${Constants.s} ${Constants.channel}",
                // TODO: add channel name
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
