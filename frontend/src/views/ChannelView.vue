<script setup>
import ChannelInfo from '@components/channel-view/ChannelInfo.vue'
import ChannelTabs from '@components/channel-view/ChannelTabs.vue'
import { computed, watch, watchEffect } from 'vue'
import { useRoute } from 'vue-router'
import Loading from '../components/Loading.vue'
import { useChannelAbout } from '../services/channel_about.services'
import { useAuthStore } from '../stores/auth'
import { useChannelStore } from '../stores/view-channel'

const route = useRoute()
const id = computed(() => route.params.id)
const channelStore = useChannelStore()
const userStore = useAuthStore()
const { data, isLoading, refetch } = useChannelAbout(id)

watchEffect(() => {
  if (!isLoading.value && data.value) {
    channelStore.setChannelInfo(data.value.data)
  }
})

watch(
  () => userStore.accessToken,
  (newToken) => {
    if (newToken) {
      refetch()
    }
  }
)
</script>
<template>
  <div class="flex">
    <div class="ml-6 mr-20 mb-6 pt-5 grow">
      <div v-if="isLoading"><Loading class="mt-40" /></div>
      <div v-else>
        <ChannelInfo class="mb-5" />
        <ChannelTabs />
      </div>
    </div>
  </div>
</template>
