import { useFetch } from '@/utils/vue-query.util'
import { COUNTRY_BASE } from '@constants/api.constant'
import { usePostFetch } from '@utils/vue-query.util'

export const countriesService = {
  getAllCountries: () => useFetch(`${COUNTRY_BASE}/countries/positions`),

  getAllStates: (country) => {
    const body = { country }

    return usePostFetch(`${COUNTRY_BASE}/countries/states`, body, {
      enabled: !country,
      refetchOnWindowFocus: false,
      staleTime: 300000
    })
  },

  getAllCities: (country, state) => {
    const body = { country: country, state: state }

    return usePostFetch(`${COUNTRY_BASE}/countries/state/cities`, body, {
      enabled: !country && !state,
      refetchOnWindowFocus: false,
      staleTime: 300000
    })
  }
}
