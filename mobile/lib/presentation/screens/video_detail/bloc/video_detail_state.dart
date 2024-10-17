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
  final String? errorMessage;
  final int? videoId;
  final String? option;
  final String? dataLink;
  final bool isCopied;

  const VideoDetailState({
    this.videoUrls,
    this.status,
    this.selectedQuality,
    this.errorMessage,
    this.videoId,
    this.option,
    this.dataLink,
    this.isCopied = false,
  });

  static VideoDetailState initial() => const VideoDetailState(
        status: VideoDetailStatus.initial,
        isCopied: false,
      );

  VideoDetailState copyWith({
    VideoDetailStatus? status,
    String? selectedQuality,
    Map<String, String>? videoUrls,
    String? errorMessage,
    int? videoId,
    String? option,
    String? dataLink,
    bool? isCopied,
  }) {
    return VideoDetailState(
      selectedQuality: selectedQuality ?? this.selectedQuality,
      status: status ?? this.status,
      videoUrls: videoUrls ?? this.videoUrls,
      errorMessage: errorMessage ?? this.errorMessage,
      videoId: videoId ?? this.videoId,
      option: option ?? this.option,
      dataLink: dataLink ?? this.dataLink,
      isCopied: isCopied ?? this.isCopied,
    );
  }

  @override
  List<Object?> get props => [
        status,
        selectedQuality,
        errorMessage,
        videoId,
        option,
        dataLink,
        isCopied,
      ];
}
