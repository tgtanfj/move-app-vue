import { useQuery } from "@tanstack/vue-query"
import { apiAxios } from "../helpers/axios.helper"

const ANALYTICS_OVERVIEW = '/channel/overview'

export const fetchAnalyticsOverview = async () => {
  const response = await apiAxios.get(ANALYTICS_OVERVIEW)
  return response.data
}

export const useAnalyticsOverview = () => {
  return useQuery({
    queryKey: ['analytics-overview'],
    queryFn: () => fetchAnalyticsOverview()
  })
}