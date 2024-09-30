
class InputValidationHelper {
  static final RegExp email = RegExp(
      r"^(?!.*\.\.)(?!\.)(?!.*\.$)([a-zA-Z0-9._+-]+)@([a-zA-Z0-9-]+\.[a-zA-Z]{2,})$");

  static final RegExp password = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,32}$');
}