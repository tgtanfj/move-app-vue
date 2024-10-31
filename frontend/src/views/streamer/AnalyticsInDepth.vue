<script setup>
import StartIcon from '@assets/icons/startIcon.vue'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@common/ui/tabs'
import { Card, CardContent, CardHeader, CardTitle } from '@/common/ui/card'
import { BarChart } from '@common/ui/chart-bar'
import CustomSelection from '@components/channel-view/CustomSelection.vue'
import FiguresCard from '@components/dashboard-analytics/FiguresCard.vue'
import { SHOW_ANALYTICS } from '@constants/view-channel.constant'
import { ChevronLeft, Percent } from 'lucide-vue-next'
import { useRoute, useRouter } from 'vue-router'
import { onMounted, ref } from 'vue'
import { ADMIN_BASE } from '@constants/api.constant'
import { apiAxios } from '@helpers/axios.helper'
import { convertDatePublish } from '@utils/convertTimePostVideo.util'
import LoadingTable from '@components/LoadingTable.vue'
import { convertToTimeFormat } from '@utils/formatVideoLength.util'

const router = useRouter()
const route = useRoute()

const videoAnaId = route.params.videoId

const videoInDepth = ref(null)
const videoInDepthGraphic = ref([])
const videoInDepthCountry = ref([])
const videoInDepthState = ref([])

const countryName = ref('')
const totalUsers = ref('')
const selectedCountry = ref(null)

const dataAge = ref([
  { name: '18 - 24', total: 0 },
  { name: '25 - 34', total: 0 },
  { name: '35 - 44', total: 0 },
  { name: '45 - 54', total: 0 },
  { name: '55 - 64', total: 0 },
  { name: '64 above', total: 0 },
  { name: 'Unknown', total: 0 }
])

const transformDataAge = (resAgeData) => {
  dataAge.value.forEach((item) => {
    item.total = 0
  })

  resAgeData.forEach(({ age_group, total_count }) => {
    const ageItem = dataAge.value.find((item) => item.name === age_group)
    if (ageItem) {
      ageItem.total = parseInt(total_count, 10)
    }
  })
}

const selectCountry = async (countryId, country_name, total_users) => {
  try {
    const res = await apiAxios.get(
      `${ADMIN_BASE}/video/analytic/graphic/${videoAnaId}/${countryId}?option=all-time`
    )
    countryName.value = country_name
    totalUsers.value = total_users
    videoInDepthState.value = res.data.data.update
    selectedCountry.value = res.data.data.update
  } catch (error) {
    console.error(error)
  }
}

const backToList = () => {
  selectedCountry.value = null
}

const backToVideoAnalytics = () => {
  router.push('/streamer/analytics/videos')
}

const handleSelectDate = (date) => {
  fetchData(date)
}

const fetchData = async (option) => {
  if (videoAnaId) {
    try {
      const resInDepth = await apiAxios.get(
        `${ADMIN_BASE}/video/analytic/${videoAnaId}?option=${option}`
      )
      if (resInDepth.data && videoAnaId) {
        const resGender = await apiAxios.get(
          `${ADMIN_BASE}/video/analytic/graphic/${videoAnaId}?option=${option}`
        )
        const resAge = await apiAxios.get(
          `${ADMIN_BASE}/video/analytic/graphic/${videoAnaId}?option=${option}&graphic=age`
        )
        const resCountry = await apiAxios.get(
          `${ADMIN_BASE}/video/analytic/graphic/${videoAnaId}?option=${option}&graphic=nation`
        )
        videoInDepthGraphic.value = resGender.data.data.update
        videoInDepthCountry.value = resCountry.data.data.update

        if (resAge.data.data) {
          transformDataAge(resAge.data.data)
        }
      }

      videoInDepth.value = resInDepth.data.data
    } catch (error) {
      console.error(error)
    }
  }
}

