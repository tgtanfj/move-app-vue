import { object, ref, string } from 'yup'
import { REGEX_EMAIL, REGEX_STRONG_PASSWORD } from '../constants/regex.constant'
import { t } from '../helpers/i18n.helper'

export const passwordSchema = object({
  password: string()
    .required(t('error_message.required_email'))
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
    .required(t('error_message.required_email'))
    .matches(REGEX_EMAIL, t('error_message.invalid_email')),
  password: string().required(t('error_message.required'))
  // .min(8, t('error_message.strong_password'))
  // .max(32, t('error_message.strong_password'))
})
