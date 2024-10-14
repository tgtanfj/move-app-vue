import * as yup from 'yup'
import { object, ref, string } from 'yup'
import {
  REGEX_EMAIL,
  REGEX_STRONG_PASSWORD,
  REGEX_USERNAME_CODE
} from '../constants/regex.constant'
import { t } from '../helpers/i18n.helper'

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
  email: string()
    .required(t('error_message.required_email')),
    // .matches(REGEX_EMAIL, t('error_message.invalid_email')),
  password: string()
    .required(t('error_message.required'))
    // .min(8, t('error_message.invalid_password'))
    // .max(32, t('error_message.invalid_password'))
    // .matches(REGEX_STRONG_PASSWORD, t('error_message.invalid_password')),
})

export const userProfileSchema = yup.object().shape({
  username: yup
    .string()
    .required(t('user_profile.field_required'))
    .matches(REGEX_USERNAME_CODE, t('user_profile.username_verify_message'))
    .min(4, t('user_profile.username_verify_message'))
    .max(25, t('user_profile.username_verify_message')),
  fullName: yup
    .string()
    .matches(/^.{8,255}$/, t('user_profile.fullname_8_255_long'))
    .matches(/^[A-Za-z\s]*$/, t('user_profile.fullname_no_special_characters')),
  country: yup.string().required(t('user_profile.field_required')),
  state: yup.string().required(t('user_profile.field_required')),
  gender: yup
    .string()
    .required(t('user_profile.field_required'))
    .oneOf(['male', 'female', 'rather not say']),
  dateOfBirth: yup
    .string()
    .required(t('user_profile.field_required'))
    .test('is-valid-date', 'Invalid date format', (value) => {
      const date = new Date(value)
      return !isNaN(date.getTime()) // Check if it's a valid date
    })
    .test('is-in-range', t('user_profile.invalid_age'), (value) => {
      const date = new Date(value)
      const maxAge = 65
      const minAge = 18
      const today = new Date()
      const minDate = new Date(today.getFullYear() - minAge, today.getMonth(), today.getDate())
      const maxDate = new Date(today.getFullYear() - maxAge, today.getMonth(), today.getDate())

      return date <= minDate && date >= maxDate // Check if the date is in the range
    }),
  avatar: yup.mixed().nullable().required(t('user_profile.field_required')),
  city: yup.string()
})
