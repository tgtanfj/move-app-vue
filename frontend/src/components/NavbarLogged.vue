<script setup>
import Notification from '@components/notificataion/Notification.vue'
import GetRep from './rep/GetRep.vue'
import MenuAccount from '@components/MenuAccount.vue'
import { useAuthStore } from '../stores/auth'
import { usePaymentStore } from '../stores/payment'
import { apiAxios } from '../helpers/axios.helper'
import { watch } from 'vue'

const props = defineProps({
  isInStreamerPage: {
    type: Boolean,
    required: false
  }
})

const authStore = useAuthStore()
const paymentStore = usePaymentStore()

watch(
  () => authStore.user,
  async (newValue) => {
    if (newValue.numberOfREPs) {
      paymentStore.reps = authStore.user.numberOfREPs
    } else {
      try {
        const res = await apiAxios.get('/user/profile')
        if (res.status === 200 && res.data.data.numberOfREPs) {
          paymentStore.reps = res.data.data.numberOfREPs
        } else paymentStore.reps = 0
      } catch (error) {
        paymentStore.reps = 0
      }
    }
  },
  { immediate: true }
)
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
