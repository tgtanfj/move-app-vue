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

  const ViewChannelProfileState({this.status, this.channel});

  static ViewChannelProfileState initial() => const ViewChannelProfileState(
        status: ViewChannelProfileStatus.initial,
      );

  ViewChannelProfileState copyWith({
    ViewChannelProfileStatus? status,
    ChannelModel? channel,
  }) {
    return ViewChannelProfileState(
      status: status ?? this.status,
      channel: channel ?? this.channel,
    );
  }

  @override
  List<Object?> get props => [
        status,
        channel,
      ];
}
