<script setup>
import Notification from '@components/notificataion/Notification.vue'
import GetRep from './rep/GetRep.vue'
import MenuAccount from '@components/MenuAccount.vue'

const props = defineProps({
  isInStreamerPage: {
    type: Boolean,
    required: false
  }
})
</script>

<template>
  <div class="flex items-center gap-3 h-full">
    <div class="mr-2">
      <GetRep :isInStreamerPage="isInStreamerPage" />
    </div>

    <Notification />

    <MenuAccount />
  </div>
</template>
