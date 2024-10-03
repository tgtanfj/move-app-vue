class ApiUrls {
  static const String baseUrl = "https://api.training-move-intern.madlab.tech/";
  static const String signUpEndpoint ="auth/signup/email";
  static const String sendVerificationCodeEndpoint="auth/send-otp";
  static const String endPointLogin = 'auth/login';
  static const String endPointLogout = '';
  static const String getUserProfileEndPoint = 'user/profile';
  static const String getCountryEndPoint = 'countries';
  static const String getStateEndPoint = 'countries/{id}/states';
  static const String editUserProfileEndPoint = 'user/edit-profile';
}
