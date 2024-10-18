import 'package:equatable/equatable.dart';
import 'package:move_app/data/models/video_model.dart';

import '../../../../data/models/comment_model.dart';

enum VideoDetailStatus {
  initial,
  processing,
  success,
  failure,
  rateSuccess,
}

class VideoDetailState extends Equatable {
  final VideoDetailStatus? status;
  final bool isShowVideo;
  final VideoModel? video;
  final String? inputComment;
  final List<CommentModel>? listComments;
  final Map<int, List<CommentModel>>? replies;
  final int? lastCommentId;
  final CommentModel? commentModel;
  final int? rateSelected;
  final String? errorMessage;
  final int? lastIdReply;
  final Map<int, bool>? isHiddenListReply;
  final String? inputReply;
  final Map<int, bool>? isHiddenInputReply;
  final Map<int?, int?>? originalNumOfReply;
  final bool isShowTemporaryListReply;
  final String? selectedQuality;
  final Map<String, String>? videoUrls;
  final int? videoId;
  final String? option;
  final String? twitterLink;
  final String? facebookLink;
  final bool isCopied;

  const VideoDetailState({
    this.videoUrls,
    this.video,
    this.status,
    this.isShowVideo = false,
    this.inputComment,
    this.listComments,
    this.replies,
    this.lastCommentId,
    this.commentModel,
    this.rateSelected,
    this.errorMessage,
    this.lastIdReply,
    this.isHiddenListReply,
    this.inputReply,
    this.isHiddenInputReply,
    this.originalNumOfReply,
    this.isShowTemporaryListReply = false,
    this.selectedQuality,
    this.videoId,
    this.option,
    this.twitterLink,
    this.facebookLink,
    this.isCopied = false,
  });

  static VideoDetailState initial() => const VideoDetailState(
        status: VideoDetailStatus.initial,
        isCopied: false,
      );

  VideoDetailState copyWith({
    VideoDetailStatus? status,
    String? inputComment,
    List<CommentModel>? listComments,
    Map<int, List<CommentModel>>? replies,
    int? lastCommentId,
    CommentModel? commentModel,
    int? rateSelected,
    String? errorMessage,
    VideoModel? video,
    bool? isShowVideo,
    int? lastIdReply,
    Map<int, bool>? isHiddenListReply,
    String? inputReply,
    Map<int, bool>? isHiddenInputReply,
    Map<int?, int?>? originalNumOfReply,
    bool? isShowTemporaryListReply,
    String? selectedQuality,
    Map<String, String>? videoUrls,
    int? videoId,
    String? option,
    String? twitterLink,
    String? facebookLink,
    bool? isCopied,
  }) {
    return VideoDetailState(
      video: video ?? this.video,
      status: status ?? this.status,
      isShowVideo: isShowVideo ?? this.isShowVideo,
      inputComment: inputComment ?? this.inputComment,
      listComments: listComments ?? this.listComments,
      replies: replies ?? this.replies,
      lastCommentId: lastCommentId ?? this.lastCommentId,
      commentModel: commentModel ?? this.commentModel,
      rateSelected: rateSelected ?? this.rateSelected,
      errorMessage: errorMessage ?? this.errorMessage,
      lastIdReply: lastIdReply ?? this.lastIdReply,
      isHiddenListReply: isHiddenListReply ?? this.isHiddenListReply,
      inputReply: inputReply ?? this.inputReply,
      isHiddenInputReply: isHiddenInputReply ?? this.isHiddenInputReply,
      originalNumOfReply: originalNumOfReply ?? this.originalNumOfReply,
      isShowTemporaryListReply:
          isShowTemporaryListReply ?? this.isShowTemporaryListReply,
      videoUrls: videoUrls ?? this.videoUrls,
      videoId: videoId ?? this.videoId,
      option: option ?? this.option,
      twitterLink: twitterLink ?? this.twitterLink,
      facebookLink: facebookLink ?? this.facebookLink,
      isCopied: isCopied ?? this.isCopied,
    );
  }

  @override
  List<Object?> get props => [
        status,
        inputComment,
        listComments,
        replies,
        lastCommentId,
        commentModel,
        rateSelected,
        errorMessage,
        video,
        isShowVideo,
        lastIdReply,
        isHiddenListReply,
        inputReply,
        isHiddenInputReply,
        originalNumOfReply,
        isShowTemporaryListReply,
        selectedQuality,
        videoId,
        option,
        twitterLink,
        facebookLink,
        isCopied,
      ];
}
