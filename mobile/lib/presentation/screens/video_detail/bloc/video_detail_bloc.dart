import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/models/video_model.dart';
import 'package:move_app/data/repositories/video_detail_repository.dart';
import 'package:move_app/data/repositories/view_channel_profile_repository.dart';
import 'package:move_app/data/repositories/share_repository.dart';
import 'package:move_app/presentation/screens/video_detail/bloc/video_detail_event.dart';
import 'package:move_app/presentation/screens/video_detail/bloc/video_detail_state.dart';

import '../../../../data/models/comment_model.dart';
import '../../../../data/repositories/comment_repository.dart';
import '../../../../utils/util_date_time.dart';

class VideoDetailBloc extends Bloc<VideoDetailEvent, VideoDetailState> {
  final ShareRepository shareRepository = ShareRepository();

  final VideoDetailRepository videoRepository = VideoDetailRepository();
  final ViewChannelProfileRepository viewChannelRepository =
      ViewChannelProfileRepository();

  final commentRepository = CommentRepository();

  VideoDetailBloc() : super(VideoDetailState.initial()) {
    on<VideoDetailInitialEvent>(_onVideoDetailInitialEvent);
    on<VideoDetailSelectQualityEvent>(_onVideoDetailSelectQualityEvent);
    on<VideoDetailShareSocialEvent>(_onVideoDetailShareSocialEvent);
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
  }

  void _onVideoDetailInitialEvent(
      VideoDetailInitialEvent event, Emitter<VideoDetailState> emit) async {
    emit(state.copyWith(
        status: VideoDetailStatus.processing,
        targetCommentId: event.targetCommentId,
        targetReplyId: event.targetReplyId));

    final result = await Future.wait([
      commentRepository.getListCommentVideo(event.videoId, limit: 30),
      videoRepository.getRateByVideoId(event.videoId),
      videoRepository.getVideoDetail(event.videoId),
      if (state.targetCommentId != null)
        commentRepository.getComment(state.targetCommentId ?? 0),
      if (state.targetReplyId != null)
        commentRepository.getComment(state.targetReplyId ?? 0),
      if (state.targetReplyId != null)
        commentRepository.getListRepliesComment(event.targetCommentId ?? 0,
            limit: 9, cursor: event.targetReplyId),
    ]);

    final listCommentVideo = result[0] as Either<String, List<CommentModel>>;
    listCommentVideo.fold(
      (error) {
        emit(state.copyWith(
            status: VideoDetailStatus.failure, errorMessage: error));
      },
      (comments) async {
        var updatedComments = comments.map((comment) {
          return comment.copyWith(
            createTimeConvert: comment.createdAt?.getTimeDifference(),
          );
        }).toList();

        final getRateResult = result[1] as Either<String, int>;
        getRateResult.fold((error) {
          emit(state.copyWith(errorMessage: error));
        }, (rate) {
          emit(state.copyWith(rateSelected: rate));
        });

        (result[2] as Either<String, VideoModel>).fold((error) {
          emit(state.copyWith(status: VideoDetailStatus.failure));
        }, (video) {
          emit(state.copyWith(
            video: video,
            isShowVideo: true,
            status: VideoDetailStatus.success,
          ));
        });

        if (state.targetCommentId != null) {
          final targetCommentResult = result[3] as Either<String, CommentModel>;
          targetCommentResult.fold((error) {}, (targetComment) {
            updatedComments
                .removeWhere((comment) => comment.id == targetComment.id);
            updatedComments.insert(
              0,
              targetComment.copyWith(
                createTimeConvert: targetComment.createdAt?.getTimeDifference(),
              ),
            );
          });
        }

        if (state.targetReplyId != null && state.targetCommentId != null) {
          final targetReplyResult = result[4] as Either<String, CommentModel>;
          final additionalRepliesResult =
              result[5] as Either<String, List<CommentModel>>;

          targetReplyResult.fold((error) {}, (targetReply) {
            additionalRepliesResult.fold((error) {}, (additionalReplies) {
              final newReplies = additionalReplies
                  .where((reply) => reply.id != state.targetReplyId)
                  .map((reply) => reply.copyWith(
                        createTimeConvert: reply.createdAt?.getTimeDifference(),
                      ))
                  .toList();

              final updatedTargetReply = targetReply.copyWith(
                createTimeConvert: targetReply.createdAt?.getTimeDifference(),
              );

              final updatedReplies = [updatedTargetReply, ...newReplies];

              emit(state.copyWith(
                replies: {
                  ...?state.replies,
                  state.targetCommentId!: updatedReplies,
                },
                isHiddenListReply: {
                  ...?state.isHiddenListReply,
                  state.targetCommentId!: true,
                },
              ));
            });
          });
        }

        final originalNumOfReplies = {
          for (var comment in updatedComments)
            comment.id: comment.numberOfReply,
        };
        final lastCommentId =
            updatedComments.isNotEmpty ? updatedComments.last.id : null;

        emit(state.copyWith(
          listComments: updatedComments,
          lastCommentId: lastCommentId,
          status: VideoDetailStatus.success,
          originalNumOfReply: originalNumOfReplies,
        ));
      },
    );
  }

