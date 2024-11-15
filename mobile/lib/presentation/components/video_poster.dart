import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';

import '../../config/theme/app_images.dart';

class VideoPoster extends StatelessWidget {
  final double? height;
  final bool isDurationText;
  final String? image;
  final String? numberOfViews;
  final String? duration;
  final VoidCallback? onTap;
  const VideoPoster({
    super.key,
    this.height,
    this.image,
    this.numberOfViews,
    required this.duration,
    this.onTap,
    this.isDurationText = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(children: [
        Positioned(
          child: Image.network(
            image ?? Constants.defaultThumbnailImage,
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width - 40.0,
            height: height,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                AppImages.posterVideo.pngAssetPath,
                fit: BoxFit.fill,
                height: height,
                width: MediaQuery.of(context).size.width - 40.0,
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
              Text(
                numberOfViews ?? "",
                style: AppTextStyles.montserratStyle.bold12White,
              ),
              const SizedBox(
                width: 3.0,
              ),
            ]),
          ),
        ),
        isDurationText
            ? Positioned(
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
                    duration ?? '',
                    style: AppTextStyles.montserratStyle.bold12White,
                  ),
                ),
              )
            : const SizedBox(),
      ]),
    );
  }
}
