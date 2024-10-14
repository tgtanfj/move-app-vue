import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/constants/key_screen.dart';
import 'package:move_app/presentation/components/app_bar_widget.dart';
import 'package:move_app/presentation/routes/app_routes.dart';
import 'package:move_app/presentation/screens/video_detail/bloc/video_detail_bloc.dart';
import 'package:move_app/presentation/screens/video_detail/bloc/video_detail_state.dart';
import 'package:move_app/presentation/screens/video_detail/widgets/info_video_detail.dart';
import 'package:video_player/video_player.dart';

import '../../../../config/theme/app_icons.dart';
import '../../../../data/data_sources/local/shared_preferences.dart';
import '../../../../data/models/comment_model.dart';
import '../../../components/custom_button.dart';
import '../../auth/widgets/dialog_authentication.dart';
import '../bloc/video_detail_event.dart';
import '../widgets/item_comment.dart';
import '../widgets/write_comment.dart';

class VideoDetailBody extends StatefulWidget {
  const VideoDetailBody({super.key});

  @override
  State<VideoDetailBody> createState() => _VideoDetailBodyState();
}

class _VideoDetailBodyState extends State<VideoDetailBody> {
  late VideoPlayerController _videoPlayerController1;
  late VideoPlayerController _videoPlayerController2;
  ChewieController? _chewieController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScrollComments);
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController?.dispose();
    _scrollController.dispose();
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

  void _onScrollComments() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final lastCommentId = context.read<VideoDetailBloc>().state.lastCommentId;
      if (lastCommentId != null) {
        context.read<VideoDetailBloc>().add(
            VideoDetailLoadMoreCommentsEvent(lastCommentId: lastCommentId));
      }
    }
  }

  void _handleCommentReaction(BuildContext context, CommentModel? commentModel,
      {required bool isLike}) {
    if (SharedPrefer.sharedPrefer.getUserToken().isEmpty) {
      showDialog(
        context: context,
        builder: (context) => const DialogAuthentication(),
      );
    } else {
      final event = isLike
          ? VideoDetailLikeCommentEvent(comment: commentModel ?? CommentModel())
          : VideoDetailDisLikeCommentEvent(
              comment: commentModel ?? CommentModel());
      context.read<VideoDetailBloc>().add(event);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
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
          listener: (context, state) {},
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  color: AppColors.black,
                  height: height * 0.3,
                  width: width,
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
                if (state.listComments?.isEmpty ?? true) ...[
                  buildInfoVideoPart(height),
                  buildWriteCommentPart(context, state),
                  Center(
                    child: Text(
                      Constants.emptyComments,
                      style: AppTextStyles.montserratStyle.regular14GraniteGray,
                    ),
                  )
                ],
                Expanded(
                  child: ListView.separated(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: state.listComments?.length ?? 0,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                    itemBuilder: (BuildContext context, int index) {
                      final CommentModel? commentModel =
                          state.listComments?[index];
                      final replies = state.replies?[commentModel?.id] ?? [];
                      final isHideRepliesForCurrentComment =
                          state.isHiddenListReply?[commentModel?.id] ?? false;
                      return Column(
                        children: [
                          if (index == 0) ...[
                            buildInfoVideoPart(height),
                            buildWriteCommentPart(context, state),
                          ],
                          ItemComment(
                            commentModel: commentModel,
                            onTapLike: () {
                              _handleCommentReaction(context, commentModel,
                                  isLike: true);
                            },
                            onTapDislike: () {
                              _handleCommentReaction(context, commentModel,
                                  isLike: false);
                            },
                            isHideReplies: isHideRepliesForCurrentComment,
                            widgetHideListReplies: Visibility(
                              visible: isHideRepliesForCurrentComment,
                              child: CustomButton(
                                title:
                                    "Hide ${commentModel?.numberOfReply} Replies",
                                titleStyle: AppTextStyles
                                    .montserratStyle.bold16tiffanyBlue,
                                prefix: Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: SvgPicture.asset(
                                      AppIcons.arrowUpTiffany.svgAssetPath),
                                ),
                                isExpanded: false,
                                onTap: () {
                                  if (commentModel?.id != null) {
                                    final updatedIsRepliesHiddenMap = {
                                      ...?state.isHiddenListReply,
                                      commentModel!.id!: false,
                                    };
                                    context.read<VideoDetailBloc>().add(
                                          VideoDetailHideRepliesCommentEvent(
                                              isHiddenListReplies:
                                                  updatedIsRepliesHiddenMap,
                                              commentId: commentModel.id ?? 0),
                                        );
                                  }
                                },
                                borderColor: AppColors.white,
                                padding: const EdgeInsets.only(top: 12),
                                mainAxisSize: MainAxisSize.min,
                              ),
                            ),
                            widgetListReplies: Visibility(
                              visible: isHideRepliesForCurrentComment ||
                                  state.isShowTemporaryListReply,
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder:
                                    (BuildContext context, int replyIndex) {
                                  final replyCommentModel = replies[replyIndex];
                                  return ItemComment(
                                    commentModel: replyCommentModel,
                                    isShowReplyButton: false,
                                    onTapLike: () {
                                      _handleCommentReaction(
                                          context, replyCommentModel,
                                          isLike: true);
                                    },
                                    onTapDislike: () {
                                      _handleCommentReaction(
                                          context, replyCommentModel,
                                          isLike: false);
                                    },
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int replyIndex) =>
                                        const Divider(),
                                itemCount: replies.length,
                              ),
                            ),
                            onTapShowInputReply: () {
                              if (SharedPrefer.sharedPrefer
                                  .getUserToken()
                                  .isEmpty) {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      const DialogAuthentication(),
                                );
                              } else {
                                context.read<VideoDetailBloc>().add(
                                      VideoDetailHideInputReplyEvent(
                                          commentId: commentModel?.id ?? 0,
                                          isShowInput: true),
                                    );
                              }
                            },
                            isShowTemporaryListReply:
                                state.isShowTemporaryListReply,
                            originalNumOfReply: state
                                .originalNumOfReply?[commentModel?.id ?? 0],
                            widgetReplyInput: Visibility(
                              visible:
                                  state.isHiddenInputReply?[commentModel?.id] ??
                                      false,
                              child: WriteComment(
                                isCancelReply: true,
                                onChanged: (value) {
                                  context.read<VideoDetailBloc>().add(
                                      VideoDetailReplyChangedEvent(
                                          content: value));
                                },
                                onTapCancel: () {
                                  context.read<VideoDetailBloc>().add(
                                      VideoDetailHideInputReplyEvent(
                                          commentId: commentModel?.id ?? 0,
                                          isShowInput: false));
                                },
                                onTapSend: () {
                                  context.read<VideoDetailBloc>().add(
                                      VideoDetailPostCommentEvent(
                                          content: state.inputReply ?? "",
                                          commentId: commentModel?.id));

                                  context.read<VideoDetailBloc>().add(
                                      VideoDetailHideInputReplyEvent(
                                          commentId: commentModel?.id ?? 0,
                                          isShowInput: false));
                                },
                              ),
                            ),
                            widgetShowListReplies: Visibility(
                              visible: ((state.originalNumOfReply?[
                                                  commentModel?.id ?? 0] ??
                                              0) >
                                          replies.length &&
                                      (commentModel?.numberOfReply ?? 0) > 0) ||
                                  (!isHideRepliesForCurrentComment &&
                                      (commentModel?.numberOfReply ?? 0) > 0),
                              child: CustomButton(
                                title: isHideRepliesForCurrentComment
                                    ? Constants.showMoreReplies
                                    : "Show ${commentModel?.numberOfReply} Replies",
                                titleStyle: AppTextStyles
                                    .montserratStyle.bold16tiffanyBlue,
                                prefix: Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: SvgPicture.asset(
                                      AppIcons.arrowDownTiffany.svgAssetPath),
                                ),
                                isExpanded: false,
                                onTap: () {
                                  final currentReplies =
                                      state.replies?[commentModel?.id] ?? [];
                                  final lastIdReply = currentReplies.isNotEmpty
                                      ? currentReplies.last.id
                                      : null;
                                  context.read<VideoDetailBloc>().add(
                                      VideoDetailLoadRepliesCommentEvent(
                                          commentId: commentModel?.id ?? 0,
                                          lastIdReply: lastIdReply ?? 0));
                                },
                                borderColor: AppColors.white,
                                padding: const EdgeInsets.only(top: 12),
                                mainAxisSize: MainAxisSize.min,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                if (state.status == VideoDetailStatus.processing)
                  Center(
                      child: Container(
                          margin: const EdgeInsets.only(bottom: 30),
                          child: const CircularProgressIndicator())),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildInfoVideoPart(double height) {
    return Column(
      children: [
        const SizedBox(
          height: 5.0,
        ),
        SizedBox(
          height: height * 0.2,
          child: InfoVideoDetail(
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
    );
  }

  Widget buildWriteCommentPart(BuildContext context, VideoDetailState state) {
    return Column(
      children: [
        WriteComment(
          onChanged: (value) {
            context
                .read<VideoDetailBloc>()
                .add(VideoDetailCommentChangedEvent(content: value));
          },
          onTapSend: () {
            //TODO: Replace the videoId by the actual id of video
            context.read<VideoDetailBloc>().add(VideoDetailPostCommentEvent(
                content: state.inputComment ?? "", videoId: 1));
          },
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
