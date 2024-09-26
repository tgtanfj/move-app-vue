// Regular expression patterns for testing content-type response headers.
// export const REGEX_CONTENT_TYPE_JSON = new RegExp('^application/(x-)?json', 'i')
// export const REGEX_CONTENT_TYPE_TEXT = new RegExp('^text/', 'i')

export const REGEX_STRONG_PASSWORD = new RegExp(
  '/^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*])(?=.{8,})/'
)
export const REGEX_EMAIL = new RegExp('/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,4}$/')
export const REGEX_REFERRAL_CODE = new RegExp('/^[A-Za-z0-9]{8}$/')
