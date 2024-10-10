import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useChannelStore = defineStore('view_channel', () => {
  const channelInfo = ref(null)

  const setChannelInfo = (data) => {
    channelInfo.value = data
  }
  return { channelInfo, setChannelInfo }
})
