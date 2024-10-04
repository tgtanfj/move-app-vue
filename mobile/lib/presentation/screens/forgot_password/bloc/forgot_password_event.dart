import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ForgotPasswordEmailChanged extends ForgotPasswordEvent {
  final String email;
  ForgotPasswordEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class ForgotPasswordSubmitted extends ForgotPasswordEvent {
  String email;
  ForgotPasswordSubmitted(this.email);

  @override
  List<Object?> get props => [email];
}

class ForgotPasswordSubmittedSuccess extends ForgotPasswordEvent {}
