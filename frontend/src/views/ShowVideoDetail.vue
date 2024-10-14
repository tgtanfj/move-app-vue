<script setup>
import VideoLeft from '@components/showVideoDetail/VideoLeft.vue'
import VideoRight from '@components/showVideoDetail/VideoRight.vue'
import axios from 'axios'
import { ref, watchEffect } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
const videoDetail = ref(null)
const isLoading = ref(true)
const isNotFoundVideo = ref(false)

const getVideoDetailById = async (videoId) => {
  isLoading.value = true
  isNotFoundVideo.value = false
  try {
    const res = await axios.get(
      `https://6582a30f02f747c83679c3ee.mockapi.io/api/v1/videos/${videoId}`
    )
    if (res.data.url) {
      const vimeoId = res.data.url.split('/').pop()
      const vimeoPlayerUrl = `https://player.vimeo.com/video/${vimeoId}?autoplay=1&title=0&byline=0&portrait=0&badge=0`
      res.data.url = vimeoPlayerUrl
    }
    videoDetail.value = res.data
  } catch (error) {
    console.log('Error', error)
    isNotFoundVideo.value = true
  } finally {
    isLoading.value = false
  }
}

watchEffect(() => {
  const videoId = route.params.id
  if (videoId) {
    getVideoDetailById(videoId)
  }
})
</script>

<template>
  <div class="flex min-h-screen">
    <div v-if="isLoading" class="m-auto">
      <p class="text-xl">Loading...</p>
    </div>

    <div v-else-if="isNotFoundVideo">
      <p>Video not found. Please check the video ID.</p>
    </div>

    <div v-else class="flex min-h-screen">
      <VideoLeft :videoDetail="videoDetail" />
      <VideoRight :videoDetail="videoDetail" />
    </div>
  </div>
</template>
