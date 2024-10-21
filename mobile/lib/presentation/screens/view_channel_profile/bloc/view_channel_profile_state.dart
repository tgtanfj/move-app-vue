import 'package:equatable/equatable.dart';
import 'package:move_app/data/models/channel_model.dart';
import 'package:move_app/data/models/video_model.dart';

enum ViewChannelProfileStatus {
  initial,
  processing,
  success,
  failure,
  loadingMore
}

final class ViewChannelProfileState extends Equatable {
  final ViewChannelProfileStatus? status;
  final ChannelModel? channel;
  final List<VideoModel>? videos;
  final int currentPage;
  final bool hasReachedMax;
  final String? errorMessage;
  final bool? isLoading;
  final int? channelId;
  const ViewChannelProfileState(
      {this.status,
      this.channel,
      this.videos,
      this.currentPage = 1,
      this.hasReachedMax = false,
      this.errorMessage,
      this.isLoading,
      this.channelId});

  static ViewChannelProfileState initial() => const ViewChannelProfileState(
        status: ViewChannelProfileStatus.initial,
      );

  ViewChannelProfileState copyWith({
    ViewChannelProfileStatus? status,
    ChannelModel? channel,
    List<VideoModel>? videos,
    int? currentPage,
    bool? hasReachedMax,
    String? errorMessage,
    bool? isLoading,
    int? channelId,
  }) {
    return ViewChannelProfileState(
        status: status ?? this.status,
        channel: channel ?? this.channel,
        videos: videos ?? this.videos,
        currentPage: currentPage ?? this.currentPage,
        isLoading: isLoading ?? this.isLoading,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        errorMessage: errorMessage ?? this.errorMessage,
        channelId: channelId ?? this.channelId);
  }

  @override
  List<Object?> get props => [
        status,
        channel,
        videos,
        currentPage,
        isLoading,
        hasReachedMax,
        errorMessage,
        channelId
      ];
}
