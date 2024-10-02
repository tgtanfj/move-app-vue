<template>
  <TableRow class="cursor-pointer hover:bg-[#E6FFFB] group">
    <TableCell>
      <Checkbox :id="item.id" :checked="isChecked" @update:checked="handleChange" />
    </TableCell>
    <TableCell>
      <img :src="item.thumbnail_url" alt="" class="w-[124px] h-[70px]" />
    </TableCell>
    <TableCell>
      <div class="flex flex-col">
        <div class="font-bold text-base capitalize">{{ item.title }}</div>
        <div class="text-sm">{{ item.description }}</div>
        <div class="flex gap-1 mt-3">
          <div class="text-xs font-bold rounded-2xl bg-[#EEEEEE] p-2">{{ item.workoutLevel }}</div>
          <div class="text-xs font-bold rounded-2xl bg-[#EEEEEE] p-2">
            {{ detectDuration(item.duration) }}
          </div>
        </div>
      </div>
    </TableCell>
    <TableCell>{{ item.datePosted }}</TableCell>
    <TableCell>{{ item.numberOfViews }}</TableCell>
    <TableCell>{{ item.numberOfComments }}</TableCell>
    <TableCell>
      <div class="flex gap-1">{{ item.ratings }} <StartIcon /></div>
    </TableCell>
    <TableCell>
      <div class="flex invisible gap-3 group-hover:visible">
        <TooltipProvider>
          <Tooltip>
            <TooltipTrigger as-child>
              <Upload size="20" color="#12BDA3" />
            </TooltipTrigger>
            <TooltipContent side="bottom" class="border-primary">
              <div class="flex gap-3 cursor-pointer">
                <div class="flex flex-col gap-2 items-center" @click="handleGetFBLink">
                  <FacebookIcon class="w-[40px] h-[40px]" />
                  <span class="text-sm">{{ $t('streamer.fb') }}</span>
                </div>
                <div class="flex flex-col gap-2 items-center" @click="handleGetTwitterLink">
                  <TwitterIcon />
                  <span class="text-sm">{{ $t('streamer.twitter') }}</span>
                </div>
                <div class="flex flex-col gap-2 items-center" @click="handleGetLink">
                  <CopyLinkIcon />
                  <span class="text-sm">{{ $t('streamer.copy_link') }}</span>
                  <div
                    class="absolute right-0 top-full p-1 border-[1.5px] rounded-lg shadow-lg z-2"
                  >
                    <div class="p-1 flex">
                      <CopyLinkIcon class="w-[24px] h-[24px]" />
                      {{ $t('streamer.link_copied') }}
                    </div>
                  </div>
                </div>
              </div>
            </TooltipContent>
          </Tooltip>
        </TooltipProvider>
        <Pen size="20" color="#12BDA3" @click="handleEditDetails" />
        <TooltipProvider>
          <Tooltip>
            <TooltipTrigger as-child>
              <EllipsisVertical size="20" color="#12BDA3" />
            </TooltipTrigger>
            <TooltipContent side="bottom" class="border-primary text-primary">
              <div class="flex flex-col gap-3 cursor-pointer">
                <div class="flex gap-2 items-center" @click="handleDeleteVideo">
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
            </TooltipContent>
          </Tooltip>
        </TooltipProvider>
      </div>
    </TableCell>
  </TableRow>
</template>
<script setup>
import CopyLinkIcon from '@assets/icons/CopyLinkIcon.vue'
import FacebookIcon from '@assets/icons/FacebookIcon.vue'
import TwitterIcon from '@assets/icons/TwitterIcon.vue'
import { Checkbox } from '@common/ui/checkbox'
import { TableCell, TableRow } from '@common/ui/table'
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from '@common/ui/tooltip'
import { ArrowDownToLine, EllipsisVertical, Pen, Trash, Upload } from 'lucide-vue-next'
import { defineProps, defineEmits, computed, ref } from 'vue'
import BaseDialog from './BaseDialog.vue'
import StartIcon from '@assets/icons/startIcon.vue'

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

const emit = defineEmits(['update:selectedItems', 'edit:item'])

const isChecked = computed(() => {
  return props.selectedItems && props.selectedItems.includes(props.item.id)
})

const detectDuration = (duration) => {
  switch (duration) {
    case 'less than 30 minutes':
      return '<30 mins'
    case 'less than 1 hours':
      return '<1h'
    case 'more than 1 hours':
      return '>1h'
    default:
      return 'Unknown'
  }
}

const handleDeleteVideo = (videoId) => {}
const handleDownloadVideo = (videoId) => {}
const handleGetLink = (videoId) => {}
const handleGetFBLink = (videoId) => {}
const handleGetTwitterLink = (videoId) => {}

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
</script>
