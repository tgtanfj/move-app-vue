import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:move_app/config/theme/app_colors.dart';

import 'package:move_app/constants/key_screen.dart';
import 'package:move_app/presentation/components/app_bar_widget.dart';
import 'package:move_app/presentation/components/rate_dialog.dart';
import 'package:move_app/presentation/routes/app_routes.dart';
import 'package:move_app/presentation/screens/video_detail/bloc/video_detail_bloc.dart';
import 'package:move_app/presentation/screens/video_detail/bloc/video_detail_event.dart';
import 'package:move_app/presentation/screens/video_detail/bloc/video_detail_state.dart';
import 'package:move_app/presentation/screens/video_detail/widgets/info_video_detail.dart';
import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';

import '../../../../data/data_sources/local/shared_preferences.dart';

import '../../../components/thanks_rating_dialog.dart';
import '../../auth/widgets/dialog_authentication.dart';

class VideoDetailBody extends StatefulWidget {
  const VideoDetailBody({super.key});

  @override
  State<VideoDetailBody> createState() => _VideoDetailBodyState();
}

class _VideoDetailBodyState extends State<VideoDetailBody> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final lastCommentId = context.read<VideoDetailBloc>().state.lastCommentId;
      if (lastCommentId != null) {
        context.read<VideoDetailBloc>().add(
            VideoDetailLoadMoreCommentsEvent(lastCommentId: lastCommentId));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Dismissible(
      key: const Key(KeyScreen.videoDetail),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBarWidget(
          prefixButton: () => Navigator.pushNamed(context, AppRoutes.routeMenu),
        ),
        body: BlocConsumer<VideoDetailBloc, VideoDetailState>(
          listener: (context, state) {
            if (state.status == VideoDetailStatus.processing) {
              EasyLoading.show();
            } else {
              EasyLoading.dismiss();
            }
            state.status == VideoDetailStatus.rateSuccess
                ? showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const ThanksRateDialog();
                    },
                  )
                : null;
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                state.isShowVideo
                    ? AspectRatio(
                        aspectRatio: 16 / 9,
                        child: VimeoPlayer(
                          videoId: state.video?.url?.split('/').last ?? '',
                        ),
                      )
                    : const SizedBox(),
                if (state.listComments?.isEmpty ?? true) ...[
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
                      onTapRate: () {
                        String token = SharedPrefer.sharedPrefer.getUserToken();
                        if (token.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const DialogAuthentication();
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return RateDialog(
                                rateSelected: state.rateSelected ?? 0,
                              );
                            },
                          ).then((onValue) {
                            if (onValue != null) {
                              if (context.mounted && onValue != null) {
                                context
                                    .read<VideoDetailBloc>()
                                    .add(VideoDetailRateSubmitEvent(onValue));
                              }
                            }
                          });
                        }
                      },
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
              ],
            );
          },
        ),
      ),
    );
  }
}
