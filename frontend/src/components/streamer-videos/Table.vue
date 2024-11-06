<template>
  <div>
    <div>
      <Table class="border-b">
        <TableHeader class="uppercase">
          <TableRow>
            <TableHead>
              <Checkbox id="all" :checked="allSelected" @update:checked="toggleAll" />
            </TableHead>
            <template v-if="selectedItems.length === 0">
              <TableHead>{{ $t('streamer.videos') }}</TableHead>
              <TableHead>{{ $t('streamer.details') }}</TableHead>
              <TableHead>{{ $t('streamer.date_post') }}</TableHead>
              <TableHead class="text-center">{{ $t('streamer.views') }}</TableHead>
              <TableHead class="text-center">{{ $t('streamer.comment') }}</TableHead>
              <TableHead class="text-center">{{ $t('streamer.rating') }}</TableHead>
              <TableHead></TableHead>
            </template>
            <template v-else>
              <TableHead class="flex items-center gap-3">
                <div
                  colspan="12"
                  class="flex gap-1 items-center text-primary capitalize font-semibold cursor-pointer"
                  @click="showConfirmModal = true"
                >
                  <Trash size="16" stroke-width="2.5" />{{ $t('streamer.delete') }}
                </div>
                <div
                  class="flex gap-1 items-center text-primary capitalize font-semibold cursor-pointer"
                  @click="handleDownloadVideoList"
                >
                  <ArrowDownToLine size="16" stroke-width="2.5" />{{ $t('streamer.download') }}
                </div>
              </TableHead>
              <TableHead></TableHead>
              <TableHead></TableHead>
              <TableHead></TableHead>
              <TableHead></TableHead>
              <TableHead></TableHead>
              <TableHead></TableHead>
            </template>
          </TableRow>
        </TableHeader>
        <TableBody class="text-base">
          <tr v-if="selectedItems.length > 0">
            <td colspan="8">
              <div
                class="p-4 bg-[#E6FFFB] flex justify-center items-center"
                v-if="selectedItems.length === props.list.length"
              >
                <p>
                  <span class="font-bold">{{ $t('streamer.all') }} {{ selectedItems.length }}</span>
                  {{ $t('streamer.videos_selected') }}
                </p>
                <span
                  class="ml-10 text-primary font-bold cursor-pointer"
                  @click="handleClearSelection"
                  >{{ $t('streamer.clear_selection') }}</span
                >
              </div>
              <div class="p-4 bg-[#E6FFFB] flex justify-center items-center" v-else>
                <p>
                  <span class="font-bold">{{ selectedItems.length }}</span>
                  {{ $t('streamer.videos_selected') }}
                </p>
                <span
                  class="ml-10 text-primary font-bold cursor-pointer"
                  @click="handleSelectAllItems"
                  >{{ $t('streamer.select_all_videos') }}</span
                >
              </div>
            </td>
          </tr>
          <TableItem
            v-for="item in props.list"
            :item="item"
            :key="item.id"
            :selectedItems="selectedItems"
            @update:selectedItems="handleItemUpdate"
            @delete:item="handleDeleteVideo"
            @download:item="handleDownloadVideo"
          />
        </TableBody>
      </Table>
    </div>
    <BaseDialog
      :title="!allSelected ? $t('streamer.delete_selected_video_modal_title') : 'Delete all videos'"
      :description="
        !allSelected
          ? $t('streamer.delete_video_modal_description')
          : 'All of your videos will be permanently deleted. You will lose all datas such from your videos as views, comments & ratings. Are you sure?'
      "
      v-model:open="showConfirmModal"
    >
      <div class="w-full flex justify-center items-center gap-4 mt-3">
        <Button
          variant="outline"
          class="px-9 text-base text-black hover:text-primary"
          @click="showConfirmModal = false"
          >{{ $t('button.cancel') }}</Button
        >
        <Button variant="default" class="px-9 text-base" @click="handleDeleteVideoList">{{
          $t('streamer.delete')
        }}</Button>
      </div>
    </BaseDialog>
  </div>
</template>

<script setup>
import { Button } from '@common/ui/button'
import { Checkbox } from '@common/ui/checkbox'
import { Table, TableBody, TableHead, TableHeader, TableRow } from '@common/ui/table'
import { useToast } from '@common/ui/toast/use-toast'
import { ArrowDownToLine, Trash } from 'lucide-vue-next'
import { computed, ref } from 'vue'
import { useVideoStore } from '../../stores/videoManage.js'
import BaseDialog from '../BaseDialog.vue'
import TableItem from './TableItem.vue'

const videoStore = useVideoStore()
const { toast } = useToast()

const props = defineProps({
  list: {
    type: Array,
    required: true
  }
})

const selectedItems = ref([])
const selectedItemsUrlS3 = ref([])
const showConfirmModal = ref(false)

const allSelected = computed(() => {
  return props.list.length > 0 && selectedItems.value.length === props.list.length
})

const handleItemUpdate = ({ id, checked, urlS3 }) => {
  if (checked) {
    if (!selectedItems.value.includes(id)) {
      selectedItems.value.push(id)
      selectedItemsUrlS3.value.push(urlS3)
    }
  } else {
    selectedItems.value = selectedItems.value.filter((item) => item !== id)
  }
}

const toggleAll = () => {
  if (selectedItems.value.length === props.list.length) selectedItems.value = []
  else selectedItems.value = props.list.map((item) => item.id)
}

const handleSelectAllItems = () => {
  selectedItems.value = props.list.map((item) => item.id)
}
const handleClearSelection = () => {
  selectedItems.value = []
}

const handleDeleteVideoList = async () => {
  const removedVideos = await videoStore.deleteVideos(selectedItems.value)
  if (removedVideos) {
    videoStore.videos = videoStore.videos.filter((video) => !selectedItems.value.includes(video.id))
    showConfirmModal.value = false
    toast({ description: 'Video deleted successfully', variant: 'successfully' })
    selectedItems.value = []
  } else {
    toast({ description: videoStore.errorMsg, variant: 'destructive' })
  }
}

const handleDeleteVideo = async (videoId) => {
  const removedVideos = await videoStore.deleteVideos([videoId])
  if (removedVideos) {
    videoStore.videos = videoStore.videos.filter((video) => video.id !== videoId)
    showConfirmModal.value = false
    toast({ description: 'Video deleted successfully', variant: 'successfully' })
    selectedItems.value = []
  } else {
    toast({ description: 'Delete video failed', variant: 'destructive' })
  }
}

const handleDownloadVideoList = async () => {
  try {
    const data = await videoStore.downloadVideos(selectedItemsUrlS3.value)
    const blob = new Blob([data], { type: 'application/zip' }); // Đặt MIME type phù hợp
    const url = URL.createObjectURL(blob);

    const a = document.createElement('a');
    a.href = url;
    document.body.appendChild(a);
    a.click();

    document.body.removeChild(a);
    URL.revokeObjectURL(url); // Giải phóng URL sau khi tải
  } catch (error) {
    console.error('Error downloading video list:', error)
  }
}

const handleDownloadVideo = async (id) => {
  const response = await videoStore.downloadVideo(id)

  const a = document.createElement('a')
  a.href = response.data
  a.click()
  document.body.removeChild(a)
}
</script>
