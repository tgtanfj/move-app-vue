import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ForgotPasswordEmailChangedEvent extends ForgotPasswordEvent {
  final String email;
  ForgotPasswordEmailChangedEvent(this.email);

  @override
  List<Object?> get props => [email];
}

class ForgotPasswordSubmittedEvent extends ForgotPasswordEvent {
  String email;
  ForgotPasswordSubmittedEvent(this.email);

  @override
  List<Object?> get props => [email];
}

class ForgotPasswordSubmittedSuccessEvent extends ForgotPasswordEvent {}

class ForgotPasswordStartTimerEvent extends ForgotPasswordEvent {}

class ForgotPasswordTickEvent extends ForgotPasswordEvent {
  final int remainingSeconds;

  ForgotPasswordTickEvent(this.remainingSeconds);

  @override
  List<Object?> get props => [remainingSeconds];
}
