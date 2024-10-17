import 'package:bloc/bloc.dart';
import 'package:move_app/data/repositories/share_repository.dart';
import 'package:move_app/presentation/screens/video_detail/bloc/video_detail_event.dart';
import 'package:move_app/presentation/screens/video_detail/bloc/video_detail_state.dart';

class VideoDetailBloc extends Bloc<VideoDetailEvent, VideoDetailState> {
  final ShareRepository shareRepository = ShareRepository();

  VideoDetailBloc() : super(VideoDetailState.initial()) {
    on<VideoDetailInitialEvent>(_onVideoDetailInitialEvent);
    on<VideoDetailSelectQualityEvent>(_onVideoDetailSelectQualityEvent);
    on<VideoDetailShareSocialEvent>(_onVideoDetailShareSocialEvent);
  }

  void _onVideoDetailInitialEvent(
      VideoDetailInitialEvent event, Emitter<VideoDetailState> emit) async {}

  void _onVideoDetailSelectQualityEvent(
      VideoDetailSelectQualityEvent event, Emitter<VideoDetailState> emit) {}

  void _onVideoDetailShareSocialEvent(VideoDetailShareSocialEvent event,
      Emitter<VideoDetailState> emit) async {
    final result =
        await shareRepository.sharingVideo(event.videoId, event.option);
    print(result);
    result.fold((l) {
      emit(state.copyWith(
        status: VideoDetailStatus.failure,
        errorMessage: l,
      ));
    }, (r) {
      emit(state.copyWith(
        status: VideoDetailStatus.success,
        dataLink: r,
      ));
    });
  }

}
