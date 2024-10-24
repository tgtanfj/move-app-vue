<script setup>
import { Card, CardContent, CardHeader, CardTitle } from '@/common/ui/card'
import Star from '../../assets/icons/Star.vue'
import Button from '../../common/ui/button/Button.vue'
import { truncateText } from '../../utils/truncateText.util'

const props = defineProps({
  video: {
    type: Object,
    required: true
  }
})
</script>
<template>
  <Card class="w-[500px] shadow-[0px_5px_10px_rgba(0,0,0,0.35)] mx-0 mt-0">
    <CardHeader class="p-5 pb-3">
      <CardTitle class="text-base">{{ $t('streamer_analysis.latest_video') }}</CardTitle>
    </CardHeader>
    <CardContent class="pb-5">
      <img :src="video.image" />
      <h3 class="my-3 font-bold">
        {{ truncateText(video.title, 65) }}
      </h3>

      <p class="flex justify-between mb-3">
        <span>{{ $t('streamer_analysis.total_views') }}</span>
        <span class="font-bold">{{ video.numberOfViews }}</span>
      </p>
      <p class="flex justify-between mb-3">
        <span>{{ $t('streamer_analysis.total_REPs_received') }}</span>
        <span class="font-bold">{{ video.totalREPs ?? 0 }}</span>
      </p>
      <p class="flex justify-between items-center mb-3">
        <span>{{ $t('streamer_analysis.ratings') }}</span>
        <span class="font-bold inline-block"
          >{{ video.ratings }} <Star class="inline-block ml-2 mt-[-5px]"
        /></span>
      </p>

      <Button variant="link" class="pl-0">{{ $t('button.go_to_video_analysis') }}</Button>
    </CardContent>
  </Card>
</template>
