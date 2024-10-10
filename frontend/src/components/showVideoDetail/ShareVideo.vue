<script>
import CopyLinkIcon from '@assets/icons/CopyLinkIcon.vue'
import FacebookIcon from '@assets/icons/FacebookIcon.vue'
import TwitterIcon from '@assets/icons/TwitterIcon.vue'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger
} from '@common/ui/dropdown-menu'
import { Share2, X } from 'lucide-vue-next'
</script>

<template>
  <DropdownMenu>
    <DropdownMenuTrigger
      class="flex items-center gap-2 text-sm cursor-pointer font-semibold text-primary"
    >
      <Share2 width="20px" class="text-primary" /> SHARE
    </DropdownMenuTrigger>
    <DropdownMenuContent side="top" align="end">
      <div class="flex items-center justify-between mb-2">
        <h3 class="ml-2 font-semibold">Share via</h3>
        <DropdownMenuItem class="cursor-pointer focus:bg-transparent">
          <X width="20px" />
        </DropdownMenuItem>
      </div>

      <div class="flex">
        <DropdownMenuItem
          class="flex flex-col gap-2 items-center cursor-pointer focus:bg-transparent"
        >
          <FacebookIcon class="w-[40px] h-[40px]" />
          <span class="text-sm">{{ $t('streamer.fb') }}</span>
        </DropdownMenuItem>
        <DropdownMenuItem
          class="flex flex-col gap-2 items-center cursor-pointer focus:bg-transparent"
        >
          <TwitterIcon />
          <span class="text-sm">{{ $t('streamer.twitter') }}</span>
        </DropdownMenuItem>
        <DropdownMenuItem
          class="flex flex-col gap-2 items-center cursor-pointer focus:bg-transparent"
        >
          <CopyLinkIcon />
          <span class="text-sm">{{ $t('streamer.copy_link') }}</span>
        </DropdownMenuItem>
      </div>
    </DropdownMenuContent>
  </DropdownMenu>
</template>
