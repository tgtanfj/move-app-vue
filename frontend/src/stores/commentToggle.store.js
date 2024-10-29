import { defineStore } from 'pinia'
import { computed, ref } from 'vue'

export const useCommentToggleStore = defineStore('commentToggle', () => {
  const channelId = ref(null)
  const videoChannelId = ref(null)
  const isCommentable = ref(false)
  const isInstructor = computed(() => channelId.value === videoChannelId.value)
  const isDisabledActions = computed(() => !isCommentable.value === isInstructor.value)

  const setChannelId = (value) => {
    channelId.value = value
  }

  const setVideoChannelId = (value) => {
    videoChannelId.value = value
  }

  const setIsDisabledActions = (value) => {
    isDisabledActions.value = value
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
    setIsDisabledActions,
    setIsCommentable
  }
})
