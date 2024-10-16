<script setup>
import StartIcon from '@assets/icons/startIcon.vue'
import Button from '@common/ui/button/Button.vue'
import { ChevronRight } from 'lucide-vue-next'
import { Tabs, TabsList, TabsContent } from '@common/ui/tabs'
import { DropdownMenuSeparator } from '@common/ui/dropdown-menu'
import Comment from '@components/comment/Comment.vue'
import Rating from './Rating.vue'
import ShareLinkVideo from '@components/showVideoDetail/ShareLinkVideo.vue'
import VideoDisplay from '@components/showVideoDetail/VideoDisplay.vue'
import { onMounted, ref } from 'vue'
import { fetchChannelAbout } from '@services/channel_about.services'
import SocialLink from '@components/channel-view/SocialLink.vue'
import HeartFilled from '@assets/icons/HeartFilled.vue'
import { useAuthStore } from '../../stores/auth'
import { useFollow, useUnfollow } from '@services/follow.services'
import Heart from '@assets/icons/Heart.vue'

const props = defineProps({
  videoDetail: {
    type: Object,
    required: true
  }
})

const channelInfo = ref({})
const userStore = useAuthStore()

const isFollowed = ref(channelInfo.isFollowed)
const mutationFollow = useFollow()
const mutationUnfollow = useUnfollow()

const durationLite =
  props.videoDetail.duration === 'less than 30 minutes'
    ? '30 mins'
    : props.videoDetail.duration === 'less than 1 hours'
      ? '< 1 hour'
      : props.videoDetail.duration === 'more than 1 hours'
        ? '> 1 hour'
        : 'unknown'

const workoutLevelLite =
  props.videoDetail.workoutLevel === 'beginner'
    ? 'Beginner'
    : props.videoDetail.workoutLevel === 'intermediate'
      ? 'Intermediate'
      : props.videoDetail.workoutLevel === 'advanced'
        ? 'Advanced'
        : 'unknown'

const handleFollow = () => {
  const isLogin = !!userStore.accessToken

  if (isLogin) {
    if (isFollowed.value) {
      mutationUnfollow.mutate(
        {
          channelId: props.videoDetail.channel.id
        },
        {
          onSuccess: () => {
            isFollowed.value = false
          }
        }
      )
    } else {
      mutationFollow.mutate(
        {
          channelId: props.videoDetail.channel.id
        },
        {
          onSuccess: () => {
            isFollowed.value = true
          }
        }
      )
    }
  } else {
    openLoginStore.toggleOpenLogin()
  }
}

onMounted(async () => {
  if (props.videoDetail) {
    const res = await fetchChannelAbout(props.videoDetail.channel.id)
    channelInfo.value = res.data
  }
})
</script>

<template>
  <div v-if="props.videoDetail" class="flex-[0.75]">
    <!-- video play -->
    <VideoDisplay :videoUrl="props.videoDetail.url" />
    <!-- /video play -->

    <!-- Video actions and info -->
    <div class="p-5 w-full">
      <div class="flex items-center justify-between">
        <h1 class="text-2xl font-semibold">{{ props.videoDetail.title }}</h1>
        <p class="flex gap-1 text-xl font-semibold">
          <StartIcon width="24px" height="24px" />{{ props.videoDetail.ratings }}
        </p>
      </div>

      <div class="flex gap-2 mt-2">
        <p class="text-red-500 font-semibold">
          <span class="font-semibold">{{ props.videoDetail.numberOfViews }}</span> {{ $t('video_detail.views') }}
        </p>
        <p class="font-semibold text-primary">• {{ props.videoDetail.category?.title }}</p>
      </div>

      <div class="flex justify-between items-center mt-4">
        <div class="flex items-center gap-2">
          <div class="py-2 px-4 rounded-3xl bg-gray-200 font-medium">{{ workoutLevelLite }}</div>
          <div class="py-2 px-4 rounded-3xl bg-gray-200 font-medium">{{ durationLite }}</div>
        </div>
        <div class="flex items-center gap-5">
          <div class="flex items-center gap-2 text-sm cursor-pointer font-semibold text-primary" @click="handleFollow">
            <Heart v-show="!isFollowed" width="24px" class="text-primary" />
            {{ $t('video_detail.follow') }}
            <HeartFilled v-show="isFollowed"/>
          </div>
          <Rating :videoDetail="videoDetail" />
          <ShareLinkVideo />
        </div>
      </div>
      <!-- /Video actions and info -->
      <DropdownMenuSeparator class="my-6" />
      <!-- Video channel -->
      <div class="flex justify-between items-center">
        <div class="flex items-center gap-4">
          <img :src="channelInfo.image" alt="ava channel" class="w-[56px] h-[56px] rounded-full" />
          <div>
            <h3 class="text-xl font-semibold">{{ channelInfo.name }}</h3>
            <p class="text-gray-500 font-medium">
              {{ channelInfo.numberOfFollowers }} {{ $t('video_detail.follower') }}
            </p>
          </div>
        </div>
        <Button class="p-4 text-base font-semibold">Gift REPs <ChevronRight /></Button>
      </div>

      <Tabs class="w-full">
        <TabsList class="mt-4 rounded-none bg-white cursor-pointer mb-0 p-0">
          <span class="text-primary border-b-[5px] border-primary pb-2 font-semibold text-lg"
            >About</span
          >
        </TabsList>
        <DropdownMenuSeparator class="m-0" />
        <TabsContent class="flex mt-4">
          <div class="flex-[1.7] bg-black text-white p-3 rounded-lg">
            <h3 class="font-semibold text-lg">About {{ channelInfo.name }}</h3>
            <p class="font-medium">
              {{ channelInfo.bio }}
            </p>
          </div>
          <div class="flex-1 ml-10">
            <h3 class="font-semibold text-lg">Social network</h3>
            <div class="flex gap-3" v-if="channelInfo.socialLinks">
              <SocialLink
                v-for="item in channelInfo.socialLinks"
                :key="item"
                :title="item.name"
                :link="item.link"
              />
            </div>
          </div>
        </TabsContent>
      </Tabs>
      <!-- /Video channel -->
      <DropdownMenuSeparator class="my-4" />

      <Comment class="mt-10" />
    </div>
  </div>
</template>
