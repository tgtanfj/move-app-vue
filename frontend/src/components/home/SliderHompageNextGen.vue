<script setup lang="ts">
import { ref, onMounted, computed, onUnmounted } from 'vue'
import { homepageService } from '@services/homepage.services'
import { useRouter } from 'vue-router'
import { formatViews } from '@utils/formatViews.util'
import { detectDuration } from '@utils/uploadVideo.util'
import { Card, CardContent } from '@common/ui/card'
import BlueBadgeIcon from '@assets/icons/BlueBadgeIcon.vue'
import EyeIcon from '@assets/icons/EyeIcon.vue'
import { ChevronLeft, ChevronRight } from 'lucide-vue-next'
import SliderHomePageSkeleton from './SliderHomePageSkeleton.vue'
import Star from '@assets/icons/Star.vue'

const videos = ref([])
const activeIndex = ref(0)
const previousIndex = ref(null)
const router = useRouter()
let autoSlideInterval = null

onMounted(async () => {
  const response = await homepageService.getHotTrendVideos()
  if (response.message === 'success') {
    videos.value = response.data
    setPreviousIndex()
  }
})

onMounted(async () => {
  const response = await homepageService.getHotTrendVideos()
  if (response.message === 'success') {
    videos.value = response.data
    setPreviousIndex()
  }

  autoSlideInterval = setInterval(() => {
    nextImage()
  }, 5000)
})

onUnmounted(() => {
  clearInterval(autoSlideInterval)
})

const activeVideo = computed(() => videos.value[activeIndex.value])
const previousVideo = computed(() =>
  previousIndex.value !== null ? videos.value[previousIndex.value] : null
)

const setPreviousIndex = () => {
  if (activeIndex.value > 0) {
    previousIndex.value = activeIndex.value - 1
  } else {
    previousIndex.value = videos.value.length - 1
  }
}

const resetAutoSlide = () => {
  clearInterval(autoSlideInterval)
  autoSlideInterval = setInterval(() => {
    nextImage()
  }, 5000)
}

const nextImage = () => {
  activeIndex.value = (activeIndex.value + 1) % videos.value.length
  setPreviousIndex()
  resetAutoSlide()
}

const prevImage = () => {
  activeIndex.value = (activeIndex.value - 1 + videos.value.length) % videos.value.length
  setPreviousIndex()
  resetAutoSlide()
}

const stopAutoSlide = () => {
  clearInterval(autoSlideInterval)
}

const startAutoSlide = () => {
  autoSlideInterval = setInterval(() => {
    nextImage()
  }, 5000)
}
</script>

<template>
  <div class="relative w-full" v-if="videos?.length > 0">
    <transition v-if="previousVideo" name="slide-fade">
      <div
        class="absolute top-8 left-1/2 transform -translate-x-1/2 w-[95%] opacity-60"
        key="previous"
      >
        <Card class="mt-5">
          <CardContent
            class="relative flex p-0 mt-0 pt-0 items-center h-[250px] w-full justify-center rounded-lg overflow-hidden"
          >
            <img
              :src="previousVideo?.thumbnailURL"
              class="w-full h-full object-cover cursor-pointer"
              alt="Previous Video"
            />
          </CardContent>
        </Card>
      </div>
    </transition>

    <transition name="slide-fade">
      <div
        @mouseenter="stopAutoSlide"
        @mouseleave="startAutoSlide"
        v-if="activeVideo"
        class="p-1 relative z-10 w-[90%] mx-auto"
        key="active"
      >
        <Card class="mt-5">
          <CardContent
            @click="router.push(`/video/${activeVideo?.videoId}`)"
            class="relative flex p-0 mt-0 pt-0 items-center h-[300px] w-full justify-center rounded-lg overflow-hidden"
          >
            <div class="flex-[0.65] h-full">
              <img
                :src="activeVideo?.thumbnailURL"
                class="w-full h-full object-cover cursor-pointer"
                alt=""
              />
            </div>
            <div class="flex-[0.35] h-full flex flex-col items-center justify-center gap-2.5">
              <div class="flex items-start gap-3 w-[70%]">
                <img
                  @click.stop="router.push(`/channel/${activeVideo?.channel?.id}`)"
                  :src="activeVideo?.channel.image"
                  class="w-[56px] h-[56px] rounded-full object-cover cursor-pointer"
                />
                <div class="flex items-start flex-col justify-start">
                  <div class="flex gap-2 items-center">
                    <p
                      @click.stop="router.push(`/channel/${activeVideo?.channel?.id}`)"
                      class="text-[16px] cursor-pointer"
                    >
                      {{ activeVideo?.channel?.name }}
                    </p>
                    <BlueBadgeIcon v-if="activeVideo?.channel?.isBlueBadge" />
                  </div>
                  <div class="text-[#666666] text-[14px] flex flex-col">
                    <p>{{ activeVideo?.category?.title }}</p>
                  </div>
                  <div class="flex items-center gap-2 mt-1">
                    <Star />
                    <p class="font-bold text-[14px]">{{ activeVideo?.ratings }}</p>
                  </div>
                </div>
              </div>
              <div class="flex items-center mt-1 justify-start w-[80%] gap-2">
                <div class="py-2 px-4 bg-[#EEEEEE] rounded-full text-[10px] font-bold">
                  {{ activeVideo?.workoutLevel }}
                </div>
                <div class="py-2 px-4 bg-[#EEEEEE] rounded-full text-[10px] font-bold">
                  {{ detectDuration(activeVideo?.duration) }}
                </div>
              </div>
              <div class="w-[80%] text-[14px] text-[#666666] mt-2">
                {{ activeVideo?.title }}
              </div>
            </div>
            <div
              class="absolute bottom-4 left-4 bg-black text-white px-2 py-1 rounded-md font-bold h-[25px] text-[16px] flex items-center gap-2"
            >
              <EyeIcon />
              <p>
                {{
                  activeVideo?.numberOfViews ? formatViews(activeVideo?.numberOfViews) : '0 view'
                }}
              </p>
            </div>
          </CardContent>
        </Card>
      </div>
    </transition>

    <button class="absolute top-1/2 -left-3 transform -translate-y-1/2" @click="prevImage">
      <ChevronLeft class="hover:text-primary" :size="30" />
    </button>
    <button class="absolute top-1/2 -right-3 transform -translate-y-1/2" @click="nextImage">
      <ChevronRight class="hover:text-primary" :size="30" />
    </button>
  </div>
  <SliderHomePageSkeleton v-if="videos.length === 0" />
</template>

<style>
.fade-enter-active,
.fade-leave-active,
.slide-fade-enter-active,
.slide-fade-leave-active {
  transition: all 0.5s ease;
}

.fade-enter,
.fade-leave-to,
.slide-fade-enter,
.slide-fade-leave-to {
  opacity: 0;
}

.slide-fade-enter {
  transform: translateX(100%);
}
.slide-fade-leave-to {
  transform: translateX(-100%);
}
</style>
