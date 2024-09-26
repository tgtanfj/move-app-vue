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


