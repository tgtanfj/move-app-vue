import 'package:equatable/equatable.dart';

import '../../../../data/models/comment_model.dart';

sealed class VideoDetailEvent extends Equatable {
  const VideoDetailEvent();
}

final class VideoDetailInitialEvent extends VideoDetailEvent {
  @override
  List<Object?> get props => [];
}

final class VideoDetailSelectQualityEvent extends VideoDetailEvent {
  final String selectedQuality;

  const VideoDetailSelectQualityEvent(this.selectedQuality);

  @override
  List<Object?> get props => [];
}

final class VideoDetailCommentChangedEvent extends VideoDetailEvent {
  final String? comment;

  const VideoDetailCommentChangedEvent({
    this.comment,
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
  final CommentModel? comment;

  const VideoDetailLikeComment({ this.comment});

  @override
  List<Object?> get props => [comment];
}

final class VideoDetailDisLikeComment extends VideoDetailEvent {
  final CommentModel? comment;

  const VideoDetailDisLikeComment({this.comment});

  @override
  List<Object?> get props => [comment];
}
