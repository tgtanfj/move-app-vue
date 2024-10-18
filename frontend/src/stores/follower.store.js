import { homepageService } from '@services/homepage.services'
import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useFollowerStore = defineStore('follower', () => {
  const follower = ref([])

  const getAllFollowers = async () => {
    const response = await homepageService.getFollowedChannels()
    if (response.message === 'success') {
      follower.value = response?.data
    }
  }

  return {
    follower,
    getAllFollowers
  }
})
