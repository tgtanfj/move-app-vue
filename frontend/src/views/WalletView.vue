<script setup>
import SeparatorCross from '@components/SeparatorCross.vue'
import Wallet from '@components/wallet/Wallet.vue'
import { t } from '@helpers/i18n.helper'
import { usePaymentStore } from '../stores/payment'
import { X } from 'lucide-vue-next'

const paymentStore = usePaymentStore()

const hideNotify = () => {
  paymentStore.hideNotify()
}
</script>

<template>
  <div class="w-full h-full flex">
    <div class="w-full h-full p-6">
      <div
        v-if="paymentStore.showSucessNotify"
        class="w-full bg-[#E6FFFB] border-[1.5px] border-[#13D0B4] p-4 rounded-lg my-2 text-sm flex item-center justify-between"
      >
        <p>{{ t('wallet.setup_success') }}</p>
        <X class="cursor-pointer" :size="15" @click="hideNotify" />
      </div>
      <SeparatorCross title="Wallet" />
      <Wallet />
    </div>
  </div>
</template>
