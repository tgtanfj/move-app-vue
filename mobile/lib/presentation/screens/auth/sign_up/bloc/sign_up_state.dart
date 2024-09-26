import 'package:equatable/equatable.dart';

enum SignUpStatus {
  initial,
  loading,
  success,
  error,
}

class SignUpState extends Equatable {
  final SignUpStatus status;
  final bool isClickSignUpWithEmail;
  final bool isEnableSignUp;
  final String email;
  final String password;
  final String confirmPassword;
  final String referralCode;

  const SignUpState({
    this.status = SignUpStatus.initial,
    this.isClickSignUpWithEmail = false,
    this.isEnableSignUp = false,
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.referralCode = '',
  });

  SignUpState copyWith({
    SignUpStatus? status,
    bool? isClickSignUpWithEmail,
    bool? isShowPassword,
    bool? isShowConfirmPassword,
    bool? isEnableSignUp,
    String? email,
    String? password,
    String? confirmPassword,
    String? referralCode,
  }) {
    return SignUpState(
      status: status ?? this.status,
      isClickSignUpWithEmail:
          isClickSignUpWithEmail ?? this.isClickSignUpWithEmail,
      isEnableSignUp: isEnableSignUp ?? this.isEnableSignUp,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      referralCode: referralCode ?? this.referralCode,
    );
  }

  @override
  List<Object?> get props => [
        status,
        isClickSignUpWithEmail,
        isEnableSignUp,
        email,
        password,
        confirmPassword,
        referralCode
      ];
}