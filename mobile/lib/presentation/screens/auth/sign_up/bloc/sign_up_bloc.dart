import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/models/user_model.dart';
import 'package:move_app/data/repositories/auth_repository.dart';
import 'package:move_app/presentation/screens/auth/sign_up/bloc/sign_up_event.dart';
import 'package:move_app/presentation/screens/auth/sign_up/bloc/sign_up_state.dart';
import 'package:move_app/utils/input_validation_helper.dart';

import '../../../../../data/services/api_service.dart';

import '../../../../../data/repositories/auth_repository.dart';
import '../../login/bloc/login_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(const SignUpState()) {
    on<SignUpClickSignUpWithEmailEvent>(onSignUpClickSignUpWithEmailEvent);
    on<SignUpValuesChangedEvent>(onSignUpValuesChangedEvent);
    on<SignUpWithEmailSubmitEvent>(onSignUpWithEmailSubmitEvent);

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
      inputEmail: event.email,
      inputPassword: event.password,
      inputConfirmPassword: event.confirmPassword,
      inputReferralCode: event.referralCode,
    );

    final isShowEmailMessage = state.inputEmail != signUpValues.inputEmail
        ? false
        : state.isShowEmailMessage;
    final isShowPasswordMessage =
        state.inputPassword != signUpValues.inputPassword
            ? false
            : state.isShowPasswordMessage;
    final isShowConfirmPasswordMessage =
        state.inputConfirmPassword != signUpValues.inputConfirmPassword
            ? false
            : state.isShowConfirmPasswordMessage;
    final isShowReferralCodeMessage =
        state.inputReferralCode != signUpValues.inputReferralCode
            ? false
            : state.isShowReferralCodeMessage;

    final isEnableSignUp = signUpValues.inputEmail.isNotEmpty &&
        signUpValues.inputPassword.isNotEmpty &&
        signUpValues.inputConfirmPassword.isNotEmpty;

    emit(signUpValues.copyWith(
      isEnableSignUp: isEnableSignUp,
      isShowEmailMessage: isShowEmailMessage,
      isShowPasswordMessage: isShowPasswordMessage,
      isShowConfirmPasswordMessage: isShowConfirmPasswordMessage,
      isShowReferralCodeMessage: isShowReferralCodeMessage,
    ));
  }

  Future<void> onSignUpWithEmailSubmitEvent(
    SignUpWithEmailSubmitEvent event,
    Emitter<SignUpState> emit,
  ) async {
    final validEmail = InputValidationHelper.validateEmail(state.inputEmail);
    final validPassword =
        InputValidationHelper.validatePassword(state.inputPassword);
    final validReferralCode =
        InputValidationHelper.validateReferralCode(state.inputReferralCode);
    final doMatchPassword = state.inputPassword == state.inputConfirmPassword;

    emit(state.copyWith(
      isShowEmailMessage: validEmail != null,
      isShowPasswordMessage: validPassword != null,
      isShowConfirmPasswordMessage: !doMatchPassword,
      isShowReferralCodeMessage: validReferralCode != null,
      messageInputEmail: validEmail,
      messageInputPassword: validPassword,
      messageInputConfirmPassword:
          doMatchPassword ? "" : Constants.errorMessageConfirmPassword,
      messageInputReferralCode: validReferralCode,
    ));

    UserModel userModel = UserModel(
        email: state.inputEmail,
        password: state.inputPassword,
        referralCode: state.inputReferralCode);

    if (validEmail == null &&
        validPassword == null &&
        doMatchPassword &&
        validReferralCode == null) {
      try {
        await AuthRepository().sendVerificationCode(state.inputEmail);
        emit(
            state.copyWith(status: SignUpStatus.success, userModel: userModel));
      } catch (e) {
        if (e is Exception) {
          emit(
            state.copyWith(
              status: SignUpStatus.error,
              isShowEmailMessage: true,
              messageInputEmail: e.toString(),
            ),
          );
        }
      }
    }
  }

  void _onSignUpWithGoogleEvent(
      SignUpWithGoogleEvent event, Emitter emit) async {
    final user = await AuthRepository().googleLogin();
    try {
      if (user != null) {
        emit(state.copyWith(
          status: SignUpStatus.completed,
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
    final facebookAccount = await AuthRepository().loginWithFacebook();
    try {
      if (facebookAccount != null) {
        emit(state.copyWith(
          status: SignUpStatus.completed,
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
