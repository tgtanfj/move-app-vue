import { defineStore } from 'pinia'
import { computed, ref, watch } from 'vue'

export const useCommentToggleStore = defineStore('commentToggle', () => {
  const channelId = ref(null)
  const videoChannelId = ref(null)
  const isCommentable = ref(false)

  const isInstructor = computed(() => channelId.value === videoChannelId.value)
  const isDisabledActions = ref(false)

  const calculateIsDisabledActions = () => {
    isDisabledActions.value = !isCommentable.value && isInstructor.value
  }

  watch([channelId, videoChannelId, isCommentable], () => {
    if (channelId.value !== null && videoChannelId.value !== null) {
      calculateIsDisabledActions()
    }
  })

  const setChannelId = (value) => {
    channelId.value = value
  }

  const setVideoChannelId = (value) => {
    videoChannelId.value = value
  }

  const setIsCommentable = (value) => {
    isCommentable.value = value
  }

  return {
    channelId,
    videoChannelId,
    isInstructor,
    isDisabledActions,
    isCommentable,
    setChannelId,
    setVideoChannelId,
    setIsCommentable
  }
})
