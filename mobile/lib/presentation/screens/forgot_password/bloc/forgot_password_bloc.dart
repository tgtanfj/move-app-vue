import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/presentation/screens/forgot_password/bloc/forgot_password_event.dart';
import 'package:move_app/presentation/screens/forgot_password/bloc/forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordState.initial()) {
    on<ForgotPasswordEmailChanged>(_onForgotPasswordEmailChanged);
    on<ForgotPasswordSubmitted>(_onForgotPasswordSubmitted);
  }

  void _onForgotPasswordEmailChanged(
      ForgotPasswordEmailChanged event, Emitter<ForgotPasswordState> emit) {
    final isEmailValid = event.email.contains("@");
    emit(state.copyWith(isEmailValid: isEmailValid));
  }

  void _onForgotPasswordSubmitted(
      ForgotPasswordSubmitted event, Emitter<ForgotPasswordState> emit) {
    if (state.isEmailValid) {
      emit(state.copyWith(isEmailSent: true));
    }
  }


}
