<template>
  <div class="bg-white w-full h-full">
    <Loading v-if="isLoading" />
    <template v-else>
      <h2 class="text-2xl m-7 font-bold">{{ $t('streamer.videos') }}</h2>
      <div class="mt-4" v-if="videos.length !== 0">
        <Table :list="videos" />
        <div class="flex justify-between items-center mt-5">
          <div class="flex gap-3 items-center">
            <p class="text-sm ml-5">{{ $t('streamer.show') }}</p>
            <Select class="text-primary">
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
                <PaginationPrev @click="handlePrevPage" />
                <PaginationListItem class="gap-1" v-for="item in pageCounts" :key="item">
                  <Button
                    class="mr-2"
                    :variant="item === selectedPage ? '' : 'outline'"
                    @click="selectedPage = item"
                    >{{ item }}</Button
                  >
                </PaginationListItem>
                <PaginationNext @click="handleNextPage" />
              </PaginationList>
            </Pagination>
          </div>
        </div>
      </div>
      <div class="mt-4 ml-7" v-else>
        <p class="ml-5 mt-4 italic">{{ $t('streamer.no_videos') }}</p>
        <Button
          variant="default"
          class="flex items-center gap-2 mt-3"
          @click="handleUploadNewVideo"
        >
          <FileVideo2 class="text-xl" />
          <span class="text-base font-semibold -mb-1">{{ $t('button.upload_video') }}</span>
        </Button>
      </div>
    </template>
  </div>
</template>

<script setup>
import Button from '@common/ui/button/Button.vue'
import Table from '@components/Table.vue'
import { FileVideo2 } from 'lucide-vue-next'
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
import { ref, watch, onMounted } from 'vue'
import { videoService } from '@services/video.services'

const count = ref(null)
const videos = ref([])
const isLoading = ref(false)
const error = ref('')
const pageCounts = ref([1, 2, 3])
const selectedPage = ref(1)

onMounted(() => {
  const token = localStorage.getItem('token')
  try {
    const {
      data,
      isLoading: serviceLoading,
      isSuccess,
      isError
    } = videoService.getUploadVideos(token, 10, 1)
    if (serviceLoading) isLoading.value = true

    if (isSuccess && data) console.log(videos.value)

    if (isError) error.value = 'Error'
  } catch (err) {
    error.value = err
  } finally {
    isLoading.value = false
  }
})

const handleNextPage = () => {}
const handlePrevPage = () => {}
const handleUploadNewVideo = () => {}
</script>
