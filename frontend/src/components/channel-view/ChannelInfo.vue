<script setup>
import defaultAvatar from '@assets/icons/default-avatar.png'
import { formatFollowers } from '@utils/formatViews.util'
import { ref, watchEffect } from 'vue'
import BlueBadgeIcon from '../../assets/icons/BlueBadgeIcon.vue'
import { useChannelStore } from '../../stores/view-channel'
import { getFollowerText } from '../../utils/follower.util'
import ChannelActions from './ChannelActions.vue'

const channelStore = useChannelStore()
const image = ref('');
const name = ref('');
const isBlueBadge = ref(false);
const numFollower = ref(0)

watchEffect(() => {
  image.value = channelStore.channelInfo?.image || '';
  name.value = channelStore.channelInfo?.name || '';
  isBlueBadge.value = channelStore.channelInfo?.isBlueBadge || false;
  numFollower.value = channelStore.channelInfo?.numberOfFollowers || 0;
});

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
          <span class="flex gap-2 ml-3"> <BlueBadgeIcon v-if="isBlueBadge" /></span>
        </div>
        <span class="text-sm"
          >{{ formatFollowers(numFollower) }} {{ getFollowerText(numFollower) }}</span
        >
      </div>
    </div>
    <ChannelActions @increaseFollower="handleIncrease" @decreaseFollower="handleDecrease" />
  </div>
</template>
