<script setup>
import { onMounted, onUnmounted, ref, watch, watchEffect } from 'vue'
import { useRoute } from 'vue-router'
import { LEVEL, SORT_BY } from '../../constants/view-channel.constant'
import { useCategory } from '../../services/category.services'
import { useChannelVideos } from '../../services/channel_about.services'
import { useChannelStore } from '../../stores/view-channel'
import Video from '../home/Video.vue'
import Loading from '../Loading.vue'
import CustomSelection from './CustomSelection.vue'
import VideoSkeleton from '@components/home/VideoSkeleton.vue'

const route = useRoute()
const id = route.params.id

const categoryItems = ref([])
const videos = ref([])
const page = ref(1)
const hasVideos = ref(false)
const hasMoreVideos = ref(true)
const isLoadingNextPage = ref(false)

const channelStore = useChannelStore()
const { name } = channelStore.channelInfo
const { data, isLoading: isLoadingCategory } = useCategory()
const { data: videosData, isFetching: isLoadingVideos, refetch } = useChannelVideos(id, page)

watchEffect(() => {
  if (!isLoadingCategory.value && data.value) {
    categoryItems.value = data.value.data
  }
})
watchEffect(() => {
  if (!isLoadingVideos.value && videosData.value) {
    const newVideos = videosData.value.data
    if (newVideos.length < 6) {
      hasMoreVideos.value = false
    }

    if (newVideos.length > 0) {
      hasVideos.value = true
      videos.value.push(...newVideos)
    }

    isLoadingNextPage.value = false
  }
})

watch(
  [
    () => channelStore.selectedLevel,
    () => channelStore.selectedCategory,
    () => channelStore.selectedSortBy
  ],
  () => {
    videos.value = []
    page.value = 1
    hasMoreVideos.value = true
    refetch()
  }
)
const handleSelectLevel = (value) => {
  channelStore.setSelectedLevel(value)
}
const handleSelectCategory = (value) => {
  channelStore.setSelectedCategory(value)
}
const handleSelectSortBy = (value) => {
  channelStore.setSelectedSortBy(value)
}

// Scroll event to load more videos
const handleScroll = () => {
  if (
    window.innerHeight + window.scrollY >= document.body.offsetHeight - 50 &&
    hasMoreVideos.value &&
    !isLoadingVideos.value
  ) {
    page.value += 1
    refetch()
    isLoadingNextPage.value = true
  }
}

// Add event listener when the component is mounted
onMounted(() => {
  window.addEventListener('scroll', handleScroll)
})

// Clean up the event listener when the component is unmounted
onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})
</script>
<template>
  <div class="flex items-center justify-between" v-if="!isLoadingCategory && hasVideos">
    <h1 class="text-title-size font-bold">{{ $t('view_channel.all_videos') }}</h1>

    <!-- SORT -->
    <div class="flex gap-5">
      <CustomSelection label="level" :listItems="LEVEL" @update:value="handleSelectLevel" />
      <CustomSelection
        label="category"
        :listItems="categoryItems"
        @update:value="handleSelectCategory"
      />
      <CustomSelection label="sort by" :listItems="SORT_BY" @update:value="handleSelectSortBy" />
    </div>
  </div>
  <VideoSkeleton v-if="isLoadingVideos && page === 1" />
  <div v-else class="@container">
    <div v-if="videos.length > 0" class="grid grid-cols-3 gap-6 mt-4 @[1100px]:grid-cols-4">
      <div v-for="item in videos" :key="item">
        <Video :video="item" />
      </div>
    </div>
    <div v-else-if="!hasVideos" class="italic text-center mt-[20%]">
      {{ $t('view_channel.not_upload_video', { name }) }}
    </div>
    <div v-else class="italic text-center mt-[15%]">
      {{ $t('common.no_data') }}
    </div>
  </div>
  <Loading v-if="isLoadingNextPage" class="mt-20" />
</template>
