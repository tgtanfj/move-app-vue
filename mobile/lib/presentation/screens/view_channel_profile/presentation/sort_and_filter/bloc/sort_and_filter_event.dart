import 'package:equatable/equatable.dart';

abstract class SortAndFilterEvent extends Equatable {
  const SortAndFilterEvent();

  @override
  List<Object> get props => [];
}

class SortAndFilterInitialEvent extends SortAndFilterEvent {}

class FetchSortFilterDataEvent extends SortAndFilterEvent {}

class LevelSelectedEvent extends SortAndFilterEvent {
  final int? levelId;

  const LevelSelectedEvent({this.levelId});

  @override
  List<Object> get props => [levelId ?? 0];
}

class CategorySelectedEvent extends SortAndFilterEvent {
  final int? categoryId;

  const CategorySelectedEvent({this.categoryId});

  @override
  List<Object> get props => [categoryId ?? 0];
}

class SortBySelectedEvent extends SortAndFilterEvent {
  final int? sortById;

  const SortBySelectedEvent({this.sortById});

  @override
  List<Object> get props => [sortById ?? 0];
}
