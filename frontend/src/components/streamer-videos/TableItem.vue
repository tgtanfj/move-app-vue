<template>
  <TableRow class="cursor-pointer hover:bg-[#E6FFFB] group" :class="{ 'bg-[#F7FEFD]': isChecked }">
    <TableCell>
      <Checkbox :id="item.id" :checked="isChecked" @update:checked="handleChange" />
    </TableCell>
    <TableCell>
      <img :src="item.thumbnail_url" alt="" class="w-[124px] h-[70px]" />
    </TableCell>
    <TableCell>
      <div class="flex flex-col">
        <div class="font-bold text-base capitalize">{{ truncatedTitle }}</div>
        <div class="text-sm">{{ item.category.title }}</div>
        <div class="flex gap-1 mt-3">
          <div class="text-xs font-bold rounded-2xl bg-[#EEEEEE] p-2">{{ item.workoutLevel }}</div>
          <div class="text-xs font-bold rounded-2xl bg-[#EEEEEE] p-2">
            {{ detectDuration(item.duration) }}
          </div>
        </div>
      </div>
    </TableCell>
    <TableCell>{{ formatDateString(item.datePosted) }}</TableCell>
    <TableCell>{{ item.numberOfViews }}</TableCell>
    <TableCell>{{ item.numberOfComments }}</TableCell>
    <TableCell>
      <div class="flex gap-1">{{ item.ratings }} <StartIcon /></div>
    </TableCell>
    <TableCell>
      <div class="flex invisible gap-3 group-hover:visible">
        <!-- Share video -->
        <Popover>
          <PopoverTrigger>
            <Upload size="20" color="#12BDA3" />
          </PopoverTrigger>
          <ShareVideo :videoIdSelected="props.item.id" />
        </Popover>
        <!-- Edit video -->
        <EditVideo :videoInfoSelected="props.item" />
        <!-- More -->
        <Popover>
          <PopoverTrigger>
            <EllipsisVertical size="20" color="#12BDA3" />
          </PopoverTrigger>
          <PopoverContent class="border-primary text-primary w-48">
            <div class="flex flex-col gap-3 cursor-pointer">
              <!-- Nhấn để hiện modal xóa -->
              <div class="flex gap-2 items-center" @click="showModalDelete">
                <Trash size="16" color="#12BDA3" />
                <span class="text-sm">{{ $t('streamer.delete_video') }}</span>
              </div>
              <div
                class="flex gap-2 items-center text-sm cursor-pointer"
                @click="handleDownloadVideo"
              >
                <ArrowDownToLine size="16" color="#12BDA3" />
                <span class="text-sm">{{ $t('streamer.download_video') }}</span>
              </div>
            </div>
          </PopoverContent>
        </Popover>
      </div>
    </TableCell>
  </TableRow>

  <BaseDialog
    :title="$t('streamer.delete_selected_video_modal_title')"
    :description="$t('streamer.delete_video_modal_description')"
    v-model:open="showConfirmModal"
  >
    <div class="w-full flex justify-center items-center gap-4 mt-3">
      <Button
        variant="outline"
        class="px-9 text-base text-black hover:text-primary"
        @click="showConfirmModal = false"
        >{{ $t('button.cancel') }}</Button
      >
      <Button variant="default" class="px-9 text-base" @click="handleDeleteVideo">{{
        $t('streamer.delete')
      }}</Button>
    </div>
  </BaseDialog>
</template>

<script setup>
import StartIcon from '@assets/icons/startIcon.vue'
import Button from '@common/ui/button/Button.vue'
import { Checkbox } from '@common/ui/checkbox'
import { TableCell, TableRow } from '@common/ui/table'
import { ArrowDownToLine, EllipsisVertical, Trash, Upload } from 'lucide-vue-next'
import { computed, ref } from 'vue'
import BaseDialog from '../BaseDialog.vue'
import EditVideo from '@components/video-manage/EditVideo.vue'
import ShareVideo from '@components/video-manage/ShareVideo.vue'
import { Popover, PopoverContent, PopoverTrigger } from '@common/ui/popover'
import { formatDateString } from '@utils/uploadVideo.util'
import { detectDuration } from '@utils/uploadVideo.util'

const props = defineProps({
  item: {
    type: Object,
    required: true
  },
  selectedItems: {
    type: Array,
    required: true
  }
})

const emit = defineEmits(['update:selectedItems', 'delete:item', 'edit:item', 'download:item'])

const showConfirmModal = ref(false)

const truncatedTitle = computed(() => {
  return props.item.title.length > 50
    ? props.item.title.slice(0, 50) + '...'
    : props.item.title
})

const isChecked = computed(() => {
  return props.selectedItems && props.selectedItems.includes(props.item.id)
})

const showModalDelete = () => {
  showConfirmModal.value = true
}

const handleDeleteVideo = () => {
  emit('delete:item', props.item.id)
}

const handleChange = () => {
  const checked = !isChecked.value
  emit('update:selectedItems', {
    id: props.item.id,
    checked
  })
}

const handleEditDetails = () => {
  emit('edit:item', { item: props.item })
}

const handleDownloadVideo = () => {
  emit('download:item', props.item.id)
}
</script>
