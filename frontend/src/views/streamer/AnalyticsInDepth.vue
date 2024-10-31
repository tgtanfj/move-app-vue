<script setup>
import StartIcon from '@assets/icons/startIcon.vue'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@common/ui/tabs'
import { Card, CardContent, CardHeader, CardTitle } from '@/common/ui/card'
import { BarChart } from '@common/ui/chart-bar'
import CustomSelection from '@components/channel-view/CustomSelection.vue'
import FiguresCard from '@components/dashboard-analytics/FiguresCard.vue'
import { SHOW_ANALYTICS } from '@constants/view-channel.constant'
import { ChevronLeft } from 'lucide-vue-next'
import { useRoute, useRouter } from 'vue-router'
import { onMounted, ref } from 'vue'
import { ADMIN_BASE } from '@constants/api.constant'
import { apiAxios } from '@helpers/axios.helper'
import { convertDatePublish } from '@utils/convertTimePostVideo.util'

const selectedCountry = ref(null)
const router = useRouter()
const route = useRoute()

const videoInDepthData = ref(null)

const data = [
  { name: '18-24', total: 1100 },
  { name: '25-34', total: Math.floor(Math.random() * 1000) },
  { name: '35-44', total: Math.floor(Math.random() * 1000) },
  { name: '45-54', total: Math.floor(Math.random() * 1000) },
  { name: '55-64', total: Math.floor(Math.random() * 1000) },
  { name: '64 above', total: Math.floor(Math.random() * 1000) },
  { name: 'Unknown', total: Math.floor(Math.random() * 1000) }
]

const selectCountry = (country) => {
  if (country === 'Vietnam') {
    selectedCountry.value = {
      name: 'Vietnam',
      provinces: ['Hà Nội', 'TP. Hồ Chí Minh', 'Đà Nẵng', 'Hải Phòng', 'Cần Thơ', 'Hué', 'Quảng Nam', 'Quảng Ngãi', 'Quảng Trị']
    }
  } else {
    selectedCountry.value = { name: country }
  }
}

const backToList = () => {
  selectedCountry.value = null
}

const backToVideoAnalytics = () => {
  router.go(-1)
}

onMounted(async () => {
  const videoAnaId = route.params.videoId
  if(videoAnaId) {
    try {
      const res = await apiAxios.get(`${ADMIN_BASE}/video/analytic/${videoAnaId}?option=all-time`)
      videoInDepthData.value = res.data.data
      console.log(videoInDepthData.value)
    } catch (error) {
      console.log(error)
    }
  }
})
</script>

