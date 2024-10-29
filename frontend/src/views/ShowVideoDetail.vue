<script setup>
import VideoLeft from '@components/showVideoDetail/VideoLeft.vue'
import VideoRight from '@components/showVideoDetail/VideoRight.vue'
import axios from 'axios'
import { onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { Skeleton } from '@common/ui/skeleton'
import VideoSkeleton from '../components/home/VideoSkeleton.vue'
import Button from '@common/ui/button/Button.vue'
import { ADMIN_BASE } from '@constants/api.constant'
import { useAuthStore } from '../stores/auth'
import { apiAxios } from '@helpers/axios.helper'

const route = useRoute()
const router = useRouter()

const authStore = useAuthStore()

const videoDetail = ref(null)
const isLoading = ref(true)
const isNotFoundVideo = ref(false)

const durationVideo = ref(0)
const hasCalledApi = ref(false)
const videoId = ref(0)
const viewTimeWatched = ref(0)

let timer = null

const goBackHome = () => {
  router.push('/')
}

const getVideoDetailById = async (videoIdParams, token) => {
  try {
    isLoading.value = true
    isNotFoundVideo.value = false
    let result = null

    videoId.value = videoIdParams
    if (!token) {
      result = await axios.get(`${ADMIN_BASE}/video/${videoIdParams}/details`)
    } else {
      result = await apiAxios.get(`/video/${videoIdParams}/details`)
    }
    const dataVideo = result.data.data
    if (dataVideo.url) {
      const vimeoId = dataVideo.url.split('/').pop()
      const vimeoPlayerUrl = `https://player.vimeo.com/video/${vimeoId}?autoplay=1&title=0&byline=0&portrait=0&badge=0`
      dataVideo.url = vimeoPlayerUrl
    }
    videoDetail.value = dataVideo
    durationVideo.value = dataVideo.durationsVideo

    startTimer()
  } catch (error) {
    console.log('Error', error)
    isNotFoundVideo.value = true
  } finally {
    isLoading.value = false
  }
}

const startTimer = () => {
  let timeWatched = 0

  if (timer) {
    clearInterval(timer)
  }

  timer = setInterval(() => {
    if (hasCalledApi.value) {
      clearInterval(timer)
      return
    }

    timeWatched += 1
    viewTimeWatched.value = timeWatched

    if (timeWatched >= (durationVideo.value * 0.7)) {
      callViewApi()
      hasCalledApi.value = true
      clearInterval(timer)
    }
  }, 1000)
}

const callViewApi = async () => {
  const jsonToSend = {
    videoId: Number(videoId.value),
    date: new Date().toISOString().split('T')[0]
  }

  try {
    await axios.post(`${ADMIN_BASE}/view`, jsonToSend)
  } catch (error) {
    console.log('Error recording view:', error)
  }
}

const onBeforeRouteLeave = (to, from, next) => {
  clearInterval(timer)
  if (hasCalledApi.value) {
    callViewApiWithViewTime()
  }
  next()
}

const callViewApiWithViewTime = async () => {
  const jsonToSend = {
    videoId: Number(videoId.value),
    date: new Date().toISOString().split('T')[0],
    viewTime: Number(viewTimeWatched.value) 
  }

  try {
    await axios.post(`${ADMIN_BASE}/view  `, jsonToSend)
  } catch (error) {
    console.log('Error recording view with viewTime:', error)
  }
}

onMounted(() => {
  router.beforeEach((to, from, next) => {
    onBeforeRouteLeave(to, from, next)
  })
})

onBeforeUnmount(() => {
  clearInterval(timer)
})

watch(() => route.params.id, (newId) => {
  hasCalledApi.value = false
  viewTimeWatched.value = 0
  getVideoDetailById(newId, authStore.accessToken)
})

watch(
  [() => route.params.id, () => authStore.accessToken],
  async (newValue) => {
    const [videoId, token] = newValue
    if (token) {
      getVideoDetailById(videoId, token)
    } else {
      getVideoDetailById(videoId, null)
    }
  },
  { immediate: true }
)
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
