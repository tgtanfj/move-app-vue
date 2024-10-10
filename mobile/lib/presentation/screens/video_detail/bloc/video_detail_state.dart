import 'package:equatable/equatable.dart';
enum VideoDetailStatus {
  initial,
  processing,
  success,
  failure,
}

final class VideoDetailState extends Equatable {
  final VideoDetailStatus? status;
  final String? selectedQuality;
  final Map<String, String>? videoUrls;

  const VideoDetailState({
    this.videoUrls,
    this.status,
    this.selectedQuality,
  });
  static VideoDetailState initial() => const VideoDetailState(
        status: VideoDetailStatus.initial,
      );

  VideoDetailState copyWith({
    VideoDetailStatus? status,
    String? selectedQuality,
    Map<String, String>? videoUrls,
  }) {
    return VideoDetailState(
      selectedQuality: selectedQuality ?? this.selectedQuality,
      status: status ?? this.status,
      videoUrls: videoUrls ?? this.videoUrls,
    );
  }

  @override
  List<Object?> get props => [status, selectedQuality];
}
