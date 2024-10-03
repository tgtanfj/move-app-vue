<template>
  <div class="bg-white w-full h-full">
    <Loading v-if="isLoading" />
    <template v-else>
      <h2 class="text-2xl m-7 font-bold">{{ $t('streamer.videos') }}</h2>
      <div class="mt-4" v-if="videos.length !== 0">
        <Table :list="videos" />
        <div class="flex justify-between items-center mt-5">
          <div class="flex gap-3 items-center">
            <p class="text-sm ml-5 uppercase">{{ $t('streamer.show') }}</p>
            <Select v-model="count" class="text-primary">
              <SelectTrigger class="w-[64px] text-primary border-primary">
                <SelectValue placeholder="10" />
              </SelectTrigger>
              <SelectContent ctContent class="text-primary">
                <SelectGroup>
                  <SelectItem value="5">5</SelectItem>
                  <SelectItem value="10">10</SelectItem>
                  <SelectItem value="20">20 </SelectItem>
                </SelectGroup>
              </SelectContent>
            </Select>
          </div>
          <div>
            <Pagination>
              <PaginationList>
                <Button
                  variant="outline"
                  class="pl-2"
                  @click="handlePrevPage"
                  :class="{ invisible: selectedPage === 1 }"
                  :disabled="selectedPage === 1"
                >
                  <ChevronLeft size="14" color="#14D2B5" />
                </Button>
                <PaginationListItem
                  class="gap-1"
                  v-for="item in pageCounts"
                  :key="item"
                  @click="handleGetVideosByPageIndex(item)"
                >
                  <Button
                    class="mr-2"
                    :variant="item === selectedPage ? '' : 'outline'"
                    @click="selectedPage = item"
                    >{{ item }}</Button
                  >
                </PaginationListItem>
                <Button
                  variant="outline"
                  class="pl-2"
                  @click="handleNextPage"
                  :class="{ invisible: selectedPage === pageCounts.length }"
                  :disabled="selectedPage === pageCounts.length"
                >
                  <ChevronRight size="14" color="#14D2B5" />
                </Button>
              </PaginationList>
            </Pagination>
          </div>
        </div>
      </div>
      <div class="mt-4 ml-7" v-else>
        <p class="ml-5 mt-4 italic">{{ $t('streamer.no_videos') }}</p>
        <UploadVideo class="mt-3"/>
        
      </div>
    </template>
  </div>
</template>

<script setup>
import Button from '@common/ui/button/Button.vue'
import Table from '@components/Table.vue'
import { ChevronLeft, ChevronRight, FileVideo2 } from 'lucide-vue-next'
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectLabel,
  SelectTrigger,
  SelectValue
} from '@common/ui/select'
import {
  Pagination,
  PaginationList,
  PaginationListItem,
  PaginationNext,
  PaginationPrev
} from '@common/ui/pagination'
import Loading from '@components/Loading.vue'
import { ref, watch, onMounted, computed } from 'vue'
import { videoService } from '@services/video.services'
import { ADMIN_BASE } from '@constants/api.constant'
import axios from 'axios'
import UploadVideo from '@components/UploadVideo.vue'

const count = ref()
const videos = ref([])
const isLoading = ref(false)
const error = ref('')
const pageCounts = ref([])
const selectedPage = ref(1)
const totalPages = ref()

const { data, isSuccess, isError } = videoService.getUploadVideos(10, 1)

watch(data, (newValue) => {
  if (isSuccess && newValue.data) {
    if (data) {
      videos.value = [...newValue.data]
      pageCounts.value = [...Array.from({ length: newValue.meta.totalPages }, (_, i) => i + 1)]
    }
  } else error.value = isError
})
watch(count, (newValue) => {
  getVideosByLimit(newValue, 1)
})
watch(selectedPage, (newValue) => {
  getVideosByLimit(count.value, newValue)
})

const getVideosByLimit = async (limit, page) => {
  isLoading.value = true // Set loading state
  error.value = null // Reset error state

  try {
    const token = localStorage.getItem('token') // Get token from localStorage
    const config = {
      headers: {
        Authorization: `Bearer ${token}`
      },
      params: {
        take: limit,
        page: page
      }
    }

    const res = await axios.get(`${ADMIN_BASE}/video/dashboard`, config)
    if ((res.statusCode = 200)) {
      videos.value = res.data.data
      pageCounts.value = [
        ...Array.from({ length: res.data.meta.totalPages }, (_, index) => index + 1)
      ]
    } else {
      throw new Error('No data received')
    }
  } catch (err) {
    error.value = err // Set error message
  } finally {
    isLoading.value = false // Reset loading state
  }
}
const handleGetVideosByPageIndex = (item) => {
  selectedPage.value = item
}

const handleNextPage = () => {
  const temp = selectedPage.value + 1
  getVideosByLimit(count.value, temp)
  selectedPage.value = temp
}
const handlePrevPage = () => {
  const temp = selectedPage.value - 1
  getVideosByLimit(count.value, temp)
  selectedPage.value = temp
}
</script>
