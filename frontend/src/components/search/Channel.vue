<script setup>
import BlueBadgeIcon from '@assets/icons/BlueBadgeIcon.vue'
import { formatFollowers } from '@utils/formatViews.util'

const props = defineProps({
  channel: {
    type: Object,
    required: true
  }
})
</script>
<template>
  <div class="flex items-center justify-start my-4 overflow-hidden">
    <router-link :to="`/channel/${channel.id}`">
      <img :src="channel.image" alt="" class="w-[100px] h-[100px] rounded-full" />
    </router-link>
    <div class="flex flex-col ml-8">
      <router-link class="flex items-center justify-start mb-1" :to="`/channel/${channel.id}`">
        <h6 class="mr-7 text-xl overflow-hidden">{{ channel.name }}</h6>
        <BlueBadgeIcon v-if="channel.isBlueBadge" />
      </router-link>
      <p class="text-gray-400 text-xl">
        {{ formatFollowers(channel.numberOfFollowers) }} {{ $t('search.followers') }}
      </p>
    </div>
  </div>
</template>
