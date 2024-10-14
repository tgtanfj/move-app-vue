import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/constants/key_screen.dart';
import 'package:move_app/presentation/components/app_bar_widget.dart';
import 'package:move_app/presentation/routes/app_routes.dart';
import 'package:move_app/presentation/screens/home/page/home_body.dart';
import 'package:move_app/presentation/screens/video_detail/bloc/video_detail_bloc.dart';
import 'package:move_app/presentation/screens/video_detail/bloc/video_detail_state.dart';
import 'package:move_app/presentation/screens/video_detail/widgets/info_video_detail.dart';
import 'package:move_app/utils/string_extentions.dart';
import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';

class VideoDetailBody extends StatefulWidget {
  const VideoDetailBody({
    super.key,
  });

  @override
  State<VideoDetailBody> createState() => _VideoDetailBodyState();
}

class _VideoDetailBodyState extends State<VideoDetailBody> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Dismissible(
      key: const Key(KeyScreen.videoDetail),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: const AppBarWidget(),
        body: BlocConsumer<VideoDetailBloc, VideoDetailState>(
          listener: (context, state) {
            if (state.status == VideoDetailStatus.processing) {
              EasyLoading.show();
            } else {
              EasyLoading.dismiss();
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  state.isShowVideo
                      ? AspectRatio(
                          aspectRatio: 16 / 9,
                          child: VimeoPlayer(
                            videoId: state.video?.url?.split('/').last ?? '',
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 5.0,
                  ),
                  SizedBox(
                    height: height * 0.2,
                    child: InfoVideoDetail(
                      video: state.video,
                      viewChanelButton: () {},
                      followButton: () {},
                      giftRepButton: () {},
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: AppColors.chineseSilver,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
