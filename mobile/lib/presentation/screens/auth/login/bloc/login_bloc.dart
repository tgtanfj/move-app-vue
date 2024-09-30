import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/data/models/user_model.dart';
import 'package:move_app/data/repositories/auth_repository.dart';
import 'package:move_app/presentation/screens/auth/login/bloc/login_state.dart';
import 'package:move_app/utils/input_validation_helper.dart';

import 'login_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationRepository authenticationRepository;

  LoginBloc({required this.authenticationRepository})
      : super(LoginState.initial()) {
    on<LoginInitialEvent>(_onLoginInitialEvent);
    on<LoginWithEmailVisibleEvent>(_onLoginWithEmailVisibleEvent);
    on<LoginChangeEmailPasswordEvent>(_onLoginChangeEmailPasswordEvent);
    on<LoginWithGoogleEvent>(_onLoginWithGoogleEvent);
    on<LoginWithFacebookEvent>(_onLoginWithFacebookEvent);
    on<LoginWithEmailPasswordEvent>(_onLoginWithEmailPasswordEvent);
  }

  void _onLoginInitialEvent(
      LoginInitialEvent event, Emitter<LoginState> emit) {}

  void _onLoginWithEmailVisibleEvent(
      LoginWithEmailVisibleEvent event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        isVisible: !state.isVisible,
      ),
    );
  }

  void _onLoginChangeEmailPasswordEvent(
      LoginChangeEmailPasswordEvent event, Emitter emit) async {
    final emailValid = InputValidationHelper.email.hasMatch(event.email);
    final passwordValid = InputValidationHelper.password.hasMatch(event.password);
    final isShowEmailMessage =
        state.email != event.email ? false : state.isShowEmailMessage;
    final isShowPasswordMessage =
        state.password != event.password ? false : state.isShowPasswordMessage;
    emit(
      state.copyWith(
        email: event.email,
        password: event.password,
        isEnabled: emailValid && passwordValid,
        isShowEmailMessage: isShowEmailMessage,
        isShowPasswordMessage: isShowPasswordMessage,
      ),
    );
  }

  void _onLoginWithGoogleEvent(LoginWithGoogleEvent event, Emitter emit) async {
    final user = await AuthenticationRepository().googleLogin();
    try {
      if (user != null) {
        emit(state.copyWith(
          status: LoginStatus.success,
          googleAccount: user.toString(),
        ));
      } else {
        emit(state.copyWith(
          status: LoginStatus.failure,
        ));
      }
    } catch (error) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  void _onLoginWithFacebookEvent(
      LoginWithFacebookEvent event, Emitter emit) async {
    final facebookAccount =
        await AuthenticationRepository().loginWithFacebook();
    try {
      if (facebookAccount != null) {
        emit(state.copyWith(
          status: LoginStatus.success,
          facebookAccount: facebookAccount.toString(),
        ));
      } else {
        emit(state.copyWith(
          status: LoginStatus.failure,
        ));
      }
    } catch (error) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _onLoginWithEmailPasswordEvent(
      LoginWithEmailPasswordEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStatus.processing));
    final UserModel userModel = UserModel(
      email: state.email,
      password: state.password,
    );
    try {
      await authenticationRepository.loginWithEmailPassword(userModel);
      emit(state.copyWith(
        status: LoginStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        isShowPasswordMessage: true,
        messageInputPassword: e.toString(),
        isShowEmailMessage: true,
        messageInputEmail: e.toString(),
      ));
    }
  }
}
