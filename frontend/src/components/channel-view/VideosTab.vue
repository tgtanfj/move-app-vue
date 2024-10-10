<script setup>
import { ref } from 'vue'
import { useChannelStore } from '../../stores/view-channel'
import Video from '../home/Video.vue'
import VideoActions from './VideoActions.vue'

const channels = ref([])

const channelStore = useChannelStore()
const { name } = channelStore.channelInfo
</script>
<template>
  <div class="flex items-center justify-between">
    <h1 class="text-title-size font-bold">{{ $t('view_channel.all_videos') }}</h1>

    <!-- SORT -->
    <div class="flex gap-5">
      <VideoActions />
    </div>
  </div>

  <div>
    <div class="grid grid-cols-3 gap-8 mt-4" v-if="channels.length > 0">
      <div v-for="(item, index) in channels" :key="index">
        <Video :video="item" />
      </div>
    </div>

    <div v-if="channels.length === 0" class="italic text-center mt-[15%]">
      {{ $t('view_channel.not_upload_video', { name }) }}
    </div>
  </div>
</template>
