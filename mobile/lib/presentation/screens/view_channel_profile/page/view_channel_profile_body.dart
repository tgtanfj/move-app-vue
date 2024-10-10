import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/app_bar_widget.dart';
import 'package:move_app/presentation/components/custom_tab_bar.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/videos/page/videos_page.dart';

class ViewChannelProfileBody extends StatefulWidget {
  const ViewChannelProfileBody({super.key});

  @override
  State<ViewChannelProfileBody> createState() => _ViewChannelProfileBodyState();
}

class _ViewChannelProfileBodyState extends State<ViewChannelProfileBody> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(),
      backgroundColor: AppColors.white,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'View Channel Profile',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
                child: CustomTabBar(tabsWithViews: {
              Constants.videos: VideosPage(),
              Constants.about: SizedBox()
            }))
          ],
        ),
      )),
    );
  }
}
