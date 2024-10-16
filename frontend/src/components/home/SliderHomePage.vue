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
import CheckVerifyIcon from '@assets/icons/CheckVerifyIcon.vue'
import Star from '@assets/icons/Star.vue'
import { formatViews } from '@utils/formatViews.util'
import EyeIcon from '@assets/icons/EyeIcon.vue'
import { homepageService } from '@services/homepage.services'
import { onMounted, ref } from 'vue'
import SliderHomePageSkeleton from './SliderHomePageSkeleton.vue'

const channels = [
  {
    thumbnail:
      'https://i0.wp.com/spartansboxing.com/wp-content/uploads/2023/08/Mike-Tyson.png?fit=1920%2C1080&ssl=1',
    title: 'Fitness World',
    avatar: 'https://wsbufm.com/wp-content/uploads/2023/03/mike-tyson.jpg?w=640',
    notification: 'posted 5 days ago',
    stars: 4.9,
    duration: 'less than 1 hour',
    workoutLevel: 'beginner',
    category: 'Strength',
    isAuth: true,
    about: 'This channel focuses on beginner-friendly workouts and fitness tips.',
    views: 141033123
  },
  {
    thumbnail:
      'https://i0.wp.com/www.muscleandfitness.com/wp-content/uploads/2018/12/1109-Larry-Wheels-Deadlift.jpg?quality=86&strip=all',
    title: 'Yoga with Jane',
    avatar: 'https://wsbufm.com/wp-content/uploads/2023/03/mike-tyson.jpg?w=640',
    notification: 'posted 2 days ago',
    stars: 4.7,
    duration: '30 minutes',
    workoutLevel: 'intermediate',
    category: 'Strength',
    isAuth: true,
    about: 'Join Jane for relaxing yoga sessions tailored to all skill levels.',
    views: 3200
  },
  {
    thumbnail:
      'https://www.si.com/.image/ar_16:9%2Cc_fill%2Ccs_srgb%2Cfl_progressive%2Cq_auto:good%2Cw_1200/MjA1MTgxNjYwNjkyNDg5ODYw/conor-mcgregor-ufc-octagon-spotlight.jpg',
    title: 'Powerlifting Pro',
    avatar: 'https://wsbufm.com/wp-content/uploads/2023/03/mike-tyson.jpg?w=640',
    notification: 'posted 1 week ago',
    stars: 4.8,
    duration: '1 hour',
    workoutLevel: 'advanced',
    category: 'Strength',
    isAuth: false,
    about: 'Learn the secrets of powerlifting and strength training from the pros.',
    views: 2250
  },
  {
    thumbnail:
      'https://boxraw.com/cdn/shop/articles/Saul-Canelo-Alvarez-Dmitry-Bivol6-Photo-by-Ed-Mulholland-Matchroom.jpg?v=1652185062',
    title: 'Cardio Burn',
    avatar: 'https://wsbufm.com/wp-content/uploads/2023/03/mike-tyson.jpg?w=640',
    notification: 'posted 3 days ago',
    stars: 4.5,
    duration: '45 minutes',
    workoutLevel: 'beginner',
    category: 'Strength',
    isAuth: true,
    about: 'High-energy cardio workouts designed to get your heart pumping.',
    views: 1720
  },
  {
    thumbnail:
      'https://media-cdn-v2.laodong.vn/storage/newsportal/2020/9/3/832994/The-Rock-Tai-Tu-The-.jpg',
    title: 'HIIT with Alex',
    avatar: 'https://wsbufm.com/wp-content/uploads/2023/03/mike-tyson.jpg?w=640',
    notification: 'posted 6 hours ago',
    stars: 4.6,
    duration: '20 minutes',
    workoutLevel: 'intermediate',
    about: 'Alex offers quick and intense HIIT sessions that fit into your busy day.',
    category: 'Strength',
    views: 2900,
    isAuth: false
  }
]

const plugin = Autoplay({
  delay: 3000,
  stopOnMouseEnter: true,
  stopOnInteraction: false
})

const videos = ref(null)

onMounted(async () => {
  const response = await homepageService.getHotTrendVideos()
  videos.value = response.data
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
      <CarouselItem v-for="(item, index) in channels" :key="index">
        
        <!-- <div class="p-1">
          <Card class="mt-5">
            <CardContent
              class="relative flex p-0 mt-0 pt-0 items-center h-[300px] w-full justify-center rounded-lg overflow-hidden"
            >
              <div class="flex-[0.65] h-full">
                <img
                  :src="item.thumbnail"
                  class="w-full h-full object-cover cursor-pointer"
                  alt=""
                />
              </div>
              <div class="flex-[0.35] h-full flex flex-col items-center justify-center gap-2.5">
                <div class="flex items-start gap-3 w-[80%]">
                  <img
                    :src="item.avatar"
                    class="w-[56px] h-[56px] rounded-full object-cover cursor-pointer"
                  />
                  <div class="flex items-start flex-col justify-start">
                    <div class="flex gap-4 items-center">
                      <p class="text-[16px] cursor-pointer">{{ item.title }}</p>
                      <CheckVerifyIcon v-if="item.isAuth" />
                      <div v-else="item.isAuth"></div>
                    </div>
                    <div class="text-[#666666] text-[14px] flex flex-col">
                      <p>{{ item.category }}</p>
                      <p>{{ item.notification }}</p>
                    </div>
                    <div class="flex items-center gap-2 mt-1">
                      <Star />
                      <p class="font-bold text-[14px]">{{ item.stars }}</p>
                    </div>
                  </div>
                </div>
                <div class="flex items-center justify-start w-[80%] gap-2">
                  <div class="py-2 px-4 bg-[#EEEEEE] rounded-full text-[10px] font-bold">
                    {{ item.workoutLevel }}
                  </div>
                  <div class="py-2 px-4 bg-[#EEEEEE] rounded-full text-[10px] font-bold">
                    {{ item.duration }}
                  </div>
                </div>
                <div class="w-[80%] text-[14px] text-[#666666] mt-2">
                  {{ item.about }}
                </div>
              </div>
              <div
                class="absolute bottom-4 left-4 bg-black text-white px-2 py-1 rounded-md font-bold h-[25px] text-[16px] flex items-center gap-2"
              >
                <EyeIcon />
                <p>
                  {{ item.views ? formatViews(item.views) : '0 view' }}
                </p>
              </div>
            </CardContent>
          </Card>
        </div> -->

        <SliderHomePageSkeleton />
      </CarouselItem>
    </CarouselContent>
    <CarouselPrevious />
    <CarouselNext />
  </Carousel>
</template>
