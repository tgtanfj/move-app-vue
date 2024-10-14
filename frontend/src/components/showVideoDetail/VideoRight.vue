<script setup>
import VideoRelate from '@components/showVideoDetail/VideoRelate.vue'

const props = defineProps({
  videoDetail: {
    type: Object,
    required: true
  }
})

</script>

<template>
  <div v-if="props.videoDetail && props.videoDetail.watch_also" class="flex-1 p-4">
    <h3 class="text-sm font-semibold mb-4">{{ $t('video_detail.watch_also') }}</h3>
    <div class="flex flex-col gap-6">
      <div v-for="video in props.videoDetail.watch_also" :key="video.id">
        <VideoRelate :video="video" />
      </div>
    </div>
  </div>
</template>