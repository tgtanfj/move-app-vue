<script setup>
import { homepageService } from '@services/homepage.services'
import { ref, watch } from 'vue'
import VideoMayLike from './VideoMayLike.vue'
import VideoSkeleton from './VideoSkeleton.vue'

const videos = ref([])

const accessToken = localStorage.getItem('token')

watch(
  () => accessToken,
  async (newValue) => {
    if (newValue) {
      console.log('new value co')
      const response = await homepageService.getVideoMayYouLikeLoggedIn()
      if (response.message === 'success') {
        videos.value = response?.data
      }
    } else {
      console.log('new value khong')
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
    <div class="@container">
      <div v-if="videos" class="grid grid-cols-3 gap-8 mt-4 @[1100px]:grid-cols-4">
        <div v-for="(item, index) in videos" :key="index">
          <VideoMayLike :video="item" />
        </div>
      </div>
    </div>
    <div v-if="!videos" class="grid grid-cols-4 gap-8 mt-4">
      <div v-for="item in 8" :key="item">
        <VideoSkeleton />
      </div>
    </div>
  </div>
</template>
