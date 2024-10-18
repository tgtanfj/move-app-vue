import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/models/video_model.dart';
import 'package:move_app/data/repositories/video_detail_repository.dart';
import 'package:move_app/data/repositories/view_channel_profile_repository.dart';
import 'package:move_app/presentation/screens/video_detail/bloc/video_detail_event.dart';
import 'package:move_app/presentation/screens/video_detail/bloc/video_detail_state.dart';

import '../../../../data/models/comment_model.dart';
import '../../../../data/repositories/comment_repository.dart';

class VideoDetailBloc extends Bloc<VideoDetailEvent, VideoDetailState> {
  final VideoDetailRepository videoRepository = VideoDetailRepository();
  final ViewChannelProfileRepository viewChannelRepository =
      ViewChannelProfileRepository();

  final commentRepository = CommentRepository();
  VideoDetailBloc() : super(VideoDetailState.initial()) {
    on<VideoDetailInitialEvent>(_onVideoDetailInitialEvent);
    on<VideoDetailSelectQualityEvent>(_onVideoDetailSelectQualityEvent);
    on<VideoDetailCommentChangedEvent>(onVideoDetailCommentChangedEvent);
    on<VideoDetailLoadMoreCommentsEvent>(onVideoDetailLoadMore);
    on<VideoDetailPostCommentEvent>(onVideoDetailPostCommentEvent);
    on<VideoDetailLikeComment>(onVideoDetailLikeComment);
    on<VideoDetailDisLikeComment>(onVideoDetailDisLikeComment);
    on<VideoDetailRateEvent>(_onVideoDetailRateEvent);
    on<VideoDetailRateSubmitEvent>(_onVideoDetailRateSubmitEvent);
    on<VideoDetailFollowChannelEvent>(_onVideoDetailFollowChannelEvent);
  }

  void _onVideoDetailInitialEvent(
      VideoDetailInitialEvent event, Emitter<VideoDetailState> emit) async {
    final result = await Future.wait([
      commentRepository.getListCommentVideo(1),
      videoRepository.getVideoDetail(event.videoId),
      videoRepository.getRateByVideoId(event.videoId),
    ]);
    final listCommentVideo = result[0] as Either<String, List<CommentModel>>;
    listCommentVideo.fold((l) {
      emit(state.copyWith(status: VideoDetailStatus.failure));
    }, (r) async {
      final updatedComments = r.map((comment) {
        return comment.copyWith(
          timeConvert: comment.createdAt != null
              ? getTimeDifference(comment.createdAt!)
              : null,
        );
      }).toList();

      final lastCommentId =
          updatedComments.isNotEmpty ? updatedComments.last.id : null;
      emit(state.copyWith(
        listComments: updatedComments,
        lastCommentId: lastCommentId,
        status: VideoDetailStatus.success,
      ));
    });

    // Use to get list reply based on commentId
    if (state.listComments != null) {
      for (var comment in state.listComments!) {
        final replyResult =
            await commentRepository.getListReplyComment(comment.id ?? 0);
        await replyResult.fold(
          (l) {
            return Future.value();
          },
          (replies) async {
            emit(state.copyWith(
                replies: {comment.id ?? 0: replies}, listReplies: replies));
          },
        );
      }
    }
    (result[1] as Either<String, VideoModel>).fold((l) {
      emit(state.copyWith(
        status: VideoDetailStatus.failure,
      ));
    }, (r) {
      emit(state.copyWith(
        video: r,
        isShowVideo: true,
        status: VideoDetailStatus.success,
      ));
    });
    final getRateResult = result[2] as Either<String, int>;
    getRateResult.fold((l) {
      emit(state.copyWith(errorMessage: l));
    }, (r) {
      emit(state.copyWith(rateSelected: r));
    });
  }

  void _onVideoDetailSelectQualityEvent(
      VideoDetailSelectQualityEvent event, Emitter<VideoDetailState> emit) {}

