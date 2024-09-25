sealed class LoginEvent{
  const LoginEvent();
}
final class LoginInitialEvent extends LoginEvent{}
final class ToggleVisibilityEvent extends LoginEvent {}
final class LoginWithGoogleEvent extends LoginEvent{}
final class LoginEnableButtonEvent extends LoginEvent{
}
final class LoginChangeEmailEvent extends LoginEvent{

}
final class LoginChangePasswordEvent extends LoginEvent{

}
final class LoginObscureTextEvent extends LoginEvent{}
