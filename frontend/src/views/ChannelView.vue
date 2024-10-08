<script setup>
import Sidebar from '@components/Sidebar.vue'
import ChannelInfo from '@components/channel-view/ChannelInfo.vue'
import ChannelTabs from '@components/channel-view/ChannelTabs.vue'
</script>
<template>
  <div class="flex">
    <div class="ml-6 mr-32 mb-6 pt-5 grow">
      <ChannelInfo class="mb-5" />
      <ChannelTabs />
    </div>
  </div>
</template>
