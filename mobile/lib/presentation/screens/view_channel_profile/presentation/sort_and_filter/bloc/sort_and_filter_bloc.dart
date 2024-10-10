import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/sort_and_filter/bloc/sort_and_filter_event.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/sort_and_filter/bloc/sort_and_filter_state.dart';

class SortAndFilterBloc extends Bloc<SortAndFilterEvent, SortAndFilterState> {
  SortAndFilterBloc() : super(SortAndFilterState.initialState()) {
    on<SortAndFilterInitialEvent>(_onSortAndFilterInitialEvent);
    on<LevelSelectedEvent>(_onLevelSelectedEvent);
    on<CategorySelectedEvent>(_onCategorySelectedEvent);
    on<SortBySelectedEvent>(_onSortBySelectedEvent);
    on<FetchSortFilterDataEvent>(_onFetchSortFilterDataEvent);
  }

  void _onSortAndFilterInitialEvent(
      SortAndFilterEvent event, Emitter<SortAndFilterState> emit) {}

  void _onFetchSortFilterDataEvent(
      FetchSortFilterDataEvent event, Emitter<SortAndFilterState> emit) async {
    emit(state.copyWith(status: SortAndFilterStatus.loading));

    try {
      final levels = [
        {'id': 1, 'title': 'All Levels'},
        {'id': 2, 'title': 'Beginner'},
        {'id': 3, 'title': 'Intermediate'},
        {'id': 4, 'title': 'Advanced'},
      ];

      final categories = [
        {'id': 1, 'title': 'All Categories'},
        {'id': 2, 'title': 'Action'},
        {'id': 3, 'title': 'Drama'},
        {'id': 4, 'title': 'Comedy'},
      ];

      final sortBy = [
        {'id': 1, 'title': 'Most Recent'},
        {'id': 2, 'title': 'Views (High to Low)'},
        {'id': 3, 'title': 'Views (Low to High)'},
        {'id': 4, 'title': 'Duration (Long to Short)'},
        {'id': 5, 'title': 'Duration (Short to Long)'},
        {'id': 6, 'title': 'Ratings (High to Low)'},
        {'id': 7, 'title': 'Ratings (Low to High)'},
      ];

      emit(state.copyWith(
        status: SortAndFilterStatus.loaded,
        levels: levels,
        categories: categories,
        sortBy: sortBy,
      ));
    } catch (e) {
      emit(state.copyWith(status: SortAndFilterStatus.error));
    }
  }

  void _onLevelSelectedEvent(
      LevelSelectedEvent event, Emitter<SortAndFilterState> emit) {
    const currentState = SortAndFilterStatus.loaded;
    emit(state.copyWith(selectedLevel: event.levelId));
  }

  void _onCategorySelectedEvent(
      CategorySelectedEvent event, Emitter<SortAndFilterState> emit) {
    const currentState = SortAndFilterStatus.loaded;
    emit(state.copyWith(selectedCategory: event.categoryId));
  }

  void _onSortBySelectedEvent(
      SortBySelectedEvent event, Emitter<SortAndFilterState> emit) {
    const currentState = SortAndFilterStatus.loaded;
    emit(state.copyWith(selectedSortBy: event.sortById));
  }
}
