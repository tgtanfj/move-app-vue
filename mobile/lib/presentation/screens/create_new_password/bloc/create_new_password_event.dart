import 'package:equatable/equatable.dart';

abstract class CreateNewPasswordEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateNewPasswordInitialEvent extends CreateNewPasswordEvent {
  final String token;

  CreateNewPasswordInitialEvent({required this.token});

  @override
  List<Object?> get props => [token];
}

class CreateNewPasswordChangedEvent extends CreateNewPasswordEvent {
  final String newPassword;
  CreateNewPasswordChangedEvent(this.newPassword);

  @override
  List<Object?> get props => [newPassword];
}

class CreateConfirmPasswordChangedEvent extends CreateNewPasswordEvent {
  final String confirmPassword;
  CreateConfirmPasswordChangedEvent(this.confirmPassword);

  @override
  List<Object?> get props => [confirmPassword];
}

class CreateNewPasswordSubmittedEvent extends CreateNewPasswordEvent {}
