import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:move_app/data/data_sources/local/shared_preferences.dart';
import 'package:move_app/data/models/category_model.dart';
import 'package:move_app/data/models/video_model.dart';
import 'package:move_app/data/repositories/category_repository.dart';
import 'package:move_app/data/repositories/video_repository.dart';
import 'package:move_app/presentation/screens/home/bloc/home_event.dart';
import 'package:move_app/presentation/screens/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState.initial()) {
    on<HomeInitialEvent>(_onHomeInitialEvent);
    on<HomeSearchVideoEvent>(_onHomeSearchVideoEvent);
    on<HomeSaveSearchHistoryEvent>(_onHomeSaveSearchHistoryEvent);
    on<HomeLoadSearchHistoryEvent>(_onHomeLoadSearchHistoryEvent);
    on<HomeRemoveSearchHistoryEvent>(_onHomeRemoveSearchHistoryEvent);
  }
  final CategoryRepository categoryRepository = CategoryRepository();
  final VideoRepository videoRepository = VideoRepository();
  void _onHomeInitialEvent(
      HomeInitialEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.processing));
    final result = await Future.wait([
      categoryRepository.getListTopCategory(),
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


  void _onHomeSearchVideoEvent(
      HomeSearchVideoEvent event, Emitter<HomeState> emit) {
    emit(state.copyWith(isVisible: !state.isVisible));
  }

  Future<void> _onHomeLoadSearchHistoryEvent(
      HomeLoadSearchHistoryEvent event, Emitter<HomeState> emit) async {
    final history = await SharedPrefer.sharedPrefer.loadSearchHistory();
    emit(state.copyWith(searchHistory: history));
  }

  Future<void> _onHomeSaveSearchHistoryEvent(
      HomeSaveSearchHistoryEvent event, Emitter<HomeState> emit) async {
    final history = await SharedPrefer.sharedPrefer.loadSearchHistory();
    history.add(event.searchText);
    await SharedPrefer.sharedPrefer.saveSearchHistory(history);
    emit(state.copyWith(searchHistory: history));
  }

  Future<void> _onHomeRemoveSearchHistoryEvent(
      HomeRemoveSearchHistoryEvent event, Emitter<HomeState> emit) async {
    final history = await SharedPrefer.sharedPrefer.loadSearchHistory();

    history.remove(event.searchText);
    await SharedPrefer.sharedPrefer.saveSearchHistory(history);
    emit(state.copyWith(searchHistory: history));
  }
}
