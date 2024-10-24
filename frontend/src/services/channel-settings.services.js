import { apiAxios } from '@helpers/axios.helper'

export const channelSettingsService = {
  getChannelSettings: async () => {
    try {
      const response = await apiAxios.get('/channel/setting')
      return response.data
    } catch (error) {
      console.error('Get channel setting error:', error)
      throw error
    }
  },
  saveChannelSettings: async (channelId, bio, facebookLink, instagramLink, youtubeLink) => {
    try {
      const body = {
        bio,
        facebookLink,
        instagramLink,
        youtubeLink
      }
      const response = await apiAxios.patch(`/channel/${channelId}`, body)
      return response.data
    } catch (error) {
      console.error('Save channel setting error:', error)
      throw error
    }
  }
}
