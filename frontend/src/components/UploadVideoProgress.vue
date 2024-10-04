<script setup>
import { Progress } from '@/common/ui/progress'
import { CircleCheck } from 'lucide-vue-next'

const props = defineProps({
  progress: {
    type: Number
  },
  isSuccess: {
    type: Boolean
  }
})
</script>

<template>
  <div class="flex items-center gap-8">
    <div class="flex flex-col gap-1 items-center justify-start">
      <Progress v-if="!isSuccess" v-model="props.progress" class="w-[157px] bg-[#caf3ef]" />
      <p v-if="!isSuccess" class="text-primary text-[14px]">
        {{ $t('upload_video.upload_video_title_progress') }} ({{ props.progress }}%)
      </p>
      <div v-if="isSuccess">
        <CircleCheck :size="18" class="m-0 p-0 text-primary" />
      </div>
      <p v-if="isSuccess" class="text-primary text-[14px]">
        {{ $t('upload_video.upload_complete') }}
      </p>
    </div>
    <div v-if="!isSuccess" class="text-primary w-[310px]">
      {{ $t('upload_video.progress_text') }}
    </div>
  </div>
</template>
