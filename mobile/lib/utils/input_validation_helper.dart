import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:move_app/constants/constants.dart';

class InputValidationHelper {
  static final RegExp email = RegExp(
      r"^(?!.*\.\.)(?!\.)(?!.*\.$)([a-zA-Z0-9._+-]+)@([a-zA-Z0-9-]+\.[a-zA-Z]{2,})$");
  static final RegExp password = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,32}$');

  static String? validateEmail(String email) {
    if (email.length < 5 || email.length > 255) {
      return Constants.invalidEmail;
    }

    const emailPattern =
        r'^[a-zA-Z0-9]+([._+-]?[a-zA-Z0-9]+)*@[a-zA-Z0-9]+([.-]?[a-zA-Z0-9]+)*\.[a-zA-Z]{2,}$';
    final regExp = RegExp(emailPattern);

    if (!regExp.hasMatch(email)) {
      return Constants.invalidEmail;
    }

    final parts = email.split('@');
    final localPart = parts[0];
    final domainPart = parts[1];
    if (localPart.contains('..') || domainPart.contains('..')) {
      return Constants.invalidEmail;
    }

    return null;
  }

  static String? validatePassword(String password) {
    if (password.length < 8 || password.length > 32) {
      return Constants.prefixPassword;
    }

    if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$%\^&\*]).{8,32}$')
        .hasMatch(password)) {
      return Constants.chooseStrongPassword;
    }

    return null;
  }

  static String? validateReferralCode(String code) {
    if (code.isEmpty) {
      return null;
    }
    if (code.length != 8) {
      return Constants.invalidReferralCode;
    }

    const codePattern = r'^[A-Za-z0-9]+$';
    final regExp = RegExp(codePattern);

    if (!regExp.hasMatch(code)) {
      return Constants.invalidReferralCode;
    }
    return null;
  }

  static String? validateOtpCode(String input) {
    const numberPattern = r'^[0-9]+$';
    final regExp = RegExp(numberPattern);

    if (!regExp.hasMatch(input)) {
      return Constants.invalidCode;
    }

    return null;
  }

  bool isPasswordValid(String password) {
    if (password.length < 8 || password.length > 32) return false;
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigit = password.contains(RegExp(r'[0-9]'));
    final hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    return hasUppercase && hasLowercase && hasDigit && hasSpecial;
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  static String? validateUsername(String username) {
    if (username.length < 4 || username.length > 25) {
      return Constants.invalidCharacterUsername;
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
      return Constants.invalidContainUsername;
    }
    return null;
  }

  static String? validateFullName(String fullName) {
    if (fullName.length < 8 || fullName.length > 255) {
      return Constants.invalidCharacterFullName;
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(fullName)) {
      return Constants.invalidSpecialCharacterFullName;
    }
    return null;
  }

  static String? validateStringValue(String value) {
    if (value.isEmpty) {
      return Constants.invalidCity;
    }

    return null;
  }

  static String? validateDateOfBirth(DateTime? dateOfBirth) {
    if (dateOfBirth == null) {
      return Constants.invalidDateOfBirth;
    }
    final today = DateTime.now();
    final age = today.year - dateOfBirth.year;
    if (age < 18 || age > 65) {
      return Constants.invalidAge;
    }
    return null;
  }

  static Future<String?> validateImage(File? file) async {
    if (file != null) {
      const int maxSizeInBytes = 5 * 1024 * 1024;
      if (file.lengthSync() > maxSizeInBytes) {
        return Constants.sizeAvatarLimit;
      }
      final String fileExtension = file.path.split('.').last.toLowerCase();
      const allowedExtensions = ['jpg', 'jpeg', 'png', 'gif'];
      if (!allowedExtensions.contains(fileExtension)) {
        return Constants.allowFileType;
      }
      final imageBytes = await file.readAsBytes();
      final image = img.decodeImage(imageBytes);
      if (image == null ||
          image.width < 100 ||
          image.height < 100 ||
          image.width > 2000 ||
          image.height > 2000) {
        return Constants.dimensionAvatar;
      }
    }
    return null;
  }
}
