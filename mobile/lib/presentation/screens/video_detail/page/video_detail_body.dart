import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/constants/key_screen.dart';
import 'package:move_app/data/services/launch_url_service.dart';
import 'package:move_app/presentation/components/app_bar_widget.dart';
import 'package:move_app/presentation/components/rate_dialog.dart';
import 'package:move_app/presentation/routes/app_routes.dart';
import 'package:move_app/presentation/screens/video_detail/bloc/video_detail_bloc.dart';
import 'package:move_app/presentation/screens/video_detail/bloc/video_detail_event.dart';
import 'package:move_app/presentation/screens/video_detail/bloc/video_detail_state.dart';
import 'package:move_app/presentation/screens/gift_reps/widgets/gift_reps_dialog.dart';
import 'package:move_app/presentation/screens/video_detail/widgets/info_video_detail.dart';
import 'package:move_app/presentation/screens/video_detail/widgets/vimeo_player.dart';
import '../../../../config/theme/app_icons.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../constants/constants.dart';
import '../../../../data/data_sources/local/shared_preferences.dart';
import '../../../../data/models/comment_model.dart';
import '../../../components/custom_button.dart';
import '../../../components/thanks_rating_dialog.dart';
import '../../auth/widgets/dialog_authentication.dart';
import '../../view_channel_profile/page/view_channel_profile_page.dart';
import '../widgets/item_comment.dart';
import '../widgets/write_comment.dart';

class VideoDetailBody extends StatefulWidget {
  const VideoDetailBody({
    super.key,
  });

  @override
  State<VideoDetailBody> createState() => _VideoDetailBodyState();
}