<template>
  <div class="mt-[56px] pt-4 pl-6 pr-20 w-full">
    <button
      @click="backToVideoAnalytics"
      class="flex items-center text-lg font-semibold text-primary"
    >
      <ChevronLeft class="mr-1" /> {{ $t('video_in_depth.back') }}
    </button>
    <div class="flex justify-between items-center my-1">
      <h1 class="font-bold text-3xl">In-depth analytics</h1>
      <CustomSelection label="show" :listItems="SHOW_ANALYTICS" />
    </div>

    <div class="flex gap-14 mt-2" v-if="videoInDepthData">
      <!-- Left content -->
      <div>
        <div class="w-[250px] h-[150px]">
          <img
            :src="videoInDepthData.thumbnail"
            alt="thumbnail"
            class="w-full h-full"
          />
        </div>
        <p class="font-bold text-lg mt-2">{{ videoInDepthData.title }}</p>
        <p class="text-lg text-gray-500 font-medium">{{ videoInDepthData.category }}</p>
        <div class="flex w-full justify-between mt-7">
          <div class="flex flex-col gap-2 uppercase text-gray-500">
            <p class="font-semibold">{{ $t('search.views') }}</p>
            <p class="font-semibold">{{ $t('video_in_depth.avg_view_time') }}</p>
            <p class="font-semibold">{{ $t('search.rating') }}</p>
            <p class="font-semibold">{{ $t('video_in_depth.publish_on') }}</p>
          </div>
          <div class="flex flex-col gap-2 items-end">
            <p>{{ videoInDepthData.numberOfViews }}</p>
            <p>{{ videoInDepthData.avgWatched }}</p>
            <p class="flex gap-1 items-center">{{ videoInDepthData.rating }}<StartIcon class="h-[16px] w-[16px]" /></p>
            <p>{{ convertDatePublish(videoInDepthData.publishedOn) }}</p>
          </div>
        </div>
      </div>

      <!-- Right content -->
      <div class="w-full">
        <div class="flex gap-7">
          <FiguresCard title="Total REPs earned" />
          <FiguresCard title="Number of shares" />
        </div>
        <h2 class="mt-8 font-bold text-lg">{{ $t('video_in_depth.demographics') }}</h2>
        <!-- Tabs info -->
        <Tabs defaultValue="gender">
          <TabsList class="w-full flex justify-start p-0 mt-1 border-b-[1px] border-[#999999]">
            <TabsTrigger
              value="gender"
              class="data-[state=active]:border-b-[3px] border-b-[3px] px-0 mr-5 border-white rounded-none data-[state=active]:border-[#000] data-[state=active]:text-[#000]"
            >
              <span class="font-bold">{{ $t('video_in_depth.gender') }}</span>
            </TabsTrigger>
            <TabsTrigger
              value="age"
              class="data-[state=active]:border-b-[3px] border-b-[3px] px-0 mx-5 border-white rounded-none data-[state=active]:border-[#000] data-[state=active]:text-[#000]"
            >
              <span class="font-bold">{{ $t('video_in_depth.age') }}</span>
            </TabsTrigger>
            <TabsTrigger
              value="country"
              class="data-[state=active]:border-b-[3px] border-b-[3px] px-0 mx-5 border-white rounded-none data-[state=active]:border-[#000] data-[state=active]:text-[#000]"
            >
              <span class="font-bold">{{ $t('video_in_depth.country') }}</span>
            </TabsTrigger>
          </TabsList>

          <TabsContent value="gender" class="w-full flex flex-wrap gap-7 mt-3">
            <FiguresCard title="Total REPs earned" />
            <FiguresCard title="Number of shares" />
            <FiguresCard title="Total REPs earned" />
            <FiguresCard title="Number of shares" />
          </TabsContent>

          <TabsContent value="age" class="w-full">
            <BarChart :data="data" :categories="['total']" :index="'name'" :rounded-corners="10" />
          </TabsContent>

          <TabsContent value="country">
            <Card
              v-if="selectedCountry"
              class="w-[34rem] shadow-[0px_5px_10px_rgba(0,0,0,0.35)] mx-0 mt-0"
            >
              <CardHeader class="p-0 pl-3 pb-2">
                <CardTitle class="text-base font-bold">
                  <button
                    @click="backToList"
                    class="flex justify-start items-center font-medium mt-4 m-0 text-base text-primary"
                  >
                    <ChevronLeft class="p-0 m-0" /> {{ $t('video_in_depth.back') }}
                  </button>
                </CardTitle>
              </CardHeader>
              <CardContent v-if="selectedCountry.provinces.length > 0" class="pb-5 px-0">
                <p class="font-semibold mb-3 px-5">{{ selectedCountry.name }} (346)</p>
                <ul class="list-none max-h-[250px] overflow-auto custom-scrollbar">
                  <li v-for="province in selectedCountry.provinces" :key="province" class="mt-2 px-5 flex justify-between w-full">
                    <p class="font-normal text-base">
                      {{ province }}
                    </p>
                    <p class="font-semibold text-lg">102 <span class="uppercase">(20.4%)</span></p>
                  </li>
                </ul>
              </CardContent>
            </Card>

            <Card v-else class="w-[34rem] shadow-[0px_5px_10px_rgba(0,0,0,0.35)] mx-0 mt-0">
              <CardHeader class="p-5 pb-3">
                <CardTitle class="text-lg font-bold">{{ $t('video_in_depth.most_views') }}</CardTitle>
              </CardHeader>
              <CardContent class="pb-5">
                <ul class="w-full flex flex-col gap-1 list-none">
                  <li class="flex justify-between w-full">
                    <p class="font-normal text-base">
                      VN
                      <span
                        class="ml-2 font-semibold text-lg hover:text-primary hover:underline cursor-pointer"
                        @click="selectCountry('Vietnam')"
                        >Vietnam</span
                      >
                    </p>
                    <p class="font-semibold text-lg">102 <span class="uppercase">(20.4%)</span></p>
                  </li>
                  <li class="flex justify-between w-full">
                    <p class="font-normal text-base">
                      VN
                      <span
                        class="ml-2 font-semibold text-lg hover:text-primary hover:underline cursor-pointer"
                        @click="selectCountry('Vietnam')"
                        >Vietnam</span
                      >
                    </p>
                    <p class="font-semibold text-lg">102 <span class="uppercase">(20.4%)</span></p>
                  </li>
                </ul>
              </CardContent>
            </Card>
          </TabsContent>
        </Tabs>
        <!-- /Tabs info -->
      </div>
    </div>
  </div>
</template>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
  width: 6px;
}

.custom-scrollbar::-webkit-scrollbar-thumb {
  background-color: #cfcfcf;
  border-radius: 8px;
}

.custom-scrollbar::-webkit-scrollbar-thumb:hover {
  background-color: #d3d3d3;
}

.custom-scrollbar::-webkit-scrollbar-track {
  background-color: #FFFFFF;
}
</style>