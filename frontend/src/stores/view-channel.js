import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useChannelStore = defineStore('view_channel', () => {
  const channelInfo = ref(null)
  const selectedLevel = ref('all-level')
  const selectedCategory = ref(0)
  const selectedSortBy = ref('most-recent')

  const setChannelInfo = (data) => {
    channelInfo.value = data
  }
  const setSelectedLevel = (data) => {
    selectedLevel.value = data
  }
  const setSelectedCategory = (data) => {
    selectedCategory.value = data
  }
  const setSelectedSortBy = (data) => {
    selectedSortBy.value = data
  }
  return {
    channelInfo,
    selectedLevel,
    selectedCategory,
    selectedSortBy,
    setChannelInfo,
    setSelectedLevel,
    setSelectedCategory,
    setSelectedSortBy
  }
})
