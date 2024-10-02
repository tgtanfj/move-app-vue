import { useMutation } from '@tanstack/vue-query'
import axios from 'axios'
import { ADMIN_BASE } from '../constants/api.constant'

const OTP_VERIFICATION_URL = '/auth/signup/email'

export const useOTPVerification = () => {
  return useMutation({
    mutationFn: (data) => {
      // return apiClient.post(OTP_VERIFICATION_URL, data)
      return axios.post(`${ADMIN_BASE}${OTP_VERIFICATION_URL}`, data)
    }
  })
}
