import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/presentation/screens/auth/otp/bloc/otp_verification_event.dart';
import 'package:move_app/presentation/screens/auth/otp/bloc/otp_verification_state.dart';

class OtpVerificationBloc
    extends Bloc<OtpVerificationEvent, OtpVerificationState> {
  OtpVerificationBloc() : super(const OtpVerificationState()) {
    on<OtpVerificationCodeChangedEvent>(onOtpVerificationCodeChangedEvent);
    on<OtpVerificationInitialEvent>(onOtpVerificationInitialEvent);
  }

  void onOtpVerificationCodeChangedEvent(
    OtpVerificationCodeChangedEvent event,
    Emitter<OtpVerificationState> emit,
  ) {
    final isValidCode = event.verificationCode.length == 6;

    emit(state.copyWith(
      verificationCode: event.verificationCode,
      isEnabledSubmit: isValidCode,
    ));
  }

  void onOtpVerificationInitialEvent(
    OtpVerificationInitialEvent event,
    Emitter<OtpVerificationState> emit,
  ) {
    emit(state.copyWith(
      email: event.email,
    ));
  }
}
