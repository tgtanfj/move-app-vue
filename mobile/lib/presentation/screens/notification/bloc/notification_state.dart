import 'package:equatable/equatable.dart';

enum NotificationStatus {
  initial,
  processing,
  success,
  failure,
}

final class NotificationState extends Equatable {
  final NotificationStatus? status;

  const NotificationState({
    this.status,
  });

  static NotificationState initial() => const NotificationState(
        status: NotificationStatus.initial,
      );

  NotificationState copyWith({
    NotificationStatus? status,
  }) {
    return NotificationState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        status,
      ];
}
