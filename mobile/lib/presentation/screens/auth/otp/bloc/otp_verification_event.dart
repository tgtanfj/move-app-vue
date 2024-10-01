import 'package:equatable/equatable.dart';

abstract class OtpVerificationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OtpVerificationCodeChangedEvent extends OtpVerificationEvent {
  final String verificationCode;

  OtpVerificationCodeChangedEvent(this.verificationCode);

  @override
  List<Object?> get props => [verificationCode];
}

class OtpVerificationInitialEvent extends OtpVerificationEvent {
  final String email;

  OtpVerificationInitialEvent(this.email);

  @override
  List<Object?> get props => [email];
}
