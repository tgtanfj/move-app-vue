import 'package:equatable/equatable.dart';
import 'package:move_app/data/models/category_model.dart';
import 'package:move_app/data/models/video_model.dart';

enum HomeStatus {
  initial,
  processing,
  success,
  failure,
}

final class HomeState extends Equatable {
  final HomeStatus? status;

  final List<CategoryModel> listTopCategory;
  final List<VideoModel> listMayULikeVideo;
  final List<VideoModel> listTrendVideo;
  final bool isShowListVideoTrend;
  final bool isLoadingPage;

  const HomeState({
    this.status,
    this.listTopCategory = const [],
    this.listMayULikeVideo = const [],
    this.listTrendVideo = const [],
    this.isShowListVideoTrend = false,
    this.isLoadingPage = true,
  });

  static HomeState initial() => const HomeState(
        status: HomeStatus.initial,
        listTopCategory: [],
        listMayULikeVideo: [],
        listTrendVideo: [],
        isShowListVideoTrend: false,
      );

  HomeState copyWith(
      {HomeStatus? status,
      List<CategoryModel>? listTopCategory,
      List<VideoModel>? listMayULikeVideo,
      List<VideoModel>? listTrendVideo,
      bool? isShowListVideoTrend,
      bool? isLoadingPage}) {
    return HomeState(
        status: status ?? this.status,
        listTopCategory: listTopCategory ?? this.listTopCategory,
        listMayULikeVideo: listMayULikeVideo ?? this.listMayULikeVideo,
        listTrendVideo: listTrendVideo ?? this.listTrendVideo,
        isShowListVideoTrend: isShowListVideoTrend ?? this.isShowListVideoTrend,
        isLoadingPage: isLoadingPage ?? this.isLoadingPage);
  }

  @override
  List<Object?> get props => [
        listTopCategory,
        status,
        listMayULikeVideo,
        listTrendVideo,
        isShowListVideoTrend,
        isLoadingPage
      ];
}
