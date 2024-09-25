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
  final bool isLoggedIn;

  const LoginState({
    required this.status,
    this.errorMessage,
    this.isVisible = false,
    this.isLoggedIn = false,
  });

  static LoginState initial() => const LoginState(
        status: LoginStatus.initial,
        isVisible: false,
        isLoggedIn: false,
      );

  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage,
    bool? isVisible,
    bool? isLoggedIn,
  }) {
    return LoginState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        isVisible: isVisible ?? this.isVisible,
        isLoggedIn: isLoggedIn ?? this.isLoggedIn);
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        isVisible,
        isLoggedIn,
      ];
}
