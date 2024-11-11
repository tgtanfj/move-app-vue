import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useVideoQueueStore = defineStore('video_queue', () => {
  const isOpenVideoQueue = ref(true)
  const isVideoQueueShow = ref(false)
  const countdownVideoQueue = ref(5)
  const isCountingVideoQueue = ref(false)
  const tempThumbnail = ref(null)
  const tempVideoTitle = ref(null)
  const tempCategory = ref(null)
  const tempWorkoutLevel = ref(null)
  const tempDuration = ref(null)
  const isBannedUpload = ref(false)
  const uploadLoadingVideoQueue = ref(false)

  const toggleIsOpenVideoQueue = () => {
    isOpenVideoQueue.value = !isOpenVideoQueue.value
  }
  return {
    isOpenVideoQueue,
    isVideoQueueShow,
    countdownVideoQueue,
    isCountingVideoQueue,
    tempThumbnail,
    tempVideoTitle,
    tempCategory,
    tempWorkoutLevel,
    tempDuration,
    isBannedUpload,
    uploadLoadingVideoQueue,
    toggleIsOpenVideoQueue,
  }
})
