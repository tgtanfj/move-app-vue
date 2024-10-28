<script setup>
import Heart from '@assets/icons/Heart.vue'
import HeartFilled from '@assets/icons/HeartFilled.vue'
import StartIcon from '@assets/icons/startIcon.vue'
import { DropdownMenuSeparator } from '@common/ui/dropdown-menu'
import { Tabs, TabsContent, TabsList } from '@common/ui/tabs'
import SocialLink from '@components/channel-view/SocialLink.vue'
import Comment from '@components/comment/Comment.vue'
import ShareLinkVideo from '@components/showVideoDetail/ShareLinkVideo.vue'
import VideoDisplay from '@components/showVideoDetail/VideoDisplay.vue'
import { fetchChannelAbout } from '@services/channel_about.services'
import { useFollow, useUnfollow } from '@services/follow.services'
import { nextTick, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { formatFollowers } from '@utils/formatViews.util'
import BlueBadgeIcon from '../../assets/icons/BlueBadgeIcon.vue'
import { useAuthStore } from '../../stores/auth'
import { useFollowerStore } from '../../stores/follower.store'
import { useOpenLoginStore } from '../../stores/openLogin'
import { getFollowerText } from '../../utils/follower.util'
import { sortedSocialLinks } from '../../utils/socialOrder.util'
import Rating from './Rating.vue'
import { Button } from '../../common/ui/button/index'
import axios from 'axios'
import { ADMIN_BASE } from '@constants/api.constant'
import GiftReps from './GiftReps.vue'

const props = defineProps({
  videoDetail: {
    type: Object,
    required: true
  }
})

const channelInfo = ref({})
const userStore = useAuthStore()
const router = useRouter()
const openLoginStore = useOpenLoginStore()
const followerStore = useFollowerStore()
const isFollowed = ref(null)
const numFollower = ref(null)
const isMyVideo = ref(null)
const mutationFollow = useFollow()
const mutationUnfollow = useUnfollow()
const route = useRoute()
const commentId = route.query.commentId
const replyId = route.query.replyId
const commentUnshift = ref({
  user: {
    id: 60,
    username: 'TomJerryhihi',
    fullName: 'Testabcabc',
    avatar:
      'https://move-project.s3.us-east-1.amazonaws.com/images/4198b020-91d2-11ef-8ca9-9310ceb7ec09.png',
    channel: {
      isBlueBadge: true,
      isPinkBadge: true
    }
  },
  totalDonation: 0
})

onMounted(async () => {
  if (props.videoDetail) {
    const res = await fetchChannelAbout(props.videoDetail.channel.id)
    channelInfo.value = res.data
    isFollowed.value = channelInfo.value.isFollowed
    numFollower.value = channelInfo.value.numberOfFollowers
    isMyVideo.value = channelInfo.value.canFollow
  }
})

const getCommentById = async () => {
  if (commentId) {
    try {
      const response = await axios.get(`${ADMIN_BASE}/comment/${commentId}`)
      if (response && response.data) {
        const apiData = response.data
        commentUnshift.value = {
          ...apiData.data,
          ...commentUnshift.value
        }
        console.log(commentUnshift.value)
        scrollToComment(commentId)
      }
    } catch (error) {
      console.error('Error fetching comment by ID:', error)
    }
  }
}

const scrollToComment = () => {
  if (commentId && replyId) {
    console.log('reply scroll')
  } else if (commentId) {
    setTimeout(() => {
      const commentElement = document.getElementById(commentId)
      if (commentElement) {
        const navbarHeight = 100
        const elementPosition = commentElement.getBoundingClientRect().top + window.scrollY
        const offsetPosition = elementPosition - navbarHeight

        window.scrollTo({
          top: offsetPosition,
          behavior: 'smooth'
        })
        commentElement.classList.add('highlight')
      } else {
        console.log('Element not found after timeout')
      }
    }, 1000)
  }
}

onMounted(() => {
  nextTick(() => {
    getCommentById()
  })
})

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
            numFollower.value--
            followerStore.getAllFollowers()
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
            numFollower.value++
            followerStore.getAllFollowers()
          }
        }
      )
    }
  } else {
    openLoginStore.toggleOpenLogin()
  }
}

