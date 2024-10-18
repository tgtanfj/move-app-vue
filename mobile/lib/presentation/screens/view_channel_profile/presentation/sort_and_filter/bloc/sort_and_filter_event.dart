import 'package:equatable/equatable.dart';
import 'package:move_app/data/models/category_model.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/sort_and_filter/bloc/sort_and_filter_state.dart';

abstract class SortAndFilterEvent extends Equatable {
  const SortAndFilterEvent();

  @override
  List<Object> get props => [];
}

class SortAndFilterInitialEvent extends SortAndFilterEvent {
    final WorkoutLevelType? selectedLevel;
  final CategoryModel? selectedCategory;
  final SortAndFilterType? selectedSortBy;

  const SortAndFilterInitialEvent(
      {this.selectedLevel ,
      this.selectedCategory, 
      this.selectedSortBy });

  @override
  List<Object> get props => [
        selectedLevel ?? 0,
        selectedCategory ?? 0,
        selectedSortBy ?? 0
      ];
}

class FetchSortFilterDataEvent extends SortAndFilterEvent {
  final int? initialCategoryId;

  const FetchSortFilterDataEvent({this.initialCategoryId});

  @override
  List<Object> get props => [initialCategoryId ?? 0];
}

class LevelSelectedEvent extends SortAndFilterEvent {
  final WorkoutLevelType? level;

  const LevelSelectedEvent({this.level});

  @override
  List<Object> get props => [level ?? 0];
}

class CategorySelectedEvent extends SortAndFilterEvent {
  final CategoryModel? selectedCategory;

  const CategorySelectedEvent({this.selectedCategory});

  @override
  List<Object> get props => [selectedCategory ?? 0];
}

class SortBySelectedEvent extends SortAndFilterEvent {
  final SortAndFilterType? sortBy;

  const SortBySelectedEvent({this.sortBy});

  @override
  List<Object> get props => [sortBy ?? 0];
}

class SortAndFilterConfirmedEvent extends SortAndFilterEvent {}
