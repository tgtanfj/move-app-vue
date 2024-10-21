import 'package:equatable/equatable.dart';
import 'package:move_app/data/models/channel_model.dart';

enum ViewChannelProfileStatus {
  initial,
  processing,
  success,
  failure,
}

final class ViewChannelProfileState extends Equatable {
  final ViewChannelProfileStatus? status;
  final ChannelModel? channel;
  final String? errorMessage;

  const ViewChannelProfileState({
    this.status,
    this.channel,
    this.errorMessage,
  });

  static ViewChannelProfileState initial() => const ViewChannelProfileState(
        status: ViewChannelProfileStatus.initial,
      );

  ViewChannelProfileState copyWith({
    ViewChannelProfileStatus? status,
    ChannelModel? channel,
    String? errorMessage,
  }) {
    return ViewChannelProfileState(
      status: status ?? this.status,
      channel: channel ?? this.channel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        channel,
        errorMessage,
      ];
}
