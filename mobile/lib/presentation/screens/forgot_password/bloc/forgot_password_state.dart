import 'package:equatable/equatable.dart';

class ForgotPasswordState extends Equatable {
  final bool isEmailValid;
  final String email;
  final bool isEmailSent;
  final String errorMessage;
  final bool isShowEmailMessage;
  final String token;

  const ForgotPasswordState({
    required this.isEmailValid,
    required this.email,
    required this.isEmailSent,
    required this.errorMessage,
    required this.isShowEmailMessage,
    required this.token,
  });

  factory ForgotPasswordState.initial() {
    return const ForgotPasswordState(
      email: '',
      isEmailSent: false,
      isEmailValid: false,
      errorMessage: '',
      isShowEmailMessage: false,
      token: '',
    );
  }

  ForgotPasswordState copyWith(
      {bool? isEmailValid,
      bool? isEmailSent,
      String? email,
      String? errorMessage,
      bool? isShowEmailMessage,
      String? token}) {
    return ForgotPasswordState(
        isEmailValid: isEmailValid ?? this.isEmailValid,
        email: email ?? this.email,
        isEmailSent: isEmailSent ?? this.isEmailSent,
        errorMessage: errorMessage ?? this.errorMessage,
        isShowEmailMessage: isShowEmailMessage ?? this.isShowEmailMessage,
        token: token ?? this.token);
  }

  @override
  List<Object> get props => [
        isEmailValid,
        email,
        isEmailSent,
        errorMessage,
        isShowEmailMessage,
        token
      ];
}
