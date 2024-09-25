import 'package:equatable/equatable.dart';

class SignUpEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class SignUpClickSignUpWithEmailEvent extends SignUpEvent {}

final class SignUpClickShowPasswordEvent extends SignUpEvent {}

final class SignUpClickShowConfirmPasswordEvent extends SignUpEvent {}

class SignUpEmailChangedEvent extends SignUpEvent {
  final String email;

  SignUpEmailChangedEvent(this.email);
}

class SignUpPasswordChangedEvent extends SignUpEvent {
  final String password;

  SignUpPasswordChangedEvent(this.password);
}

class SignUpConfirmPasswordChangedEvent extends SignUpEvent {
  final String confirmPassword;

  SignUpConfirmPasswordChangedEvent(this.confirmPassword);
}

class SignUpReferralCodeChangedEvent extends SignUpEvent {
  final String referralCode;

  SignUpReferralCodeChangedEvent(this.referralCode);
}
