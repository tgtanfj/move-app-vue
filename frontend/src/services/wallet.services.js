import { COUNTRY_BASE } from '@constants/api.constant'
import { apiAxios } from '@helpers/axios.helper'

export const walletServices = {
  fetchUserLocation: async () => {
    const ipinforToken = import.meta.env.VITE_IPINFO_TOKEN

    try {
      const response = await apiAxios.get(`https://ipinfo.io?token=${ipinforToken}`)
      return response.data
    } catch (err) {
      return Error('Error fetching location data:')
    }
  },
  getCountries: async () => {
    try {
      const response = await apiAxios.get(`${COUNTRY_BASE}/countries/positions`)
      return response.data
    } catch (error) {
      console.error('Error fetching location data:', error)
    }
  }
}
