import 'package:equatable/equatable.dart';

import '../../../../data/models/comment_model.dart';

sealed class VideoDetailEvent extends Equatable {
  const VideoDetailEvent();
}

final class VideoDetailInitialEvent extends VideoDetailEvent {
  final int videoId;

  const VideoDetailInitialEvent({required this.videoId});

  @override
  List<Object?> get props => [videoId];
}

final class VideoDetailSelectQualityEvent extends VideoDetailEvent {
  final String selectedQuality;

  const VideoDetailSelectQualityEvent(this.selectedQuality);

  @override
  List<Object?> get props => [];
}

final class VideoDetailCommentChangedEvent extends VideoDetailEvent {
  final String comment;

  const VideoDetailCommentChangedEvent({
    required this.comment,
  });

  @override
  List<Object?> get props => [comment];
}

class VideoDetailLoadMoreCommentsEvent extends VideoDetailEvent {
  final int? lastCommentId;

  const VideoDetailLoadMoreCommentsEvent({this.lastCommentId});

  @override
  List<Object?> get props => [lastCommentId];
}

final class VideoDetailPostCommentEvent extends VideoDetailEvent {
  @override
  List<Object?> get props => [];
}

final class VideoDetailLikeComment extends VideoDetailEvent {
  final CommentModel comment;

  const VideoDetailLikeComment({required this.comment});

  @override
  List<Object?> get props => [comment];
}

final class VideoDetailDisLikeComment extends VideoDetailEvent {
  final CommentModel comment;

  const VideoDetailDisLikeComment({required this.comment});

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

class VideoDetailFollowChannelEvent extends VideoDetailEvent {
  final int channelId;

  const VideoDetailFollowChannelEvent(this.channelId);

  @override
  List<Object?> get props => [channelId];
}