class _VideoDetailBodyState extends State<VideoDetailBody> {
  late ScrollController _scrollController;
  final String username = SharedPrefer.sharedPrefer.getUsername();
  bool _hasScrolledToPosition = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScrollComments);
  }

  @override
  void deactivate() {
    context.read<VideoDetailBloc>().add(const VideoDetailPopEvent());
    super.deactivate();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
        builder: (context) => const DialogAuthentication(
          isStayOnPage: true,
        ),
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

    return Dismissible(
      key: const Key(KeyScreen.videoDetail),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBarWidget(
          prefixButton: () => Navigator.pushNamed(context, AppRoutes.routeMenu),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<VideoDetailBloc, VideoDetailState>(
              buildWhen: (previous, current) =>
                  previous.isShowVideo != current.isShowVideo ||
                  previous.video?.url != current.video?.url,
              builder: (context, state) {
                return state.isShowVideo
                    ? _buildVideoPlayer(state.video?.url)
                    : const SizedBox.shrink();
              },
            ),
            Expanded(
              child: BlocConsumer<VideoDetailBloc, VideoDetailState>(
                listener: (context, state) {
                  if (state.status == VideoDetailStatus.rateSuccess) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const ThanksRateDialog();
                      },
                    );
                  }
                  if (state.targetCommentId != null &&
                      !_hasScrolledToPosition) {
                    final comments = state.listComments;

                    if ((comments?.length ?? 0) > 2) {
                      double scrollToPosition = 100;
                      _hasScrolledToPosition = true;

                      Future.delayed(const Duration(seconds: 1), () {
                        _scrollController.animateTo(
                          scrollToPosition,
                          duration: const Duration(seconds: 1),
                          curve: Curves.linear,
                        );
                      });
                    }
                  }
                },
                builder: (context, state) {
                  state.status == VideoDetailStatus.processing
                      ? EasyLoading.show()
                      : EasyLoading.dismiss();
                  return state.status == VideoDetailStatus.processing
                      ? const SizedBox.shrink()
                      : state.isShowVideo
                          ? SizedBox(
                              child: state.listComments?.isEmpty ?? true
                                  ? SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildEmptyCommentSection(
                                              context, state, height),
                                        ],
                                      ),
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildCommentList(
                                            context, state, height),
                                        if (state.status ==
                                            VideoDetailStatus.loading)
                                          _buildLoadingIndicator(),
                                      ],
                                    ),
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    Constants.videoNotFound,
                                    style: AppTextStyles
                                        .montserratStyle.bold14Black,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomButton(
                                    title: Constants.goToHome,
                                    titleStyle: AppTextStyles
                                        .montserratStyle.bold14White,
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushNamed(AppRoutes.home);
                                    },
                                    width: 120,
                                    padding: const EdgeInsets.all(5),
                                    backgroundColor: AppColors.tiffanyBlue,
                                  )
                                ],
                              ),
                            );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer(String? videoUrl) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: VimeoPlayer(
        videoId: videoUrl?.split('/').last ?? '',
      ),
    );
  }

  Widget _buildEmptyCommentSection(
      BuildContext context, VideoDetailState state, double height) {
    return Column(
      children: [
        buildInfoVideoPart(height, state),
        if (state.video?.isCommentable == false)
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              child: Text(
                Constants.isCommentable,
                style: AppTextStyles.montserratStyle.regular14GraniteGray,
              ),
            ),
          )
        else
          Column(
            children: [
              buildWriteCommentPart(context, state),
              Center(
                child: Column(
                  children: [
                    Text(
                      Constants.emptyComments,
                      style: AppTextStyles.montserratStyle.bold14GraniteGray,
                    ),
                    Text(
                      Constants.leaveAComment,
                      style: AppTextStyles.montserratStyle.regular13GraniteGray,
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildCommentList(
      BuildContext context, VideoDetailState state, double height) {
    return Expanded(
      child: (state.video?.isCommentable == false &&
              state.listComments?.isNotEmpty == true &&
              state.video?.channel?.name != username)
          ? _buildCommentSectionWithInfo(state, height)
          : ListView.separated(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: state.listComments?.length ?? 0,
              separatorBuilder: (BuildContext context, int index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  child: const Divider()),
              itemBuilder: (BuildContext context, int index) {
                return _buildCommentItem(
                    context, state.listComments![index], state, height);
              },
            ),
    );
  }

  Widget _buildCommentSectionWithInfo(VideoDetailState state, double height) {
    return Wrap(
      children: [
        buildInfoVideoPart(height, state),
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 16),
            child: Text(
              Constants.isCommentable,
              style: AppTextStyles.montserratStyle.regular14GraniteGray,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentItem(BuildContext context, CommentModel commentModel,
      VideoDetailState state, double height) {
    final replies = state.replies?[commentModel.id] ?? [];
    final isHideRepliesForCurrentComment =
        state.isHiddenListReply?[commentModel.id] ?? false;
    final hasTargetCommentId =
        state.targetCommentId == commentModel.id && state.targetReplyId == 0;
    return Column(
      children: [
        if (commentModel == state.listComments?.first) ...[
          buildInfoVideoPart(height, state),
          if (state.video?.isCommentable == true)
            buildWriteCommentPart(context, state),
        ],
        ItemComment(
          commentModel: commentModel,
          hasTargetCommentId: hasTargetCommentId,
          onTapLike: state.video?.isCommentable == true
              ? () =>
                  _handleCommentReaction(context, commentModel, isLike: true)
              : null,
          onTapDislike: state.video?.isCommentable == true
              ? () =>
                  _handleCommentReaction(context, commentModel, isLike: false)
              : null,
          isHideReplies: isHideRepliesForCurrentComment,
          widgetHideListReplies: _buildHideRepliesButton(
              context, commentModel, state, isHideRepliesForCurrentComment),
          widgetListReplies: _buildReplyList(
              context, replies, isHideRepliesForCurrentComment, state),
          onTapShowInputReply: state.video?.isCommentable == true
              ? () => _onTapShowInputReply(context, commentModel)
              : null,
          isShowTemporaryListReply: state.isShowTemporaryListReply,
          originalNumOfReply: state.originalNumOfReply?[commentModel.id] ?? 0,
          widgetReplyInput: _buildReplyInput(
            context,
            commentModel,
            state,
          ),
          widgetShowListReplies: _buildShowRepliesButton(context, commentModel,
              replies, isHideRepliesForCurrentComment, state),
        ),
      ],
    );
  }

  Widget _buildHideRepliesButton(BuildContext context,
      CommentModel commentModel, VideoDetailState state, bool isHideReplies) {
    return Visibility(
      visible: isHideReplies,
      child: CustomButton(
        title:
            "Hide ${(commentModel.numberOfReply ?? 0) > (state.originalNumOfReply?[commentModel.id] ?? 0) ? (commentModel.numberOfReply ?? 0) : (state.originalNumOfReply?[commentModel.id] ?? 0)} ${(state.originalNumOfReply?[commentModel.id] ?? 0) == 1 ? 'Reply' : 'Replies'}",
        titleStyle: AppTextStyles.montserratStyle.bold16tiffanyBlue,
        prefix: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: SvgPicture.asset(AppIcons.arrowUpTiffany.svgAssetPath),
        ),
        isExpanded: false,
        onTap: () {
          if (commentModel.id != null) {
            final updatedIsRepliesHiddenMap = {
              ...?state.isHiddenListReply,
              commentModel.id!: false,
            };
            context.read<VideoDetailBloc>().add(
                  VideoDetailHideRepliesCommentEvent(
                    isHiddenListReplies: updatedIsRepliesHiddenMap,
                    commentId: commentModel.id ?? 0,
                  ),
                );
          }
        },
        borderColor: AppColors.white,
        padding: const EdgeInsets.only(top: 12),
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }

  Widget _buildReplyList(BuildContext context, List<CommentModel> replies,
      bool isHideReplies, VideoDetailState state) {
    return Visibility(
      visible: isHideReplies || state.isShowTemporaryListReply,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int replyIndex) {
          final replyCommentModel = replies[replyIndex];
          final hasTargetReplyId = state.targetReplyId == replyCommentModel.id;
          return ItemComment(
            commentModel: replyCommentModel,
            hasTargetReplyId: hasTargetReplyId,
            isShowReplyButton: false,
            onTapLike: state.video?.isCommentable == true
                ? () => _handleCommentReaction(context, replyCommentModel,
                    isLike: true)
                : null,
            onTapDislike: state.video?.isCommentable == true
                ? () => _handleCommentReaction(context, replyCommentModel,
                    isLike: false)
                : null,
          );
        },
        separatorBuilder: (BuildContext context, int replyIndex) =>
            const Divider(),
        itemCount: replies.length,
      ),
    );
  }

  void _onTapShowInputReply(BuildContext context, CommentModel commentModel) {
    if (SharedPrefer.sharedPrefer.getUserToken().isEmpty) {
      showDialog(
        context: context,
        builder: (context) => const DialogAuthentication(),
      );
    } else {
      context.read<VideoDetailBloc>().add(
            VideoDetailHideInputReplyEvent(
              commentId: commentModel.id ?? 0,
              isShowInput: true,
            ),
          );
    }
  }

  Widget _buildReplyInput(
      BuildContext context, CommentModel commentModel, VideoDetailState state) {
    return Visibility(
      visible: state.isHiddenInputReply?[commentModel.id] ?? false,
      child: WriteComment(
        hintText: Constants.writeReply,
        isCancelReply: true,
        marginRight: 0,
        onChanged: (value) {
          context.read<VideoDetailBloc>().add(
                VideoDetailReplyChangedEvent(content: value),
              );
        },
        onTapCancel: () {
          context.read<VideoDetailBloc>().add(
                VideoDetailHideInputReplyEvent(
                  commentId: commentModel.id ?? 0,
                  isShowInput: false,
                ),
              );
        },
        onTapSend: () {
          context.read<VideoDetailBloc>().add(
                VideoDetailPostCommentEvent(
                  content: state.inputReply ?? "",
                  commentId: commentModel.id,
                ),
              );

          context.read<VideoDetailBloc>().add(
                VideoDetailHideInputReplyEvent(
                  commentId: commentModel.id ?? 0,
                  isShowInput: false,
                ),
              );
        },
      ),
    );
  }

  Widget _buildShowRepliesButton(
      BuildContext context,
      CommentModel commentModel,
      List<CommentModel> replies,
      bool isHideReplies,
      VideoDetailState state) {
    return Visibility(
      visible:
          ((state.originalNumOfReply?[commentModel.id] ?? 0) > replies.length &&
                  (commentModel.numberOfReply ?? 0) > 0) ||
              (!isHideReplies && (commentModel.numberOfReply ?? 0) > 0),
      child: CustomButton(
        title: isHideReplies
            ? Constants.showMoreReplies
            : "Show ${commentModel.numberOfReply} ${commentModel.numberOfReply == 1 ? "Reply" : "Replies"}",
        titleStyle: AppTextStyles.montserratStyle.bold16tiffanyBlue,
        prefix: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: SvgPicture.asset(AppIcons.arrowDownTiffany.svgAssetPath),
        ),
        isExpanded: false,
        onTap: () {
          final currentReplies = state.replies?[commentModel.id] ?? [];
          final lastIdReply =
              currentReplies.isNotEmpty ? currentReplies.last.id : null;
          context.read<VideoDetailBloc>().add(
                VideoDetailLoadRepliesCommentEvent(
                  commentId: commentModel.id ?? 0,
                  lastIdReply: lastIdReply ?? 0,
                ),
              );
        },
        borderColor: AppColors.white,
        padding: const EdgeInsets.only(top: 12),
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 30),
        child: const CircularProgressIndicator(),
      ),
    );
  }

  Widget buildInfoVideoPart(
    double height,
    VideoDetailState state,
  ) {
    return Column(
      children: [
        const SizedBox(
          height: 5.0,
        ),
        SizedBox(
          height: height * 0.2,
          child: InfoVideoDetail(
            video: state.video,
            viewChanelButton: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewChannelProfilePage(
                      idChannel: state.video?.channel?.id ?? 0),
                ),
              );
            },
            followButton: () {
              if (SharedPrefer.sharedPrefer.getUserToken().isEmpty) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const DialogAuthentication(
                      isStayOnPage: true,
                    );
                  },
                );
              } else {
                context.read<VideoDetailBloc>().add(
                    VideoDetailFollowChannelEvent(
                        state.video?.channel?.id ?? 0));
              }
            },
            giftRepButton: () {
              if (SharedPrefer.sharedPrefer.getUserToken().isEmpty) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const DialogAuthentication(
                      isStayOnPage: true,
                    );
                  },
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return GiftRepsDialog(videoId: state.video?.id ?? 0);
                  },
                );
              }
            },
            onTapRate: () {
              if (SharedPrefer.sharedPrefer.getUserToken().isEmpty) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const DialogAuthentication(
                      isStayOnPage: true,
                    );
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
                    if (mounted) {
                      context
                          .read<VideoDetailBloc>()
                          .add(VideoDetailRateSubmitEvent(onValue));
                    }
                  }
                });
              }
            },
            facebookButton: () {
              context.read<VideoDetailBloc>().add(VideoDetailShareSocialEvent(
                  videoId: state.video?.id ?? 0,
                  option: Constants.facebookOption));
              if (state.facebookLink != null &&
                  state.facebookLink!.isNotEmpty) {
                openExternalApplication(state.facebookLink ?? "");
              }
            },
            twitterButton: () {
              context.read<VideoDetailBloc>().add(VideoDetailShareSocialEvent(
                  videoId: state.video?.id ?? 0,
                  option: Constants.twitterOption));
              if (state.twitterLink != null && state.twitterLink!.isNotEmpty) {
                openExternalApplication(state.twitterLink ?? "");
              }
            },
            copyLinkButton: () {
              Clipboard.setData(ClipboardData(text: state.video?.url ?? ""));
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
            context.read<VideoDetailBloc>().add(VideoDetailPostCommentEvent(
                content: state.inputComment ?? "",
                videoId: state.video?.id ?? 0));
          },
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
