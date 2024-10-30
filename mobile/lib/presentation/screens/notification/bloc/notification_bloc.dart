import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:move_app/data/data_sources/local/shared_preferences.dart';
import 'package:move_app/presentation/screens/notification/bloc/notification_event.dart';
import 'package:move_app/presentation/screens/notification/bloc/notification_state.dart';
import '../../../../data/data_sources/remote/notification_service.dart';
import '../../../../data/models/notification_model.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationService notificationService;
  StreamSubscription<NotificationModel>? _notificationSubscription;
  int? _lastTimestamp;

  NotificationBloc(this.notificationService)
      : super(NotificationState.initial()) {
    on<NotificationInitialEvent>(_onNotificationInitialEvent);
    on<NotificationsLoadMoreEvent>(_onNotificationsLoadMoreEvent);
    on<NotificationMarkAsReadEvent>(_onNotificationMarkAsReadEvent);
    on<NotificationReceivedEvent>(_onNotificationReceivedEvent);
  }

  Future<void> _onNotificationInitialEvent(
      NotificationInitialEvent event, Emitter<NotificationState> emit) async {
    emit(state.copyWith(status: NotificationStatus.processing));

    try {
      int userId = SharedPrefer().getUserId();
      List<NotificationModel> notifications =
          await notificationService.getLatestUserNotifications(userId, 20);

      _lastTimestamp =
          notifications.isNotEmpty ? notifications.last.timestamp : null;

      emit(state.copyWith(
        status: NotificationStatus.success,
        listNotifications: notifications,
      ));

      _subscribeToRealTimeNotifications(userId);
    } catch (error) {
      emit(state.copyWith(status: NotificationStatus.failure));
    }
  }

  Future<void> _onNotificationsLoadMoreEvent(
      NotificationsLoadMoreEvent event, Emitter<NotificationState> emit) async {
    if (state.status == NotificationStatus.processing || _lastTimestamp == null) {
      return;
    }

    try {
      emit(state.copyWith(status: NotificationStatus.processing));

      List<NotificationModel> moreNotifications =
          await notificationService.loadMoreNotifications(
              SharedPrefer().getUserId(), 20, _lastTimestamp!);

      if (moreNotifications.isNotEmpty) {
        _lastTimestamp = moreNotifications.last.timestamp;

        emit(state.copyWith(
          status: NotificationStatus.success,
          listNotifications: List.of(state.listNotifications ?? [])
            ..addAll(moreNotifications),
        ));
      } else {
        emit(state.copyWith(status: NotificationStatus.success));
      }
    } catch (error) {
      emit(state.copyWith(status: NotificationStatus.failure));
    }
  }

  void _onNotificationReceivedEvent(
      NotificationReceivedEvent event, Emitter<NotificationState> emit) {
    emit(state.copyWith(
      listNotifications: List.of(state.listNotifications ?? [])
        ..insert(0, event.notification),
    ));
  }

  void _subscribeToRealTimeNotifications(int userId) {
    _notificationSubscription = notificationService
        .listenForNewNotifications(userId)
        .listen((notification) {
      add(NotificationReceivedEvent(notification));
    });
  }

  @override
  Future<void> close() {
    _notificationSubscription?.cancel();
    return super.close();
  }

  Future<void> _onNotificationMarkAsReadEvent(NotificationMarkAsReadEvent event,
      Emitter<NotificationState> emit) async {
    try {
      int userId = SharedPrefer().getUserId();
      bool isUpdated =
          await notificationService.markNotificationAsRead(userId, event.key);

      if (isUpdated) {
        final updatedNotifications =
            (state.listNotifications ?? []).map((notification) {
          if (notification.key == event.key) {
            return notification.copyWith(isRead: true);
          }
          return notification;
        }).toList();

        emit(state.copyWith(
          status: NotificationStatus.success,
          listNotifications: updatedNotifications,
        ));
      } else {
        emit(state.copyWith(status: NotificationStatus.failure));
      }
    } catch (error) {
      emit(state.copyWith(status: NotificationStatus.failure));
    }
  }
}
