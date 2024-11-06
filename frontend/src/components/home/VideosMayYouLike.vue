<script setup>
import { homepageService } from '@services/homepage.services'
import { onMounted, ref, watch } from 'vue'
import VideoMayLike from './VideoMayLike.vue'
import VideoSkeleton from './VideoSkeleton.vue'
import { useAuthStore } from '../../stores/auth'
import Loading from '@components/Loading.vue'

const videos = ref([])
const displayedVideos = ref([])
const isLoadingMore = ref(false)
const videosPerLoad = 8

const authStore = useAuthStore()

const loadInitialVideos = async () => {
  if (authStore.accessToken) {
    const response = await homepageService.getVideoMayYouLikeLoggedIn()
    if (response.message === 'success') {
      videos.value = response.data
      displayedVideos.value = videos.value.slice(0, videosPerLoad)
    }
  } else {
    const response = await homepageService.getVideoMayYouLikeNotLogin()
    if (response.message === 'success') {
      videos.value = response.data
      displayedVideos.value = videos.value.slice(0, videosPerLoad)
    }
  }
}

const loadMoreVideos = () => {
  if (isLoadingMore.value) return

  isLoadingMore.value = true
  setTimeout(() => {
    const currentLength = displayedVideos.value.length
    if (currentLength < videos.value.length) {
      const newVideos = videos.value.slice(currentLength, currentLength + videosPerLoad)
      displayedVideos.value.push(...newVideos)
    }
    isLoadingMore.value = false
  }, 600)
}

onMounted(() => {
  window.addEventListener('scroll', () => {
    if (
      window.innerHeight + window.scrollY >= document.documentElement.scrollHeight - 10 &&
      !isLoadingMore.value
    ) {
      loadMoreVideos()
    }
  })
})

watch(
  () => authStore.accessToken,
  async (newValue) => {
    if (newValue !== undefined) {
      await loadInitialVideos()
    }
  },
  {
    immediate: true
  }
)
</script>

<template>
  <div class="w-full mt-6 flex flex-col">
    <div class="flex items-center justify-between">
      <p class="font-bold text-[24px]">{{ $t('homepage.video_may_you_like') }}</p>
    </div>
    <div class="@container">
      <div v-if="displayedVideos.length" class="grid grid-cols-3 gap-8 mt-4 @[1200px]:grid-cols-4">
        <div v-for="(item, index) in displayedVideos" :key="index">
          <VideoMayLike :video="item" />
        </div>
      </div>
      <div v-else class="grid grid-cols-3 gap-8 mt-4 @[1200px]:grid-cols-4">
        <div v-for="item in 8" :key="item">
          <VideoSkeleton />
        </div>
      </div>
      <div v-if="isLoadingMore && displayedVideos.length < 32" class="mt-4 text-center">
        <Loading/>
      </div>
    </div>
  </div>
</template>
