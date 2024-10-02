import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/data/repositories/forgot_password_repository.dart';
import 'package:move_app/presentation/screens/forgot_password/bloc/forgot_password_event.dart';
import 'package:move_app/presentation/screens/forgot_password/bloc/forgot_password_state.dart';
import 'package:move_app/utils/input_validation_helper.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordRepository forgotPasswordRepository;
  ForgotPasswordBloc(this.forgotPasswordRepository)
      : super(ForgotPasswordState.initial()) {
    on<ForgotPasswordEmailChanged>(_onForgotPasswordEmailChanged);
    on<ForgotPasswordSubmitted>(_onForgotPasswordSubmitted);
  }

  void _onForgotPasswordEmailChanged(
      ForgotPasswordEmailChanged event, Emitter<ForgotPasswordState> emit) {
    final isShowEmailMessage =
        state.email != event.email ? false : state.isShowEmailMessage;
    final isEmailValid = InputValidationHelper().isValidEmail(event.email);
    emit(state.copyWith(
        isEmailValid: isEmailValid,
        email: event.email,
        isShowEmailMessage: isShowEmailMessage));
  }

  void _onForgotPasswordSubmitted(
      ForgotPasswordSubmitted event, Emitter<ForgotPasswordState> emit) async {
    if (state.isEmailValid) {
      final emailExists =
          await forgotPasswordRepository.checkEmailExists(state.email);
      if (emailExists) {
        emit(state.copyWith(
            isEmailSent: true, errorMessage: '', isShowEmailMessage: true));
      } else {
        emit(state.copyWith(
            isEmailSent: true,
            errorMessage: 'Email does not found',
            isShowEmailMessage: true));
      }
    }

    // if (state.isEmailValid) {
    //   emit(state.copyWith(isEmailSent: true));
    // }
  }
}
