import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/constants/api_urls.dart';
import 'package:move_app/constants/key_screen.dart';
import 'package:move_app/data/services/launch_service.dart';
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
            if (state.facebookLink != null &&
                state.facebookLink!.isNotEmpty) {
              openExternalApplication(
                  "${state.facebookLink?.split('?').first}?u=${ApiUrls.deepLink}?path=${Constants.shareSocial}/${state.video?.id}");
            }
            if (state.twitterLink != null && state.twitterLink!.isNotEmpty) {
              openExternalApplication(
                  "${state.twitterLink?.split('?').first}?url=${ApiUrls.deepLink}?path=${Constants.shareSocial}/${state.video?.id}");
            }
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
                  buildInfoVideoPart(height, state),
                  if (state.video?.isCommentable == false)
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 16),
                        child: Text(
                          Constants.isCommentable,
                          style: AppTextStyles
                              .montserratStyle.regular14GraniteGray,
                        ),
                      ),
                    )
                  else ...[
                    buildWriteCommentPart(context, state),
                    Center(
                      child: Column(children: [
                        Text(
                          Constants.emptyComments,
                          style:
                              AppTextStyles.montserratStyle.bold14GraniteGray,
                        ),
                        Text(
                          Constants.leaveAComment,
                          style: AppTextStyles
                              .montserratStyle.regular13GraniteGray,
                        ),
                      ]),
                    ),
                  ],
                ],
                Expanded(
                  child: (state.video?.isCommentable == false &&
                          state.listComments?.isNotEmpty == true)
                      ? Wrap(
                          children: [
                            buildInfoVideoPart(height, state),
                            Center(
                              child: Container(
                                margin: const EdgeInsets.only(top: 16),
                                child: Text(
                                  Constants.isCommentable,
                                  style: AppTextStyles
                                      .montserratStyle.regular14GraniteGray,
                                ),
                              ),
                            )
                          ],
                        )
                      : ListView.separated(
                          controller: _scrollController,
                          shrinkWrap: true,
                          itemCount: state.listComments?.length ?? 0,
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                          itemBuilder: (BuildContext context, int index) {
                            final CommentModel? commentModel =
                                state.listComments?[index];
                            final replies =
                                state.replies?[commentModel?.id] ?? [];
                            final isHideRepliesForCurrentComment =
                                state.isHiddenListReply?[commentModel?.id] ??
                                    false;
                            return Column(
                              children: [
                                if (index == 0) ...[
                                  buildInfoVideoPart(height, state),
                                  buildWriteCommentPart(context, state),
                                ],
                                ItemComment(
                                  commentModel: commentModel,
                                  onTapLike: () {
                                    _handleCommentReaction(
                                        context, commentModel,
                                        isLike: true);
                                  },
                                  onTapDislike: () {
                                    _handleCommentReaction(
                                        context, commentModel,
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
                                        padding:
                                            const EdgeInsets.only(right: 12),
                                        child: SvgPicture.asset(AppIcons
                                            .arrowUpTiffany.svgAssetPath),
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
                                                    commentId:
                                                        commentModel.id ?? 0),
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
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (BuildContext context,
                                          int replyIndex) {
                                        final replyCommentModel =
                                            replies[replyIndex];
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
                                      separatorBuilder: (BuildContext context,
                                              int replyIndex) =>
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
                                                commentId:
                                                    commentModel?.id ?? 0,
                                                isShowInput: true),
                                          );
                                    }
                                  },
                                  isShowTemporaryListReply:
                                      state.isShowTemporaryListReply,
                                  originalNumOfReply: state.originalNumOfReply?[
                                      commentModel?.id ?? 0],
                                  widgetReplyInput: Visibility(
                                    visible: state.isHiddenInputReply?[
                                            commentModel?.id] ??
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
                                                commentId:
                                                    commentModel?.id ?? 0,
                                                isShowInput: false));
                                      },
                                      onTapSend: () {
                                        context.read<VideoDetailBloc>().add(
                                            VideoDetailPostCommentEvent(
                                                content: state.inputReply ?? "",
                                                commentId: commentModel?.id));

                                        context.read<VideoDetailBloc>().add(
                                            VideoDetailHideInputReplyEvent(
                                                commentId:
                                                    commentModel?.id ?? 0,
                                                isShowInput: false));
                                      },
                                    ),
                                  ),
                                  widgetShowListReplies: Visibility(
                                    visible: ((state.originalNumOfReply?[
                                                        commentModel?.id ??
                                                            0] ??
                                                    0) >
                                                replies.length &&
                                            (commentModel?.numberOfReply ?? 0) >
                                                0) ||
                                        (!isHideRepliesForCurrentComment &&
                                            (commentModel?.numberOfReply ?? 0) >
                                                0),
                                    child: CustomButton(
                                      title: isHideRepliesForCurrentComment
                                          ? Constants.showMoreReplies
                                          : "Show ${commentModel?.numberOfReply} Replies",
                                      titleStyle: AppTextStyles
                                          .montserratStyle.bold16tiffanyBlue,
                                      prefix: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 12),
                                        child: SvgPicture.asset(AppIcons
                                            .arrowDownTiffany.svgAssetPath),
                                      ),
                                      isExpanded: false,
                                      onTap: () {
                                        final currentReplies =
                                            state.replies?[commentModel?.id] ??
                                                [];
                                        final lastIdReply =
                                            currentReplies.isNotEmpty
                                                ? currentReplies.last.id
                                                : null;
                                        context.read<VideoDetailBloc>().add(
                                            VideoDetailLoadRepliesCommentEvent(
                                                commentId:
                                                    commentModel?.id ?? 0,
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

  Widget buildInfoVideoPart(
    double height,
    VideoDetailState state,
  ) {
    String token = SharedPrefer.sharedPrefer.getUserToken();
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
              if (token.isEmpty) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const DialogAuthentication();
                  },
                );
              } else {
                context.read<VideoDetailBloc>().add(
                    VideoDetailFollowChannelEvent(
                        state.video?.channel?.id ?? 0));
              }
            },
            giftRepButton: () {
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
                    return GiftRepsDialog(videoId: state.video?.id ?? 0);
                  },
                );
              }
            },
            onTapRate: () {
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
            facebookButton: () {
              context.read<VideoDetailBloc>().add(VideoDetailShareSocialEvent(
                  videoId: state.video?.id ?? 0,
                  option: Constants.facebookOption));
            },
            twitterButton: () {
              context.read<VideoDetailBloc>().add(VideoDetailShareSocialEvent(
                  videoId: state.video?.id ?? 0,
                  option: Constants.twitterOption));
            },
            copyLinkButton: () {
              Clipboard.setData(ClipboardData(
                  text:
                      "${ApiUrls.deepLink}?path=${Constants.shareSocial}/${state.video?.id}"));
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
