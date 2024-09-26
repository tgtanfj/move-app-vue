import 'package:equatable/equatable.dart';

enum LoginStatus {
  initial,
  processing,
  success,
  failure,
}

final class LoginState extends Equatable {
  final LoginStatus status;
  final String? errorMessage;
  final bool isVisible;
  final bool isLoginTab;
  final bool showEmailLogin;

  const LoginState({
    required this.status,
    this.errorMessage,
    this.isVisible = false,
    this.isLoginTab = true,
    this.showEmailLogin = false,
  });

  static LoginState initial() => const LoginState(
      status: LoginStatus.initial,
      isVisible: false,
      isLoginTab: true,
      showEmailLogin: false);

  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage,
    bool? isVisible,
    bool? isLoggedIn,
    bool? isLoginTab,
    bool? showEmailLogin,
  }) {
    return LoginState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        isVisible: isVisible ?? this.isVisible,
        isLoginTab: isVisible ?? this.isLoginTab,
        showEmailLogin: showEmailLogin ?? this.showEmailLogin);
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        isVisible,
        isLoginTab,
        showEmailLogin,
      ];
}
