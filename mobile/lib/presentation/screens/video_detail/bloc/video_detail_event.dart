import 'package:equatable/equatable.dart';

import '../../../../data/models/comment_model.dart';

sealed class VideoDetailEvent extends Equatable {
  const VideoDetailEvent();
}

final class VideoDetailInitialEvent extends VideoDetailEvent {
  final int videoId;
  final int? targetCommentId;
  final int? targetReplyId;

  const VideoDetailInitialEvent(
      {required this.videoId, this.targetCommentId, this.targetReplyId});

  @override
  List<Object?> get props => [videoId, targetCommentId, targetReplyId];
}

final class VideoDetailSelectQualityEvent extends VideoDetailEvent {
  final String selectedQuality;

  const VideoDetailSelectQualityEvent(this.selectedQuality);

  @override
  List<Object?> get props => [];
}

final class VideoDetailCommentChangedEvent extends VideoDetailEvent {
  final String content;

  const VideoDetailCommentChangedEvent({
    required this.content,
  });

  @override
  List<Object?> get props => [content];
}

class VideoDetailLoadMoreCommentsEvent extends VideoDetailEvent {
  final int? lastCommentId;

  const VideoDetailLoadMoreCommentsEvent({this.lastCommentId});

  @override
  List<Object?> get props => [lastCommentId];
}

final class VideoDetailPostCommentEvent extends VideoDetailEvent {
  final String content;
  final int? videoId;
  final int? commentId;

  const VideoDetailPostCommentEvent(
      {required this.content, this.videoId, this.commentId});

  @override
  List<Object?> get props => [content, videoId, commentId];
}

final class VideoDetailLikeCommentEvent extends VideoDetailEvent {
  final CommentModel comment;

  const VideoDetailLikeCommentEvent({required this.comment});

  @override
  List<Object?> get props => [comment];
}

final class VideoDetailDisLikeCommentEvent extends VideoDetailEvent {
  final CommentModel comment;

  const VideoDetailDisLikeCommentEvent({required this.comment});

  @override
  List<Object?> get props => [comment];
}

class VideoDetailRateEvent extends VideoDetailEvent {
  final int rating;

  const VideoDetailRateEvent(this.rating);

  @override
  List<Object> get props => [rating];
}

class VideoDetailRateSubmitEvent extends VideoDetailEvent {
  final int rating;

  const VideoDetailRateSubmitEvent(this.rating);

  @override
  List<Object?> get props => [rating];
}

final class VideoDetailLoadRepliesCommentEvent extends VideoDetailEvent {
  final int commentId;
  final int lastIdReply;

  const VideoDetailLoadRepliesCommentEvent(
      {required this.commentId, required this.lastIdReply});

  @override
  List<Object?> get props => [commentId, lastIdReply];
}

class VideoDetailHideRepliesCommentEvent extends VideoDetailEvent {
  final Map<int, bool> isHiddenListReplies;
  final int commentId;

  const VideoDetailHideRepliesCommentEvent({
    required this.isHiddenListReplies,
    required this.commentId,
  });

  @override
  List<Object?> get props => [isHiddenListReplies, commentId];
}

final class VideoDetailReplyChangedEvent extends VideoDetailEvent {
  final String content;

  const VideoDetailReplyChangedEvent({
    required this.content,
  });

  @override
  List<Object?> get props => [content];
}

final class VideoDetailHideInputReplyEvent extends VideoDetailEvent {
  final int commentId;
  final bool isShowInput;

  const VideoDetailHideInputReplyEvent(
      {required this.commentId, required this.isShowInput});

  @override
  List<Object?> get props => [commentId, isShowInput];
}

class VideoDetailFollowChannelEvent extends VideoDetailEvent {
  final int channelId;

  const VideoDetailFollowChannelEvent(this.channelId);

  @override
  List<Object?> get props => [channelId];
}

final class VideoDetailShareSocialEvent extends VideoDetailEvent {
  final int? videoId;
  final String? option;

  const VideoDetailShareSocialEvent({
    this.videoId,
    required this.option,
  });

  @override
  List<Object?> get props => [
        videoId,
        option,
      ];
}

final class VideoDetailPopEvent extends VideoDetailEvent {
  const VideoDetailPopEvent();

  @override
  List<Object?> get props => [];
}

final class VideoDetailDeleteCommentEvent extends VideoDetailEvent {
  final int commentId;
  final int? parenCommentId;

  const VideoDetailDeleteCommentEvent({required this.commentId, this.parenCommentId});

  @override
  List<Object?> get props => [commentId, parenCommentId];
}