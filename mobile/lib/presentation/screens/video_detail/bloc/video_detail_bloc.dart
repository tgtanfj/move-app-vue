import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/models/video_model.dart';
import 'package:move_app/data/repositories/share_repository.dart';
import 'package:move_app/data/repositories/video_detail_repository.dart';
import 'package:move_app/data/repositories/view_channel_profile_repository.dart';
import 'package:move_app/presentation/screens/video_detail/bloc/video_detail_event.dart';
import 'package:move_app/presentation/screens/video_detail/bloc/video_detail_state.dart';

import '../../../../data/models/comment_model.dart';
import '../../../../data/repositories/comment_repository.dart';

class VideoDetailBloc extends Bloc<VideoDetailEvent, VideoDetailState> {
  final ShareRepository shareRepository = ShareRepository();

  final VideoDetailRepository videoRepository = VideoDetailRepository();
  final ViewChannelProfileRepository viewChannelRepository =
      ViewChannelProfileRepository();
  final commentRepository = CommentRepository();

  VideoDetailBloc() : super(VideoDetailState.initial()) {
    on<VideoDetailInitialEvent>(_onVideoDetailInitialEvent);
    on<VideoDetailShareFacebookEvent>(_onVideoDetailShareFacebookEvent);
    on<VideoDetailShareTwitterEvent>(_onVideoDetailShareTwitterEvent);
    on<VideoDetailCommentChangedEvent>(onVideoDetailCommentChangedEvent);
    on<VideoDetailLoadMoreCommentsEvent>(onVideoDetailLoadMoreCommentEvent);
    on<VideoDetailPostCommentEvent>(onVideoDetailPostCommentEvent);
    on<VideoDetailRateEvent>(_onVideoDetailRateEvent);
    on<VideoDetailRateSubmitEvent>(_onVideoDetailRateSubmitEvent);
    on<VideoDetailLikeCommentEvent>(onVideoDetailLikeCommentEvent);
    on<VideoDetailDisLikeCommentEvent>(onVideoDetailDisLikeCommentEvent);
    on<VideoDetailLoadRepliesCommentEvent>(
        onVideoDetailLoadRepliesCommentEvent);
    on<VideoDetailHideRepliesCommentEvent>(
        onVideoDetailHideRepliesCommentEvent);
    on<VideoDetailReplyChangedEvent>(onVideoDetailReplyChangedEvent);
    on<VideoDetailHideInputReplyEvent>(onVideoDetailHideInputReplyEvent);
    on<VideoDetailFollowChannelEvent>(_onVideoDetailFollowChannelEvent);
    on<VideoDetailPopEvent>(_onVideoDetailPopEvent);
    on<VideoDetailDeleteCommentEvent>(onVideoDetailDeleteCommentEvent);
    on<VideoDetailClearTargetCommentEvent>(
        onVideoDetailClearTargetCommentEvent);
    on<VideoDetailLoad30CommentsEvent>(onVideoDetailLoad30CommentsEvent);
  }

