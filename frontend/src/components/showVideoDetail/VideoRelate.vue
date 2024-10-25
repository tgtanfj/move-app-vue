<script setup>
import CheckVerifyIcon from '@assets/icons/CheckVerifyIcon.vue'
import EyeIcon from '@assets/icons/EyeIcon.vue'
import StartIcon from '@assets/icons/startIcon.vue'
import { convertTimePostVideo } from '@utils/convertTimePostVideo.util'
import { formatViews } from '@utils/formatViews.util'
import { convertToTimeFormat } from '../../utils/formatVideoLength.util'

const props = defineProps({
  video: {
    type: Object,
    required: true
  }
})

const durationLite =
  props.video.duration === 'less than 30 minutes'
    ? '30 mins'
    : props.video.duration === 'less than 1 hours'
      ? '< 1 hour'
      : props.video.duration === 'more than 1 hours'
        ? '> 1 hour'
        : 'unknown'

const workoutLevelLite =
  props.video.workoutLevel === 'beginner'
    ? 'Beginner'
    : props.video.workoutLevel === 'intermediate'
      ? 'Intermediate'
      : props.video.workoutLevel === 'advanced'
        ? 'Advanced'
        : 'unknown'
</script>

<template>
  <RouterLink :to="`/video/${video?.id}`">
    <div class="flex flex-col cursor-pointer">
      <div class="aspect-w-1 aspect-h-1 h-[170px] relative">
        <img
          class="object-cover w-full h-[170px]"
          :src="
            video?.thumbnailURL ||
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR-GwBWO82SDhf6q-IDxzTm06rATH45qELJyw&s'
          "
          :alt="video?.title"
        />
        <div
          class="absolute bottom-4 left-4 text-white bg-black text-[12px] flex items-center gap-2 px-2 rounded-md"
        >
          <EyeIcon />
          <p class="font-bold">
            {{ video?.numberOfViews ? formatViews(video?.numberOfViews) : '0 view' }}
          </p>
        </div>
        <div class="absolute bottom-4 right-4 text-white bg-black text-[12px] px-2 rounded-md">
          <p class="font-bold">{{ convertToTimeFormat(video.durationsVideo) }}</p>
        </div>
      </div>
      <div class="flex items-start mt-2">
        <img class="w-[32px] h-[32px] rounded-full" :src="video?.channel?.image" />
        <div class="ml-3">
          <p class="text-[16px] font-bold">{{ video?.title }}</p>
          <div class="flex flex-col items-start justify-start mt-1.5">
            <div class="flex items-center gap-3">
              <p class="text-[#666666] text-[14px]">{{ video.name }}</p>
              <CheckVerifyIcon v-if="video.isAuth" />
            </div>
            <div class="flex gap-1 items-center">
              <p class="text-[#666666] text-[14px]">{{ video?.category?.title }}</p>
              <p>⋅</p>
              <p class="text-[#666666] text-[14px]">
                {{ video.createdAt ? convertTimePostVideo(video?.createdAt) : 'Posted a day ago' }}
              </p>
            </div>
            <div class="flex items-center gap-1 justify-start mt-2">
              <div class="py-2 px-4 bg-[#EEEEEE] rounded-full text-[10px] font-bold">
                {{ workoutLevelLite }}
              </div>
              <div class="py-2 px-4 bg-[#EEEEEE] rounded-full text-[10px] font-bold">
                {{ durationLite }}
              </div>
            </div>
          </div>
        </div>
        <div v-if="video?.ratings !== 0" class="flex items-center gap-1 ml-auto">
          <StartIcon class="h-[16px] w-[16px]" />
          <p class="text-[14px] font-bold">{{ video?.ratings }}</p>
        </div>
        <div v-else class="flex items-center gap-1 ml-auto"></div>
      </div>
    </div>
  </RouterLink>
</template>
