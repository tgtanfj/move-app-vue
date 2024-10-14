import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/constants/key_screen.dart';
import 'package:move_app/presentation/components/app_bar_widget.dart';
import 'package:move_app/presentation/components/rate_dialog.dart';
import 'package:move_app/presentation/routes/app_routes.dart';
import 'package:move_app/presentation/screens/video_detail/bloc/video_detail_bloc.dart';
import 'package:move_app/presentation/screens/video_detail/bloc/video_detail_event.dart';
import 'package:move_app/presentation/screens/video_detail/bloc/video_detail_state.dart';
import 'package:move_app/presentation/screens/video_detail/widgets/info_video_detail.dart';
import 'package:video_player/video_player.dart';

import '../../../../data/data_sources/local/shared_preferences.dart';
import '../../../components/thanks_rating_dialog.dart';
import '../../auth/widgets/dialog_authentication.dart';

class VideoDetailBody extends StatefulWidget {
  const VideoDetailBody({super.key});

  @override
  State<VideoDetailBody> createState() => _VideoDetailBodyState();
}

class _VideoDetailBodyState extends State<VideoDetailBody> {
  late VideoPlayerController _videoPlayerController1;
  late VideoPlayerController _videoPlayerController2;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  String selectedQuality = Constants.auto;

  // To-Do: Replace with actual video URLs
  final Map<String, String> videoUrls = {
    'Auto':
        "https://assets.mixkit.co/videos/preview/mixkit-spinning-around-the-earth-29351-large.mp4",
    '480p':
        "https://assets.mixkit.co/videos/preview/mixkit-spinning-around-the-earth-29351-large.mp4",
    // Replace with actual video URLs
    '720p':
        "https://assets.mixkit.co/videos/preview/mixkit-spinning-around-the-earth-29351-large.mp4",
    '1080p':
        "https://assets.mixkit.co/videos/preview/mixkit-spinning-around-the-earth-29351-large.mp4",
  };

  Future<void> initializePlayer() async {
    _videoPlayerController1 = VideoPlayerController.networkUrl(
        Uri.parse(videoUrls.entries.first.value));
    _videoPlayerController2 = VideoPlayerController.networkUrl(
        Uri.parse(videoUrls.entries.first.value));
    await Future.wait([
      _videoPlayerController1.initialize(),
      _videoPlayerController2.initialize()
    ]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: true,
      looping: false,
      aspectRatio: 16 / 9,
      draggableProgressBar: true,
      showControlsOnInitialize: true,
      hideControlsTimer: const Duration(seconds: 2),
      customControls: const MaterialDesktopControls(),
      additionalOptions: (context) {
        return [
          OptionItem(
            onTap: () {
              _showQualityBottomSheet(); // Show quality selection dialog
            },
            iconData: Icons.tune,
            title: Constants.quality,
          ),
        ];
      },
      errorBuilder: (context, errorMessage) => Container(
        color: AppColors.black,
        child: Center(
          child: Text(
            errorMessage,
          ),
        ),
      ),
    );
  }

  void _showQualityBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.black,
                        size: 20.0,
                      )),
                  Text(Constants.quality,
                      style: AppTextStyles.montserratStyle.bold16Black),
                ],
              ),
              Column(
                children: videoUrls.keys.map((quality) {
                  return RadioListTile<String>(
                    title: Text(quality),
                    value: quality,
                    groupValue: selectedQuality,
                    onChanged: (value) async {
                      if (value != null) {
                        selectedQuality = value;
                        Navigator.pop(context);
                      }
                    },
                  );
                }).toList(),
              ),
            ]),
          );
        });
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
            return SingleChildScrollView(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    color: AppColors.black,
                    height: height * 0.3,
                    width: double.infinity,
                    child: Center(
                      child: _chewieController != null &&
                              _chewieController!
                                  .videoPlayerController.value.isInitialized
                          ? Chewie(controller: _chewieController!)
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 20),
                                Text(Constants.loading),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  SizedBox(
                    height: height * 0.2,
                    child: InfoVideoDetail(
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
              ),
            );
          },
        ),
      ),
    );
  }
}
