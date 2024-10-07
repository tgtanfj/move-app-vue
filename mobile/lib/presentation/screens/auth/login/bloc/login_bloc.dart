import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/data/models/user_model.dart';
import 'package:move_app/data/repositories/auth_repository.dart';
import 'package:move_app/presentation/screens/auth/login/bloc/login_state.dart';
import 'package:move_app/utils/input_validation_helper.dart';

import '../../../../../constants/constants.dart';
import 'login_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authenticationRepository;

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
    final isShowEmailMessage =
        state.email != event.email ? false : state.isShowEmailMessage;
    final isShowPasswordMessage =
        state.password != event.password ? false : state.isShowPasswordMessage;
    emit(
      state.copyWith(
        email: event.email,
        password: event.password,
        isEnabled: event.email.isNotEmpty && event.password.isNotEmpty,
        isShowEmailMessage: isShowEmailMessage,
        isShowPasswordMessage: isShowPasswordMessage,
      ),
    );
  }

  void _onLoginWithGoogleEvent(LoginWithGoogleEvent event, Emitter emit) async {
    final user = await AuthRepository().googleLogin();
    user.fold((l) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: l,
      ));
    }, (r) {
      emit(state.copyWith(
        status: LoginStatus.success,
        googleAccount: user.toString(),
      ));
    });
  }

  void _onLoginWithFacebookEvent(
      LoginWithFacebookEvent event, Emitter emit) async {
    final facebookAccount = await AuthRepository().loginWithFacebook();
    facebookAccount.fold((l) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: l,
      ));
    }, (r) {
      emit(state.copyWith(
        status: LoginStatus.success,
        facebookAccount: facebookAccount.toString(),
      ));
    });
  }

  Future<void> _onLoginWithEmailPasswordEvent(
      LoginWithEmailPasswordEvent event, Emitter<LoginState> emit) async {
    final validEmail = InputValidationHelper.email.hasMatch(state.email);
    final validPassword =
        InputValidationHelper.password.hasMatch(state.password);
    emit(state.copyWith(status: LoginStatus.processing));
    final UserModel userModel = UserModel(
      email: state.email,
      password: state.password,
    );
    if (!validEmail && validPassword) {
      emit(state.copyWith(
          status: LoginStatus.failure,
          isShowEmailMessage: true,
          messageInputEmail: Constants.invalidEmail));
    } else if (validEmail && !validPassword) {
      emit(state.copyWith(
          status: LoginStatus.failure,
          isShowPasswordMessage: true,
          messageInputPassword: Constants.anInvalidPassword));
    } else if (!validEmail && !validPassword) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        isShowPasswordMessage: true,
        messageInputPassword: Constants.anInvalidPassword,
        isShowEmailMessage: true,
        messageInputEmail: Constants.invalidEmail,
      ));
    } else {
      final result =
          await authenticationRepository.loginWithEmailPassword(userModel);
      result.fold((l) {
        emit(
          state.copyWith(
            status: LoginStatus.failure,
            isShowPasswordMessage: true,
            messageInputPassword: l,
            isShowEmailMessage: true,
            messageInputEmail: l,
          ),
        );
      }, (r) {
        emit(state.copyWith(status: LoginStatus.success));
      });
    }
  }
}
