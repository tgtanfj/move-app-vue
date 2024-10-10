<script setup>
import BlueBadgeIcon from '@assets/icons/BlueBadgeIcon.vue'
import defaultAvatar from '@assets/icons/default-avatar.png'
import PinkBadgeIcon from '@assets/icons/PinkBadgeIcon.vue'
import { getFollowerText } from '../../utils/follower.util'

const props = defineProps({
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
</script>
<template>
  <div class="flex flex-col items-center text-center">
    <img :src="avatar || defaultAvatar" class="w-[56px] h-[56px] mb-4" />
    <div>
      <div class="flex items-center">
        <span class="text-2xl ml-3">{{ name }}</span>
        <span class="flex gap-2 ml-3">
          <BlueBadgeIcon v-if="isBlueBadge" /> <PinkBadgeIcon v-if="isPinkBadge"
        /></span>
      </div>
      <p class="text-sm">{{ follower }} {{ getFollowerText(follower) }}</p>
    </div>
  </div>
</template>
