import 'package:equatable/equatable.dart';

import '../../../../data/models/notification_model.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();
}

final class NotificationInitialEvent extends NotificationEvent {
  @override
  List<Object?> get props => [];
}

final class NotificationClickItemEvent extends NotificationEvent {
  @override
  List<Object?> get props => [];
}

class NotificationsLoadMoreEvent extends NotificationEvent {
  @override
  List<Object?> get props => [];
}

final class NotificationMarkAsReadEvent extends NotificationEvent {
  final String key;

  const NotificationMarkAsReadEvent(this.key);

  @override
  List<Object?> get props => [key];
}
final class NotificationReceivedEvent extends NotificationEvent {
  final NotificationModel notification;

  const NotificationReceivedEvent(this.notification);

  @override
  List<Object?> get props => [notification];
}
class NotificationTimeUpdateEvent extends NotificationEvent {
  @override
  List<Object?> get props => [];
}

