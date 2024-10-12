<template>
  <div class="bg-white w-full h-full">
    <Loading v-if="videoStore.isLoading" />
    <template v-if="!videoStore.isLoading && videoStore.videos">
      <h2 class="text-2xl m-7 font-bold">{{ $t('streamer.videos') }}</h2>
      <div class="mt-4" v-if="videoStore.videos.length !== 0">
        <Table :list="videoStore.videos" />
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
                  v-for="item in videoStore.pageCounts"
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
                  :class="{ invisible: selectedPage === videoStore.pageCounts.length }"
                  :disabled="selectedPage === videoStore.pageCounts.length"
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
      </div>
    </template>
  </div>
</template>

<script setup>
import Button from '@common/ui/button/Button.vue'
import Table from '@components/streamer-videos/Table.vue'
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
import { useVideoStore } from '../stores/videoManage'

const videoStore = useVideoStore()

const count = ref()
const selectedPage = ref(1)

onMounted(async () => {
  await videoStore.getUploadedVideosList(10, 1)
})
watch(count, async (newValue) => {
  await videoStore.getVideosByLimit(newValue, 1)
})
watch(selectedPage, (newValue) => {
  getVideosByLimit(count.value, newValue)
})

const handleGetVideosByPageIndex = (item) => {
  selectedPage.value = item
}

const handleNextPage = () => {
  const temp = selectedPage.value + 1
  videoStore.getVideosByLimit(count.value, temp)
  selectedPage.value = temp
}
const handlePrevPage = () => {
  const temp = selectedPage.value - 1
  videStore.getVideosByLimit(count.value, temp)
  selectedPage.value = temp
}
const handleUploadNewVideo = () => {}
</script>
