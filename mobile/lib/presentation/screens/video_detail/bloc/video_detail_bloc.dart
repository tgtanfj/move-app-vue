import 'package:bloc/bloc.dart';
import 'package:move_app/data/repositories/video_detail_repository.dart';
import 'package:move_app/presentation/screens/video_detail/bloc/video_detail_event.dart';
import 'package:move_app/presentation/screens/video_detail/bloc/video_detail_state.dart';

class VideoDetailBloc extends Bloc<VideoDetailEvent, VideoDetailState> {
  final VideoDetailRepository videoRepository = VideoDetailRepository();

  VideoDetailBloc() : super(VideoDetailState.initial()) {
    on<VideoDetailInitialEvent>(_onVideoDetailInitialEvent);
    on<VideoDetailSelectQualityEvent>(_onVideoDetailSelectQualityEvent);
    on<VideoDetailRateEvent>(_onVideoDetailRateEvent);
    on<VideoDetailRateSubmitEvent>(_onVideoDetailRateSubmitEvent);
  }

  void _onVideoDetailInitialEvent(
      VideoDetailInitialEvent event, Emitter<VideoDetailState> emit) async {
    final getRateResult = await videoRepository.getRateByVideoId(8);
    getRateResult.fold((l) {
      emit(state.copyWith(errorMessage: l));
    }, (r) {
      emit(state.copyWith(rateSelected: r));
    });
  }

  void _onVideoDetailSelectQualityEvent(
      VideoDetailSelectQualityEvent event, Emitter<VideoDetailState> emit) {}

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
}
