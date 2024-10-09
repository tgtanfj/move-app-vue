<script setup>
import defaultAvatar from '@assets/icons/default-avatar.png'
import BlueBadgeIcon from '@assets/icons/BlueBadgeIcon.vue'
import PinkBadgeIcon from '@assets/icons/PinkBadgeIcon.vue'

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
  }
})
</script>
<template>
  <div class="flex flex-col items-center text-center">
    <img :src="avatar || defaultAvatar" class="w-[56px] h-[56px] mb-4" />
    <div>
      <div class="flex items-center">
        <span class="text-2xl ml-3">{{ name }}</span>
        <span class="flex gap-2 ml-3"> <BlueBadgeIcon /> <PinkBadgeIcon /></span>
      </div>
      <p class="text-sm">{{ follower }} followers</p>
    </div>
  </div>
</template>
