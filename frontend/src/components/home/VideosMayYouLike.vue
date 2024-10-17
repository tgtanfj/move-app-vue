<script setup>
import { ref, watch } from 'vue'
import VideoSkeleton from './VideoSkeleton.vue'
import { homepageService } from '@services/homepage.services'
import VideoMayLike from './VideoMayLike.vue'

const videos = ref([])

const accessToken = localStorage.getItem('token')

watch(
  () => accessToken,
  async (newValue) => {
    if (newValue) {
      const response = await homepageService.getVideoMayYouLikeLoggedIn()
      if (response.message === 'success') {
        videos.value = response?.data
      }
    } else {
      const response = await homepageService.getVideoMayYouLikeNotLogin()
      if (response.message === 'success') {
        videos.value = response?.data
      }
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
    <div v-if="videos" class="grid grid-cols-4 gap-8 mt-4">
      <div v-for="(item, index) in videos" :key="index">
        <VideoMayLike :video="item" />
      </div>
    </div>
    <div v-if="!videos" class="grid grid-cols-4 gap-8 mt-4">
      <div v-for="item in 8" :key="item">
        <VideoSkeleton />
      </div>
    </div>
    <div v-if="!videos" class="grid grid-cols-4 gap-8 mt-4">
      <div v-for="item in 8" :key="item">
        <VideoSkeleton />
      </div>
    </div>
  </div>
</template>
