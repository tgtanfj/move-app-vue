import { useQuery } from '@tanstack/vue-query'
import { storeToRefs } from 'pinia'
import { apiAxios } from '../helpers/axios.helper'
import { useChannelStore } from '../stores/view-channel'

const fetchChannelAbout = async (id) => {
  const response = await apiAxios.get(`/channel/${id}/about`)
  return response.data
}

export const useChannelAbout = (id) => {
  return useQuery({
    queryKey: ['channel_about', id],
    queryFn: () => fetchChannelAbout(id.value),
    enabled: !!id.value
  })
}

const fetchVideos = async (id, level, sortBy, category, page) => {
  let response
  if (category != 0) {
    response = await apiAxios.get(
      `/channel/${id}/videos?workout-level=${level}&sort-by=${sortBy}&categoryId=${category}&page=${page}`
    )
  } else {
    response = await apiAxios.get(
      `/channel/${id}/videos?workout-level=${level}&sort-by=${sortBy}&page=${page}`
    )
  }
  return response.data
}

export const useChannelVideos = (id, page) => {
  const channelStore = useChannelStore()
  const { selectedLevel, selectedSortBy, selectedCategory } = storeToRefs(channelStore)

  return useQuery({
    queryKey: ['channel_videos', id],
    queryFn: () =>
      fetchVideos(
        id,
        selectedLevel.value,
        selectedSortBy.value,
        selectedCategory.value,
        page.value
      ),
    enabled: !!id && !!selectedLevel && !!selectedSortBy
  })
}
