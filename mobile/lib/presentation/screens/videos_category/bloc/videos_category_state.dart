import 'package:equatable/equatable.dart';
import 'package:move_app/data/models/video_model.dart';

enum VideosCategoryStatus {
  initial,
  processing,
  success,
  failure,
}

final class VideosCategoryState extends Equatable {
  final VideosCategoryStatus? status;
  final List<VideoModel>? listVideoCategory;
  final int? categoryId;
  final int? page;

  const VideosCategoryState({
    this.status,
    this.listVideoCategory,
    this.categoryId,
    this.page,
  });

  static VideosCategoryState initial() => const VideosCategoryState(
        status: VideosCategoryStatus.initial,
        page: 1,
      );


  VideosCategoryState copyWith({
    VideosCategoryStatus? status,
    List<VideoModel>? listVideoCategory,
    int? categoryId,
    int? page,
  }) {
    return VideosCategoryState(
      status: status ?? this.status,
      listVideoCategory: listVideoCategory ?? this.listVideoCategory,
      categoryId: categoryId ?? this.categoryId,
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props => [status, listVideoCategory, categoryId];
}
