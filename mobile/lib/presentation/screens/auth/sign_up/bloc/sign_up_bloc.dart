import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/presentation/screens/auth/sign_up/bloc/sign_up_event.dart';
import 'package:move_app/presentation/screens/auth/sign_up/bloc/sign_up_state.dart';

import '../../../../../data/repositories/auth_repository.dart';
import '../../login/bloc/login_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(const SignUpState()) {
    on<SignUpClickSignUpWithEmailEvent>(onSignUpClickSignUpWithEmailEvent);
    on<SignUpValuesChangedEvent>(onSignUpValuesChangedEvent);
    on<SignUpWithFacebookEvent>(_onSignUpWithFacebookEvent);
    on<SignUpWithGoogleEvent>(_onSignUpWithGoogleEvent);
  }

  void onSignUpClickSignUpWithEmailEvent(
    SignUpClickSignUpWithEmailEvent event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(isClickSignUpWithEmail: true));
  }


  void onSignUpValuesChangedEvent(
    SignUpValuesChangedEvent event,
    Emitter<SignUpState> emit,
  ) {
    final signUpValues = state.copyWith(
      email: event.email,
      password: event.password,
      confirmPassword: event.confirmPassword,
      referralCode: event.referralCode,
    );

    final isEnableSignUp = signUpValues.email.isNotEmpty &&
        signUpValues.password.isNotEmpty &&
        signUpValues.confirmPassword.isNotEmpty &&
        signUpValues.referralCode.isNotEmpty &&
        signUpValues.email.contains("@");

    emit(signUpValues.copyWith(isEnableSignUp: isEnableSignUp));
  }

  void _onSignUpWithGoogleEvent(SignUpWithGoogleEvent event, Emitter emit) async {
    final user = await AuthenticationRepository().googleLogin();
    try {
      if (user != null) {
        emit(state.copyWith(
          status: SignUpStatus.success,
          googleAccount: user.toString(),
        ));
      } else {
        emit(state.copyWith(
          status: SignUpStatus.error,
        ));
      }
    } catch (error) {
      emit(state.copyWith(
        status: SignUpStatus.error,
      ));
    }
  }

  void _onSignUpWithFacebookEvent(
      SignUpWithFacebookEvent event, Emitter emit) async {
    final facebookAccount =
    await AuthenticationRepository().loginWithFacebook();
    try {
      if (facebookAccount != null) {
        emit(state.copyWith(
          status: SignUpStatus.success,
          facebookAccount: facebookAccount.toString(),
        ));
      } else {
        emit(state.copyWith(
          status: SignUpStatus.error,
        ));
      }
    } catch (error) {
      emit(state.copyWith(
        status: SignUpStatus.error,
      ));
    }
  }

}
