import 'package:equatable/equatable.dart';

enum ViewChannelProfileStatus {
  initial,
  loading,
  loaded,
  error,
}

final class ViewChannelProfileState extends Equatable {
  final ViewChannelProfileStatus? status;
  const ViewChannelProfileState({this.status});
  @override
  List<Object> get props => [];

  static ViewChannelProfileState initialState() =>
      const ViewChannelProfileState(
        status: ViewChannelProfileStatus.initial,
      );

  ViewChannelProfileState copyWith({
    ViewChannelProfileStatus? status,
  }) {
    return ViewChannelProfileState(
      status: status ?? this.status,
    );
  }
}
