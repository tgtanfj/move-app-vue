import 'package:move_app/data/models/category_model.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/sort_and_filter/bloc/sort_and_filter_state.dart';

class VideosInitialEvent extends VideosEvent {
  final int channelId;

  const VideosInitialEvent({required this.channelId});

  List<Object?> get props => [channelId];
}

sealed class VideosEvent {
  const VideosEvent();
}

class VideoSortedAndFiledEvent extends VideosEvent {
  final WorkoutLevelType selectedLevel;
  final CategoryModel? selectedCategory;
  final SortAndFilterType selectedSortBy;

  const VideoSortedAndFiledEvent(
      {required this.selectedLevel,
      this.selectedCategory,
      required this.selectedSortBy});

  List<Object?> get props => [
        selectedLevel,
        selectedCategory,
        selectedSortBy,
      ];
}

class LoadMoreVideosEvent extends VideosEvent {}
