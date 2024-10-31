import { useQuery } from '@tanstack/vue-query'
import { apiAxios } from '../helpers/axios.helper'

const ANALYTICS_OVERVIEW_URL = '/channel/overview'
const ANALYTICS_VIDEOS_URL = '/channel/video-analytics'

export const fetchAnalyticsOverview = async () => {
  const response = await apiAxios.get(ANALYTICS_OVERVIEW_URL)
  return response.data
}

export const useAnalyticsOverview = () => {
  return useQuery({
    queryKey: ['overview-analytics'],
    queryFn: () => fetchAnalyticsOverview()
  })
}

const fetchVideoAnalytics = async (option, sortBy, asc, page, take) => {
  const response = await apiAxios.get(
    `${ANALYTICS_VIDEOS_URL}?option=${option}&sortBy=${sortBy}&asc=${asc}&page=${page}&take=${take}`
  )

  return response.data
}

export const useVideoAnalytics = (option, sortBy, asc, page, take) => {
  return useQuery({
    queryKey: ['videos-analytics'],
    queryFn: () =>
      fetchVideoAnalytics(option.value, sortBy.value, asc.value, page.value, take.value)
  })
}
