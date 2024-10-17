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
  getAllCategories: async () => {
    try {
      const response = await apiAxios.get(`/home/categories`)
      return response.data
    } catch (error) {
      console.error('Get all categories error:', error)
      throw error
    }
  },
  getVideoByCategory: async (categoryId, page) => {
    try {
      const response = await apiAxios.get(`/home/categories/${categoryId}`, {
        params: {
          page: page,
          take: 12
        }
      })
      return response.data
    } catch (error) {
      console.error('Get video by category error:', error)
      throw error
    }
  },
  getVideoByCategoryNoLogin: async (categoryId, page) => {
    try {
      const response = await apiAxios.get(`/home/categories-no-login/${categoryId}`, {
        params: {
          page: page,
          take: 12
        }
      })
      return response.data
    } catch (error) {
      console.error('Get video by category no login error:', error)
      throw error
    }
  },
  getVideoMayYouLikeLoggedIn: async () => {
    try {
      const response = await apiAxios.get(`/home/you-may-like`)
      return response.data
    } catch (error) {
      console.error('Get you may like videos error:', error)
      throw error
    }
  },
  getVideoMayYouLikeNotLogin: async () => {
    try {
      const response = await apiAxios.get(`/home/you-may-like-no-login`)
      return response.data
    } catch (error) {
      console.error('Get you may like videos no login error:', error)
      throw error
    }
  },
  getFollowedChannels: async () => {
    try {
      const response = await apiAxios.get(`/home/get-channels`)
      return response.data
    } catch (error) {
      console.error('Get follwed channels error:', error)
      throw error
    }
  }
}
