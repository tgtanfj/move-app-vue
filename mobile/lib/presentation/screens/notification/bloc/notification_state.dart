import 'package:equatable/equatable.dart';

import '../../../../data/models/notification_model.dart';

enum NotificationStatus {
  initial,
  processing,
  success,
  failure,
}

final class NotificationState extends Equatable {
  final NotificationStatus? status;
  final List<NotificationModel>? listNotifications;

  const NotificationState({
    this.status,
    this.listNotifications,
  });

  static NotificationState initial() => const NotificationState(
        status: NotificationStatus.initial,
      );

  NotificationState copyWith({
    NotificationStatus? status,
    List<NotificationModel>? listNotifications,
  }) {
    return NotificationState(
        status: status ?? this.status,
        listNotifications: listNotifications ?? this.listNotifications);
  }

  @override
  List<Object?> get props => [status, listNotifications];
}
