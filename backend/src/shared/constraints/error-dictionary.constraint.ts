export enum ERRORS_DICTIONARY {
  // Users
  EMAIL_EXISTED = 'Email already existed',
  USER_NOT_FOUND = 'User not found',

  // CLASS VALIDATOR
  VALIDATION_ERROR = 'ValidationError',
  //
  AUTHORIZE_ERROR = 'You are not authorize',
  TOKEN_ERROR = 'Token invalid',
  RESET_PASSWORD_FAIL = 'RESET_PASSWORD_FAIL',

  // USER
  NOT_FOUND_ANY_USER = 'Not found any user',

  NOT_FOUND_ANY_COUNTRY = 'Not found any country',
  //Token
  GENERATE_TOKEN_FAIL = 'Genereate_token_fail',
  VERIFY_TOKEN_FAIL = 'Token is not valid',

  //Account
  NOT_FOUND_ACCOUNT = 'Not found account',
  UPDATE_PASSWORD_FAIL = 'Update password fail',

  // SOCIAL
  TRY_ANOTHER_LOGIN_METHOD = 'An account with this email already exists using a different login method. Please use the original method to log in',
}
