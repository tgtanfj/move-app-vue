import 'package:equatable/equatable.dart';

import '../../../../data/models/comment_model.dart';

enum VideoDetailStatus {
  initial,
  processing,
  success,
  failure,
}

final class VideoDetailState extends Equatable {
  final VideoDetailStatus? status;
  final String? selectedQuality;
  final Map<String, String>? videoUrls;
  final String? inputComment;
  final List<CommentModel>? listComments;
  final Map<int, List<CommentModel>>? replies;
  final int? lastCommentId;
  final CommentModel? commentModel;
  final int? lastIdReply;
  final Map<int, bool>? isHiddenListReply;
  final String? inputReply;
  final Map<int, bool>? isHiddenInputReply;
  final Map<int?, int?>? originalNumOfReply;
  final bool isShowTemporaryListReply;

  const VideoDetailState({
    this.videoUrls,
    this.status,
    this.selectedQuality,
    this.inputComment,
    this.listComments,
    this.replies,
    this.lastCommentId,
    this.commentModel,
    this.lastIdReply,
    this.isHiddenListReply,
    this.inputReply,
    this.isHiddenInputReply,
    this.originalNumOfReply,
    this.isShowTemporaryListReply = false,
  });

  static VideoDetailState initial() => const VideoDetailState(
        status: VideoDetailStatus.initial,
      );

  VideoDetailState copyWith(
      {VideoDetailStatus? status,
      String? selectedQuality,
      Map<String, String>? videoUrls,
      String? inputComment,
      List<CommentModel>? listComments,
      Map<int, List<CommentModel>>? replies,
      int? lastCommentId,
      CommentModel? commentModel,
      int? lastIdReply,
      Map<int, bool>? isHiddenListReply,
      String? inputReply,
      Map<int, bool>? isHiddenInputReply,
      Map<int?, int?>? originalNumOfReply,
      bool? isShowTemporaryListReply}) {
    return VideoDetailState(
        selectedQuality: selectedQuality ?? this.selectedQuality,
        status: status ?? this.status,
        videoUrls: videoUrls ?? this.videoUrls,
        inputComment: inputComment ?? this.inputComment,
        listComments: listComments ?? this.listComments,
        replies: replies ?? this.replies,
        lastCommentId: lastCommentId ?? this.lastCommentId,
        commentModel: commentModel ?? this.commentModel,
        lastIdReply: lastIdReply ?? this.lastIdReply,
        isHiddenListReply: isHiddenListReply ?? this.isHiddenListReply,
        inputReply: inputReply ?? this.inputReply,
        isHiddenInputReply: isHiddenInputReply ?? this.isHiddenInputReply,
        originalNumOfReply: originalNumOfReply ?? this.originalNumOfReply,
        isShowTemporaryListReply:
            isShowTemporaryListReply ?? this.isShowTemporaryListReply);
  }

  @override
  List<Object?> get props => [
        status,
        selectedQuality,
        inputComment,
        listComments,
        replies,
        lastCommentId,
        commentModel,
        lastIdReply,
        isHiddenListReply,
        inputReply,
        isHiddenInputReply,
        originalNumOfReply,
        isShowTemporaryListReply
      ];
}
