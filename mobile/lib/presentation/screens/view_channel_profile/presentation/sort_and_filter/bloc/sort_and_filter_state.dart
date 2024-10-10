import 'package:equatable/equatable.dart';

enum SortAndFilterStatus {
  initial,
  loading,
  loaded,
  error,
}

class SortAndFilterState extends Equatable {
  final SortAndFilterStatus? status;
  final List<Map<String, dynamic>> levels;
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> sortBy;
  final int? selectedLevel;
  final int? selectedCategory;
  final int? selectedSortBy;

  const SortAndFilterState({
    this.status = SortAndFilterStatus.initial,
    this.levels = const [],
    this.categories = const [],
    this.sortBy = const [],
    this.selectedLevel,
    this.selectedCategory,
    this.selectedSortBy,
  });

  @override
  List<Object?> get props => [
        status,
        levels,
        categories,
        sortBy,
        selectedLevel,
        selectedCategory,
        selectedSortBy
      ];

  static SortAndFilterState initialState() =>
      const SortAndFilterState(status: SortAndFilterStatus.initial);

  SortAndFilterState copyWith({
    SortAndFilterStatus? status,
    List<Map<String, dynamic>>? levels,
    List<Map<String, dynamic>>? categories,
    List<Map<String, dynamic>>? sortBy,
    int? selectedLevel,
    int? selectedCategory,
    int? selectedSortBy,
  }) {
    return SortAndFilterState(
      status: status ?? this.status,
      levels: levels ?? this.levels,
      categories: categories ?? this.categories,
      sortBy: sortBy ?? this.sortBy,
      selectedLevel: selectedLevel ?? this.selectedLevel,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedSortBy: selectedSortBy ?? this.selectedSortBy,
    );
  }
}