  void _onVideoDetailInitialEvent(
      VideoDetailInitialEvent event, Emitter<VideoDetailState> emit) async {
    emit(state.copyWith(
        status: VideoDetailStatus.processing,
        targetCommentId: event.targetCommentId,
        targetReplyId: event.targetReplyId));
    final now = DateTime.now();

    final result = await Future.wait([
      commentRepository.getListCommentVideo(event.videoId, limit: 30),
      videoRepository.getRateByVideoId(event.videoId),
      videoRepository.getVideoDetail(event.videoId),
      videoRepository.postViewVideo(
          videoId: event.videoId,
          date: DateFormat('yyyy-MM-dd').format(now),
          viewTime: 0),
      if (state.targetCommentId != null)
        commentRepository.getComment(state.targetCommentId ?? 0),
      if (state.targetReplyId != null)
        commentRepository.getComment(state.targetReplyId ?? 0),
      if (state.targetReplyId != null)
        commentRepository.getListRepliesComment(event.targetCommentId ?? 0,
            limit: 9),
    ]);
    var updatedComments;
    final listCommentVideo = result[0] as Either<String, List<CommentModel>>;
    listCommentVideo.fold(
      (l) {
        emit(
            state.copyWith(status: VideoDetailStatus.failure, errorMessage: l));
      },
      (comments) async {
        updatedComments = comments;

        final originalNumOfReplies = {
          for (var comment in comments) comment.id: comment.numberOfReply,
        };

        final lastCommentId = comments.isNotEmpty ? comments.last.id : null;
        emit(state.copyWith(
          listComments: comments,
          lastCommentId: lastCommentId,
          status: VideoDetailStatus.success,
          originalNumOfReply: originalNumOfReplies,
        ));
      },
    );

    final getRateResult = result[1] as Either<String, int>;
    getRateResult.fold((l) {
      emit(state.copyWith(errorMessage: l));
    }, (r) {
      emit(state.copyWith(rateSelected: r));
    });
    (result[2] as Either<String, VideoModel>).fold((l) {
      emit(state.copyWith(
        status: VideoDetailStatus.failure,
      ));
    }, (r) {
      emit(state.copyWith(
        video: r,
        isShowVideo: true,
      ));
    });

    (result[3] as Either<String, bool>).fold((l) {
      emit(state.copyWith(
        status: VideoDetailStatus.failure,
      ));
    }, (r) {
      emit(state.copyWith(
        timeStarted: now,
        status: VideoDetailStatus.success,
      ));
    });

    if (state.targetCommentId != null) {
      final targetCommentResult = result[4] as Either<String, CommentModel>;
      targetCommentResult.fold(
        (l) {},
        (r) {
          updatedComments.removeWhere((comment) => comment.id == r.id);
          updatedComments.insert(0, r);
        },
      );

      final originalNumOfReplies = <int?, int?>{
        for (var comment in updatedComments) comment.id: comment.numberOfReply,
      };
      final lastCommentId =
          updatedComments.isNotEmpty ? updatedComments.last.id : null;

      emit(state.copyWith(
        listComments: updatedComments,
        lastCommentId: lastCommentId,
        status: VideoDetailStatus.success,
        originalNumOfReply: originalNumOfReplies,
      ));
    }
    if (state.targetCommentId != null && state.targetReplyId != null) {
      final targetReplyResult = result[5] as Either<String, CommentModel>;
      final listRepliesResult = result[6] as Either<String, List<CommentModel>>;

      targetReplyResult.fold(
        (l) {},
        (targetReply) {
          listRepliesResult.fold(
            (l) {},
            (replies) {
              final filteredReplies = replies
                  .where((reply) => reply.id != state.targetReplyId)
                  .toList();
              filteredReplies.insert(0, targetReply);

              final updatedReplies = {
                ...?state.replies,
                state.targetCommentId!: filteredReplies,
              };
              final updateIsHiddenListReply = {
                ...?state.isHiddenListReply,
                event.targetCommentId ?? 0: true,
              };
              emit(state.copyWith(
                replies: updatedReplies,
                isHiddenListReply: updateIsHiddenListReply,
              ));
            },
          );
        },
      );
    }
  }

  void _onVideoDetailShareFacebookEvent(VideoDetailShareFacebookEvent event,
      Emitter<VideoDetailState> emit) async {
    emit(state.copyWith(
      status: VideoDetailStatus.processing,
      twitterLink: '',
    ));
    final facebookLink = await shareRepository.sharingVideo(
        event.videoId, Constants.facebookOption);
    facebookLink.fold((l) {
      emit(state.copyWith(
        status: VideoDetailStatus.failure,
        errorMessage: l,
      ));
    }, (r) {
      emit(state.copyWith(
        status: VideoDetailStatus.success,
        facebookLink: r,
      ));
    });
  }

