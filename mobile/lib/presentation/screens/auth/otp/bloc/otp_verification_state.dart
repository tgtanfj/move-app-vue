import 'package:equatable/equatable.dart';

class OtpVerificationState extends Equatable {
  final bool isEnabledSubmit;
  final String verificationCode;
  final String email;

  const OtpVerificationState(
      {this.isEnabledSubmit = false,
      this.verificationCode = "",
      this.email = ""});

  OtpVerificationState copyWith(
      {bool? isEnabledSubmit, String? verificationCode, String? email}) {
    return OtpVerificationState(
        isEnabledSubmit: isEnabledSubmit ?? this.isEnabledSubmit,
        verificationCode: verificationCode ?? this.verificationCode,
        email: email ?? this.email);
  }

  @override
  List<Object?> get props => [isEnabledSubmit, verificationCode, email];
}
