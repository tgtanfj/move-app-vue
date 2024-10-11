import 'package:equatable/equatable.dart';

class ForgotPasswordState extends Equatable {
  final bool isEmailValid;
  final String email;
  final bool isEmailSent;
  final String errorMessage;
  final bool isShowEmailMessage;
  final String token;
  final int remainingSeconds;

  const ForgotPasswordState({
    required this.isEmailValid,
    required this.email,
    required this.isEmailSent,
    required this.errorMessage,
    required this.isShowEmailMessage,
    required this.token,
    required this.remainingSeconds,
  });

  factory ForgotPasswordState.initial() {
    return const ForgotPasswordState(
      email: '',
      isEmailSent: false,
      isEmailValid: false,
      errorMessage: '',
      isShowEmailMessage: false,
      token: '',
      remainingSeconds: 10,
    );
  }

  ForgotPasswordState copyWith(
      {bool? isEmailValid,
      bool? isEmailSent,
      String? email,
      String? errorMessage,
      bool? isShowEmailMessage,
      String? token,
      int? remainingSeconds}) {
    return ForgotPasswordState(
        isEmailValid: isEmailValid ?? this.isEmailValid,
        email: email ?? this.email,
        isEmailSent: isEmailSent ?? this.isEmailSent,
        errorMessage: errorMessage ?? this.errorMessage,
        isShowEmailMessage: isShowEmailMessage ?? this.isShowEmailMessage,
        token: token ?? this.token,
        remainingSeconds: remainingSeconds ?? this.remainingSeconds);
  }

  @override
  List<Object> get props => [
        isEmailValid,
        email,
        isEmailSent,
        errorMessage,
        isShowEmailMessage,
        token,
        remainingSeconds
      ];
}
