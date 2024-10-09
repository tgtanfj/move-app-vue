<script setup>
import defaultAvatar from '@assets/icons/default-avatar.png'
import ChannelActions from './ChannelActions.vue'
</script>
<template>
  <div class="flex items-center justify-between">
    <div class="flex items-center">
      <img :src="defaultAvatar" class="w-[56px] h-[56px] mr-5" />
      <div>
        <div class="text-2xl">dianeTV</div>
        <span class="text-sm">10335 followers</span>
      </div>
    </div>
    <ChannelActions />
  </div>
</template>
