import * as yup from 'yup'
import { object, ref, string } from 'yup'
import {
  REGEX_CARD_HOLDER_NAME,
  REGEX_EMAIL,
  REGEX_STRONG_PASSWORD,
  REGEX_USERNAME_CODE
} from '../constants/regex.constant'
import { t } from '../helpers/i18n.helper'
import { isBefore, subYears } from 'date-fns'

export const passwordSchema = object({
  password: string()
    .required(t('error_message.required'))
    .min(8, t('error_message.password_length'))
    .max(32, t('error_message.password_length'))
    .matches(REGEX_STRONG_PASSWORD, t('error_message.strong_password')),
  confirmPassword: string()
    .required(t('error_message.required'))
    .oneOf([ref('password')], t('error_message.match_password'))
})

export const emailSchema = object({
  email: string()
    .required(t('error_message.required_email'))
    .matches(REGEX_EMAIL, t('error_message.invalid_email'))
})

export const registerSchema = object({
  email: string()
    .required(t('error_message.required_email'))
    .test('has-at-symbol', 'Email must contain "@" symbol.', value => value && value.includes('@'))
    .test('has-dot', 'Email must contain a dot "."', value => value && value.includes('.'))
    .test('valid-domain', 'Email domain must be between 2 and 4 characters and only contain letters.', value => {
      const domain = value && value.split('@')[1]?.split('.')[1];
      return domain && /^[a-zA-Z]{2,4}$/.test(domain);
    })
    .matches(REGEX_EMAIL, t('error_message.invalid_email')),

  password: string()
    .required(t('error_message.required'))
    .min(8, t('error_message.password_length'))
    .max(32, t('error_message.password_length'))
    .matches(REGEX_STRONG_PASSWORD, t('error_message.strong_password')),

  confirmPassword: string()
    .required(t('error_message.required'))
    .oneOf([ref('password')], t('error_message.match_password'))
})

export const signinSchema = object({
  email: string().required(t('error_message.required_email')),
  // .matches(REGEX_EMAIL, t('error_message.invalid_email')),
  password: string().required(t('error_message.required'))
  // .min(8, t('error_message.invalid_password'))
  // .max(32, t('error_message.invalid_password'))
  // .matches(REGEX_STRONG_PASSWORD, t('error_message.invalid_password')),
})

export const userProfileSchema = yup.object().shape({
  username: yup
    .string()
    .trim()
    .matches(REGEX_USERNAME_CODE, t('user_profile.username_verify_message'))
    .min(4, t('user_profile.username_8_255_long'))
    .max(25, t('user_profile.username_8_255_long')),
  fullName: yup
    .string()
    .trim()
    .matches(/^.{8,255}$/, t('user_profile.fullname_8_255_long'))
    .matches(/^[a-zA-ZÀ-ỹ\s]+$/, t('user_profile.fullname_no_special_characters')),
  country: yup.string(),
  state: yup.string(),
  gender: yup.string().oneOf(['male', 'female', 'rather not say']),
  dateOfBirth: yup
    .string()
    .test('is-valid-date', 'Invalid date format', (value) => {
      const date = new Date(value)
      return !isNaN(date.getTime()) // Check if it's a valid date
    })
    .test('is-in-range', t('user_profile.invalid_age'), (value) => {
      const date = new Date(value)
      const maxAge = 65
      const minAge = 13
      const today = new Date()

      const maxDate = subYears(today, minAge)
      const minDate = subYears(today, maxAge)
      return isBefore(date, maxDate) && isBefore(minDate, date)
    }),
  avatar: yup.mixed().nullable(),
  city: yup.string().trim()
})

export const searchSchema = yup.string().max(255)

export const walletSchema = yup.object().shape({
  cardholderName: yup
    .string()
    .trim()
    .matches(/^[a-zA-ZÀ-ỹ\s]+$/, t('wallet.no_special_characters'))
    .max(50, 'Max 50 characters'),
  cardNumber: yup
    .string()
    .trim()
    .length(16, 'Invalid card number')
    .matches(/^\d{16}$/, 'Invalid card number'),
  cvc: yup
    .string()
    .trim()
    .length(3, 'Invalid card verification code')
    .matches(/^\d{3}$/, 'Invalid card verification code'),
  expDate: yup
    .string()
    .matches(/^(0[1-9]|1[0-2])\/\d{2}$/, 'Check your expiration date')
    .test('valid-expiration-date', 'Check your expiration date', (value) => {
      if (!value) return false
      const [month, year] = value.split('/').map(Number)
      const currentYear = new Date().getFullYear() % 100
      const currentMonth = new Date().getMonth() + 1

      // Validate month
      if (month < 1 || month > 12) return false

      // Validate year
      if (year < currentYear || (year === currentYear && month < currentMonth)) {
        return false
      }

      return true
    }),
  cardType: yup.string().trim()
})
