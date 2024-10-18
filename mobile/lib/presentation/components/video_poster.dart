import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/screens/video_detail/page/video_detail_page.dart';
import 'package:move_app/utils/util_compact_view_account.dart';

class VideoPoster extends StatefulWidget {
  final double? height;
  final bool isLargePoster;
  final String? thumbnailURL;
  final int? videoLength;
  final int? numberOfViews;
  const VideoPoster({
    super.key,
    this.isLargePoster = false,
    this.height,
    this.thumbnailURL,
    this.videoLength,
    this.numberOfViews,
  });

  @override
  State<VideoPoster> createState() => _VideoPosterState();
}

class _VideoPosterState extends State<VideoPoster> {
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
            widget.thumbnailURL ?? '',
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width - 40.0,
            height: widget.height,
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
                    '${widget.numberOfViews?.toCompactViewCount()} ',
                    style: AppTextStyles.montserratStyle.bold12White,
                  ),
                  widget.isLargePoster
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
        Positioned(
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
              '${widget.videoLength?.toDurationFormat()}',
              style: AppTextStyles.montserratStyle.bold12White,
            ),
          ),
        )
      ]),
    );
  }
}
