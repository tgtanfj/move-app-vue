import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:move_app/data/models/category_model.dart';
import 'package:move_app/data/models/video_model.dart';
import 'package:move_app/data/repositories/categories_repository.dart';
import 'package:move_app/data/repositories/videos_repository.dart';
import 'package:move_app/presentation/screens/home/bloc/home_event.dart';
import 'package:move_app/presentation/screens/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState.initial()) {
    on<HomeInitialEvent>(_onHomeInitialEvent);
  }
  final CategoriesRepository categoriesRepository = CategoriesRepository();
  final VideosRepository videoRepository = VideosRepository();
  void _onHomeInitialEvent(
      HomeInitialEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.processing));
    final result = await Future.wait([
      categoriesRepository.getListTopCategory(),
      videoRepository.getListYouMayLikeVideo(),
      videoRepository.getListTrendVideo(),
    ]);
    (result[0] as Either<String, List<CategoryModel>>).fold((l) {
      emit(state.copyWith(
        status: HomeStatus.failure,
      ));
    }, (r) {
      emit(state.copyWith(
        listTopCategory: r,
      ));
    });
    (result[1] as Either<String, List<VideoModel>>).fold((l) {
      emit(state.copyWith(
        status: HomeStatus.failure,
      ));
    }, (r) {
      emit(state.copyWith(
        listMayULikeVideo: r,
      ));
    });
    (result[2] as Either<String, List<VideoModel>>).fold((l) {
      emit(state.copyWith(
        status: HomeStatus.failure,
      ));
    }, (r) {
      emit(state.copyWith(
        listTrendVideo: r,
        isShowListVideoTrend: true,
      ));
    });
    emit(state.copyWith(status: HomeStatus.success));
  }
}
