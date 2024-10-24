<script setup>
import { onMounted } from 'vue'
import { usePaymentStore } from '../../stores/payment'
import PaymentCard from './PaymentCard.vue'
import { t } from '@helpers/i18n.helper'
import PaymentDetailModal from './PaymentDetailModal.vue'
import Loading from '@components/Loading.vue'
const paymentStore = usePaymentStore()

onMounted(() => {
  paymentStore.fetchUserPaymentMethod()
})
</script>

<template>
  <div class="w-full">
    <div class="w-full h-full flex items-center justify-center mt-60" v-if="paymentStore.isLoading">
      <Loading />
    </div>
    <div class="w-full flex flex-col" v-else>
      <span class="text-[16px] font-bold">{{ t('wallet.your_payment_method') }}</span>
      <div v-if="paymentStore.userPaymentList.length > 0" class="w-full mt-4 flex gap-8">
        <PaymentCard v-for="item in paymentStore.userPaymentList" :key="item.id" :item="item" />
      </div>
      <div v-else class="w-full pt-[15%] flex flex-col items-center justify-center gap-2">
        <p class="text-[16px] font-bold">{{ t('wallet.no_payment_method_setup') }}</p>
        <p class="text-[16px] italic mb-3">{{ t('wallet.no_saved_info') }}</p>
        <PaymentDetailModal />
      </div>
    </div>
  </div>
</template>
