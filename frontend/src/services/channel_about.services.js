import { useQuery } from '@tanstack/vue-query'
import { apiAxios } from '../helpers/axios.helper'

export const fetchChannelAbout = async (id) => {
  const response = await apiAxios.get(`/channel/${id}/about`)
  return response.data
}

export const useChannelAbout = (id) => {
  return useQuery({
    queryKey: ['channel_about', id],
    queryFn: () => fetchChannelAbout(id),
    enabled: !!id
  })
}
