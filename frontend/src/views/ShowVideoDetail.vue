<script setup>
import VideoLeft from '@components/showVideoDetail/VideoLeft.vue'
import VideoRight from '@components/showVideoDetail/VideoRight.vue'
import axios from 'axios'
import { ref, watchEffect } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { Skeleton } from '@common/ui/skeleton'
import VideoSkeleton from '../components/home/VideoSkeleton.vue'
import Button from '@common/ui/button/Button.vue'
import { ADMIN_BASE } from '@constants/api.constant'

const route = useRoute()
const router = useRouter()
const videoDetail = ref(null)
const isLoading = ref(true)
const isNotFoundVideo = ref(false)

const getVideoDetailById = async (videoId) => {
  isLoading.value = true
  isNotFoundVideo.value = false
  try {
    const res = await axios.get(`${ADMIN_BASE}/video/${videoId}/details`)
    const dataVideo = res.data.data
    if (dataVideo.url) {
      const vimeoId = dataVideo.url.split('/').pop()
      const vimeoPlayerUrl = `https://player.vimeo.com/video/${vimeoId}?autoplay=1&title=0&byline=0&portrait=0&badge=0`
      dataVideo.url = vimeoPlayerUrl
    }
    videoDetail.value = dataVideo
  } catch (error) {
    console.log('Error', error)
    isNotFoundVideo.value = true
  } finally {
    isLoading.value = false
  }
}

const goBackHome = () => {
  router.push('/')
}

watchEffect(() => {
  const videoId = route.params.id
  if (videoId) {
    getVideoDetailById(videoId)
  }
})
</script>

<template>
  <div class="flex h-screen">
    <div v-if="isLoading" class="flex w-full">
      <div class="flex-[2.8]">
        <Skeleton class="w-full h-[519px]" />
        <div class="flex justify-between p-4">
          <Skeleton class="w-80 h-10" />
          <Skeleton class="w-20 h-10" />
        </div>
        <div class="flex items-center gap-3 px-4 mt-2">
          <Skeleton class="w-16 h-16 rounded-full" />
          <Skeleton class="w-80 h-10" />
        </div>
      </div>
      <div class="flex-1 flex flex-col gap-3 p-4">
        <VideoSkeleton />
        <VideoSkeleton />
        <VideoSkeleton />
      </div>
    </div>

    <div v-else-if="isNotFoundVideo" class="m-auto flex flex-col items-center gap-5">
      <p class="text-2xl font-semibold">Video not found</p>
      <Button @click="goBackHome" class="text-lg"> GO TO HOME </Button>
    </div>

    <div v-else class="flex min-h-screen w-full">
      <VideoLeft :videoDetail="videoDetail" />
      <VideoRight :videoDetail="videoDetail" />
    </div>
  </div>
</template>
