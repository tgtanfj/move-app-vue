<script setup>
import BlueBadgeIcon from '@assets/icons/BlueBadgeIcon.vue'
import defaultAvatar from '@assets/images/default-avatar.png'
import { useRouter } from 'vue-router'
import { getFollowerText } from '../../utils/follower.util'
import { formatFollowers } from '@utils/formatViews.util'

const props = defineProps({
  id: {
    type: Number,
    required: true
  },
  name: {
    type: String,
    required: true
  },
  follower: {
    type: Number,
    required: true
  },
  avatar: {
    type: String,
    required: true
  },
  isPinkBadge: {
    type: Boolean,
    required: true
  },
  isBlueBadge: {
    type: Boolean,
    required: true
  }
})
const router = useRouter()
const handleNavigate = () => {
  router.push(`/channel/${props.id}`)
}

const handleImageError = (event) => {
  event.target.src = defaultAvatar
}

</script>
<template>
  <div class="flex flex-col items-center text-center">
    <img
      :src="avatar || defaultAvatar"
      @error="handleImageError"
      class="w-[56px] h-[56px] mb-4 rounded-full cursor-pointer"
      @click="handleNavigate"
    />
    <div>
      <div class="flex">
        <span class="text-2xl ml-3 cursor-pointer break-all" @click="handleNavigate">{{ name }}</span>
        <span class="flex gap-2 ml-3"> <BlueBadgeIcon v-if="isBlueBadge" class="mt-[6px]" /> </span>
      </div>
      <p class="text-sm">{{ formatFollowers(follower) }} {{ getFollowerText(follower) }}</p>
    </div>
  </div>
</template>