  void onVideoDetailLoadMore(VideoDetailLoadMoreCommentsEvent event,
      Emitter<VideoDetailState> emit) async {
    emit(state.copyWith(status: VideoDetailStatus.processing));
    final result = await commentRepository.getListCommentVideo(1,
        cursor: event.lastCommentId);
    result.fold((l) {
      emit(state.copyWith(status: VideoDetailStatus.failure));
    }, (r) {
      final newComments = r.map<CommentModel>((comment) {
        return comment.copyWith(
          timeConvert: comment.createdAt != null
              ? getTimeDifference(comment.createdAt!)
              : null,
        );
      }).toList();
      final updatedComments = [...state.listComments ?? [], ...newComments];
      final lastCommentId =
          updatedComments.isNotEmpty ? updatedComments.last.id : null;
      emit(state.copyWith(
        listComments: updatedComments.cast<CommentModel>(),
        lastCommentId: lastCommentId,
        status: VideoDetailStatus.success,
      ));
    });
  }

  void onVideoDetailCommentChangedEvent(
      VideoDetailCommentChangedEvent event, Emitter<VideoDetailState> emit) {
    emit(state.copyWith(inputComment: event.comment));
  }

  void onVideoDetailPostCommentEvent(
      VideoDetailPostCommentEvent event, Emitter<VideoDetailState> emit) async {
    CommentModel commentModel =
        CommentModel(content: state.inputComment, videoId: 1);
    final request = await commentRepository.postComment(commentModel);
    request.fold(
      (error) {},
      (response) {
        final responseData = response.data['data'];
        CommentModel newComment = CommentModel.fromJson(responseData);

        final updatedComments = [
          newComment.copyWith(
            timeConvert: newComment.createdAt != null
                ? getTimeDifference(newComment.createdAt!)
                : null,
          ),
          ...state.listComments?.map((comment) {
                return comment.copyWith(
                  timeConvert: comment.createdAt != null
                      ? getTimeDifference(comment.createdAt!)
                      : null,
                );
              }).toList() ??
              [],
        ];

        emit(state.copyWith(
          listComments: updatedComments.cast<CommentModel>(),
          status: VideoDetailStatus.success,
        ));
      },
    );
  }

  void onVideoDetailLikeComment(
    VideoDetailLikeComment event,
    Emitter<VideoDetailState> emit,
  ) async {
    final comment = event.comment;

    if (comment.likeStatus == LikeStatus.unknown) {
      final updatedComment = comment.copyWith(
          likeStatus: LikeStatus.liked,
          isLike: true,
          numberOfLike: (comment.numberOfLike ?? 0) + 1);
      final result =
          await commentRepository.postCommentReaction(updatedComment);

      if (result.isRight()) {
        emit(
          state.copyWith(
            listComments: updateCommentList(state.listComments, updatedComment),
          ),
        );
      }
    } else if (comment.likeStatus == LikeStatus.liked) {
      final result =
          await commentRepository.deleteCommentReaction(comment.id ?? 0);
      if (result.isRight()) {
        final updatedComment = comment.copyWith(
            likeStatus: LikeStatus.unknown,
            numberOfLike: (comment.numberOfLike ?? 0) - 1);
        emit(
          state.copyWith(
            listComments: updateCommentList(state.listComments, updatedComment),
          ),
        );
      }
    } else if (comment.likeStatus == LikeStatus.unliked) {
      final updatedComment = comment.copyWith(
          likeStatus: LikeStatus.liked,
          isLike: true,
          numberOfLike: (comment.numberOfLike ?? 0) + 1);
      final result =
          await commentRepository.patchCommentReaction(updatedComment);

      if (result.isRight()) {
        emit(
          state.copyWith(
            listComments: updateCommentList(state.listComments, updatedComment),
          ),
        );
      }
    }
  }