  void _onVideoDetailShareTwitterEvent(VideoDetailShareTwitterEvent event,
      Emitter<VideoDetailState> emit) async {
    emit(state.copyWith(
      status: VideoDetailStatus.processing,
      facebookLink: '',
    ));
    final twitterLink = await shareRepository.sharingVideo(
        event.videoId, Constants.twitterOption);
    twitterLink.fold((l) {
      emit(state.copyWith(
        status: VideoDetailStatus.failure,
        errorMessage: l,
      ));
    }, (r) {
      emit(state.copyWith(
        status: VideoDetailStatus.success,
        twitterLink: r,
      ));
    });
  }

  void onVideoDetailLoadMoreCommentEvent(VideoDetailLoadMoreCommentsEvent event,
      Emitter<VideoDetailState> emit) async {
    emit(state.copyWith(status: VideoDetailStatus.loading));
    print("Video Id: ${state.videoId}");
    print("Event Id: ${state.videoId}");

    final result = await commentRepository.getListCommentVideo(
        state.video?.id ?? 0,
        limit: 30,
        cursor: event.lastCommentId);
    result.fold((l) {
      emit(state.copyWith(status: VideoDetailStatus.failure));
    }, (r) {
      final updatedComments = state.targetCommentId != null
          ? mergeCommentsWithoutDuplicates(state.listComments, r)
          : [...state.listComments ?? [], ...r];

      final newNumOfReplies = {
        for (var comment in r) comment.id: comment.numberOfReply
      };
      final mergedNumOfReplies = {
        ...?state.originalNumOfReply,
        ...newNumOfReplies,
      };
      final lastCommentId =
          updatedComments.isNotEmpty ? updatedComments.last.id : null;
      emit(state.copyWith(
          listComments: updatedComments.cast<CommentModel>(),
          lastCommentId: lastCommentId,
          status: VideoDetailStatus.success,
          originalNumOfReply: mergedNumOfReplies));
    });
  }

  List<CommentModel> mergeCommentsWithoutDuplicates(
      List<CommentModel>? existingComments, List<CommentModel> newComments) {
    final existingIds =
        existingComments?.map((comment) => comment.id).toSet() ?? {};
    return [
      ...?existingComments,
      ...newComments.where((comment) => !existingIds.contains(comment.id)),
    ];
  }

  void onVideoDetailCommentChangedEvent(
      VideoDetailCommentChangedEvent event, Emitter<VideoDetailState> emit) {
    emit(state.copyWith(inputComment: event.content));
  }

  void onVideoDetailPostCommentEvent(
      VideoDetailPostCommentEvent event, Emitter<VideoDetailState> emit) async {
    CommentModel commentModel;

    if (event.commentId != null) {
      commentModel = CommentModel(
        content: state.inputReply?.trim(),
        id: event.commentId,
      );
    } else {
      commentModel = CommentModel(
        content: state.inputComment?.trim(),
        videoId: event.videoId,
      );
    }

    final request = await commentRepository.postComment(commentModel);
    request.fold(
      (error) {},
      (response) {
        final responseData = response.data['data'];
        CommentModel newComment = CommentModel.fromJson(responseData);

        if (commentModel.id != null) {
          final existingReplies = state.replies?[commentModel.id!] ?? [];

          final updatedReplies = [
            newComment,
            ...existingReplies,
          ];

          final updatedComments = state.listComments?.map((comment) {
            if (comment.id == event.commentId) {
              return comment.copyWith(
                numberOfReply: (comment.numberOfReply ?? 0) + 1,
              );
            }
            return comment;
          }).toList();

          //   isShowTemporaryListReply: {
          // ...state.isShowTemporaryListReply ?? {},
          // event.commentId ?? 0: updatedReplies.length > 1 ? false : true,
          emit(state.copyWith(
            replies: {
              ...state.replies ?? {},
              commentModel.id!: updatedReplies.cast<CommentModel>(),
            },
            listComments: updatedComments,
            status: VideoDetailStatus.success,
            isShowTemporaryListReply: {
              ...state.isShowTemporaryListReply ?? {},
              event.commentId ?? 0: true,
            },
          ));
        } else {
          final updatedComments = [
            newComment,
            ...state.listComments ?? [],
          ];

          emit(state.copyWith(
            listComments: updatedComments.cast<CommentModel>(),
            status: VideoDetailStatus.success,
          ));
        }
      },
    );
  }

