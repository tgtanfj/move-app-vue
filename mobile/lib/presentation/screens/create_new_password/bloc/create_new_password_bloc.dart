import 'package:flutter_bloc/flutter_bloc.dart';

import 'create_new_password_event.dart';
import 'create_new_password_state.dart';

class CreatePasswordBloc
    extends Bloc<CreateNewPasswordEvent, CreateNewPasswordState> {
  CreatePasswordBloc() : super(CreateNewPasswordState.initial()) {
    on<CreateNewPasswordChangedEvent>(_onCreateNewPasswordChangedEvent);
    on<CreateConfirmPasswordChangedEvent>(_onCreateConfirmPasswordChangedEvent);
    on<CreateNewPasswordSubmittedEvent>(_onCreateNewPasswordSubmittedEvent);
    on<CreateNewPasswordResetValidationErrorsEvent>(
        _onCreateNewPasswordResetValidationErrorsEvent);
  }

  void _onCreateNewPasswordChangedEvent(CreateNewPasswordChangedEvent event,
      Emitter<CreateNewPasswordState> emit) {
    final isValid = _isPasswordValid(event.newPassword);

    emit(state.copyWith(
      isPasswordValid: isValid,
      newPassword: event.newPassword,
      doPasswordsMatch: state.confirmNewPassword == event.newPassword,
    ));
    emit(state.copyWith(showValidationError: false));
  }

  void _onCreateConfirmPasswordChangedEvent(
      CreateConfirmPasswordChangedEvent event,
      Emitter<CreateNewPasswordState> emit) {
    emit(state.copyWith(
      confirmNewPassword: event.confirmPassword,
      doPasswordsMatch: state.newPassword == event.confirmPassword,
    ));
    emit(state.copyWith(showValidationError: false));
  }

  void _onCreateNewPasswordSubmittedEvent(CreateNewPasswordSubmittedEvent event,
      Emitter<CreateNewPasswordState> emit) {
    if (state.isPasswordValid && state.doPasswordsMatch) {
      emit(state.copyWith(
        isPasswordValid: true,
        doPasswordsMatch: true,
      ));
    } else {
      emit(state.copyWith(showValidationError: true));
    }
  }

  void _onCreateNewPasswordResetValidationErrorsEvent(
      CreateNewPasswordResetValidationErrorsEvent event,
      Emitter<CreateNewPasswordState> emit) {
    emit(state.copyWith(showValidationError: false));
  }

  bool _isPasswordValid(String password) {
    if (password.length < 8 || password.length > 32) return false;

    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigit = password.contains(RegExp(r'[0-9]'));
    final hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    return hasUppercase && hasLowercase && hasDigit && hasSpecial;
  }
}