  void onVideoDetailDisLikeComment(
    VideoDetailDisLikeComment event,
    Emitter<VideoDetailState> emit,
  ) async {
    final comment = event.comment;

    if (comment.likeStatus == LikeStatus.unknown) {
      final updatedComment = comment.copyWith(
        isLike: false,
        likeStatus: LikeStatus.unliked,
      );
      final result =
          await commentRepository.postCommentReaction(updatedComment);

      if (result.isRight()) {
        emit(
          state.copyWith(
            listComments: updateCommentList(state.listComments, updatedComment),
          ),
        );
      }
    } else if (comment.likeStatus == LikeStatus.unliked) {
      final result =
          await commentRepository.deleteCommentReaction(comment.id ?? 0);

      if (result.isRight()) {
        final updatedComment = comment.copyWith(
          likeStatus: LikeStatus.unknown,
        );
        emit(
          state.copyWith(
            listComments: updateCommentList(state.listComments, updatedComment),
          ),
        );
      }
    } else if (comment.likeStatus == LikeStatus.liked) {
      final updatedComment = comment.copyWith(
        isLike: false,
        likeStatus: LikeStatus.unliked,
        numberOfLike: (comment.numberOfLike ?? 0) > 0
            ? (comment.numberOfLike ?? 0) - 1
            : 0,
      );
      final result =
          await commentRepository.patchCommentReaction(updatedComment);

      if (result.isRight()) {
        emit(
          state.copyWith(
            listComments: updateCommentList(state.listComments, updatedComment),
          ),
        );
      }
    }
  }

  String getTimeDifference(DateTime createdAt) {
    final now = DateTime.now().toUtc();
    final createdAtUtc = createdAt.toUtc();
    final difference = now.difference(createdAtUtc);

    if (difference.isNegative) {
      return Constants.justNow;
    }

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} ${Constants.secondsAgo}';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${Constants.minutesAgo}';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${Constants.hoursAgo}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${Constants.daysAgo}';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} ${Constants.weeksAgo}';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}  ${Constants.monthsAgo}';
    } else {
      return '${(difference.inDays / 365).floor()} ${Constants.yeasAgo}';
    }
  }

  List<CommentModel> updateCommentList(
      List<CommentModel>? comments, CommentModel updatedComment) {
    return comments
            ?.map((c) => c.id == updatedComment.id ? updatedComment : c)
            .toList() ??
        [];
  }

  void _onVideoDetailRateEvent(
      VideoDetailRateEvent event, Emitter<VideoDetailState> emit) {
    emit(state.copyWith(rateSelected: event.rating));
  }

  void _onVideoDetailRateSubmitEvent(
      VideoDetailRateSubmitEvent event, Emitter<VideoDetailState> emit) async {
    final rateResult = await videoRepository.rateVideo(8, event.rating);
    rateResult.fold((l) {
      emit(state.copyWith(errorMessage: l));
    }, (r) {
      emit(state.copyWith(
        status: VideoDetailStatus.rateSuccess,
        rateSelected: r,
      ));
    });
  }

  void _onVideoDetailFollowChannelEvent(VideoDetailFollowChannelEvent event,
      Emitter<VideoDetailState> emit) async {
    emit(state.copyWith(status: VideoDetailStatus.processing));
    if (state.video?.channel?.isFollowed == true) {
      final result = await viewChannelRepository
          .unFollowChannel(state.video?.channel?.id ?? 0);
      result.fold((l) {
        emit(state.copyWith(
          status: VideoDetailStatus.failure,
          errorMessage: l,
        ));
      }, (r) {
        emit(state.copyWith(
          status: VideoDetailStatus.failure,
          video: state.video?.copyWith(
              channel: state.video?.channel?.copyWith(isFollowed: false)),
        ));
      });
    } else {
      final result = await viewChannelRepository
          .followChannel(state.video?.channel?.id ?? 0);
      result.fold((l) {
        emit(state.copyWith(
          status: VideoDetailStatus.failure,
          errorMessage: l,
        ));
      }, (r) {
        emit(state.copyWith(
          status: VideoDetailStatus.success,
          video: state.video?.copyWith(
              channel: state.video?.channel?.copyWith(isFollowed: true)),
        ));
      });
    }
  }
}
