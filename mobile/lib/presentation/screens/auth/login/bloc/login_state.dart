import 'package:equatable/equatable.dart';

enum LoginStatus {
  initial,
  processing,
  success,
  dismiss,
  failure,
  failureSocial,
}

final class LoginState extends Equatable {
  final LoginStatus status;
  final String? errorMessage;
  final bool isVisible;
  final bool isEnabled;
  final String email;
  final String password;
  final String googleAccount;
  final String facebookAccount;
  final String messageInputEmail;
  final String messageInputPassword;
  final bool isShowEmailMessage;
  final bool isShowPasswordMessage;
  final bool isShowErrorBorder;

  const LoginState({
    required this.status,
    this.errorMessage,
    this.isVisible = false,
    this.isEnabled = false,
    this.email = '',
    this.password = '',
    this.googleAccount = '',
    this.facebookAccount = '',
    this.messageInputEmail = "",
    this.messageInputPassword = "",
    this.isShowEmailMessage = false,
    this.isShowPasswordMessage = false,
    this.isShowErrorBorder = false,
  });

  static LoginState initial() => const LoginState(
        status: LoginStatus.initial,
        isVisible: false,
        isEnabled: false,
        email: '',
        password: '',
        googleAccount: '',
        facebookAccount: '',
        messageInputEmail: '',
        messageInputPassword: '',
        isShowEmailMessage: false,
        isShowPasswordMessage: false,
        isShowErrorBorder: false,
      );

  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage,
    bool? isVisible,
    bool? isEnabled,
    String? email,
    String? password,
    String? googleAccount,
    String? facebookAccount,
    String? messageInputEmail,
    String? messageInputPassword,
    bool? isShowEmailMessage,
    bool? isShowPasswordMessage,
    bool? isShowErrorBorder,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isVisible: isVisible ?? this.isVisible,
      isEnabled: isEnabled ?? this.isEnabled,
      email: email ?? this.email,
      password: password ?? this.password,
      googleAccount: googleAccount ?? this.googleAccount,
      facebookAccount: facebookAccount ?? this.facebookAccount,
      messageInputEmail: messageInputEmail ?? this.messageInputEmail,
      messageInputPassword: messageInputPassword ?? this.messageInputPassword,
      isShowEmailMessage: isShowEmailMessage ?? this.isShowEmailMessage,
      isShowPasswordMessage:
          isShowPasswordMessage ?? this.isShowPasswordMessage,
      isShowErrorBorder: isShowErrorBorder ?? this.isShowErrorBorder,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        isVisible,
        isEnabled,
        email,
        password,
        googleAccount,
        facebookAccount,
        messageInputEmail,
        messageInputPassword,
        isShowEmailMessage,
        isShowPasswordMessage,
        isShowErrorBorder,
      ];
}
