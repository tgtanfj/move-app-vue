<script setup>
import { onBeforeUnmount, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import defaultAvatar from '@assets/images/default-avatar.png'
import defaultNotify from '@assets/images/default-notify.png'
import AvaSystem from '@assets/icons/AvaSystem.vue'

const props = defineProps({
  modalPopup: {
    type: Function,
    required: true
  },
  notifyData: {
    type: Object,
    required: true
  },
  markAsRead: {
    type: Function,
    required: true
  },
  isLast: {
    type: Boolean,
    default: true
  }
})

const router = useRouter()
const timestamp = props.notifyData.timestamp
const {
  commentId,
  sender,
  videoId,
  type,
  videoTitle,
  replyId,
  purchase,
  donation,
  repMilestone,
  cashout,
  followMilestone,
  viewVideoMilestone
} = props.notifyData.data

const setTimeInterval = ref(null)

const truncateString = (str, length = 65) => {
  return str.length > length ? str.slice(0, length) + '...' : str
}

const isSystemType = (type) => {
  const systemTypes = [
    'cashout',
    'purchase',
    'follow_milestone',
    'view_video_milestone',
    'rep_milestone'
  ]
  return systemTypes.includes(type)
}

const getContentByType = () => {
  switch (type) {
    // Engagement
    case 'like':
      return truncateString(`liked your comment on '<strong>${videoTitle}</strong>'`)
    case 'comment':
      return truncateString(`commented on your video '<strong>${videoTitle}</strong>'`)
    case 'reply':
      return truncateString(`replied to your comment on the video '<strong>${videoTitle}<strong>'`)
    case 'follow':
      return 'started following you!'
    case 'upload':
      return truncateString(`just uploaded a new video '<strong>${videoTitle}</strong>'`)
    case 'donation':
      return truncateString(
        `has donated ${donation} REPs to your video '<strong>${videoTitle}</strong>'`
      )

    // System
    case 'cashout':
      return `You have successfully withdrawn $${cashout}`
    case 'purchase':
      return `You've successfully purchased ${purchase} REPs.`
    case 'password_change_reminder':
      return "Please update your password as it hasn't been changed for 90 days."
    case 'follow_milestone':
      return `Congratulations! You've just reached ${followMilestone} followers.`
    case 'view_video_milestone':
      return truncateString(
        `Your video '<strong>${videoTitle}</strong>' has surpassed ${viewVideoMilestone} views.`
      )
    case 'rep_milestone':
      return `You've earned ${repMilestone} REPs in total from your content.`
    default:
      return 'performed an action'
  }
}

const formatTimeAgo = (timestamp) => {
  const now = Date.now()
  const secondsElapsed = Math.floor((now - timestamp) / 1000)

  const validSecondsElapsed = Math.max(secondsElapsed, 0)

  const minutesElapsed = Math.floor(secondsElapsed / 60)
  const hoursElapsed = Math.floor(minutesElapsed / 60)
  const daysElapsed = Math.floor(hoursElapsed / 24)
  const weeksElapsed = Math.floor(daysElapsed / 7)
  const monthsElapsed = Math.floor(daysElapsed / 30)
  const yearsElapsed = Math.floor(daysElapsed / 365)

  if (validSecondsElapsed < 60) {
    return `${validSecondsElapsed} seconds ago`
  } else if (minutesElapsed < 60) {
    return `${minutesElapsed} minutes ago`
  } else if (hoursElapsed < 24) {
    return `${hoursElapsed} hours ago`
  } else if (daysElapsed < 7) {
    return `${daysElapsed} days ago`
  } else if (daysElapsed < 30) {
    return `${weeksElapsed} weeks ago`
  } else if (daysElapsed < 365) {
    return `${monthsElapsed} months ago`
  } else {
    return `${yearsElapsed} years ago`
  }
}

const timeAgo = ref(formatTimeAgo(timestamp))
const content = ref(getContentByType())

const handleModalPopup = () => {
  if (props.modalPopup && type !== 'cashout' && type !== 'purchase') {
    props.modalPopup()
  }
  props.markAsRead(props.notifyData.id, props.notifyData.userId)

  switch (type) {
    // Engagement
    case 'like':
      router.push({
        name: 'videoDetail',
        params: { id: videoId },
        query: commentId ? { commentId: commentId } : {}
      })
      break
    case 'comment':
      router.push({
        name: 'videoDetail',
        params: { id: videoId },
        query: commentId ? { commentId: commentId } : {}
      })
      break
    case 'reply':
      router.push({
        name: 'videoDetail',
        params: { id: videoId },
        query: { commentId: commentId, replyId: replyId }
      })
      break
    case 'upload':
      router.push({ name: 'videoDetail', params: { id: videoId } })
      break
    case 'follow':
      router.push('/streamer/analytics/overview')
      break

    // System
    case 'donation':
      router.push('/streamer/analytics/overview')
      break
    case 'follow_milestone':
      router.push('/streamer/analytics/overview')
      break
    case 'view_video_milestone':
      router.push('/streamer/analytics/overview')
      break
    case 'repMilestone':
      router.push('/streamer/analytics/overview')
      break
    case 'password_change_reminder':
      router.push('/profile')
      break
    default:
      return 'performed an action'
  }
}

const handleImageError = (event) => {
  event.target.src = defaultNotify
}

onMounted(() => {
  setTimeInterval.value = setInterval(() => {
    timeAgo.value = formatTimeAgo(timestamp)
  }, 60000)
})

onBeforeUnmount(() => {
  clearInterval(setTimeInterval.value)
})
</script>

<template>
  <div>
    <div
      @click="handleModalPopup"
      class="min-h-[80px] flex gap-3 p-3 hover:bg-[#333333] cursor-pointer duration-75"
      :class="{
        'bg-black hover:bg-[#333333] duration-75': !notifyData.isRead,
        'bg-[#4F4F4F] duration-75': notifyData.isRead
      }"
    >
      <div class="min-w-[40px] w-[40px] h-[40px] rounded-full">
        <div v-if="isSystemType(type)">
          <AvaSystem width="40px" height="40px" />
        </div>

        <img
          v-else
          :src="sender.avatar || defaultAvatar"
          alt="User avatar"
          class="w-full h-full rounded-full object-cover"
          @error="handleImageError"
        />
      </div>
      <div class="flex flex-col justify-between">
        <p>
          <span class="font-semibold">{{ sender.username }}</span> <span v-html="content"></span>
        </p>
        <p class="mt-2 opacity-80 text-sm">{{ timeAgo }}</p>
      </div>
    </div>
    <hr v-if="!isLast" class="w-[95%] mx-auto opacity-85" />
  </div>
</template>