onMounted(() => {
  fetchData('all-time')
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
      <CustomSelection label="show" :listItems="SHOW_ANALYTICS" @update:value="handleSelectDate" />
    </div>

    <div class="flex gap-14 mt-2" v-if="videoInDepth && videoInDepthGraphic">
      <!-- Left content -->
      <div>
        <div class="w-[250px] h-[150px]">
          <img :src="videoInDepth.thumbnail" alt="thumbnail" class="w-full h-full" />
        </div>
        <p class="font-bold text-lg mt-2">{{ videoInDepth.title }}</p>
        <p class="text-lg text-gray-500 font-medium">{{ videoInDepth.category }}</p>

        <ul class="flex flex-col gap-2 w-full mt-7">
          <li class="flex justify-between items-end">
            <p class="font-semibold uppercase text-gray-500">{{ $t('search.views') }}</p>
            <p>{{ videoInDepth.numberOfViews === null ? '0' : videoInDepth.numberOfViews }}</p>
          </li>
          <li class="flex justify-between items-end">
            <p class="font-semibold uppercase text-gray-500">
              {{ $t('video_in_depth.avg_view_time') }}
            </p>
            <p>{{ convertToTimeFormat(videoInDepth.avgWatched) }}</p>
          </li>
          <li class="flex justify-between items-end">
            <p class="font-semibold uppercase text-gray-500">{{ $t('search.rating') }}</p>
            <p class="flex gap-1 items-center">
              {{ videoInDepth.rating === null ? '0' : videoInDepth.rating
              }}<StartIcon class="h-[16px] w-[16px]" />
            </p>
          </li>
          <li class="flex justify-between items-end">
            <p class="font-semibold uppercase text-gray-500">
              {{ $t('video_in_depth.publish_on') }}
            </p>
            <p>{{ convertDatePublish(videoInDepth.publishedOn) }}</p>
          </li>
        </ul>
      </div>

      <!-- Right content -->
      <div class="w-full">
        <div class="flex gap-7">
          <FiguresCard title="Total REPs earned" :figures="videoInDepth.numberOfReps" />
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
            <FiguresCard
              v-for="(item, index) in videoInDepthGraphic"
              :key="index"
              :title="item.gender_group"
              :figures="item.total_count"
              :percent="item.percent"
            />
          </TabsContent>

          <TabsContent value="age" class="w-full">
            <BarChart
              :data="dataAge"
              :categories="['total']"
              :index="'name'"
              :rounded-corners="10"
            />
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
              <CardContent v-if="videoInDepthState.length > 0" class="pb-5 px-0">
                <p class="font-semibold mb-3 px-5">{{ countryName }} ({{ totalUsers }})</p>
                <ul class="list-none max-h-[250px] overflow-auto custom-scrollbar">
                  <li
                    v-for="item in selectedCountry"
                    :key="province"
                    class="mt-2 px-5 flex justify-between w-full"
                  >
                    <p class="font-normal text-base">
                      {{ item.state_name }}
                    </p>
                    <p class="font-semibold text-lg">
                      {{ item.total_users }}
                      <span class="uppercase">({{ Math.round(item.percent) }}%)</span>
                    </p>
                  </li>
                </ul>
              </CardContent>
            </Card>

            <Card v-else class="w-[34rem] shadow-[0px_5px_10px_rgba(0,0,0,0.35)] mx-0 mt-0">
              <CardHeader class="p-5 pb-3">
                <CardTitle class="text-lg font-bold">{{
                  $t('video_in_depth.most_views')
                }}</CardTitle>
              </CardHeader>
              <CardContent class="pb-5">
                <ul
                  class="w-full flex flex-col gap-1 list-none"
                  v-for="item in videoInDepthCountry"
                  :key="item.id"
                >
                  <li class="flex justify-between w-full">
                    <p
                      class="font-semibold text-lg hover:text-primary hover:underline cursor-pointer"
                      @click="selectCountry(item.country_id, item.country_name, item.total_users)"
                    >
                      {{ item.country_name }}
                    </p>
                    <p class="font-semibold text-lg">
                      {{ item.total_users }}
                      <span class="uppercase">({{ Math.round(item.percent) }}%)</span>
                    </p>
                  </li>
                </ul>
              </CardContent>
            </Card>
          </TabsContent>
        </Tabs>
        <!-- /Tabs info -->
      </div>
    </div>
    <div v-else class="flex items-center justify-center h-96 w-full">
      <LoadingTable />
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
  background-color: #ffffff;
}
</style>
