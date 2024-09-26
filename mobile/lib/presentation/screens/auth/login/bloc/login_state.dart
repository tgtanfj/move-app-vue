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

  const LoginState({
    required this.status,
    this.errorMessage,
    this.isVisible = false,
  });

  static LoginState initial() => const LoginState(
        status: LoginStatus.initial,
        isVisible: false,
      );

  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage,
    bool? isVisible,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        isVisible,
      ];
}
