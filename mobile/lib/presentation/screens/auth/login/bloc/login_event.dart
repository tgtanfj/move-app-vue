sealed class LoginEvent {
  const LoginEvent();
}

final class LoginInitialEvent extends LoginEvent {}

final class LoginWithEmailVisibleEvent extends LoginEvent {}

