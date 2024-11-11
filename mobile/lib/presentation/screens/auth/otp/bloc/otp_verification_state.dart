import 'package:equatable/equatable.dart';
import 'package:move_app/data/models/user_model.dart';

enum OtpVerificationStatus {
  initial,
  loading,
  success,
  error,
}

class OtpVerificationState extends Equatable {
  final OtpVerificationStatus status;
  final bool isEnabledSubmit;
  final String inputOtpCode;
  final String email;
  final int remainingSeconds;
  final String messageOtp;
  final bool isShowMessageOtp;
  final UserModel? userModel;

  const OtpVerificationState(
      {this.status = OtpVerificationStatus.initial,
      this.isEnabledSubmit = false,
      this.inputOtpCode = "",
      this.email = "",
      this.remainingSeconds = 10,
      this.messageOtp = "",
      this.isShowMessageOtp = false,
      this.userModel});

  OtpVerificationState copyWith(
      {OtpVerificationStatus? status,
      bool? isEnabledSubmit,
      String? inputOtpCode,
      String? email,
      int? remainingSeconds,
      String? messageOtp,
      bool? isShowMessageOtp,
      UserModel? userModel}) {
    return OtpVerificationState(
        status: status ?? this.status,
        isEnabledSubmit: isEnabledSubmit ?? this.isEnabledSubmit,
        inputOtpCode: inputOtpCode ?? this.inputOtpCode,
        email: email ?? this.email,
        remainingSeconds: remainingSeconds ?? this.remainingSeconds,
        messageOtp: messageOtp ?? this.messageOtp,
        isShowMessageOtp: isShowMessageOtp ?? this.isShowMessageOtp,
        userModel: userModel ?? this.userModel);
  }

  @override
  List<Object?> get props => [
        status,
        isEnabledSubmit,
        inputOtpCode,
        email,
        remainingSeconds,
        messageOtp,
        isShowMessageOtp,
        userModel
      ];
}