  void _onVideoDetailSelectQualityEvent(
      VideoDetailSelectQualityEvent event, Emitter<VideoDetailState> emit) {}

  void _onVideoDetailShareSocialEvent(
      VideoDetailShareSocialEvent event, Emitter<VideoDetailState> emit) async {
    final result =
        await shareRepository.sharingVideo(event.videoId, event.option);
    if (event.option == Constants.twitterOption) {
      result.fold((l) {
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
    } else if (event.option == Constants.facebookOption) {
      result.fold((l) {
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
  }

  void onVideoDetailLoadMoreCommentEvent(VideoDetailLoadMoreCommentsEvent event,
      Emitter<VideoDetailState> emit) async {
    emit(state.copyWith(status: VideoDetailStatus.processing));
    final result = await commentRepository.getListCommentVideo(
        state.video?.id ?? 0,
        limit: 30,
        cursor: event.lastCommentId);
    result.fold((l) {
      emit(state.copyWith(status: VideoDetailStatus.failure));
    }, (r) {
      final newComments = r
          .map<CommentModel>((comment) {
            return comment.copyWith(
              createTimeConvert: comment.createdAt?.getTimeDifference(),
            );
          })
          .where((comment) => comment.id != state.targetCommentId)
          .toList();

      final updatedComments = [...state.listComments ?? [], ...newComments];

      final newNumOfReplies = {
        for (var comment in newComments) comment.id: comment.numberOfReply
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
            newComment.copyWith(
              createTimeConvert: newComment.createdAt?.getTimeDifference(),
            ),
            ...existingReplies.map((reply) {
              return reply.copyWith(
                createTimeConvert: reply.createdAt?.getTimeDifference(),
              );
            }),
          ];
          final updatedComments = state.listComments?.map((comment) {
            if (comment.id == event.commentId &&
                (state.originalNumOfReply?[event.commentId] ?? 0) > 0) {
              return comment.copyWith(
                numberOfReply: state.isShowTemporaryListReply
                    ? (comment.numberOfReply ?? 0) + 1
                    : (comment.numberOfReply ?? 0),
              );
            }
            return comment;
          }).toList();

          emit(state.copyWith(
              replies: {
                ...state.replies ?? {},
                commentModel.id!: updatedReplies.cast<CommentModel>(),
              },
              listComments: updatedComments,
              status: VideoDetailStatus.success,
              isShowTemporaryListReply: true));
        } else {
          final updatedComments = [
            newComment.copyWith(
              createTimeConvert: newComment.createdAt?.getTimeDifference(),
            ),
            ...state.listComments?.map((comment) {
                  return comment.copyWith(
                    createTimeConvert: comment.createdAt?.getTimeDifference(),
                  );
                }).toList() ??
                [],
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
    final result = await commentRepository.getListRepliesComment(
        event.commentId,
        limit: 10,
        cursor: event.lastIdReply);
    result.fold((l) {
      emit(state.copyWith(status: VideoDetailStatus.failure));
    }, (r) {
      final newReplies = r.map<CommentModel>((comment) {
        return comment.copyWith(
          createTimeConvert: comment.createdAt?.getTimeDifference(),
        );
      }).toList();
      final existingReplies = state.replies?[event.commentId] ?? [];
      final allReplies = [...existingReplies, ...newReplies];
      final updatedReplies = {
        ...?state.replies,
        event.commentId: allReplies,
      };
      final updateIsHiddenListReply = {
        ...?state.isHiddenListReply,
        event.commentId: true,
      };
      final updatedComments = state.listComments?.map((comment) {
        if (comment.id == event.commentId) {
          return comment.copyWith(numberOfReply: allReplies.length);
        }
        return comment;
      }).toList();
      emit(state.copyWith(
        replies: updatedReplies,
        isHiddenListReply: updateIsHiddenListReply,
        listComments: updatedComments,
      ));
    });
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

    final updatedComments = state.listComments?.map((comment) {
      if (comment.id == event.commentId) {
        var originalNumOfReply =
            state.originalNumOfReply?[event.commentId] ?? comment.numberOfReply;
        if (state.isShowTemporaryListReply) {
          originalNumOfReply = (originalNumOfReply ?? 0) + 1;
        }
        if ((comment.numberOfReply ?? 0) <= (originalNumOfReply ?? 0)) {
          return comment.copyWith(numberOfReply: originalNumOfReply);
        }
      }
      return comment;
    }).toList();

    emit(state.copyWith(
        replies: updatedReplies,
        isHiddenListReply: updateIsHiddenListReply,
        listComments: updatedComments,
        targetReplyId: 0,
        targetCommentId: 0,
        isShowTemporaryListReply: false));
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
