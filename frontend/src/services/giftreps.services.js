import { useMutation, useQuery } from '@tanstack/vue-query'
import { apiAxios } from '../helpers/axios.helper'

const GIFT_PACKAGES_URL = '/donation/list-gift-packages'
const DONATION_URL = '/donation'
const USER_PROFILE_URL = '/user/profile'

const fetchGiftPackages = async () => {
  const response = await apiAxios.get(GIFT_PACKAGES_URL)
  return response.data
}

export const useGiftPackages = () => {
  return useQuery({
    queryKey: ['gift-packages'],
    queryFn: () => fetchGiftPackages()
  })
}

const fetchUserReps = async () => {
  const response = await apiAxios.get(USER_PROFILE_URL)
  return response.data
}

export const useUserReps = () => {
  return useQuery({
    queryKey: ['user-reps'],
    queryFn: () => fetchUserReps()
  })
}

export const useDonation = () => {
  return useMutation({
    mutationFn: (data) => {
      return apiAxios.post(`${DONATION_URL}`, data)
    }
  })
}