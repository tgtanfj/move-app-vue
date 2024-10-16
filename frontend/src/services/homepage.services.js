import { apiAxios } from '@helpers/axios.helper'

export const homepageService = {
  getHotTrendVideos: async () => {
    try {
      const response = await apiAxios.get(`/home/videos-trend`)
      return response.data
    } catch (error) {
      console.error('Get hot trend video error:', error)
      throw error
    }
  },
  getTopCategories: async () => {
    try {
      const response = await apiAxios.get(`/home/top-categories`)
      return response.data
    } catch (error) {
      console.error('Get top categories error:', error)
      throw error
    }
  },
  getVideoMayYouLikeLoggedIn: async () => {
    
  }
}
