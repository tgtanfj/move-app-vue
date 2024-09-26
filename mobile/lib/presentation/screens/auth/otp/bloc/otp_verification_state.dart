import 'package:equatable/equatable.dart';

class OtpVerificationState extends Equatable {
  final bool isEnabledSubmit;
  final String verificationCode;

  const OtpVerificationState({
    this.isEnabledSubmit = false,
    this.verificationCode = "",
  });

  OtpVerificationState copyWith({
    bool? isEnabledSubmit,
    String? verificationCode,
  }) {
    return OtpVerificationState(
      isEnabledSubmit: isEnabledSubmit ?? this.isEnabledSubmit,
      verificationCode: verificationCode ?? this.verificationCode,
    );
  }

  @override
  List<Object?> get props => [isEnabledSubmit, verificationCode];
}
