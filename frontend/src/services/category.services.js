import { useQuery } from '@tanstack/vue-query'
import { apiAxios } from '../helpers/axios.helper'

export const fetchCategory = async () => {
  return (await apiAxios.get('/category')).data
}

export const useCategory = () => {
  return useQuery({
    queryKey: ['category'],
    queryFn: () => fetchCategory()
  })
}
