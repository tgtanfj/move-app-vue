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

final class VideoDetailState extends Equatable {
  final VideoDetailStatus? status;
  final bool isShowVideo;
  final VideoModel? video;
  final String? inputComment;
  final List<CommentModel>? listComments;
  final Map<int, List<CommentModel>>? replies;
  final List<CommentModel>? listReplies;
  final int? lastCommentId;
  final CommentModel? commentModel;
  final int? rateSelected;
  final String? errorMessage;

  const VideoDetailState({
    this.video,
    this.status,
    this.isShowVideo = false,
    this.inputComment,
    this.listComments,
    this.replies,
    this.listReplies,
    this.lastCommentId,
    this.commentModel,
    this.rateSelected,
    this.errorMessage,
  });

  static VideoDetailState initial() => const VideoDetailState(
        status: VideoDetailStatus.initial,
      );

  VideoDetailState copyWith({
    VideoDetailStatus? status,
    String? inputComment,
    List<CommentModel>? listComments,
    Map<int, List<CommentModel>>? replies,
    List<CommentModel>? listReplies,
    int? lastCommentId,
    CommentModel? commentModel,
    int? rateSelected,
    String? errorMessage,
    VideoModel? video,
    bool? isShowVideo,
  }) {
    return VideoDetailState(
      video: video ?? this.video,
      status: status ?? this.status,
      isShowVideo: isShowVideo ?? this.isShowVideo,
      inputComment: inputComment ?? this.inputComment,
      listComments: listComments ?? this.listComments,
      replies: replies ?? this.replies,
      listReplies: listReplies ?? this.listReplies,
      lastCommentId: lastCommentId ?? this.lastCommentId,
      commentModel: commentModel ?? this.commentModel,
      rateSelected: rateSelected ?? this.rateSelected,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        inputComment,
        listComments,
        replies,
        listReplies,
        lastCommentId,
        commentModel,
        rateSelected,
        errorMessage,
        video,
        isShowVideo
      ];
}
