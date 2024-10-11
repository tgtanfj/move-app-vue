<script setup>
import defaultAvatar from '@assets/icons/default-avatar.png'
import BlueBadgeIcon from '../../assets/icons/BlueBadgeIcon.vue'
import PinkBadgeIcon from '../../assets/icons/PinkBadgeIcon.vue'
import { useChannelStore } from '../../stores/view-channel'
import { getFollowerText } from '../../utils/follower.util'
import ChannelActions from './ChannelActions.vue'

const channelStore = useChannelStore()
const { image, numberOfFollowers, name, isBlueBadge, isPinkBadge } = channelStore.channelInfo
</script>
<template>
  <div class="flex items-center justify-between">
    <div class="flex items-center">
      <img :src="image || defaultAvatar" class="w-[56px] h-[56px] mr-5" />
      <div>
        <div class="flex items-center">
          <span class="text-2xl">{{ name }}</span>
          <span class="flex gap-2 ml-3">
            <BlueBadgeIcon v-if="isBlueBadge" /> <PinkBadgeIcon v-if="isPinkBadge"
          /></span>
        </div>
        <span class="text-sm"
          >{{ numberOfFollowers }} {{ getFollowerText(numberOfFollowers) }}</span
        >
      </div>
    </div>
    <ChannelActions />
  </div>
</template>
