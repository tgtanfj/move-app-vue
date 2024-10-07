<template>
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
        <div v-if="videoStore.isCopied" class="absolute right-0 top-full p-1 border-[1.5px] rounded-lg shadow-lg z-2">
          <div class="p-1 flex">
            <CopyLinkIcon class="w-[24px] h-[24px]" />
            {{ $t('streamer.link_copied') }}
          </div>
        </div>
      </div>
    </div>
  </TooltipContent>
</template>

<script setup>
import CopyLinkIcon from '@assets/icons/CopyLinkIcon.vue'
import FacebookIcon from '@assets/icons/FacebookIcon.vue'
import TwitterIcon from '@assets/icons/TwitterIcon.vue'
import { TooltipContent } from '@common/ui/tooltip'
import { useVideoStore } from '../../stores/videoManage'

const props = defineProps({
  videoIdSelected: {
    type: Number,
    required: true
  }
})

const videoStore = useVideoStore()

const handleGetFBLink = async () => {
  await videoStore.shareVideoSocial(props.videoIdSelected, 'Facebook')
}

const handleGetTwitterLink = async () => {
  await videoStore.shareVideoSocial(props.videoIdSelected, 'Twitter')
}

const handleGetLink = () => {
  videoStore.getAndCopyUrlVideo(props.videoIdSelected)
}
</script>
