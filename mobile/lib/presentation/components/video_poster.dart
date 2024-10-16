import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/screens/video_detail/page/video_detail_page.dart';
import 'package:move_app/data/models/video_model.dart';

import '../../config/theme/app_images.dart';

class VideoPoster extends StatelessWidget {
  final double? height;
  final bool isLargePoster;
  final String? image;
  final String? numberOfViews;

  const VideoPoster({
    super.key,
    this.isLargePoster = false,
    this.height,
    this.image,
    this.numberOfViews,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const VideoDetailPage(),
          ),
        );
      },
      child: Stack(children: [
        Positioned(
          child: Image.network(
            image ?? '',
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width - 40.0,
            height: height,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                AppImages.posterVideo.pngAssetPath,
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        Positioned(
          left: 8.0,
          bottom: 8.0,
          child: Container(
            height: 16.0,
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              color: AppColors.black,
            ),
            child: Row(mainAxisSize: MainAxisSize.max, children: [
              const SizedBox(
                width: 3.0,
              ),
              SvgPicture.asset(
                AppIcons.eye.svgAssetPath,
              ),
              const SizedBox(
                width: 3.0,
              ),
              Row(
                children: [
                  Text(
                    numberOfViews ?? "",
                    style: AppTextStyles.montserratStyle.bold12White,
                  ),
                  isLargePoster
                      ? Text(
                          Constants.views,
                          style: AppTextStyles.montserratStyle.bold12White,
                        )
                      : const SizedBox(),
                ],
              ),
              const SizedBox(
                width: 3.0,
              ),
            ]),
          ),
        ),
        isLargePoster
            ? const SizedBox()
            : Positioned(
                right: 8.0,
                bottom: 8.0,
                child: Container(
                  height: 16.0,
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: AppColors.black,
                  ),
                  child: Text(
                    '12:32',
                    style: AppTextStyles.montserratStyle.bold12White,
                  ),
                ),
              )
      ]),
    );
  }
}
