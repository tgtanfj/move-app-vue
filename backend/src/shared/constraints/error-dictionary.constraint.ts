export enum ERRORS_DICTIONARY {
  // Users
  EMAIL_EXISTED = 'Email already existed',
  USER_NOT_FOUND = 'User not found',

  // Auth

  INVALID_OTP = 'Invalid OTP. Please try again.',
  ACCOUNT_LOCKED = 'Account is temporarily locked. Try again later.',
  OTP_WRONG_MANY_TIMES = "You've entered the wrong OTP too many times. Your account is locked for 10 minutes. Please try again later",

  // CLASS VALIDATOR
  VALIDATION_ERROR = 'ValidationError',
  //
  AUTHORIZE_ERROR = 'You are not authorize',
  TOKEN_ERROR = 'Token invalid',
  RESET_PASSWORD_FAIL = 'Reset password failed',

  // USER
  NOT_FOUND_ANY_USER = 'Not found any user',

  NOT_FOUND_ANY_COUNTRY = 'Not found any country',
  INVALID_STATE = 'Invalid state',

  //Token
  GENERATE_TOKEN_FAIL = 'Generate token fail',
  VERIFY_TOKEN_FAIL = 'Token is not valid',

  //Account
  NOT_FOUND_ACCOUNT = 'Not found account',
  UPDATE_PASSWORD_FAIL = 'Update password fail',
  PASSWORD_RESTRICTION = 'New passwords cannot match any of the user previous 2 passwords',
  PASSWORD_INCORRECT = 'Password mismatch your password',
  WRONG_METHOD = 'Your method cant change password',

  // SOCIAL
  TRY_ANOTHER_LOGIN_METHOD = 'An account with this email already exists us  ing a different login method. Please use the original method to log in',
  NOT_FOUND_ANY_CHANNEL_OF_THIS_USER = 'Not found any channel of this user',
  NOT_FOUND_ANY_CHANNEL = 'Not found any channel ',

  //video
  UPLOAD_THUMBNAIL_FAIL = 'Thumbnail resolution should be at least 1280x720 pixels',
  UPLOAD_VIDEO_FAIL = 'Upload video fail',
  NOT_FOUND_VIDEO = 'Not found video',
  UPDATE_VIDEO_FAIL = 'Update video fail',
  //category
  NOT_FOUND_CATEGORY = 'Not found category',
  CAN_NOT_DELETE_VIDEOS = 'Can not delete videos',
}
