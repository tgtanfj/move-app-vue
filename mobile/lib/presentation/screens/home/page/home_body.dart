import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_images.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/app_bar_widget.dart';
import 'package:move_app/presentation/components/list_categories.dart';
import 'package:move_app/presentation/screens/home/widgets/list_videos_may_u_like.dart';
import 'package:move_app/presentation/screens/home/widgets/slide_show_videos_feature.dart';
import 'package:move_app/presentation/screens/home/widgets/horizontal_divider.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const AppBarWidget(),
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20.0,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              height: height * 0.1,
              decoration: const BoxDecoration(color: AppColors.chineseSilver),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(Constants.featured,
                      style: AppTextStyles.montserratStyle.bold20black),
                  Image.asset(
                    AppImages.headline.webpAssetPath,
                    width: width * 0.5,
                    height: 8.0,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: SlideShowVideosFeature(
                  listVideo: [],
                )),
            const SizedBox(
              height: 10.0,
            ),
            const HorizontalDivider(),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Constants.category,
                    style: AppTextStyles.montserratStyle.bold20black,
                  ),
                  GestureDetector(
                    child: Text(Constants.viewAll,
                        style:
                            AppTextStyles.montserratStyle.regular18tiffanyBlue),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: const ListCategories(),
            ),
            const SizedBox(
              height: 12.0,
            ),
            const HorizontalDivider(),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                Constants.videosYouMayLike,
                style: AppTextStyles.montserratStyle.bold20black,
              ),
            ),
            const SizedBox(
              height: 21.0,
            ),
            const ListVideosMayULike(),
          ],
        ),
      ),
    );
  }
}
