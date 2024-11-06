<script setup>
import BlueBadgeIcon from '@assets/icons/BlueBadgeIcon.vue'
import EyeIcon from '@assets/icons/EyeIcon.vue'
import StartIcon from '@assets/icons/startIcon.vue'
import { convertTimePostVideo } from '@utils/convertTimePostVideo.util'
import { convertToTimeFormat } from '@utils/formatVideoLength.util'
import { formatViews } from '@utils/formatViews.util'
import { detectDuration } from '@utils/uploadVideo.util'

const props = defineProps({
  video: {
    type: Object,
    required: true
  }
})
</script>
<template>
  <div class="flex flex-col cursor-pointer">
    <div class="aspect-w-1 aspect-h-1 h-[170px] relative">
      <router-link :to="`/video/${video.id}`">
        <img
          class="object-cover w-full h-[170px]"
          :src="video?.thumbnails[0]?.image"
          :alt="video.title"
        />
      </router-link>
      <div
        v-if="video.numberOfViews > 0"
        class="absolute bottom-4 left-4 text-white bg-black text-[12px] flex items-center gap-2 px-2 rounded-md"
      >
        <EyeIcon />
        <p class="font-bold">
          {{ video.numberOfViews && formatViews(video.numberOfViews) }}
        </p>
      </div>
      <div class="absolute bottom-4 right-4 text-white bg-black text-[12px] px-2 rounded-md">
        <p class="font-bold">{{ convertToTimeFormat(video.durationsVideo) }}</p>
      </div>
    </div>
    <div class="flex items-start mt-2">
      <router-link :to="`/channel/${video.channel.id}`">
        <div class="w-[40px] h-[40px] rounded-full">
          <img class="w-full h-full rounded-full" :src="video?.channel?.image" />
        </div>
      </router-link>
      <div class="ml-3">
        <router-link :to="`/video/${video.id}`">
          <p class="text-[16px] font-bold">
            {{
              video.title && video.title.length > 30
                ? `${video.title.slice(0, 30)}...`
                : video.title
            }}
          </p>
        </router-link>
        <div class="flex flex-col items-start justify-start mt-1.5">
          <router-link :to="`/channel/${video?.channel?.id}`">
            <div class="flex items-center gap-3">
              <p class="text-[#666666] text-[14px]">{{ video?.channel?.name }}</p>
              <BlueBadgeIcon v-if="video.channel.isBlueBadge" />
            </div>
          </router-link>
          <div class="flex gap-1 items-center">
            <p class="text-[#666666] text-[14px]">{{ video?.category?.title }}</p>
            <p>⋅</p>
            <p class="text-[#666666] text-[14px]">
              {{ video.createdAt ? convertTimePostVideo(video?.createdAt) : 'Posted a day ago' }}
            </p>
          </div>
          <div class="flex items-center gap-1 justify-start mt-2">
            <div class="py-2 px-4 bg-[#EEEEEE] rounded-full text-[10px] font-bold capitalize">
              {{ video.workoutLevel }}
            </div>
            <div class="py-2 px-4 bg-[#EEEEEE] rounded-full text-[10px] font-bold">
              {{ detectDuration(video.duration) }}
            </div>
          </div>
        </div>
      </div>
      <div v-if="video?.ratings !== 0" class="flex items-center gap-1 ml-auto pr-1 pl-2">
        <StartIcon class="h-[16px] w-[16px] mr-1" />
        <p class="text-[14px] font-bold">{{ video.ratings }}</p>
      </div>
      <div v-else class="flex items-center gap-1 ml-auto pr-1 pl-2"></div>
    </div>
  </div>
</template>
