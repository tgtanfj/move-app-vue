<script setup>
import CustomSelection from '@components/channel-view/CustomSelection.vue'
import TableAnalytics from '@components/dashboard-analytics/TableAnalytics.vue'
import { ChevronLeft, ChevronRight } from 'lucide-vue-next'
import { ref } from 'vue'
import { Button } from '../../common/ui/button/index'
import { PAGINATION } from '../../constants/pagination.constant'
import { SHOW_ANALYTICS, SORT_BY_ANALYTICS } from '../../constants/view-channel.constant'

const videos = ref([
  {
    image: 'https://www.puregym.com/media/aoljxc1l/dumbbell-workouts-for-women.jpg?quality=80',
    details: {
      title: 'Full Body Workout',
      category: 'Strength Training',
      time: '45 minutes'
    },
    views: 1200,
    average_view_time: 30,
    ratings: 4.5,
    reps: 15,
    viewer_gifted: 120
  },
  {
    image: 'https://www.puregym.com/media/aoljxc1l/dumbbell-workouts-for-women.jpg?quality=80',
    details: {
      title: 'Full Body Workout Full Body Workout',
      category: ' Functional training',
      time: '45 minutes'
    },
    views: 1200,
    average_view_time: 30,
    ratings: 4.5,
    reps: 15,
    viewer_gifted: 120
  }
])
</script>
<template>
  <div class="mt-[80px] ml-6 mb-16">
    <div class="flex items-center justify-between pr-16 mb-5">
      <h1 class="text-title-size font-bold">{{ $t('streamer_analysis.video_analytics') }}</h1>
      <div class="flex gap-10">
        <CustomSelection label="sort by" :listItems="SORT_BY_ANALYTICS" />
        <CustomSelection label="show" :listItems="SHOW_ANALYTICS" />
      </div>
    </div>
    <TableAnalytics :videos="videos" />

    <div class="flex items-center justify-between mt-5 pr-16">
      <div class="flex items-center">
        <p class="uppercase">{{ $t('common.show') }}</p>
        <CustomSelection :list-items="PAGINATION" class="w-24" />
      </div>

      <div class="flex items-center gap-2">
        <p>
          {{
            $t('common.display_range_record', {
              to: 1,
              from: 10,
              total: 10
            })
          }}
        </p>

        <div>
          <Button variant="link" class="p-4">
            <ChevronLeft :size="16" class="text-darkGray hover:text-primary" />
          </Button>
          <Button variant="link" class="p-4">
            <ChevronRight :size="16" class="text-darkGray hover:text-primary" />
          </Button>
        </div>
      </div>
    </div>
  </div>
</template>
