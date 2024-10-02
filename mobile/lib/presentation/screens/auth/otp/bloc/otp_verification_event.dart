import 'package:equatable/equatable.dart';
import 'package:move_app/data/models/user_model.dart';

class OtpVerificationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OtpVerificationCodeChangedEvent extends OtpVerificationEvent {
  final String inputOtpCode;

  OtpVerificationCodeChangedEvent(this.inputOtpCode);

  @override
  List<Object?> get props => [inputOtpCode];
}

class OtpVerificationInitialEvent extends OtpVerificationEvent {
  final UserModel? userModel;

  OtpVerificationInitialEvent(this.userModel);

  @override
  List<Object?> get props => [userModel];
}

class OtpVerificationStartTimerEvent extends OtpVerificationEvent {}

class OtpVerificationResendEvent extends OtpVerificationEvent {}

class OtpVerificationSubmitEvent extends OtpVerificationEvent {}

