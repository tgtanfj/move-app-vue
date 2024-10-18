import 'package:equatable/equatable.dart';
import 'package:move_app/data/models/category_model.dart';
import 'package:move_app/data/models/channel_model.dart';
import 'package:move_app/data/models/video_model.dart';
import 'package:move_app/presentation/screens/view_channel_profile/presentation/sort_and_filter/bloc/sort_and_filter_state.dart';

enum VideosStatus { initial, processing, success, failure, loadingMore }

final class VideosState extends Equatable {
  final VideosStatus? status;
  final ChannelModel? channel;
  final List<VideoModel> videos;
  final WorkoutLevelType? selectedLevel;
  final CategoryModel? selectedCategory;
  final SortAndFilterType? selectedSortBy;
  final int currentPage;
  final String? errorMessage;
  final bool? isLoading;

  const VideosState(
      {this.status,
      this.channel,
      this.videos = const [],
      this.selectedLevel ,
      this.selectedCategory,
      this.selectedSortBy ,
      this.currentPage = 1,
      this.errorMessage,
      this.isLoading});

  static VideosState initial() => const VideosState(
        status: VideosStatus.initial,
      );

  VideosState copyWith(
      {VideosStatus? status,
      ChannelModel? channel,
      List<VideoModel>? videos,
      int? currentPage,
       WorkoutLevelType? selectedLevel,
   CategoryModel? selectedCategory,
   SortAndFilterType? selectedSortBy,
      String? errorMessage,
      bool? isLoading}) {
    return VideosState(
      status: status ?? this.status,
      channel: channel ?? this.channel,
      videos: videos ?? this.videos,
      currentPage: currentPage ?? this.currentPage,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedLevel: selectedLevel ?? this.selectedLevel,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedSortBy: selectedSortBy ?? this.selectedSortBy,
    );
  }

  @override
  List<Object?> get props => [
        status,
        channel,
        videos,
        currentPage,
        isLoading,
        errorMessage,
        selectedLevel,
        selectedCategory,
        selectedSortBy
      ];
}
