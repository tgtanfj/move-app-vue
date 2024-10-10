<script setup>
import CheckVerifyIcon from '@assets/icons/CheckVerifyIcon.vue'
import EyeIcon from '@assets/icons/EyeIcon.vue'
import StartIcon from '@assets/icons/startIcon.vue'
// import { convertTimePostVideo } from '@utils/convertTimePostVideo.util'
// import { formatViews } from '@utils/formatViews.util'

const props = defineProps({
  video: {
    type: Object,
    required: true
  }
})
</script>

<template>
  <RouterLink :to="`/video/${video.id}`">
    <div class="flex flex-col cursor-pointer">
      <div class="aspect-w-1 aspect-h-1 h-[170px] relative">
        <img class="object-cover w-full h-[170px]" :src="video.thumbnail" :alt="video.title" />
        <div
          class="absolute bottom-4 left-4 text-white bg-black text-[12px] flex items-center gap-2 px-2 rounded-md"
        >
          <EyeIcon />
          <p class="font-bold">
            <!-- {{ video.views ? formatViews(video.views) : '0 view' }} -->
            0 view
          </p>
        </div>
        <div class="absolute bottom-4 right-4 text-white bg-black text-[12px] px-2 rounded-md">
          <p class="font-bold">{{ video.videoTime }}</p>
        </div>
      </div>
      <div class="flex items-start mt-2">
        <img class="w-[32px] h-[32px] rounded-full" :src="video.avatar" />
        <div class="ml-3">
          <p class="text-[16px] font-bold">{{ video.title }}</p>
          <div class="flex flex-col items-start justify-start mt-1.5">
            <div class="flex items-center gap-3">
              <p class="text-[#666666] text-[14px]">{{ video.title }}</p>
              <CheckVerifyIcon v-if="video.isAuth" />
            </div>
            <div class="flex gap-1 items-center">
              <p class="text-[#666666] text-[14px]">{{ video.category }}</p>
              <p>⋅</p>
              <p class="text-[#666666] text-[14px]">
                <!-- {{ video.postedTime ? convertTimePostVideo(video.postedTime) : 'Posted a day ago' }} -->
                Posted a day ago
              </p>
            </div>
            <div class="flex items-center gap-1 justify-start mt-2">
              <div class="py-2 px-4 bg-[#EEEEEE] rounded-full text-[10px] font-bold">
                {{ video.workoutLevel }}
              </div>
              <div class="py-2 px-4 bg-[#EEEEEE] rounded-full text-[10px] font-bold">
                {{ video.duration }}
              </div>
            </div>
          </div>
        </div>
        <div class="flex items-center gap-1 ml-auto">
          <StartIcon class="h-[16px] w-[16px]" />
          <p class="text-[14px] font-bold">{{ video.stars }}</p>
        </div>
      </div>
    </div>
  </RouterLink>
</template>
