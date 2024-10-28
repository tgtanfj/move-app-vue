<script setup>
import { Popover, PopoverContent, PopoverTrigger } from '@common/ui/popover'
import { usePaymentStore } from '../../stores/payment'
import { onMounted, ref } from 'vue'
import { useAuthStore } from '../../stores/auth'
import { useOpenLoginStore } from '../../stores/openLogin'

const props = defineProps({
  isInStreamerPage: {
    type: Boolean,
    required: true
  }
})

const paymentStore = usePaymentStore()
const authStore = useAuthStore()
const openLoginStore = useOpenLoginStore()

const showListReps = ref(false)

const onUpdateOpen = () => {
  if (authStore.accessToken) {
    showListReps.value = true
  } else {
    openLoginStore.toggleOpenLogin()
  }
}

onMounted(() => {
  paymentStore.getListRepsPackage()
})
</script>
<template>
  <Popover>
    <PopoverTrigger asChild class="cursor-pointer font-semibold text-[16px]">
      <p class="font-bold text-center text-[16px] text-nowrap">Get REP$</p>
    </PopoverTrigger>
    <PopoverContent class="mt-2 -translate-x-24">
      <ul v-if="paymentStore.repsPackageList.length > 0">
        <li v-for="item in paymentStore.repsPackageList" :key="item.id" :item="item">
          {{ item.numberOfREPs }}
        </li>
      </ul>
    </PopoverContent>
  </Popover>
</template>