  void onVideoDetailLikeCommentEvent(
    VideoDetailLikeCommentEvent event,
    Emitter<VideoDetailState> emit,
  ) async {
    final comment = event.comment;
    bool isReply = state.replies?.values
            .any((list) => list.any((reply) => reply.id == comment.id)) ??
        false;

    if (comment.likeStatus == LikeStatus.unknown) {
      final updatedComment = comment.copyWith(
        likeStatus: LikeStatus.liked,
        isLike: true,
        numberOfLike: (comment.numberOfLike ?? 0) + 1,
      );
      final result =
          await commentRepository.postCommentReaction(updatedComment);

      if (result.isRight()) {
        emit(
          state.copyWith(
            listComments: isReply
                ? state.listComments
                : updateCommentInComments(state.listComments, updatedComment),
            replies: isReply
                ? updateReplyInReplies(state.replies, updatedComment)
                : state.replies,
          ),
        );
      }
    } else if (comment.likeStatus == LikeStatus.liked) {
      final result = await commentRepository.deleteCommentReaction(comment.id!);

      if (result.isRight()) {
        final updatedComment = comment.copyWith(
          likeStatus: LikeStatus.unknown,
          numberOfLike: (comment.numberOfLike ?? 0) - 1,
        );

        emit(
          state.copyWith(
            listComments: isReply
                ? state.listComments
                : updateCommentInComments(state.listComments, updatedComment),
            replies: isReply
                ? updateReplyInReplies(state.replies, updatedComment)
                : state.replies,
          ),
        );
      }
    } else if (comment.likeStatus == LikeStatus.unliked) {
      final updatedComment = comment.copyWith(
        likeStatus: LikeStatus.liked,
        isLike: true,
        numberOfLike: (comment.numberOfLike ?? 0) + 1,
      );
      final result =
          await commentRepository.patchCommentReaction(updatedComment);

      if (result.isRight()) {
        emit(
          state.copyWith(
            listComments: isReply
                ? state.listComments
                : updateCommentInComments(state.listComments, updatedComment),
            replies: isReply
                ? updateReplyInReplies(state.replies, updatedComment)
                : state.replies,
          ),
        );
      }
    }
  }

