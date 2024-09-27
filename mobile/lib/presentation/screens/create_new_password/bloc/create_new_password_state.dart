import 'package:equatable/equatable.dart';

class CreateNewPasswordState extends Equatable {
  final String newPassword;
  final String confirmNewPassword;
  final bool isPasswordValid;
  final bool doPasswordsMatch;
  final bool showValidationError;

  const CreateNewPasswordState({
    required this.newPassword,
    required this.confirmNewPassword,
    required this.isPasswordValid,
    required this.doPasswordsMatch,
    required this.showValidationError,
  });

  factory CreateNewPasswordState.initial() {
    return const CreateNewPasswordState(
      newPassword: '',
      confirmNewPassword: '',
      isPasswordValid: false,
      doPasswordsMatch: false,
      showValidationError: false,
    );
  }

  CreateNewPasswordState copyWith({
    String? newPassword,
    String? confirmNewPassword,
    bool? isPasswordValid,
    bool? doPasswordsMatch,
    bool? showValidationError,
    bool? isShowConfirmPassword,
  }) {
    return CreateNewPasswordState(
      newPassword: newPassword ?? this.newPassword,
      confirmNewPassword: confirmNewPassword ?? this.confirmNewPassword,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      doPasswordsMatch: doPasswordsMatch ?? this.doPasswordsMatch,
      showValidationError: showValidationError ?? this.showValidationError,
    );
  }

  @override
  List<Object> get props => [
        newPassword,
        confirmNewPassword,
        isPasswordValid,
        doPasswordsMatch,
        showValidationError,
      ];
}
