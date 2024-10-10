import 'package:equatable/equatable.dart';

enum VideosStatus {
  initial,
  loading,
  loaded,
  error,
}

final class VideosState extends Equatable {
  final VideosStatus? status;
  const VideosState({this.status});
  @override
  List<Object> get props => [];

  static VideosState initialState() =>
      const VideosState(
        status: VideosStatus.initial,
      );

  VideosState copyWith({
    VideosStatus? status,
  }) {
    return VideosState(
      status: status ?? this.status,
    );
  }
}
