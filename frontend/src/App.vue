<script setup>
import Toaster from '@common/ui/toast/Toaster.vue'
import ToastProvider from '@common/ui/toast/ToastProvider.vue'
import Navbar from '@components/Navbar.vue'
import UploadVideoQueue from '@components/upload-video/UploadVideoQueue.vue'
import { useVideoQueueStore } from './stores/videoQueue.store'
import { RouterView } from 'vue-router'

const videoQueueStore = useVideoQueueStore()
</script>

<template>
  <ToastProvider>
    <Navbar />

    <RouterView />
    <Toaster />
    <UploadVideoQueue v-if="videoQueueStore.isVideoQueueShow" />
  </ToastProvider>
</template>
