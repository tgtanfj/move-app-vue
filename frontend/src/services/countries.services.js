import { useFetch } from '@/utils/vue-query.util'
import { useQueryClient } from '@tanstack/vue-query'
import { usePost, usePostFetch } from '@utils/vue-query.util'

export const countriesService = {
  getAllCountries: () => useFetch('https://countriesnow.space/api/v0.1/countries/positions'),

  getStatesByCountry: (country) => {
    const queryClient = useQueryClient() 

    return async () => {
      const url = 'https://countriesnow.space/api/v0.1/countries/states' 

      const configs = {
      }

      try {
        const response = await apiClient.post(url, { country }, configs) 
        const data = response.data 

        queryClient.setQueryData(['states', country], data)
        return data
      } catch (error) {
        console.error('Error fetching states:', error)
        throw error
      }
    }
  }
}
