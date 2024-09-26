import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/presentation/screens/auth/login/bloc/login_state.dart';

import 'login_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState.initial()) {
    on<LoginInitialEvent>(_onLoginInitialEvent);
    on<LoginWithEmailVisibleEvent>(_onLoginWithEmailVisibleEvent);
  }

  void _onLoginInitialEvent(
      LoginInitialEvent event, Emitter<LoginState> emit) {}

  void _onLoginWithEmailVisibleEvent(
      LoginWithEmailVisibleEvent event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        status: LoginStatus.success,
        isVisible: !state.isVisible,
      ),
    );
  }
}
