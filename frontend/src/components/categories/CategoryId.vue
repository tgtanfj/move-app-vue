<script setup>
import VideoMayLike from '@components/home/VideoMayLike.vue'
import VideoSkeleton from '@components/home/VideoSkeleton.vue'
import SeparatorCross from '@components/SeparatorCross.vue'
import { homepageService } from '@services/homepage.services'
import { useAuthStore } from '../../stores/auth'
import { formatUrlToCategoryTitle } from '@utils/formatCategoryTitle.util'
import { onMounted, onUnmounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()

const categoryTitle = ref(formatUrlToCategoryTitle(route.params.title))
const categoryId = ref(route.params.id)
const videos = ref([])
const isLoading = ref(false)
const hasMoreVideos = ref(true)
const page = ref(1)

const authStore = useAuthStore()

const accessToken = ref(localStorage.getItem('token'))

onMounted(async () => {
  // if (accessToken.value) {
  //   handleGetVideosLoggedIn()
  // } else {
  //   handleGetVideosNoLogin()
  // }
  window.addEventListener('scroll', handleScroll)
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})

const handleGetVideosLoggedIn = async () => {
  if (!hasMoreVideos.value || isLoading.value) return
  isLoading.value = true

  try {
    const response = await homepageService.getVideoByCategory(categoryId.value, page.value)
    if (response.message === 'success') {
      if (response.data.length === 0) {
        hasMoreVideos.value = false
        page.value = 0
      } else {
        hasMoreVideos.value = true
        videos.value.push(...response?.data)
        page.value += 1
      }
    }
  } catch (error) {
    console.error('Error loading video:', error)
  } finally {
    isLoading.value = false
  }
}

const handleGetVideosNoLogin = async () => {
  if (!hasMoreVideos.value || isLoading.value) return
  isLoading.value = true

  try {
    const response = await homepageService.getVideoByCategoryNoLogin(categoryId.value, page.value)
    if (response.message === 'success') {
      if (response.data.length === 0) {
        hasMoreVideos.value = false
        page.value = 0
      } else {
        hasMoreVideos.value = true
        videos.value.push(...response?.data)
        page.value += 1
      }
    }
  } catch (error) {
    console.error('Error loading video no login:', error)
  } finally {
    isLoading.value = false
  }
}

watch(
  () => authStore.accessToken || accessToken.value,
  async (newValue) => {
    if (newValue) {
      await handleGetVideosLoggedIn()
    } else {
      await handleGetVideosNoLogin()
    }
  },
  {
    immediate: true
  }
)

const handleScroll = () => {
  const bottomReached = window.innerHeight + window.scrollY >= document.body.offsetHeight - 10
  if (bottomReached && !isLoading.value) {
    if (accessToken) {
      handleGetVideosLoggedIn()
    } else {
      handleGetVideosNoLogin()
    }
  }
}
</script>

<template>
  <div class="w-full h-full">
    <div class="w-full h-full">
      <div class="w-[90%] h-full p-6">
        <SeparatorCross :title="categoryTitle" />
        <div class="@container">
          <div v-if="videos" class="grid grid-cols-3 gap-8 mt-4  @[1100px]:grid-cols-4">
            <div v-for="(item, index) in videos" :key="index">
              <VideoMayLike :video="item" />
            </div>
          </div>
        </div>
        <div v-if="!videos" class="grid grid-cols-4 gap-8 mt-4">
          <div v-for="item in 12" :key="item">
            <VideoSkeleton />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
