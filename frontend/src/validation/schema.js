import { object, ref, string } from 'yup'
import {
  REGEX_EMAIL,
  REGEX_REFERRAL_CODE,
  REGEX_STRONG_PASSWORD
} from '../constants/regex.constant'
import { t } from '../helpers/i18n.helper'

export const passwordSchema = object({
  password: string()
    .required(t('error_message.required_email'))
    .min(8, t('error_message.password_length'))
    .max(32, t('error_message.password_length'))
    .matches(REGEX_STRONG_PASSWORD, t('error_message.strong_password')),
  confirmPassword: string()
    .required(t('error_message.required'))
    .min(8)
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
    .oneOf([ref('password')], t('error_message.match_password')),
  code: string().matches(REGEX_REFERRAL_CODE, t('error_message.referral_code'))
})

export const signinSchema = object({
  email: string()
    .required(t('error_message.required_email'))
    .matches(REGEX_EMAIL, t('error_message.invalid_email')),
  password: string()
    .required(t('error_message.required'))
    .min(8, t('error_message.strong_password'))
    .max(32, t('error_message.strong_password'))
})

// export const userProfileSchema = toTypedSchema(
//   z.object({
//     username: z
//       .string()
//       .regex(REGEX_USERNAME_CODE, 'Invalid username')
//       .min(4, { message: 'Username must be at least 4 characters' })
//       .max(25, 'Username cannot exceed 25 characters'),

//     gender: z.enum(['male', 'female', 'none'], {
//       required_error: 'You need to select one'
//     }),

//     fullName: z.string(),

//     country: z.string().nonempty('Country is required'),
//     state: z.string().nonempty('State is required'),
//     city: z.string().nonempty('City is required')
//   })
// )
