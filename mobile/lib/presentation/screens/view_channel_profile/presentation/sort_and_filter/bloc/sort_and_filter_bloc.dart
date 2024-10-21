import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/data/models/category_model.dart';
import 'package:move_app/data/repositories/categories_repository.dart';
import 'package:move_app/data/repositories/view_channel_profile_repository.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/sort_and_filter/bloc/sort_and_filter_event.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/sort_and_filter/bloc/sort_and_filter_state.dart';

class SortAndFilterBloc extends Bloc<SortAndFilterEvent, SortAndFilterState> {
  final categoryRepository = CategoriesRepository();
  final videoRepository = ViewChannelProfileRepository();

  SortAndFilterBloc() : super(SortAndFilterState.initialState()) {
    on<SortAndFilterInitialEvent>(_onSortAndFilterInitialEvent);
    on<LevelSelectedEvent>(_onLevelSelectedEvent);
    on<CategorySelectedEvent>(_onCategorySelectedEvent);
    on<SortBySelectedEvent>(_onSortBySelectedEvent);
    on<FetchSortFilterDataEvent>(_onFetchSortFilterDataEvent);
    on<SortAndFilterConfirmedEvent>(_onSortAndFilterConfirmedEvent);
  }

  void _onSortAndFilterInitialEvent(
      SortAndFilterInitialEvent event, Emitter<SortAndFilterState> emit) {
    emit(state.copyWith(
      selectedCategory: event.selectedCategory,
      selectedLevel: event.selectedLevel,
      selectedSortBy: event.selectedSortBy,
      channelId: event.channelId,
    ));

    add(const FetchSortFilterDataEvent());
  }

  void _onFetchSortFilterDataEvent(
      FetchSortFilterDataEvent event, Emitter<SortAndFilterState> emit) async {
    emit(state.copyWith(status: SortAndFilterStatus.processing));

    try {
      final categoriesResult = await categoryRepository.getCategories();

      categoriesResult.fold(
        (failure) {
          emit(state.copyWith(status: SortAndFilterStatus.failure));
        },
        (categories) {
          if (categories.isNotEmpty) {
            categories.insert(
                0, CategoryModel(id: -1, title: 'All Categories'));
          }
          var index = categories.indexWhere(
              (element) => element.id == state.selectedCategory?.id);

          index = index < 0 ? 0 : index;
          emit(state.copyWith(
            selectedCategory: categories[index],
            categories: categories,
            status: SortAndFilterStatus.success,
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(status: SortAndFilterStatus.failure));
    }
  }

  void _onLevelSelectedEvent(
      LevelSelectedEvent event, Emitter<SortAndFilterState> emit) {
    emit(state.copyWith(selectedLevel: event.level));
  }

  void _onCategorySelectedEvent(
      CategorySelectedEvent event, Emitter<SortAndFilterState> emit) {
    emit(state.copyWith(selectedCategory: event.selectedCategory));
  }

  void _onSortBySelectedEvent(
      SortBySelectedEvent event, Emitter<SortAndFilterState> emit) {
    emit(state.copyWith(selectedSortBy: event.sortBy));
  }

  void _onSortAndFilterConfirmedEvent(SortAndFilterConfirmedEvent event,
      Emitter<SortAndFilterState> emit) async {
    emit(state.copyWith(status: SortAndFilterStatus.processing));

    final workoutLevel = state.selectedLevel == WorkoutLevelType.allLevels
        ? null
        : state.selectedLevel.value;
    final categoryId = state.selectedCategory?.id;
    final sortBy = state.selectedSortBy.value;
    final videosResult = await videoRepository.getViewChannelProfileVideos(
      state.channelId ?? 0,
      page: state.currentPage,
      workoutLevel: workoutLevel,
      categoryId: categoryId,
      sortBy: sortBy,
    );

    videosResult.fold((failure) {
      emit(state.copyWith(status: SortAndFilterStatus.failure));
    }, (videos) {
      emit(state.copyWith(
        status: SortAndFilterStatus.pop,
        videoModel: videos,
      ));
    });
  }
}
