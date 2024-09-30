import 'package:equatable/equatable.dart';

class SignUpEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class SignUpClickSignUpWithEmailEvent extends SignUpEvent {}


class SignUpValuesChangedEvent extends SignUpEvent {
  final String? email;
  final String? password;
  final String? confirmPassword;
  final String? referralCode;

  SignUpValuesChangedEvent({
    this.email,
    this.password,
    this.confirmPassword,
    this.referralCode,
  });

  @override
  List<Object?> get props => [email, password, confirmPassword, referralCode];
}

final class SignUpWithGoogleEvent extends SignUpEvent {
  @override
  List<Object?> get props => [];
}

final class SignUpWithFacebookEvent extends SignUpEvent {
  @override
  List<Object?> get props => [];
}


