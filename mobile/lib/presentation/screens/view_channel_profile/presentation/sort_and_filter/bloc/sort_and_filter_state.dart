import 'package:equatable/equatable.dart';
import 'package:move_app/data/models/category_model.dart';
import 'package:move_app/data/models/video_model.dart';

enum WorkoutLevelType {
  allLevels,
  beginner,
  intermediate,
  advanced;

  String get title {
    switch (this) {
      case WorkoutLevelType.allLevels:
        return 'All Levels';
      case WorkoutLevelType.beginner:
        return 'Beginner';
      case WorkoutLevelType.intermediate:
        return 'Intermediate';
      case WorkoutLevelType.advanced:
        return 'Advanced';
    }
  }

  String get value {
    switch (this) {
      case WorkoutLevelType.allLevels:
        return 'all-level';
      case WorkoutLevelType.beginner:
        return 'beginner';
      case WorkoutLevelType.intermediate:
        return 'intermediate';
      case WorkoutLevelType.advanced:
        return 'advanced';
    }
  }
}

enum SortAndFilterType {
  mostRecent,
  viewsHighToLow,
  viewsLowToHigh,
  durationHighToLow,
  durationLowToHigh,
  ratingsHighToLow,
  ratingsLowToHigh;

  String get title {
    switch (this) {
      case SortAndFilterType.mostRecent:
        return 'Most Recent';
      case SortAndFilterType.viewsHighToLow:
        return 'Views (High to Low)';
      case SortAndFilterType.viewsLowToHigh:
        return 'Views (Low to High)';
      case SortAndFilterType.durationHighToLow:
        return 'Duration (High to Low)';
      case SortAndFilterType.durationLowToHigh:
        return 'Duration (Low to High)';
      case SortAndFilterType.ratingsHighToLow:
        return 'Ratings (High to Low)';
      case SortAndFilterType.ratingsLowToHigh:
        return 'Ratings (Low to High)';
    }
  }

  String get value {
    switch (this) {
      case SortAndFilterType.mostRecent:
        return 'most-recent';
      case SortAndFilterType.viewsHighToLow:
        return 'views-high-to-low';
      case SortAndFilterType.viewsLowToHigh:
        return 'views-low-to-high';
      case SortAndFilterType.durationHighToLow:
        return 'duration-high-to-low';
      case SortAndFilterType.durationLowToHigh:
        return 'duration-low-to-high';
      case SortAndFilterType.ratingsHighToLow:
        return 'ratings-high-to-low';
      case SortAndFilterType.ratingsLowToHigh:
        return 'ratings-low-to-high';
    }
  }
}

enum SortAndFilterStatus {
  initial,
  processing,
  success,
  failure,
  pop,
}

class SortAndFilterState extends Equatable {
  final SortAndFilterStatus? status;
  final List<VideoModel>? videoModel;
  final List<CategoryModel> categories;
  final WorkoutLevelType selectedLevel;
  final CategoryModel? selectedCategory;
  final SortAndFilterType selectedSortBy;
  final int currentPage;

  const SortAndFilterState({
    this.status = SortAndFilterStatus.initial,
    this.videoModel,
    this.categories = const [],
    this.selectedLevel = WorkoutLevelType.allLevels,
    this.selectedCategory ,
    this.selectedSortBy = SortAndFilterType.mostRecent,
    this.currentPage = 1,
  });

  @override
  List<Object?> get props => [
        status,
        categories,
        selectedLevel,
        selectedCategory,
        selectedSortBy,
        videoModel,
        currentPage
      ];

  static SortAndFilterState initialState() =>
      const SortAndFilterState(status: SortAndFilterStatus.initial);

  SortAndFilterState copyWith({
    SortAndFilterStatus? status,
    List<VideoModel>? videoModel,
    List<CategoryModel>? categories,
    WorkoutLevelType? selectedLevel,
    CategoryModel? selectedCategory,
    SortAndFilterType? selectedSortBy,
    int? currentPage,
  }) {
    return SortAndFilterState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      selectedLevel: selectedLevel ?? this.selectedLevel,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedSortBy: selectedSortBy ?? this.selectedSortBy,
      videoModel: videoModel ?? this.videoModel,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
