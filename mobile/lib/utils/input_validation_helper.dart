class InputValidationHelper {
  static final RegExp email = RegExp(
      r"^(?!.*\.\.)(?!\.)(?!.*\.$)([a-zA-Z0-9._+-]+)@([a-zA-Z0-9-]+\.[a-zA-Z]{2,})$");
  static final RegExp password = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,32}$');

  bool isPasswordValid(String password) {
    if (password.length < 8 || password.length > 32) return false;

    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigit = password.contains(RegExp(r'[0-9]'));
    final hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    return hasUppercase && hasLowercase && hasDigit && hasSpecial;
  }
}
