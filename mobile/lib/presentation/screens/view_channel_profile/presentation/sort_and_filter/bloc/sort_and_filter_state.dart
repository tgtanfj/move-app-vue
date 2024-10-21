import 'package:equatable/equatable.dart';
import 'package:move_app/constants/constants.dart';
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
        return Constants.allLevels;
      case WorkoutLevelType.beginner:
        return Constants.beginner;
      case WorkoutLevelType.intermediate:
        return Constants.intermediate;
      case WorkoutLevelType.advanced:
        return Constants.advanced;
    }
  }

  String get value {
    switch (this) {
      case WorkoutLevelType.allLevels:
        return Constants.allLevelsValue;
      case WorkoutLevelType.beginner:
        return Constants.beginnerValue;
      case WorkoutLevelType.intermediate:
        return Constants.intermediateValue;
      case WorkoutLevelType.advanced:
        return Constants.advancedValue;
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
        return Constants.mostRecent;
      case SortAndFilterType.viewsHighToLow:
        return Constants.viewsHighToLow;
      case SortAndFilterType.viewsLowToHigh:
        return Constants.viewsLowToHigh;
      case SortAndFilterType.durationHighToLow:
        return Constants.durationHighToLow;
      case SortAndFilterType.durationLowToHigh:
        return Constants.durationLowToHigh;
      case SortAndFilterType.ratingsHighToLow:
        return Constants.ratingsHighToLow;
      case SortAndFilterType.ratingsLowToHigh:
        return Constants.ratingsLowToHigh;
    }
  }

  String get value {
    switch (this) {
      case SortAndFilterType.mostRecent:
        return Constants.mostRecentValue;
      case SortAndFilterType.viewsHighToLow:
        return Constants.viewsHighToLowValue;
      case SortAndFilterType.viewsLowToHigh:
        return Constants.viewsLowToHighValue;
      case SortAndFilterType.durationHighToLow:
        return Constants.durationHighToLowValue;
      case SortAndFilterType.durationLowToHigh:
        return Constants.durationLowToHighValue;
      case SortAndFilterType.ratingsHighToLow:
        return Constants.ratingsHighToLowValue;
      case SortAndFilterType.ratingsLowToHigh:
        return Constants.ratingsLowToHighValue;
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
  final int? channelId;
  final int currentPage;

  const SortAndFilterState({
    this.status = SortAndFilterStatus.initial,
    this.videoModel,
    this.categories = const [],
    this.selectedLevel = WorkoutLevelType.allLevels,
    this.selectedCategory,
    this.selectedSortBy = SortAndFilterType.mostRecent,
    this.currentPage = 1,
    this.channelId,
  });

  @override
  List<Object?> get props => [
        status,
        categories,
        selectedLevel,
        selectedCategory,
        selectedSortBy,
        videoModel,
        currentPage,
        channelId
      ];

  static SortAndFilterState initialState() =>
      const SortAndFilterState(status: SortAndFilterStatus.initial);

  SortAndFilterState copyWith(
      {SortAndFilterStatus? status,
      List<VideoModel>? videoModel,
      List<CategoryModel>? categories,
      WorkoutLevelType? selectedLevel,
      CategoryModel? selectedCategory,
      SortAndFilterType? selectedSortBy,
      int? currentPage,
      int? channelId}) {
    return SortAndFilterState(
        status: status ?? this.status,
        categories: categories ?? this.categories,
        selectedLevel: selectedLevel ?? this.selectedLevel,
        selectedCategory: selectedCategory ?? this.selectedCategory,
        selectedSortBy: selectedSortBy ?? this.selectedSortBy,
        videoModel: videoModel ?? this.videoModel,
        currentPage: currentPage ?? this.currentPage,
        channelId: channelId ?? this.channelId);
  }
}
