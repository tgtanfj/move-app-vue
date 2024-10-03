import { useMutation } from '@tanstack/vue-query'
import { apiAxios } from '../helpers/axios.helper'

const OTP_VERIFICATION_URL = '/auth/signup/email'

export const useOTPVerification = () => {
  return useMutation({
    mutationFn: (data) => {
      // return apiClient.post(OTP_VERIFICATION_URL, data)
      return apiAxios.post(`${OTP_VERIFICATION_URL}`, data)
    }
  })
}
