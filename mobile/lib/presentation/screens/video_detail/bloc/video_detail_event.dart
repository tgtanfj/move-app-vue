import 'package:equatable/equatable.dart';

sealed class VideoDetailEvent extends Equatable {
  const VideoDetailEvent();
}

final class VideoDetailInitialEvent extends VideoDetailEvent {
  final int videoId;
  const VideoDetailInitialEvent({required this.videoId});
  @override
  List<Object?> get props => [videoId];
}
