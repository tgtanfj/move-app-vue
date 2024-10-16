import 'package:bloc/bloc.dart';
import 'package:move_app/data/data_sources/local/shared_preferences.dart';
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

  void _onHomeInitialEvent(HomeInitialEvent event, Emitter<HomeState> emit) {}

  void _onHomeSearchVideoEvent(
      HomeSearchVideoEvent event, Emitter<HomeState> emit) {
    emit(state.copyWith(isVisible: !state.isVisible));
  }

  Future<void> _onHomeLoadSearchHistoryEvent(
      HomeLoadSearchHistoryEvent event, Emitter<HomeState> emit) async {
    final history =
        await SharedPrefer.sharedPrefer.loadSearchHistory();
    emit(state.copyWith(searchHistory: history));
  }

  Future<void> _onHomeSaveSearchHistoryEvent(
      HomeSaveSearchHistoryEvent event, Emitter<HomeState> emit) async {
    final history =
        await SharedPrefer.sharedPrefer.loadSearchHistory();
    history.add(event.searchText);
    await SharedPrefer.sharedPrefer
        .saveSearchHistory(history);
    emit(state.copyWith(searchHistory: history));
  }

  Future<void> _onHomeRemoveSearchHistoryEvent(
      HomeRemoveSearchHistoryEvent event, Emitter<HomeState> emit) async {
    final history =
        await SharedPrefer.sharedPrefer.loadSearchHistory();

    history.remove(event.searchText);
    await SharedPrefer.sharedPrefer
        .saveSearchHistory(history);
    emit(state.copyWith(searchHistory: history));
  }
}
