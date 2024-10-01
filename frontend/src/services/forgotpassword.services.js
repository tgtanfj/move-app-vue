import { useMutation } from '@tanstack/vue-query'
import { apiClient } from '../helpers/fetch.helper'

const FORGOT_PASSWORD_URL = '/auth/forgot-password'
const RESET_PASSWORD_URL = '/auth/reset-password'

export const useForgotPassword = () => {
  return useMutation({
    mutationFn: (data) => {
      return apiClient.post(FORGOT_PASSWORD_URL, data)
    }
  })
}
export const useResetPassword = () => {
  return useMutation({
    mutationFn: (data) => {
      return apiClient.post(RESET_PASSWORD_URL, data)
    }
  })
}
