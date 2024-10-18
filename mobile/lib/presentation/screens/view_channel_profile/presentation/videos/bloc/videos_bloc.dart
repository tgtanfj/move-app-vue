import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/data/models/video_model.dart';
import 'package:move_app/data/repositories/view_channel_profile_repository.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/videos/bloc/videos_event.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/videos/bloc/videos_state.dart';

class VideosBloc extends Bloc<VideosEvent, VideosState> {
  final videoRepository = ViewChannelProfileRepository();

  VideosBloc() : super(VideosState.initial()) {
    on<VideosInitialEvent>(_onVideosInitialEvent);
    on<LoadMoreVideosEvent>(_onLoadMoreVideosEvent);
    on<VideoSortedAndFiledEvent>(_onVideoSortedAndFiledEvent);
  }

  void _onVideosInitialEvent(
      VideosInitialEvent event, Emitter<VideosState> emit) async {
    emit(state.copyWith(status: VideosStatus.processing));

    final videosResult = await videoRepository.getViewChannelProfileVideos(2,
        page: state.currentPage);

    videosResult.fold((videoFailure) {
      emit(state.copyWith(status: VideosStatus.failure));
    }, (videos) {
      emit(state.copyWith(
        status: VideosStatus.success,
        videos: videos,
        currentPage: 1,
      ));
    });
  }

  void _onLoadMoreVideosEvent(
      LoadMoreVideosEvent event, Emitter<VideosState> emit) async {
    emit(state.copyWith(isLoading: true));

    final videosResult = await videoRepository.getViewChannelProfileVideos(2,
        page: state.currentPage + 1);
    videosResult.fold(
      (failure) {
        emit(state.copyWith(
          status: VideosStatus.failure,
          isLoading: false,
        ));
      },
      (newVideos) {
        final updatedVideos = [
          ...(state.videos ?? <VideoModel>[]),
          ...newVideos,
        ];
        emit(state.copyWith(
          status: VideosStatus.success,
          videos: updatedVideos,
          isLoading: false,
          currentPage: state.currentPage + 1,
        ));
      },
    );
  }

  void _onVideoSortedAndFiledEvent(
      VideoSortedAndFiledEvent event, Emitter<VideosState> emit) async {
    final videosResult = await videoRepository.getViewChannelProfileVideos(2,
        page: 1,
        categoryId: event.selectedCategory?.id,
        workoutLevel: event.selectedLevel.value,
        sortBy: event.selectedSortBy.value);

    videosResult.fold((videoFailure) {
      emit(state.copyWith(status: VideosStatus.failure));
    }, (videos) {
      emit(state.copyWith(
        status: VideosStatus.success,
        videos: videos,
        currentPage: 1,
        selectedCategory: event.selectedCategory,
        selectedLevel: event.selectedLevel,
        selectedSortBy: event.selectedSortBy,
      ));
    });
  }
}
