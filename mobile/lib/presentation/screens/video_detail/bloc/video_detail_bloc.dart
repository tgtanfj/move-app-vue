import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:move_app/data/models/video_model.dart';
import 'package:move_app/data/repositories/videos_repository.dart';
import 'package:move_app/presentation/screens/video_detail/bloc/video_detail_event.dart';
import 'package:move_app/presentation/screens/video_detail/bloc/video_detail_state.dart';

class VideoDetailBloc extends Bloc<VideoDetailEvent, VideoDetailState> {
  VideoDetailBloc() : super(VideoDetailState.initial()) {
    on<VideoDetailInitialEvent>(_onVideoDetailInitialEvent);
  }
  final VideosRepository videoDetailRepository = VideosRepository();
  void _onVideoDetailInitialEvent(
      VideoDetailInitialEvent event, Emitter<VideoDetailState> emit) async {
    emit(state.copyWith(
      status: VideoDetailStatus.processing,
    ));
    final result =
        await videoDetailRepository.getVideoDetail(videoId: event.videoId);
    result.fold((l) {
      emit(state.copyWith(status: VideoDetailStatus.failure));
    }, (r) {
      emit(
        state.copyWith(
          video: r,
          isShowVideo: true,
        ),
      );
    });
    emit(state.copyWith(
      status: VideoDetailStatus.success,
    ));
  }
}
