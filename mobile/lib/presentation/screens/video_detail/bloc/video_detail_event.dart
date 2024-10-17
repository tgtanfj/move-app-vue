import 'package:equatable/equatable.dart';

sealed class VideoDetailEvent extends Equatable {
  const VideoDetailEvent();
}

final class VideoDetailInitialEvent extends VideoDetailEvent {
  @override
  List<Object?> get props => [];
}

final class VideoDetailSelectQualityEvent extends VideoDetailEvent {
  final String selectedQuality;

  const VideoDetailSelectQualityEvent(this.selectedQuality);

  @override
  List<Object?> get props => [];
}

final class VideoDetailShareSocialEvent extends VideoDetailEvent {
  final int? videoId;
  final String? option;

  const VideoDetailShareSocialEvent({
    this.videoId,
    required this.option,
  });

  @override
  List<Object?> get props => [
        videoId,
        option,
      ];
}

