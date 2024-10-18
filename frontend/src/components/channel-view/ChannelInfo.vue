<script setup>
import defaultAvatar from '@assets/icons/default-avatar.png'
import BlueBadgeIcon from '../../assets/icons/BlueBadgeIcon.vue'
import PinkBadgeIcon from '../../assets/icons/PinkBadgeIcon.vue'
import { useChannelStore } from '../../stores/view-channel'
import { getFollowerText } from '../../utils/follower.util'
import ChannelActions from './ChannelActions.vue'
import { ref } from 'vue'

const channelStore = useChannelStore()
const { image, numberOfFollowers, name, isBlueBadge, isPinkBadge } = channelStore.channelInfo
const numFollower = ref(numberOfFollowers)

const handleIncrease = () => {
  numFollower.value++
}
const handleDecrease = () => {
  numFollower.value--
}
</script>
<template>
  <div class="flex items-center justify-between">
    <div class="flex items-center">
      <img :src="image || defaultAvatar" class="w-[56px] h-[56px] mr-5 rounded-full" />
      <div>
        <div class="flex items-center">
          <span class="text-2xl">{{ name }}</span>
          <span class="flex gap-2 ml-3">
            <BlueBadgeIcon v-if="isBlueBadge" /></span>
        </div>
        <span class="text-sm">{{ numFollower }} {{ getFollowerText(numFollower) }}</span>
      </div>
    </div>
    <ChannelActions @increaseFollower="handleIncrease" @decreaseFollower="handleDecrease" />
  </div>
</template>
