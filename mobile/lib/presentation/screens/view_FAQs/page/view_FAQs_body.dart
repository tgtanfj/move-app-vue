import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/app_bar_widget.dart';
import 'package:move_app/presentation/components/custom_tile.dart';

class ViewFAQsBody extends StatefulWidget {
  const ViewFAQsBody({super.key});

  @override
  State<ViewFAQsBody> createState() => _ViewFAQsBodyState();
}

class _ViewFAQsBodyState extends State<ViewFAQsBody> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: const AppBarWidget(),
      backgroundColor: AppColors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  AppIcons.faqs.svgAssetPath,
                  width: 20,
                  height: 20,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            height: height * 0.7,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 20,
              itemBuilder: (context, index) => CustomTile(
                title: Constants.titleExample,
                titleStyle: AppTextStyles.montserratStyle.bold16black,
                expandedContent: Text(
                  Constants.contentExample,
                  style: AppTextStyles.montserratStyle.regular16Black,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: RichText(
              text: TextSpan(
                text: Constants.cantFindAnAnswer,
                style: AppTextStyles.montserratStyle.regular14Black,
                children: [
                  TextSpan(
                    text: Constants.contactUs,
                    style: AppTextStyles.montserratStyle.regular14TiffanyBlue
                        .copyWith(decoration: TextDecoration.underline),
                  ),
                  TextSpan(
                    text: Constants.hereAndWeWillAddress,
                    style: AppTextStyles.montserratStyle.regular14Black,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
