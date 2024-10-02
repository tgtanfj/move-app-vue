import { object, ref, string } from 'yup'
import {
  REGEX_EMAIL,
  REGEX_REFERRAL_CODE,
  REGEX_STRONG_PASSWORD
} from '../constants/regex.constant'

export const passwordSchema = object({
  password: string()
    .min(8, 'Password must be between 8 and 32 characters')
    .max(32, 'Password must be between 8 and 32 characters')
    .matches(
      REGEX_STRONG_PASSWORD,
      'Please choose a stronger password. Try a combination of letters, numbers, and special character'
    )
    .required('This field is required'),
  confirmPassword: string()
    .min(8)
    .oneOf([ref('password')], 'The confirmation password does not match the new password.')
    .required('This field is required')
})
export const emailSchema = object({
  email: string().required('Please enter your email').matches(REGEX_EMAIL, 'Invalid email')
})

export const registerSchema = object({
  email: string().required('Please enter your email').matches(REGEX_EMAIL, 'Invalid email'),

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
  email: string().required('Please enter your email').matches(REGEX_EMAIL, 'Invalid email'),
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

//     country: z.string().nonempty('Country is required'),
//     state: z.string().nonempty('State is required'),
//     city: z.string().nonempty('City is required')
//   })
// )
