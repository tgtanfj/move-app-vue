import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/models/user_model.dart';
import 'package:move_app/data/repositories/auth_repository.dart';
import 'package:move_app/presentation/screens/auth/sign_up/bloc/sign_up_event.dart';
import 'package:move_app/presentation/screens/auth/sign_up/bloc/sign_up_state.dart';
import 'package:move_app/utils/input_validation_helper.dart';

import '../../../../../data/services/api_service.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(const SignUpState()) {
    on<SignUpClickSignUpWithEmailEvent>(onSignUpClickSignUpWithEmailEvent);
    on<SignUpValuesChangedEvent>(onSignUpValuesChangedEvent);
    on<SignUpWithEmailSubmitEvent>(onSignUpWithEmailSubmitEvent);

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
        signUpValues.inputConfirmPassword.isNotEmpty &&
        signUpValues.inputEmail.contains("@");

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

    if (validEmail == null &&
        validPassword == null &&
        doMatchPassword &&
        validReferralCode == null) {
      try {
        await AuthRepository().sendVerificationCode(state.inputEmail);
        emit(state.copyWith(status: SignUpStatus.success));
      } catch (e) {
        if (e is Exception) {
          emit(state.copyWith(
              isShowEmailMessage: true, messageInputEmail: e.toString()));
        }
      }
    }
  }

}
