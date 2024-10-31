import 'package:bloc/bloc.dart';
import 'package:move_app/data/repositories/videos_repository.dart';
import 'package:move_app/presentation/screens/videos_category/bloc/videos_category_event.dart';
import 'package:move_app/presentation/screens/videos_category/bloc/videos_category_state.dart';

class VideosCategoryBloc
    extends Bloc<VideosCategoryEvent, VideosCategoryState> {
  VideosCategoryBloc() : super(VideosCategoryState.initial()) {
    on<VideosCategoryInitialEvent>(_onVideosCategoryInitialEvent);
    on<VideosCategoryLoadMoreEvent>(_onVideosCategoryLoadMoreEvent);
  }
  final VideosRepository categoriesRepository = VideosRepository();
  void _onVideosCategoryInitialEvent(VideosCategoryInitialEvent event,
      Emitter<VideosCategoryState> emit) async {
    emit(state.copyWith(status: VideosCategoryStatus.processing));

    final result = await categoriesRepository.getListVideoOfCategory(
        categoryId: event.categoryId, page: state.page ?? 1);
    result.fold((l) {
      emit(state.copyWith(
        status: VideosCategoryStatus.failure,
      ));
    }, (r) {
      emit(state.copyWith(
        listVideoCategory: r,
      ));
    });
  }

  void _onVideosCategoryLoadMoreEvent(VideosCategoryLoadMoreEvent event,
      Emitter<VideosCategoryState> emit) async {
    emit(state.copyWith(
      status: VideosCategoryStatus.processing,
    ));

    final result = await categoriesRepository.getListVideoOfCategory(
        categoryId: state.categoryId ?? 0, page: state.page ?? 1 + 1);
    result.fold((l) {
      emit(state.copyWith());
    }, (r) {
      emit(state.copyWith(
        listVideoCategory: [...?state.listVideoCategory, ...r],
        page: state.page! + 1,
      ));
    });
  }
}
