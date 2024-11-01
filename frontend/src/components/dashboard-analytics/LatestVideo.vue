<script setup>
import { Card, CardContent, CardHeader, CardTitle } from '@/common/ui/card'
import Star from '../../assets/icons/Star.vue'
import Button from '../../common/ui/button/Button.vue'
import { useRouter } from 'vue-router';

const props = defineProps({
  video: {
    type: Object,
    required: true
  }
})

const router = useRouter()

const routeToInDepth = (videoId) => {
  router.push({ name: 'InDepthVideo', params: {videoId: videoId}})
}
</script>
<template>
  <Card class="w-[500px] shadow-[0px_5px_10px_rgba(0,0,0,0.35)] mx-0 mt-0">
    <CardHeader class="p-5 pb-3">
      <CardTitle class="text-base">{{ $t('streamer_analysis.latest_video') }}</CardTitle>
    </CardHeader>
    <CardContent class="pb-5">
      <img :src="video.thumbnail" class="h-[265px] w-full object-cover">
      <h3 class="my-3 font-bold truncate text-nowrap">
        {{ video.title  }}
      </h3>

      <p class="flex justify-between mb-3">
        <span>{{ $t('streamer_analysis.total_views') }}</span>
        <span class="font-bold">{{ video.numberOfViews }}</span>
      </p>
      <p class="flex justify-between mb-3">
        <span>{{ $t('streamer_analysis.total_REPs_received') }}</span>
        <span class="font-bold">{{ video.totalreps ?? 0 }}</span>
      </p>
      <p class="flex justify-between items-center mb-3">
        <span>{{ $t('streamer_analysis.ratings') }}</span>
        <span class="font-bold inline-block"
          >{{ video.ratings }} <Star class="inline-block ml-1 mt-[-5px]"
        /></span>
      </p>

      <Button @click="routeToInDepth(video.id)" variant="link" class="pl-0">{{ $t('button.go_to_video_analysis') }}</Button>
    </CardContent>
  </Card>
</template>
