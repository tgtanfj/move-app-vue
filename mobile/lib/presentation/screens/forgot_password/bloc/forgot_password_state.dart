import 'package:equatable/equatable.dart';

class ForgotPasswordState extends Equatable {
  final bool isEmailValid;
  final String email;
  final bool isEmailSent;

  const ForgotPasswordState({
    required this.isEmailValid,
    required this.email,
    required this.isEmailSent,
  });

  factory ForgotPasswordState.initial() {
    return const ForgotPasswordState(
      email: '',
      isEmailSent: false,
      isEmailValid: false,
    );
  }

  ForgotPasswordState copyWith(
      {bool? isEmailValid,
      bool? isEmailSent,
      String? email,}) {
    return ForgotPasswordState(
        isEmailValid: isEmailValid ?? this.isEmailValid,
        email: email ?? this.email,
        isEmailSent: isEmailSent ?? this.isEmailSent,
       );
  }

  @override
  List<Object> get props => [
        isEmailValid,
        email,
        isEmailSent,
   
      ];
}
