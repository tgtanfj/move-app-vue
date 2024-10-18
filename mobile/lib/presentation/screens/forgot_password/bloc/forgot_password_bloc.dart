import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/data/repositories/forgot_password_repository.dart';
import 'package:move_app/presentation/screens/forgot_password/bloc/forgot_password_event.dart';
import 'package:move_app/presentation/screens/forgot_password/bloc/forgot_password_state.dart';
import 'package:move_app/utils/input_validation_helper.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordRepository forgotPasswordRepository;
  Timer? timer;

  ForgotPasswordBloc(this.forgotPasswordRepository)
      : super(ForgotPasswordState.initial()) {
    on<ForgotPasswordEmailChangedEvent>(_onForgotPasswordEmailChanged);
    on<ForgotPasswordSubmittedEvent>(_onForgotPasswordSubmitted);
    on<ForgotPasswordStartTimerEvent>(_onForgotPasswordStartTimerEvent);
    // on<ForgotPasswordResendEvent>(_onForgotPasswordResendEvent);
  }

  void _onForgotPasswordEmailChanged(ForgotPasswordEmailChangedEvent event,
      Emitter<ForgotPasswordState> emit) {
    final isShowEmailMessage =
        state.email != event.email ? false : state.isShowEmailMessage;
    final isEmailValid =
        (InputValidationHelper.validateEmail(event.email) ?? "").isEmpty;
    emit(state.copyWith(
        isEmailValid: isEmailValid,
        email: event.email,
        isShowEmailMessage: isShowEmailMessage));
  }

  void _onForgotPasswordSubmitted(ForgotPasswordSubmittedEvent event,
      Emitter<ForgotPasswordState> emit) async {
    emit(state.copyWith(email: state.email.trim()));

    if (state.isEmailValid) {
      final emailExists =
          await forgotPasswordRepository.checkEmailExists(state.email.trim());
      if (emailExists) {
        emit(state.copyWith(
            isEmailSent: true, errorMessage: '', isShowEmailMessage: true));

        add(ForgotPasswordStartTimerEvent());
      } else {
        emit(state.copyWith(
            isEmailSent: false,
            errorMessage: 'Email does not found',
            isShowEmailMessage: true));
      }
    } else {
      emit(state.copyWith(
          isEmailSent: false,
          errorMessage: "Invalid email",
          isShowEmailMessage: true));
    }
  }

  void _onForgotPasswordStartTimerEvent(ForgotPasswordStartTimerEvent event,
      Emitter<ForgotPasswordState> emit) async {
    timer?.cancel();
    emit(state.copyWith(remainingSeconds: 60));
    await Future.forEach(List.generate(60, (index) => index), (index) async {
      await Future.delayed(const Duration(seconds: 1));
      if (emit.isDone) return;
      emit(state.copyWith(remainingSeconds: state.remainingSeconds - 1));
    });
  }

  @override
  Future<void> close() {
    timer?.cancel();
    return super.close();
  }
}
