import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/data/repositories/forgot_password_repository.dart';
import 'package:move_app/utils/input_validation_helper.dart';

import 'create_new_password_event.dart';
import 'create_new_password_state.dart';

class CreatePasswordBloc
    extends Bloc<CreateNewPasswordEvent, CreateNewPasswordState> {
  final ForgotPasswordRepository forgotPasswordRepository;
  CreatePasswordBloc(this.forgotPasswordRepository)
      : super(CreateNewPasswordState.initial()) {
    on<CreateNewPasswordInitialEvent>(_onCreateNewPasswordInitialEvent);
    on<CreateNewPasswordChangedEvent>(_onCreateNewPasswordChangedEvent);
    on<CreateConfirmPasswordChangedEvent>(_onCreateConfirmPasswordChangedEvent);
    on<CreateNewPasswordSubmittedEvent>(_onCreateNewPasswordSubmittedEvent);
  }

  void _onCreateNewPasswordChangedEvent(CreateNewPasswordChangedEvent event,
      Emitter<CreateNewPasswordState> emit) {
    final isValid = InputValidationHelper().isPasswordValid(event.newPassword);
    // final isShowPasswordMessage = state.newPassword != event.newPassword
    //     ? false
    //     : state.isShowValidationError;

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
      Emitter<CreateNewPasswordState> emit) async {
    if (state.isPasswordValid && state.doPasswordsMatch) {
      emit(state.copyWith(
        isPasswordValid: true,
        doPasswordsMatch: true,
      ));

      final token = state.token;
      final result = await forgotPasswordRepository.sendResetPasswordLink(
        token,
        state.newPassword,
      );
      result.fold((failure) {
        emit(state.copyWith(
            isPasswordResetSuccessful: false, errorMessage: failure));
      }, (success) {
        emit(state.copyWith(isPasswordResetSuccessful: true, errorMessage: ''));
      });
    } else {
      emit(state.copyWith(showValidationError: true));
    }
  }

  FutureOr<void> _onCreateNewPasswordInitialEvent(
      CreateNewPasswordInitialEvent event,
      Emitter<CreateNewPasswordState> emit) {
    emit(state.copyWith(token: event.token));
  }
}
