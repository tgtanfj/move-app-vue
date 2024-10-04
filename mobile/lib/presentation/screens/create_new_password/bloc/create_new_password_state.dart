import 'package:equatable/equatable.dart';

class CreateNewPasswordState extends Equatable {
  final String newPassword;
  final String confirmNewPassword;
  final bool isPasswordValid;
  final bool doPasswordsMatch;
  final bool isShowValidationError;
  final String errorMessage;
  final String token;
  final bool isPasswordResetSuccessful;

  const CreateNewPasswordState(
      {required this.newPassword,
      required this.confirmNewPassword,
      required this.isPasswordValid,
      required this.doPasswordsMatch,
      required this.isShowValidationError,
      required this.errorMessage,
      required this.isPasswordResetSuccessful,
      required this.token});

  factory CreateNewPasswordState.initial() {
    return const CreateNewPasswordState(
      newPassword: '',
      confirmNewPassword: '',
      isPasswordValid: false,
      doPasswordsMatch: false,
      isShowValidationError: false,
      errorMessage: '',
      isPasswordResetSuccessful: false,
      token: '',
    );
  }

  CreateNewPasswordState copyWith({
    String? newPassword,
    String? confirmNewPassword,
    bool? isPasswordValid,
    bool? doPasswordsMatch,
    bool? showValidationError,
    bool? isShowConfirmPassword,
    String? errorMessage,
    bool? isPasswordResetSuccessful,
    String? token,
  }) {
    return CreateNewPasswordState(
        newPassword: newPassword ?? this.newPassword,
        confirmNewPassword: confirmNewPassword ?? this.confirmNewPassword,
        isPasswordValid: isPasswordValid ?? this.isPasswordValid,
        doPasswordsMatch: doPasswordsMatch ?? this.doPasswordsMatch,
        isShowValidationError: showValidationError ?? isShowValidationError,
        errorMessage: errorMessage ?? this.errorMessage,
        isPasswordResetSuccessful:
            isPasswordResetSuccessful ?? this.isPasswordResetSuccessful,
        token: token ?? this.token);
  }

  @override
  List<Object> get props => [
        newPassword,
        confirmNewPassword,
        isPasswordValid,
        doPasswordsMatch,
        isShowValidationError,
        errorMessage,
        isPasswordResetSuccessful,
        token
      ];
}
