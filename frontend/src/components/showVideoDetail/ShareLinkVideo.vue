<script setup>
import { useRoute } from 'vue-router'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger
} from '@common/ui/dropdown-menu'
import FacebookIcon from '@assets/icons/FacebookIcon.vue'
import TwitterIcon from '@assets/icons/TwitterIcon.vue'
import CopyLinkIcon from '@assets/icons/CopyLinkIcon.vue'
import { Share2, X } from 'lucide-vue-next'
import { ref, watch } from 'vue'
import { useToast } from '../../common/ui/toast'

const route = useRoute()
const currentUrl = ref(window.location.origin + route.fullPath)
const isCopied = ref(false)

const { toast } = useToast()

watch(route, (newRoute) => {
  const currentPath = newRoute.fullPath
  currentUrl.value = window.location.origin + currentPath
})

const shareOnFacebook = () => {
  if (!navigator.onLine) {
    toast({ description: 'Network Unavailable', variant: 'destructive' })
    return
  }

  const fbShareUrl = `https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(currentUrl.value)}`
  window.open(fbShareUrl, '_blank')
}

const shareOnTwitter = () => {
  if (!navigator.onLine) {
    toast({ description: 'Network Unavailable', variant: 'destructive' })
    return
  }

  const twShareUrl = `https://twitter.com/intent/tweet?url=${encodeURIComponent(currentUrl.value)}`
  window.open(twShareUrl, '_blank')
}

const copyLinkVideo = () => {
  navigator.clipboard
    .writeText(currentUrl.value)
    .then(() => {
      isCopied.value = true

      setTimeout(() => {
        isCopied.value = false
      }, 2000)
    })
    .catch((err) => {
      console.error('Failed to copy: ', err)
    })
}
</script>

<template>
  <DropdownMenu>
    <DropdownMenuTrigger
      class="flex items-center gap-2 text-sm cursor-pointer font-semibold text-primary"
    >
      <Share2 width="24px" class="text-primary" /> {{ $t('video_detail.share') }}
    </DropdownMenuTrigger>
    <DropdownMenuContent side="top" align="end">
      <div class="flex items-center justify-between mb-2">
        <h3 class="ml-2 font-semibold">{{ $t('video_detail.share_via') }}</h3>
        <DropdownMenuItem class="cursor-pointer focus:bg-transparent">
          <X width="20px" />
        </DropdownMenuItem>
      </div>

      <div class="flex items-center gap-3 px-3 pb-2">
        <div
          @click="shareOnFacebook"
          class="flex flex-col gap-2 items-center cursor-pointer focus:bg-transparent"
        >
          <FacebookIcon class="w-[40px] h-[40px]" />
          <span class="text-sm font-medium">{{ $t('streamer.fb') }}</span>
        </div>
        <div
          @click="shareOnTwitter"
          class="flex flex-col gap-2 items-center cursor-pointer focus:bg-transparent"
        >
          <TwitterIcon />
          <span class="text-sm font-medium">{{ $t('streamer.twitter') }}</span>
        </div>
        <div
          @click="copyLinkVideo"
          class="flex flex-col gap-2 items-center cursor-pointer focus:bg-transparent"
        >
          <CopyLinkIcon />
          <span class="text-sm font-medium">{{ $t('streamer.copy_link') }}</span>
          <div
            v-if="isCopied"
            class="absolute left-0 top-[-45px] p-1 border-[1.5px] rounded-lg bg-white shadow-lg z-2"
          >
            <div class="p-1 flex items-center gap-2 font-semibold">
              <CopyLinkIcon class="w-[24px] h-[24px]" />
              {{ $t('streamer.link_copied') }}
            </div>
          </div>
        </div>
      </div>
    </DropdownMenuContent>
  </DropdownMenu>
</template>
