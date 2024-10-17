<script setup>
import EyeIcon from '@assets/icons/EyeIcon.vue'
import StartIcon from '@assets/icons/startIcon.vue'
import { convertTimePostVideo } from '@utils/convertTimePostVideo.util'
import { formatViews } from '@utils/formatViews.util'
import { useRouter } from 'vue-router'
import BlueBadgeIcon from '../../assets/icons/BlueBadgeIcon.vue'
import PinkBadgeIcon from '../../assets/icons/PinkBadgeIcon.vue'
import { convertToTimeFormat } from '../../utils/formatVideoLength.util'
import { detectDuration } from '../../utils/uploadVideo.util'

const props = defineProps({
  video: {
    type: Object,
    required: true
  }
})

const router = useRouter()
</script>

<template>
  <div class="flex flex-col">
    <div class="aspect-w-1 aspect-h-1 h-[170px] relative">
      <img
        class="object-cover w-full h-[170px] cursor-pointer"
        :src="video.thumbnailURL"
        :alt="video.title"
        @click="router.push(`/video/${video.id}`)"
      />
      <div
        class="absolute bottom-4 left-4 text-white bg-black text-[12px] flex items-center gap-2 px-2 rounded-md"
      >
        <EyeIcon />
        <p class="font-bold">
          {{ video.numberOfViews ? formatViews(video.numberOfViews) : '0 view' }}
        </p>
      </div>
      <div class="absolute bottom-4 right-4 text-white bg-black text-[12px] px-2 rounded-md">
        <p class="font-bold">{{ convertToTimeFormat(video.videoLength) }}</p>
      </div>
    </div>
    <div class="flex items-start mt-2">
      <img class="w-[32px] h-[32px] rounded-full" :src="video.channel.image" />
      <div class="ml-3">
        <p class="text-[16px] font-bold mt-2">{{ video.title }}</p>
        <div class="flex flex-col items-start justify-start mt-1.5">
          <div class="flex items-center gap-3">
            <p
              class="text-[#666666] text-[14px] cursor-pointer"
              @click="router.push(`/channel/${video.channel.id}`)"
            >
              {{ video.channel.name }}
            </p>
            <span class="flex gap-2 ml-3">
              <BlueBadgeIcon v-if="video.channel.isBlueBadge" />
              <PinkBadgeIcon v-if="video.channel.isPinkBadge" />
            </span>
          </div>
          <div class="flex gap-1 items-center">
            <p class="text-[#666666] text-[14px]">{{ video.category.title }}</p>
            <p>⋅</p>
            <p class="text-[#666666] text-[14px]">
              {{ video.createdAt ? convertTimePostVideo(video.createdAt) : 'Posted a day ago' }}
            </p>
          </div>
          <div class="flex items-center gap-1 justify-start mt-2">
            <div class="py-2 px-4 bg-[#EEEEEE] rounded-full text-[10px] font-bold">
              {{ video.workoutLevel }}
            </div>
            <div class="py-2 px-4 bg-[#EEEEEE] rounded-full text-[10px] font-bold">
              {{ detectDuration(video.duration) }}
            </div>
          </div>
        </div>
      </div>
      <div class="flex items-center gap-1 ml-auto mt-[5px]">
        <StartIcon class="h-[16px] w-[16px]" />
        <p class="text-[14px] font-bold">{{ video.ratings }}</p>
      </div>
    </div>
  </div>
</template>
