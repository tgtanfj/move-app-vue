import { useMutation } from '@tanstack/vue-query'
import { apiAxios } from '../helpers/axios.helper'
const FOLLOW_URL = `/follow`

export const useFollow = () => {
  return useMutation({
    mutationFn: (data) => {
      return apiAxios.post(FOLLOW_URL, data)
    }
  })
}
export const useUnfollow = () => {
  return useMutation({
    mutationFn: (data) => {
      return apiAxios.delete(FOLLOW_URL, {
        data: data 
      })
    }
  })
}
