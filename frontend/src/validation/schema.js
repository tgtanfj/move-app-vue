import { object, ref, string } from 'yup'
import {
  REGEX_EMAIL,
  REGEX_REFERRAL_CODE,
  REGEX_STRONG_PASSWORD
} from '../constants/regex.constant'

export const passwordSchema = object({
  password: string()
    .required('This field is required')
    .min(8, 'Password must be between 8 and 32 characters')
    .max(32, 'Password must be between 8 and 32 characters')
    .matches(
      REGEX_STRONG_PASSWORD,
      'Please choose a stronger password. Try a combination of letters, numbers, and special character'
    ),
  confirmPassword: string()
    .required('This field is required')
    .min(8)
    .oneOf([ref('password')], 'Password must match')
})
export const emailSchema = object({
  email: string()
    .matches(REGEX_EMAIL, 'Please enter a valid email address')
    .required('Please enter your email')
})

export const registerSchema = object({
  email: string()
    .email('Invalid email')
    .matches(REGEX_EMAIL, 'Invalid email')
    .min(5, 'Email must be at least 5 characters')
    .max(255, 'Email must not exceed 255 characters')
    .required('Please enter your email'),

  password: string()
    .min(8, 'Password must be between 8 and 32 characters')
    .max(32, 'Password must be between 8 and 32 characters')
    .matches(
      REGEX_STRONG_PASSWORD,
      'Please choose a stronger password. Try a combination of letters, numbers, and special character'
    )
    .required('Please enter your password'),

  confirmPassword: string()
    .oneOf([ref('password')], 'Confirmation password does not match')
    .required('Please enter confirm password'),

  code: string().matches(REGEX_REFERRAL_CODE, 'Referral code must be 8 alphanumeric characters')
})

export const signinSchema = object({
  email: string()
    .matches(REGEX_EMAIL, 'Please enter a valid email address')
    .required('Please enter your email'),
  password: string()
    .required('Please enter your password')
    .min(8, 'Password must be between 8 and 32 characters')
    .max(32, 'Password must be between 8 and 32 characters')
})
