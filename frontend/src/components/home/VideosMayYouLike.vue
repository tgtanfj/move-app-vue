<script setup>
import { ref } from 'vue'
import Video from './Video.vue'
import VideoSkeleton from './VideoSkeleton.vue'

const channels = ref([])
</script>

<template>
  <div class="w-full mt-6 flex flex-col">
    <div class="flex items-center justify-between">
      <p class="font-bold text-[24px]">{{ $t('homepage.video_may_you_like') }}</p>
    </div>
    <div v-if="channels" class="grid grid-cols-4 gap-8 mt-4">
      <div v-for="(item, index) in channels" :key="index">
        <Video :video="item" />
      </div>
    </div>
    <div v-if="!channels" class="grid grid-cols-4 gap-8 mt-4">
      <div v-for="item in 8" :key="item">
        <VideoSkeleton />
      </div>
    </div>
  </div>
</template>
