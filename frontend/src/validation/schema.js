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
    .oneOf([ref('password')], 'The confirmation password does not match the new password.')
})
export const emailSchema = object({
  email: string().matches(REGEX_EMAIL, 'Invalid email').required('Please enter your email')
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
    .required('This field is required'),

  confirmPassword: string()
    .oneOf([ref('password')], 'The confirmation password does not match the new password.')
    .required('This field is required'),

  code: string().matches(REGEX_REFERRAL_CODE, 'Referral code must be 8 alphanumeric characters')
})

export const signinSchema = object({
  email: string().matches(REGEX_EMAIL, 'Invalid email').required('Please enter your email'),
  password: string()
    .required('Please enter your password')
    .min(8, 'Password must be between 8 and 32 characters')
    .max(32, 'Password must be between 8 and 32 characters')
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

//     country: z.string().nonempty('Country is required')
//   })
// )
