import 'package:equatable/equatable.dart';

enum VideoDetailStatus {
  initial,
  processing,
  success,
  failure,
  rateSuccess,
}

final class VideoDetailState extends Equatable {
  final VideoDetailStatus? status;
  final String? selectedQuality;
  final Map<String, String>? videoUrls;
  final int? rateSelected;
  final String? errorMessage;

  const VideoDetailState({
    this.videoUrls,
    this.status,
    this.selectedQuality,
    this.rateSelected,
    this.errorMessage,
  });

  static VideoDetailState initial() => const VideoDetailState(
        status: VideoDetailStatus.initial,
      );

  VideoDetailState copyWith({
    VideoDetailStatus? status,
    String? selectedQuality,
    Map<String, String>? videoUrls,
    int? rateSelected,
    String? errorMessage,
  }) {
    return VideoDetailState(
      selectedQuality: selectedQuality ?? this.selectedQuality,
      status: status ?? this.status,
      videoUrls: videoUrls ?? this.videoUrls,
      rateSelected: rateSelected ?? this.rateSelected,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        selectedQuality,
        rateSelected,
        errorMessage,
      ];
}
