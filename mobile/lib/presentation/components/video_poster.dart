import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';

class VideoPoster extends StatefulWidget {
  final double? height;
  final bool isLargePoster;
  const VideoPoster({super.key, this.isLargePoster = false, this.height});

  @override
  State<VideoPoster> createState() => _VideoPosterState();
}

class _VideoPosterState extends State<VideoPoster> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Stack(children: [
        Positioned(
          child: Image.network(
            'https://tse3.mm.bing.net/th?id=OIP.OxebR72Xy-AhpHIRpwutBAHaE8&pid=Api&P=0&h=180',
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
                    '12k ',
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
        widget.isLargePoster
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
