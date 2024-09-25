import 'package:bloc/bloc.dart';
import 'package:move_app/presentation/screens/setting/bloc/setting_event.dart';
import 'package:move_app/presentation/screens/setting/bloc/setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(SettingState.initial()) {
    on<SettingInitialEvent>(_onSettingInitialEvent);
  }

  void _onSettingInitialEvent(
      SettingInitialEvent event, Emitter<SettingState> emit) {}
}
