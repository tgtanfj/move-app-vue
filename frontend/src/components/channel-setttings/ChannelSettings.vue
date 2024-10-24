<script setup>
import { onMounted, ref } from 'vue'
import ChannelTab from './ChannelTab.vue'
import ChannelNotificationsTab from './ChannelNotificationsTab.vue'
import { channelSettingsService } from '@services/channel-settings.services'

const tabs = [
  { id: 1, label: 'channel_settings.channel' },
  { id: 2, label: 'channel_settings.notifications' }
]

const tabShow = ref(1)
const channelBio = ref()
const channelLinks = ref([])
const channelId = ref(null)

const changeTab = (tab) => {
  tabShow.value = tab
}

onMounted(async () => {
  const response = await channelSettingsService.getChannelSettings()
  if (response.message === 'success') {
    channelBio.value = response.data.bio
    channelLinks.value = [...response.data.socialLinks]
    channelId.value = response.data.id
  }
})
</script>

<template>
  <div class="w-full h-full mt-[65px]">
    <h2 class="text-2xl m-7 font-bold">{{ $t('channel_settings.channel_settings') }}</h2>
    <div class="ml-7">
      <div
        class="ml-0 pl-0 text-[16px] w-full border-b-[1px] border-[#999999] pb-0 rounded-none mb-4 self-start flex justify-start gap-4"
      >
        <div
          v-for="tab in tabs"
          :key="tab.id"
          @click="changeTab(tab.id)"
          class="border-b-[3px] cursor-pointer px-0 mx-3 rounded-none flex items-center justify-start ml-0 pl-0 pb-3 transition-transform"
          :class="{
            'border-[#13D0B4] text-[#13D0B4] font-bold': tabShow === tab.id,
            'border-white': tabShow !== tab.id
          }"
        >
          {{ $t(tab.label) }}
        </div>
      </div>
      <div v-show="tabShow === 1">
        <ChannelTab
          :channelId="channelId"
          v-model:channelBio="channelBio"
          v-model:channelLinks="channelLinks"
        />
      </div>
      <div v-show="tabShow === 2">
        <ChannelNotificationsTab />
      </div>
    </div>
  </div>
</template>
