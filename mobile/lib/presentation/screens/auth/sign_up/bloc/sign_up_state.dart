import 'package:equatable/equatable.dart';
import 'package:move_app/data/models/user_model.dart';

enum SignUpStatus {
  initial,
  loading,
  goOn,
  success,
  error,
}

class SignUpState extends Equatable {
  final SignUpStatus status;
  final bool isEnableSignUp;
  final String inputEmail;
  final String inputPassword;
  final String inputConfirmPassword;
  final String inputReferralCode;
  final String messageInputEmail;
  final String messageInputPassword;
  final String messageInputConfirmPassword;
  final String messageInputReferralCode;
  final bool isShowEmailMessage;
  final bool isShowPasswordMessage;
  final bool isShowConfirmPasswordMessage;
  final bool isShowReferralCodeMessage;
  final String googleAccount;
  final String facebookAccount;
  final UserModel? userModel;

  const SignUpState({
    this.status = SignUpStatus.initial,
    this.isEnableSignUp = false,
    this.inputEmail = "",
    this.inputPassword = "",
    this.inputConfirmPassword = "",
    this.inputReferralCode = "",
    this.messageInputEmail = "",
    this.messageInputPassword = "",
    this.messageInputConfirmPassword = "",
    this.messageInputReferralCode = "",
    this.isShowEmailMessage = false,
    this.isShowPasswordMessage = false,
    this.isShowConfirmPasswordMessage = false,
    this.isShowReferralCodeMessage = false,
    this.googleAccount = '',
    this.facebookAccount = '',
    this.userModel,
  });

  SignUpState copyWith({
    SignUpStatus? status,
    bool? isEnableSignUp,
    String? inputEmail,
    String? inputPassword,
    String? inputConfirmPassword,
    String? inputReferralCode,
    String? messageInputEmail,
    String? messageInputPassword,
    String? messageInputConfirmPassword,
    String? messageInputReferralCode,
    bool? isShowEmailMessage,
    bool? isShowPasswordMessage,
    bool? isShowConfirmPasswordMessage,
    bool? isShowReferralCodeMessage,
    bool? isShowPassword,
    bool? isShowConfirmPassword,
    String? googleAccount,
    String? facebookAccount,
    UserModel? userModel,
  }) {
    return SignUpState(
      status: status ?? this.status,
      isEnableSignUp: isEnableSignUp ?? this.isEnableSignUp,
      inputEmail: inputEmail ?? this.inputEmail,
      inputPassword: inputPassword ?? this.inputPassword,
      inputConfirmPassword: inputConfirmPassword ?? this.inputConfirmPassword,
      inputReferralCode: inputReferralCode ?? this.inputReferralCode,
      messageInputEmail: messageInputEmail ?? this.messageInputEmail,
      messageInputPassword: messageInputPassword ?? this.messageInputPassword,
      messageInputConfirmPassword:
          messageInputConfirmPassword ?? this.messageInputConfirmPassword,
      messageInputReferralCode:
          messageInputReferralCode ?? this.messageInputReferralCode,
      isShowEmailMessage: isShowEmailMessage ?? this.isShowEmailMessage,
      isShowPasswordMessage:
          isShowPasswordMessage ?? this.isShowPasswordMessage,
      isShowConfirmPasswordMessage:
          isShowConfirmPasswordMessage ?? this.isShowConfirmPasswordMessage,
      isShowReferralCodeMessage:
          isShowReferralCodeMessage ?? this.isShowReferralCodeMessage,
      googleAccount: googleAccount ?? this.googleAccount,
      facebookAccount: facebookAccount ?? this.facebookAccount,
      userModel: userModel ?? this.userModel,
    );
  }

  @override
  List<Object?> get props => [
        status,
        isEnableSignUp,
        inputEmail,
        inputPassword,
        inputConfirmPassword,
        inputReferralCode,
        messageInputEmail,
        messageInputPassword,
        messageInputConfirmPassword,
        messageInputReferralCode,
        isShowEmailMessage,
        isShowPasswordMessage,
        isShowConfirmPasswordMessage,
        isShowReferralCodeMessage,
        googleAccount,
        facebookAccount,
        userModel,
      ];
}
