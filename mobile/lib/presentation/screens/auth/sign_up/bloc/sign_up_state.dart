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
  final bool isShowPassword;
  final bool isShowConfirmPassword;
  final bool isEnableSignUp;
  final String email;
  final String password;
  final String confirmPassword;
  final String referralCode;

  const SignUpState({
    this.status = SignUpStatus.initial,
    this.isClickSignUpWithEmail = false,
    this.isShowPassword = true,
    this.isShowConfirmPassword = true,
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
      isShowPassword: isShowPassword ?? this.isShowPassword,
      isShowConfirmPassword:
          isShowConfirmPassword ?? this.isShowConfirmPassword,
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
        isShowPassword,
        isShowConfirmPassword,
        isEnableSignUp,
        email,
        password,
        confirmPassword,
        referralCode
      ];
}
