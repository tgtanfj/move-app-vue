<template>
  <div class="bg-white w-full h-full mt-[65px]">
    <div class="h-full flex items-center justify-center" v-if="videoStore.isLoading">
      <Loading />
    </div>
    <template v-if="!videoStore.isLoading && videoStore.videos">
      <h2 class="text-title-size mx-7 mt-24 font-bold">{{ $t('streamer.videos') }}</h2>
      <div class="mt-4 ml-5" v-if="videoStore.videos.length !== 0">
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
                  <SelectItem :value="10">10</SelectItem>
                  <SelectItem :value="20">20</SelectItem>
                  <SelectItem :value="50">50 </SelectItem>
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
                  :class="{ invisible: videoStore.selectedPage === 1 }"
                  :disabled="videoStore.selectedPage === 1"
                >
                  <ChevronLeft size="14" color="#14D2B5" />
                </Button>
                <PaginationListItem
                  class="gap-1"
                  v-for="item in videoStore.visiblePages"
                  :key="item"
                  @click="handleGetVideosByPageIndex(item)"
                >
                  <Button
                    class="mr-2"
                    :variant="item === videoStore.selectedPage ? '' : 'outline'"
                    @click="selectedPage = item"
                    >{{ item }}</Button
                  >
                </PaginationListItem>
                <Button
                  variant="outline"
                  class="pl-2"
                  @click="handleNextPage"
                  :class="{ invisible: videoStore.selectedPage === videoStore.totalPages }"
                  :disabled="videoStore.selectedPage === videoStore.totalPages"
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
import { Pagination, PaginationList, PaginationListItem } from '@common/ui/pagination'
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectTrigger,
  SelectValue
} from '@common/ui/select'
import Loading from '@components/Loading.vue'
import Table from '@components/streamer-videos/Table.vue'
import { ChevronLeft, ChevronRight } from 'lucide-vue-next'
import { onMounted, ref, watch } from 'vue'
import { useVideoStore } from '../../stores/videoManage'

const videoStore = useVideoStore()

const count = ref()

onMounted(async () => {
  await videoStore.getUploadedVideosList(10, 1)
})
watch(count, async (newValue) => {
  await videoStore.getVideosByLimit(newValue, 1)
})
watch(
  () => videoStore.selectedPage,
  async (newValue) => {
    await videoStore.getVideosByLimit(count.value, newValue)
  }
)

const handleGetVideosByPageIndex = (item) => {
  videoStore.updateSelectedPage(item)
}
const handleNextPage = async () => {
  const temp = videoStore.selectedPage + 1
  await videoStore.getVideosByLimit(count.value, temp)
  videoStore.updateSelectedPage(temp)
}
const handlePrevPage = async () => {
  const temp = videoStore.selectedPage - 1
  await videoStore.getVideosByLimit(count.value, temp)
  videoStore.updateSelectedPage(temp)
}
</script>
