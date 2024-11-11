import 'dart:io';

import 'package:move_app/constants/constants.dart';
import 'package:move_app/utils/card_number_formatter.dart';

class InputValidationHelper {
  static final RegExp email = RegExp(
      r"^(?!.*\.\.)(?!\.)(?!.*\.$)([a-zA-Z0-9._+-]+)@([a-zA-Z0-9-]+\.[a-zA-Z]{2,})$");
  static final RegExp password = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,32}$');

  static String? validateEmail(String email) {
    if (email.length < 5 || email.length > 255) {
      return Constants.emailLength;
    }

    final atSymbolCount = '@'.allMatches(email).length;
    if (atSymbolCount != 1) {
      return Constants.emailSymbol;
    }

    final parts = email.split('@');
    final localPart = parts[0];
    final domainPart = parts[1];

    final localPartRegex = RegExp(r'^[a-zA-Z0-9._+-]+$');
    if (!localPartRegex.hasMatch(localPart)) {
      return Constants.emailLocalPart;
    }
    if (localPart.startsWith('.') || localPart.endsWith('.')) {
      return Constants.cannotStartWithDot;
    }
    if (localPart.contains('..')) {
      return Constants.cannotContainDot;
    }

    final domainRegex = RegExp(r'^[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$');
    if (!domainRegex.hasMatch(domainPart)) {
      return Constants.mustContainAt;
    }
    if (domainPart.startsWith('.') || domainPart.endsWith('.')) {
      return Constants.domainDot;
    }
    if (domainPart.contains('..')) {
      return Constants.domainConsecutiveDot;
    }

    final domainSections = domainPart.split('.');
    final tld = domainSections.last;
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(tld)) {
      return Constants.lastDomain;
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
    int age = today.year - dateOfBirth.year;
    if (dateOfBirth.month > today.month) {
      age--;
    } else if (dateOfBirth.month == today.month) {
      if (dateOfBirth.day > today.day) {
        age--;
      } else {
        age++;
      }
    }
    if (age < 13 || age > 65) {
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
    }
    return null;
  }

  static String? validateCardHolderName(String cardHolderName) {
    if (cardHolderName.length < 2) {
      return Constants.incorrectlyFormattedCardHolderName;
    }
    return null;
  }

  static String? validateExpiryDate(String expiryDate) {
    final parts = expiryDate.split('/');

    if (parts.length != 2) {
      return Constants.checkYourExpirationDate;
    }

    int month = int.parse(parts[0]);
    int year = int.parse(parts[1]) + 2000;

    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;
    if (year < currentYear) {
      return Constants.checkYourExpirationDate;
    } else if (year == currentYear && month < currentMonth) {
      return Constants.checkYourExpirationDate;
    } else if (month < 1 || month > 12) {
      return Constants.checkYourExpirationDate;
    }

    return null;
  }

  static String? validateCvv(String cvv) {
    if (cvv.length < 3) {
      return Constants.invalidCardVerificationCode;
    }
    return null;
  }

  static String? validateCardNumber(String value) {
    if (value.length < 16) {
      return Constants.invalidCardNumber;
    }
    if (CardNumberValidator.getCardType(value) == CardType.unknown) {
      return Constants.invalidVisaOrCreditCard;
    }
    return null;
  }
}
