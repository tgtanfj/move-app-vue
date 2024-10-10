<script setup>
import ChannelInfo from '@components/channel-view/ChannelInfo.vue'
import ChannelTabs from '@components/channel-view/ChannelTabs.vue'
import { watchEffect } from 'vue'
import { useRoute } from 'vue-router'
import Loading from '../components/Loading.vue'
import { useChannelAbout } from '../services/channel_about.services'
import { useChannelStore } from '../stores/view-channel'

const route = useRoute()
const id = route.params.id
const channelStore = useChannelStore()

const { data, isLoading } = useChannelAbout(id)

watchEffect(() => {
  if (!isLoading.value && data.value) {
    channelStore.setChannelInfo(data.value.data)
  }
})
</script>
<template>
  <div class="flex">
    <div class="ml-6 mr-32 mb-6 pt-5 grow">
      <div v-if="isLoading"><Loading /></div>
      <div v-else>
        <ChannelInfo class="mb-5" />
        <ChannelTabs />
      </div>
    </div>
  </div>
</template>
