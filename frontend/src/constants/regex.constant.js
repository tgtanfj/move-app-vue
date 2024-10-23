// Regular expression patterns for testing content-type response headers.
export const REGEX_CONTENT_TYPE_JSON = new RegExp('^application/(x-)?json', 'i')
export const REGEX_CONTENT_TYPE_TEXT = new RegExp('^text/', 'i')

export const REGEX_STRONG_PASSWORD = new RegExp(
  /^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*])(?=.{8,})/
)
export const REGEX_EMAIL = /^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[\w-]{2,4}$/
export const REGEX_REFERRAL_CODE = new RegExp(/^[A-Za-z0-9]{8}$/)
export const REGEX_FULLNAME_CODE = new RegExp(/^[A-Za-z\s]{8,255}$/)
export const REGEX_USERNAME_CODE = new RegExp(/^[a-zA-Z0-9_]+$/)
export const REGEX_UPLOADVIDE_TEXTAREA = new RegExp(/^[a-zA-Z0-9,\p{L}\p{M} ]*$/u)
export const REGEX_CONVERT_CATEGORY_TITLE_TO_URL_FIRST = new RegExp(/\s+/g)
export const REGEX_CONVERT_CATEGORY_TITLE_TO_URL_SECOND = new RegExp(/[^a-z0-9\-]/g)
export const REGEX_CONVERT_URL_TO_CATEGORY_TITLE = new RegExp(/-/g)
export const REGEX_FACEBOOK_URL = new RegExp(
  /^https?:\/\/(www\.)?facebook\.com(\/[a-zA-Z0-9(\.\?)?]*)?$/
)
export const REGEX_INSTAGRAM_URL = new RegExp(
  /^https?:\/\/(www\.)?instagram\.com(\/[a-zA-Z0-9._%+-]+)?\/?$/
)
export const REGEX_YOUTUBE_URL = new RegExp(
  /^https?:\/\/(www\.)?youtube\.com\/(channel\/[a-zA-Z0-9_-]+|@[\w-]+|watch\?v=[\w-]+)?\/?$/
)
