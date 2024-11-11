import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/data/models/user_model.dart';
import 'package:move_app/data/repositories/auth_repository.dart';
import 'package:move_app/presentation/screens/auth/otp/bloc/otp_verification_event.dart';
import 'package:move_app/presentation/screens/auth/otp/bloc/otp_verification_state.dart';

class OtpVerificationBloc
    extends Bloc<OtpVerificationEvent, OtpVerificationState> {
  Timer? timer;

  OtpVerificationBloc() : super(const OtpVerificationState()) {
    on<OtpVerificationCodeChangedEvent>(onOtpVerificationCodeChangedEvent);
    on<OtpVerificationInitialEvent>(onOtpVerificationInitialEvent);
    on<OtpVerificationStartTimerEvent>(onOtpVerificationStartTimerEvent);
    on<OtpVerificationResendEvent>(onOtpVerificationResendEvent);
    on<OtpVerificationSubmitEvent>(onOtpVerificationSubmitEvent);
  }

  void onOtpVerificationInitialEvent(
    OtpVerificationInitialEvent event,
    Emitter<OtpVerificationState> emit,
  ) {
    emit(state.copyWith(
        userModel: event.userModel, status: OtpVerificationStatus.initial));
    add(OtpVerificationStartTimerEvent());
  }

  void onOtpVerificationStartTimerEvent(
    OtpVerificationStartTimerEvent event,
    Emitter<OtpVerificationState> emit,
  ) async {
    timer?.cancel();
    emit(state.copyWith(remainingSeconds: 60));

    await Future.forEach(List.generate(60, (index) => index), (index) async {
      await Future.delayed(const Duration(seconds: 1));
      if (emit.isDone) return;
      emit(state.copyWith(remainingSeconds: state.remainingSeconds - 1));
    });
  }

  void onOtpVerificationCodeChangedEvent(
    OtpVerificationCodeChangedEvent event,
    Emitter<OtpVerificationState> emit,
  ) {
    final isShowMessageOtp = state.inputOtpCode != event.inputOtpCode
        ? false
        : state.isShowMessageOtp;
    emit(state.copyWith(
        inputOtpCode: event.inputOtpCode,
        isEnabledSubmit: event.inputOtpCode.isNotEmpty,
        isShowMessageOtp: isShowMessageOtp));
  }

  void onOtpVerificationResendEvent(
    OtpVerificationResendEvent event,
    Emitter<OtpVerificationState> emit,
  ) async {
    final email = state.userModel?.email ?? "";
    final result = await AuthRepository().sendVerificationCode(email);
    result.fold(
      (errorMessage) {
        emit(state.copyWith(
          status: OtpVerificationStatus.error,
          isShowMessageOtp: true,
          messageOtp: errorMessage,
        ));
      },
      (response) {
        add(OtpVerificationStartTimerEvent());
      },
    );
  }

  void onOtpVerificationSubmitEvent(
    OtpVerificationSubmitEvent event,
    Emitter<OtpVerificationState> emit,
  ) async {
    emit(state.copyWith(status: OtpVerificationStatus.loading));

    final userModel = state.userModel ?? UserModel();
    final otpCode = state.inputOtpCode;

    final result = await AuthRepository().signUpWithEmail(userModel, otpCode);

    result.fold(
      (errorMessage) {
        emit(state.copyWith(
          status: OtpVerificationStatus.error,
          isShowMessageOtp: true,
          messageOtp: errorMessage,
        ));
      },
      (response) {
        emit(state.copyWith(status: OtpVerificationStatus.success));
      },
    );
  }

  @override
  Future<void> close() {
    timer?.cancel();
    return super.close();
  }
}
