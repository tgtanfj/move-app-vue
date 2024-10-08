<script setup>
import StartIcon from '@assets/icons/startIcon.vue'
import Button from '@common/ui/button/Button.vue'
import { ChevronRight, Heart, Share2, Star, X } from 'lucide-vue-next'
import { Tabs, TabsList, TabsContent } from '@common/ui/tabs'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger
} from '@common/ui/dropdown-menu'
import defaultAvatar from '@assets/icons/default-avatar.png'
import InstaIcon from '@assets/icons/InstaIcon.vue'
import YoutubeIcon from '@assets/icons/YoutubeIcon.vue'
import FBIcon from '@assets/icons/FBIcon.vue'
import CommentVideo from '@components/showVideoDetail/CommentVideo.vue'
import FacebookIcon from '@assets/icons/FacebookIcon.vue'
import TwitterIcon from '@assets/icons/TwitterIcon.vue'
import CopyLinkIcon from '@assets/icons/CopyLinkIcon.vue'

const props = defineProps({
  videoDetail: {
    type: Object,
    required: true
  }
})
</script>

<template>
  <div class="flex-[2.8]">
    <!-- video play -->
    <div class="w-full h-[520px]">
      <iframe
        class="w-full h-full"
        src="https://move-project.s3.us-east-1.amazonaws.com/videos/1728017172580-1728017169372-Y2meta.app-Nature%20Beautiful%20short%20video%20720p%20HD.mp4"
        frameborder="0"
      ></iframe>
    </div>
    <!-- /video play -->

    <!-- Video actions and info -->
    <div class="p-5 w-full">
      <div class="flex items-center justify-between">
        <h1 class="text-2xl font-semibold">Video title</h1>
        <p class="flex gap-1 text-xl font-semibold"><StartIcon width="24px" height="24px" />4.5</p>
      </div>

      <div class="flex gap-2 mt-2">
        <p class="text-red-500 font-semibold"><span class="font-semibold">10.3</span>k views</p>
        <p class="font-semibold text-primary">• Just Move</p>
      </div>

      <div class="flex justify-between items-center mt-4">
        <div class="flex items-center gap-2">
          <div class="py-2 px-4 rounded-3xl bg-gray-200 font-medium">Beginner</div>
          <div class="py-2 px-4 rounded-3xl bg-gray-200 font-medium">< 30 mins</div>
        </div>
        <div class="flex items-center gap-5">
          <div class="flex items-center gap-2 text-sm cursor-pointer font-semibold text-primary">
            <Heart width="20px" class="text-primary" /> FOLLOW
          </div>
          <div class="flex items-center gap-2 text-sm cursor-pointer font-semibold text-primary">
            <Star width="20px" class="text-primary" /> RATE VIDEO
          </div>

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
                  <X width="20px"/>
                </DropdownMenuItem>
              </div>
              
              <div class="flex">
                <DropdownMenuItem class="flex flex-col gap-2 items-center cursor-pointer focus:bg-transparent">
                  <FacebookIcon class="w-[40px] h-[40px]" />
                  <span class="text-sm">{{ $t('streamer.fb') }}</span>
                </DropdownMenuItem>
                <DropdownMenuItem class="flex flex-col gap-2 items-center cursor-pointer focus:bg-transparent">
                  <TwitterIcon />
                  <span class="text-sm">{{ $t('streamer.twitter') }}</span>
                </DropdownMenuItem>
                <DropdownMenuItem class="flex flex-col gap-2 items-center cursor-pointer focus:bg-transparent">
                  <CopyLinkIcon />
                  <span class="text-sm">{{ $t('streamer.copy_link') }}</span>
                </DropdownMenuItem>
              </div>
            </DropdownMenuContent>
          </DropdownMenu>
        </div>
      </div>
      <!-- /Video actions and info -->
      <DropdownMenuSeparator class="my-6" />
      <!-- Video channel -->
      <div class="flex justify-between items-center">
        <div class="flex items-center gap-4">
          <img :src="defaultAvatar" alt="ava channel" class="w-[56px] h-[56px] rounded-full" />
          <div>
            <h3 class="text-xl font-semibold">dianeTV</h3>
            <p class="text-gray-500 font-medium">10355 followers</p>
          </div>
        </div>
        <Button class="p-4 text-base font-semibold">Gift REPs <ChevronRight /></Button>
      </div>

      <Tabs>
        <TabsList class="mt-4 rounded-none bg-white cursor-pointer mb-0 p-0">
          <span class="text-primary border-b-[5px] border-primary pb-2 font-semibold text-lg"
            >About</span
          >
        </TabsList>
        <DropdownMenuSeparator class="m-0" />
        <TabsContent class="flex mt-4">
          <div class="flex-[1.7] bg-black text-white p-3 rounded-lg">
            <h3 class="font-semibold text-lg">About Diane</h3>
            <p class="font-medium">
              Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor
              invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et
              accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata
              sanctus est Lorem
            </p>
          </div>
          <div class="flex-1 ml-10">
            <h3 class="font-semibold text-lg">Social network</h3>
            <div class="flex mt-2 gap-3">
              <FBIcon class="cursor-pointer" />
              <InstaIcon class="cursor-pointer" />
              <YoutubeIcon class="cursor-pointer" />
            </div>
          </div>
        </TabsContent>
      </Tabs>
      <!-- /Video channel -->
      <DropdownMenuSeparator class="my-4" />

      <CommentVideo />
    </div>
  </div>
</template>