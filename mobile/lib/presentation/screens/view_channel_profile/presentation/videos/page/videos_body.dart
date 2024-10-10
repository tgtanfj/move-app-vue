import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/custom_button.dart';
import 'package:move_app/presentation/components/video_poster.dart';
import 'package:move_app/presentation/screens/home/widgets/video_feature_description.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/sort_and_filter/page/sort_and_filter_page.dart';

class VideosBody extends StatefulWidget {
  const VideosBody({super.key});

  @override
  State<VideosBody> createState() => _VideosBodyState();
}

class _VideosBodyState extends State<VideosBody> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          CustomButton(
            width: MediaQuery.of(context).size.width - 215,
            prefix: SvgPicture.asset(
              AppIcons.filterList.svgAssetPath,
              width: 24,
              height: 18,
            ),
            sizedBox: const SizedBox(width: 4),
            title: Constants.sortFilter,
            titleStyle: AppTextStyles.montserratStyle.bold14White,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SortAndFilterPage()))
            },
            backgroundColor: AppColors.tiffanyBlue,
          ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 6,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                        onTap: () {},
                        child: VideoPoster(
                          height: height * 0.22,
                          isLargePoster: true,
                        )),
                    const SizedBox(
                      height: 4.0,
                    ),
                    const VideoFeatureDescription(),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
