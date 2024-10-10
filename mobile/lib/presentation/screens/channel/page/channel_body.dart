import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_images.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/app_bar_widget.dart';
import 'package:move_app/presentation/components/custom_tab_bar.dart';
import 'package:move_app/presentation/screens/channel/presentation/about/page/about_page.dart';

import '../../../../config/theme/app_colors.dart';

class ChannelBody extends StatelessWidget {
  const ChannelBody({super.key});

  @override
  Widget build(BuildContext context) {
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
                    '',
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
                            'dianeTV',
                            style: AppTextStyles.montserratStyle.regular20Black,
                          ),
                          const SizedBox(width: 7),
                          SvgPicture.asset(
                            AppIcons.blueStick.svgAssetPath,
                            width: 16,
                            height: 16,
                          ),
                          const SizedBox(width: 4),
                          SvgPicture.asset(
                            AppIcons.starFlower.svgAssetPath,
                            width: 16,
                            height: 16,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '10355 followers',
                        style:
                            AppTextStyles.montserratStyle.regular14graniteGray,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: SvgPicture.asset(
                    AppIcons.fillHeart.svgAssetPath,
                    width: 20,
                    height: 18,
                  ),
                )
              ],
            ),
          ),
          const Expanded(
            child: CustomTabBar(
              labelPadding: EdgeInsets.fromLTRB(16, 0, 20, 0),
              dividerColor: AppColors.chineseSilver,
              tabsWithViews: {
                Constants.videos: SizedBox(),
                Constants.about: AboutPage(),
              },
            ),
          ),
        ],
      )),
    );
  }
}
