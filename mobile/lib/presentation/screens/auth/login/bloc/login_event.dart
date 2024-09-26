sealed class LoginEvent {
  const LoginEvent();
}

final class LoginInitialEvent extends LoginEvent {}

final class LoginWithEmailVisibleEvent extends LoginEvent {}

class LoginTabSelected extends LoginEvent {
  final bool isLoginTab;

  LoginTabSelected(this.isLoginTab);
}

class SignupTabSelected extends LoginEvent {}

class ToggleEmailLogin extends LoginEvent {}
