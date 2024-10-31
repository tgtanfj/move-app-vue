<script setup>
import CustomSelection from '@components/channel-view/CustomSelection.vue'
import TableAnalytics from '@components/dashboard-analytics/TableAnalytics.vue'
import { ChevronLeft, ChevronRight } from 'lucide-vue-next'
import { reactive, ref, watchEffect } from 'vue'
import { Button } from '../../common/ui/button/index'
import Loading from '../../components/Loading.vue'
import { PAGINATION } from '../../constants/pagination.constant'
import { SHOW_ANALYTICS, SORT_BY_ANALYTICS } from '../../constants/view-channel.constant'
import { useVideoAnalytics } from '../../services/streamer-analytics.services'
import { determineAsc, getSortTypeFromTitle } from '../../utils/filterVideos.utils'

const show = ref('all-time')
const sortBy = ref('all')
const asc = ref(false)
const take = ref(10)
const currentPage = ref(1)
const videos = ref([])
const total = ref(0)
const totalPages = ref()
const { data, isLoading, refetch } = useVideoAnalytics(show, sortBy, asc, currentPage, take)
const display_range = reactive({
  to: 1,
  from: 1
})

watchEffect(() => {
  if (!isLoading.value && data.value) {
    total.value = data?.value?.meta?.total
    totalPages.value = data?.value?.meta?.totalPages
    videos.value = data.value.data
  }
})

watchEffect(() => {
  display_range.to = (currentPage.value - 1) * take.value + 1
  display_range.from = currentPage.value * take.value
  if (display_range.from > total.value) {
    display_range.from = total.value
  }
})

const handleShowAnalyticChange = (value) => {
  show.value = value
  refetch()
}
const handleSortTypeChange = (value) => {
  sortBy.value = getSortTypeFromTitle(value)
  asc.value = determineAsc(value)
  refetch()
}
const handleTakeChange = (value) => {
  currentPage.value = 1
  take.value = Number(value)
  refetch()
}

const handlePrevPage = () => {
  if (currentPage.value > 1) {
    currentPage.value--
    refetch()
  }
}
const handleNextPage = () => {
  if (currentPage.value < totalPages.value) {
    currentPage.value++
    refetch()
  }
}
</script>
<template>
  <div class="mt-[80px] ml-6 mb-10 w-full">
    <Loading v-if="isLoading" class="mt-72"></Loading>
    <div v-else>
      <div class="flex items-center justify-between pr-16 mb-5">
        <h1 class="text-title-size font-bold">{{ $t('streamer_analysis.video_analytics') }}</h1>
        <div class="flex gap-10" v-if="videos.length > 0">
          <CustomSelection
            label="sort by"
            :listItems="SORT_BY_ANALYTICS"
            @update:value="handleSortTypeChange"
          />
          <CustomSelection
            label="show"
            :listItems="SHOW_ANALYTICS"
            @update:value="handleShowAnalyticChange"
          />
        </div>
      </div>
      <div>
        <div v-if="videos.length > 0">
          <TableAnalytics :videos="videos" />
        </div>
        <div v-else class="ml-5 mt-4 italic">{{ $t('streamer.no_videos') }}</div>
      </div>
      <div class="flex items-center justify-between mt-5 pr-16" v-if="videos.length > 0">
        <div class="flex items-center">
          <p class="uppercase">{{ $t('common.show') }}</p>
          <CustomSelection :list-items="PAGINATION" class="w-24" @update:value="handleTakeChange" />
        </div>
        <div class="flex items-center gap-2">
          <p
            v-if="videos.length > 1"
            v-html="
              $t('common.display_range_record', {
                to: `<strong>${display_range.to}</strong>`,
                from: `<strong>${display_range.from}</strong>`,
                total
              })
            "
          ></p>
          <p v-else>
            {{ $t('common.display_single_record', { num: total }) }}
          </p>
          <div>
            <Button variant="link" class="p-4" @click="handlePrevPage">
              <ChevronLeft
                :size="17"
                :class="currentPage > 1 ? 'text-primary' : 'text-darkGray '"
              />
            </Button>
            <Button variant="link" class="p-4" @click="handleNextPage">
              <ChevronRight
                :size="17"
                :class="currentPage < totalPages ? 'text-primary' : 'text-darkGray '"
              />
            </Button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
