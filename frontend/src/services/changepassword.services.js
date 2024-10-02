import { useMutation } from '@tanstack/vue-query'
import { apiAxios } from '../helpers/axios.helper'

const CHANGE_PASSWORD_URL = `/auth/change-password`

export const useChangePassword = () => {
  return useMutation({
    mutationFn: (data) => {
      return apiAxios.post(`${CHANGE_PASSWORD_URL}`, data)
    }
  })
}