  void onVideoDetailDisLikeCommentEvent(
    VideoDetailDisLikeCommentEvent event,
    Emitter<VideoDetailState> emit,
  ) async {
    final comment = event.comment;

    bool isReply = state.replies?.values
            .any((list) => list.any((reply) => reply.id == comment.id)) ??
        false;

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
            listComments: isReply
                ? state.listComments
                : updateCommentInComments(state.listComments, updatedComment),
            replies: isReply
                ? updateReplyInReplies(state.replies, updatedComment)
                : state.replies,
          ),
        );
      }
    } else if (comment.likeStatus == LikeStatus.unliked) {
      final result = await commentRepository.deleteCommentReaction(comment.id!);

      if (result.isRight()) {
        final updatedComment = comment.copyWith(
          likeStatus: LikeStatus.unknown,
        );
        emit(
          state.copyWith(
            listComments: isReply
                ? state.listComments
                : updateCommentInComments(state.listComments, updatedComment),
            replies: isReply
                ? updateReplyInReplies(state.replies, updatedComment)
                : state.replies,
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
            listComments: isReply
                ? state.listComments
                : updateCommentInComments(state.listComments, updatedComment),
            replies: isReply
                ? updateReplyInReplies(state.replies, updatedComment)
                : state.replies,
          ),
        );
      }
    }
  }

  void onVideoDetailLoadRepliesCommentEvent(
      VideoDetailLoadRepliesCommentEvent event,
      Emitter<VideoDetailState> emit) async {
    final existingReplies = state.replies?[event.commentId] ?? [];

    bool havePostReply = existingReplies.length == 1;
    final result = await commentRepository.getListRepliesComment(
        event.commentId,
        limit: 10,
        cursor: havePostReply ? null : event.lastIdReply);

    result.fold(
      (error) {
        emit(state.copyWith(status: VideoDetailStatus.failure));
      },
      (replies) {
        final filterReplies = replies
            .where((reply) =>
                !existingReplies.any((existing) => existing.id == reply.id))
            .toList();

        final allReplies = state.targetReplyId != null
            ? havePostReply
                ? filterReplies
                : [...existingReplies, ...filterReplies]
            : havePostReply
                ? replies
                : [...existingReplies, ...replies];

        final updatedReplies = {
          ...?state.replies,
          event.commentId: allReplies,
        };

        final updateIsHiddenListReply = {
          ...?state.isHiddenListReply,
          event.commentId: true,
        };

        emit(state.copyWith(
            replies: updatedReplies,
            isHiddenListReply: updateIsHiddenListReply,
            isShowTemporaryListReply: {
              ...state.isShowTemporaryListReply ?? {},
              event.commentId: false,
            }));
      },
    );
  }

  void onVideoDetailHideRepliesCommentEvent(
      VideoDetailHideRepliesCommentEvent event,
      Emitter<VideoDetailState> emit) {
    final updatedReplies = {...?state.replies};

    if (updatedReplies.containsKey(event.commentId)) {
      updatedReplies.remove(event.commentId);
    }

    final updateIsHiddenListReply = {
      ...?state.isHiddenListReply,
      event.commentId: false,
    };

    emit(state.copyWith(
        replies: updatedReplies,
        isHiddenListReply: updateIsHiddenListReply,
        isShowTemporaryListReply: {
          ...state.isShowTemporaryListReply ?? {},
          event.commentId: false,
        }));
  }

  void onVideoDetailReplyChangedEvent(
      VideoDetailReplyChangedEvent event, Emitter<VideoDetailState> emit) {
    emit(state.copyWith(inputReply: event.content));
  }

  void onVideoDetailHideInputReplyEvent(
      VideoDetailHideInputReplyEvent event, Emitter<VideoDetailState> emit) {
    final currentVisibilityMap = state.isHiddenInputReply ?? {};

    emit(state.copyWith(
      isHiddenInputReply: {
        ...currentVisibilityMap,
        event.commentId: event.isShowInput ? true : false,
      },
    ));
  }

  List<CommentModel> updateCommentInComments(
      List<CommentModel>? comments, CommentModel updatedComment) {
    return comments
            ?.map((c) => c.id == updatedComment.id ? updatedComment : c)
            .toList() ??
        [];
  }

  Map<int, List<CommentModel>> updateReplyInReplies(
      Map<int, List<CommentModel>>? currentReplies, CommentModel updatedReply) {
    final updatedReplies = currentReplies?.map((key, list) {
      return MapEntry(
        key,
        list
            .map((reply) => reply.id == updatedReply.id ? updatedReply : reply)
            .toList(),
      );
    });
    return updatedReplies ?? {};
  }

  void _onVideoDetailRateEvent(
      VideoDetailRateEvent event, Emitter<VideoDetailState> emit) {
    emit(state.copyWith(rateSelected: event.rating));
  }

  void _onVideoDetailRateSubmitEvent(
      VideoDetailRateSubmitEvent event, Emitter<VideoDetailState> emit) async {
    final rateResult =
        await videoRepository.rateVideo(state.video?.id ?? 0, event.rating);
    rateResult.fold((l) {
      emit(state.copyWith(errorMessage: l));
    }, (r) {
      emit(state.copyWith(
        status: VideoDetailStatus.rateSuccess,
        rateSelected: r,
      ));
    });
    if (state.status == VideoDetailStatus.rateSuccess) {
      final updateVideo =
          await videoRepository.getVideoDetail(state.video?.id ?? 0);
      updateVideo.fold((l) {
        emit(state.copyWith(
          errorMessage: l,
          status: VideoDetailStatus.failure,
        ));
      }, (r) {
        emit(state.copyWith(
          video: state.video?.copyWith(ratings: r.ratings),
          status: VideoDetailStatus.success,
        ));
      });
    }
  }

  void _onVideoDetailFollowChannelEvent(VideoDetailFollowChannelEvent event,
      Emitter<VideoDetailState> emit) async {
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
          status: VideoDetailStatus.success,
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

  void _onVideoDetailPopEvent(
      VideoDetailPopEvent event, Emitter<VideoDetailState> emit) async {
    emit(state.copyWith(isShowVideo: false));
    final now = DateTime.now();
    var viewTime =
        now.difference(state.timeStarted ?? DateTime.now()).inSeconds;
    if (viewTime > (state.video?.durationsVideo ?? 0 * 0.7)) {
      await videoRepository.postViewVideo(
        videoId: state.video?.id ?? 0,
        date: DateFormat('yyyy-MM-dd')
            .format(state.timeStarted ?? DateTime.now()),
        viewTime: 0,
      );
    }
    if (viewTime > (state.video?.durationsVideo ?? 0)) {
      viewTime = state.video?.durationsVideo ?? 0;
    }
    final result = await videoRepository.postViewVideo(
      videoId: state.video?.id ?? 0,
      date:
          DateFormat('yyyy-MM-dd').format(state.timeStarted ?? DateTime.now()),
      viewTime: viewTime,
    );
    result.fold((l) {
      emit(state.copyWith(
        status: VideoDetailStatus.failure,
        errorMessage: l,
      ));
    }, (r) {
      emit(state.copyWith(
        timeStarted: null,
        status: VideoDetailStatus.success,
      ));
    });
  }

  void onVideoDetailDeleteCommentEvent(VideoDetailDeleteCommentEvent event,
      Emitter<VideoDetailState> emit) async {
    final result = await commentRepository.deleteComment(event.commentId);

    result.fold(
      (error) {
        emit(state.copyWith(status: VideoDetailStatus.failure));
      },
      (_) {
        final updatedComments = state.listComments
            ?.map((comment) {
              if (comment.id == event.parenCommentId) {
                return comment.copyWith(
                    numberOfReply: (comment.numberOfReply ?? 0) - 1);
              }
              return comment;
            })
            .where((comment) => comment.id != event.commentId)
            .toList();

        final updatedReplies = <int, List<CommentModel>>{
          for (var entry in (state.replies ?? {}).entries)
            entry.key: entry.value
                .where((reply) => reply.id != event.commentId)
                .toList(),
        };

        emit(state.copyWith(
          listComments: updatedComments,
          replies: updatedReplies,
          status: VideoDetailStatus.success,
        ));
      },
    );
  }

  void onVideoDetailClearTargetCommentEvent(
      VideoDetailClearTargetCommentEvent event,
      Emitter<VideoDetailState> emit) async {
    emit(state.copyWith(targetReplyId: 0, targetCommentId: 0));
  }

  void onVideoDetailLoad30CommentsEvent(VideoDetailLoad30CommentsEvent event,
      Emitter<VideoDetailState> emit) async {
    final result =
        await commentRepository.getListCommentVideo(event.videoId, limit: 30);

    result.fold((l) {
      emit(state.copyWith(status: VideoDetailStatus.failure, errorMessage: l));
    }, (comments) {
      final originalNumOfReplies = {
        for (var comment in comments) comment.id: comment.numberOfReply,
      };

      final lastCommentId = comments.isNotEmpty ? comments.last.id : null;
      emit(state.copyWith(
        listComments: comments,
        lastCommentId: lastCommentId,
        status: VideoDetailStatus.success,
        originalNumOfReply: originalNumOfReplies,
      ));
    });
  }
}
