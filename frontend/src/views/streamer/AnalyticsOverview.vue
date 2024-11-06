<script setup>
import FiguresCard from '@components/dashboard-analytics/FiguresCard.vue'
import LatestVideo from '@components/dashboard-analytics/LatestVideo.vue'
import Loading from '@components/Loading.vue'
import { useAnalyticsOverview } from '@services/streamer-analytics.services'
import { reactive, ref, watchEffect } from 'vue'
import { convertToTimeFormat } from '../../utils/formatVideoLength.util'

const latestVideo = ref({})
const figures = reactive({
  numberOfFollowers: 0,
  numberOfREPs: 0,
  totalView: 0,
  avgTime: 0
})
const { data, isLoading } = useAnalyticsOverview()

watchEffect(() => {
  if (!isLoading.value && data.value) {
    figures.numberOfFollowers = data.value.data.numberOfFollowers
    figures.numberOfREPs = data.value.data.numberOfREPs
    figures.totalView = data.value.data.totalView
    figures.avgTime = data.value.data.avgTime
    latestVideo.value = data.value.data.lastVideo
  }
})
</script>
<template>
  <div class="mt-[80px] ml-6 mb-16 w-full">
    <Loading v-if="isLoading" class="mt-72" />
    <div v-else class="flex gap-7">
      <div>
        <div>
          <h1 class="text-title-size font-bold mb-2">{{ $t('streamer_analysis.overview') }}</h1>
          <div v-if="latestVideo" class="flex gap-5">
            <FiguresCard
              :title="$t('streamer_analysis.total_followers')"
              :figures="figures.numberOfFollowers"
            />
            <FiguresCard
              :title="$t('streamer_analysis.total_REPs_earned')"
              :figures="figures.numberOfREPs"
            />
          </div>
          <div v-else class="text-[16px] italic">{{ $t('common.no_data') }}</div>
        </div>
        <div class="mt-10" v-if="latestVideo">
          <h1 class="text-title-size font-bold mb-5">
            {{ $t('streamer_analysis.video_summary') }}
          </h1>
          <div class="flex gap-5">
            <FiguresCard
              :title="$t('streamer_analysis.total_video_views')"
              :figures="figures.totalView"
            />
            <FiguresCard
              :title="$t('streamer_analysis.average_view_time')"
              :figures="convertToTimeFormat(Math.round(figures.avgTime))"
            />
          </div>
        </div>
      </div>
      <div v-if="latestVideo">
        <h1 class="text-title-size font-bold mb-5">
          {{ $t('streamer_analysis.latest_analytics') }}
        </h1>
        <LatestVideo v-if="latestVideo" :video="latestVideo" />
      </div>
    </div>
  </div>
</template>