const checkFollowStatus = async () => {
  const isLogin = !!userStore.accessToken
  if (isLogin) {
    try {
      const response = await fetchChannelAbout(props.videoDetail.channel.id)
      isFollowed.value = response.data.isFollowed
    } catch (error) {
      console.error('Error fetching follow status', error)
    }
  } else {
    isFollowed.value = null
  }
}

const handleNavigate = () => {
  router.push(`/channel/${props.videoDetail.channel.id}`)
}

watch(
  () => userStore.accessToken,
  (newToken) => {
    if (newToken) {
      checkFollowStatus()
    } else {
      isFollowed.value = null
    }
  }
)

onMounted(() => {
  checkFollowStatus()
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
          <span class="font-semibold">{{ props.videoDetail.numberOfViews }}</span>
          {{ $t('video_detail.views') }}
        </p>
        <p class="font-semibold text-primary">• {{ props.videoDetail.category?.title }}</p>
      </div>

      <div class="flex justify-between items-center mt-4">
        <div class="flex items-center gap-2">
          <div class="py-2 px-4 rounded-3xl bg-gray-200 font-medium">{{ workoutLevelLite }}</div>
          <div class="py-2 px-4 rounded-3xl bg-gray-200 font-medium">{{ durationLite }}</div>
        </div>
        <div class="flex items-center gap-5">
          <div
            class="flex items-center gap-2 text-sm cursor-pointer font-semibold text-primary"
            @click="handleFollow"
            v-if="isMyVideo !== false"
          >
            <Heart v-show="!isFollowed" width="24px" class="text-primary" />
            <HeartFilled v-show="isFollowed" />
            {{ $t('video_detail.follow') }}
          </div>
          <Rating :videoDetail="videoDetail" />
          <ShareLinkVideo />
        </div>
      </div>
      <!-- /Video actions and info -->
      <DropdownMenuSeparator class="my-6" />
      <!-- Video channel -->
      <div class="flex justify-between items-center">
        <RouterLink :to="`/channel/${props.videoDetail.channel.id}`">
          <div class="flex items-center gap-4">
            <img
              :src="channelInfo.image"
              alt="ava channel"
              class="w-[56px] h-[56px] rounded-full cursor-pointer"
              @click="handleNavigate"
            />
            <div>
              <h3 class="text-xl font-semibold cursor-pointer" @click="handleNavigate">
                {{ channelInfo.name }}
                <BlueBadgeIcon v-if="channelInfo.isBlueBadge" class="inline-block ml-3" />
              </h3>
              <p class="text-gray-500 font-medium">
                {{ numFollower ? formatFollowers(numFollower) : 0 }}
                {{ getFollowerText(numFollower) }}
              </p>
            </div>
          </div>
        </RouterLink>
        <GiftReps :videoId="props.videoDetail.id" v-if="isMyVideo !== false"/> 
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
            <h3 class="font-semibold text-lg mb-2">About {{ channelInfo.name }}</h3>
            <p class="font-medium" v-if="channelInfo.bio">
              {{ channelInfo.bio }}
            </p>
            <p class="italic" v-else>{{ $t('view_channel.no_bio') }}</p>
          </div>
          <div class="flex-1 ml-10" v-if="channelInfo?.socialLinks">
            <h3 class="font-semibold text-lg mb-2">Social network</h3>
            <div class="flex gap-3" v-if="channelInfo.socialLinks.length">
              <SocialLink
                v-for="item in sortedSocialLinks(channelInfo?.socialLinks)"
                :key="item"
                :title="item.name"
                :link="item.link"
              />
            </div>
            <p v-else class="italic">{{ $t('view_channel.no_social_network') }}</p>
          </div>
        </TabsContent>
      </Tabs>
      <!-- /Video channel -->
      <DropdownMenuSeparator class="my-4" />

      <Comment
        :isCommentable="videoDetail?.isCommentable"
        class="mt-10"
        :commentUnshift="commentUnshift"
      />
    </div>
  </div>
</template>
