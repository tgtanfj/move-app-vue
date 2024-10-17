<script setup lang="ts">
import Autoplay from 'embla-carousel-autoplay'
import {
  Carousel,
  CarouselContent,
  CarouselItem,
  CarouselNext,
  CarouselPrevious
} from '@common/ui/carousel'
import { Card, CardContent } from '@common/ui/card'
import Star from '@assets/icons/Star.vue'
import { formatViews } from '@utils/formatViews.util'
import EyeIcon from '@assets/icons/EyeIcon.vue'
import { homepageService } from '@services/homepage.services'
import { onMounted, ref } from 'vue'
import SliderHomePageSkeleton from './SliderHomePageSkeleton.vue'
import BlueBadgeIcon from '@assets/icons/BlueBadgeIcon.vue'
import PinkBadgeIcon from '@assets/icons/PinkBadgeIcon.vue'
import { useRouter } from 'vue-router'
import { detectDuration } from '@utils/uploadVideo.util'

const plugin = Autoplay({
  delay: 3000,
  stopOnMouseEnter: true,
  stopOnInteraction: false
})

const router = useRouter()

const videos = ref([])

onMounted(async () => {
  const response = await homepageService.getHotTrendVideos()
  if (response.message === 'success') {
    videos.value = response.data
    console.log('videos', videos.value)
  }
})
</script>

<template>
  <Carousel
    class="relative w-full"
    :plugins="[plugin]"
    @mouseenter="plugin.stop"
    @mouseleave="[plugin.reset(), plugin.play()]"
  >
    <CarouselContent>
      <CarouselItem v-if="videos.length > 0" v-for="(item, index) in videos" :key="index">
        <div class="p-1">
          <Card class="mt-5">
            <CardContent
              @click="router.push(`/video/${item.videoId}`)"
              class="relative flex p-0 mt-0 pt-0 items-center h-[300px] w-full justify-center rounded-lg overflow-hidden"
            >
              <div class="flex-[0.65] h-full">
                <img
                  :src="item.thumbnailURL"
                  class="w-full h-full object-cover cursor-pointer"
                  alt=""
                />
              </div>
              <div class="flex-[0.35] h-full flex flex-col items-center justify-center gap-2.5">
                <div class="flex items-start gap-3 w-[80%]">
                  <img
                    :src="item.channel.image"
                    class="w-[56px] h-[56px] rounded-full object-cover cursor-pointer"
                  />
                  <div class="flex items-start flex-col justify-start">
                    <div class="flex gap-2 items-center">
                      <p
                        @click.stop="router.push(`/channel/${item.channel.id}`)"
                        class="text-[16px] cursor-pointer"
                      >
                        {{ item.channel.name }}
                      </p>
                      <BlueBadgeIcon v-if="item.channel.isBlueBadge" />
                      <PinkBadgeIcon v-if="item.channel.isPinkBadge" />
                    </div>
                    <div class="text-[#666666] text-[14px] flex flex-col">
                      <p>{{ item.category.content }}</p>
                    </div>
                    <div class="flex items-center gap-2 mt-1">
                      <Star />
                      <p class="font-bold text-[14px]">{{ item.ratings }}</p>
                    </div>
                  </div>
                </div>
                <div class="flex items-center mt-1 justify-start w-[80%] gap-2">
                  <div class="py-2 px-4 bg-[#EEEEEE] rounded-full text-[10px] font-bold">
                    {{ item.workoutLevel }}
                  </div>
                  <div class="py-2 px-4 bg-[#EEEEEE] rounded-full text-[10px] font-bold">
                    {{ detectDuration(item.duration) }}
                  </div>
                </div>
                <div class="w-[80%] text-[14px] text-[#666666] mt-2">
                  {{ item.title }}
                </div>
              </div>
              <div
                class="absolute bottom-4 left-4 bg-black text-white px-2 py-1 rounded-md font-bold h-[25px] text-[16px] flex items-center gap-2"
              >
                <EyeIcon />
                <p>
                  {{ item.numberOfViews ? formatViews(item.numberOfViews) : '0 view' }}
                </p>
              </div>
            </CardContent>
          </Card>
        </div>
      </CarouselItem>
      <CarouselItem v-if="videos.length === 0">
        <SliderHomePageSkeleton />
      </CarouselItem>
    </CarouselContent>
    <CarouselPrevious />
    <CarouselNext />
  </Carousel>
</template>
