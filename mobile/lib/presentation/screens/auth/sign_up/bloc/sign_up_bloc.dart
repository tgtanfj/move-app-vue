import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/presentation/screens/auth/sign_up/bloc/sign_up_event.dart';
import 'package:move_app/presentation/screens/auth/sign_up/bloc/sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(const SignUpState()) {
    on<SignUpClickSignUpWithEmailEvent>(onSignUpClickSignUpWithEmailEvent);
    on<SignUpClickShowPasswordEvent>(onSignUpClickShowPasswordEvent);
    on<SignUpClickShowConfirmPasswordEvent>(
        onSignUpClickShowConfirmPasswordEvent);
    on<SignUpEmailChangedEvent>(onSignUpEmailChangedEvent);
    on<SignUpPasswordChangedEvent>(onSignUpPasswordChangedEvent);
    on<SignUpConfirmPasswordChangedEvent>(onSignUpConfirmPasswordChangedEvent);
    on<SignUpReferralCodeChangedEvent>(onSignUpReferralCodeChangedEvent);
  }

  void onSignUpClickSignUpWithEmailEvent(
    SignUpClickSignUpWithEmailEvent event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(isClickSignUpWithEmail: true));
  }

  void onSignUpClickShowPasswordEvent(
    SignUpClickShowPasswordEvent event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(isShowPassword: !state.isShowPassword));
  }

  void onSignUpClickShowConfirmPasswordEvent(
    SignUpClickShowConfirmPasswordEvent event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(isShowConfirmPassword: !state.isShowConfirmPassword));
  }

  void onSignUpEmailChangedEvent(
    SignUpEmailChangedEvent event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(email: event.email));
  }

  void onSignUpPasswordChangedEvent(
    SignUpPasswordChangedEvent event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(password: event.password));
  }

  void onSignUpConfirmPasswordChangedEvent(
      SignUpConfirmPasswordChangedEvent event, Emitter<SignUpState> emit) {
    emit(state.copyWith(confirmPassword: event.confirmPassword));
  }

  void onSignUpReferralCodeChangedEvent(
      SignUpReferralCodeChangedEvent event, Emitter<SignUpState> emit) {
    emit(state.copyWith(referralCode: event.referralCode));
  }
}
