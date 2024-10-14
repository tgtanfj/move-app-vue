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

class VideoDetailRateEvent extends VideoDetailEvent {
  final int rating;

  const VideoDetailRateEvent(this.rating);

  @override
  List<Object> get props => [rating];
}

class VideoDetailRateSubmitEvent extends VideoDetailEvent {
  final int rating;

  const VideoDetailRateSubmitEvent(this.rating);

  @override
  List<Object?> get props => [rating];
}
