import 'package:bloc/bloc.dart';
import 'package:move_app/presentation/screens/notification/bloc/notification_event.dart';
import 'package:move_app/presentation/screens/notification/bloc/notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationState.initial()) {
    on<NotificationInitialEvent>(_onNotificationInitialEvent);
  }

  void _onNotificationInitialEvent(
      NotificationInitialEvent event, Emitter<NotificationState> emit) {}
}
