import 'package:equatable/equatable.dart';
import 'package:move_app/data/models/video_model.dart';

enum VideoDetailStatus {
  initial,
  processing,
  success,
  failure,
}

final class VideoDetailState extends Equatable {
  final VideoDetailStatus? status;
  final bool isShowVideo;
  final VideoModel? video;

  const VideoDetailState({
    this.video,
    this.status,
    this.isShowVideo = false,
  });
  static VideoDetailState initial() => const VideoDetailState(
        status: VideoDetailStatus.initial,
      );

  VideoDetailState copyWith({
    VideoDetailStatus? status,
    VideoModel? video,
    bool? isShowVideo,
  }) {
    return VideoDetailState(
      video: video ?? this.video,
      status: status ?? this.status,
      isShowVideo: isShowVideo ?? this.isShowVideo,
    );
  }

  @override
  List<Object?> get props => [status, video, isShowVideo];
}
