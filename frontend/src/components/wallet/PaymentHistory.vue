<script setup lang="ts">
import { Button } from '@common/ui/button'
import { ChevronLeft, ChevronRight } from 'lucide-vue-next'
import { ref, watchEffect } from 'vue'
import { PAGINATION } from '../../constants/pagination.constant'
import { usePaymentHistory } from '../../services/paymenthistory.services'
import CustomSelection from '../channel-view/CustomSelection.vue'
import PaymentHistoryCalendar from './PaymentHistoryCalendar.vue'
import PaymentHistoryTable from './PaymentHistoryTable.vue'

const payments = ref([])
const total = ref()
const { data, isLoading } = usePaymentHistory()
watchEffect(() => {
  if (!isLoading.value && data.value) {
    total.value = data?.value.meta.total
    payments.value = data.value.data
  }
})
</script>

<template>
  <div class="flex gap-6 justify-end">
    <PaymentHistoryCalendar />
  </div>

  <PaymentHistoryTable :payments="payments" />
  <div class="flex items-center justify-between mt-5" v-if="payments.length > 0">
    <div class="w-40">
      <CustomSelection label="SHOW" :list-items="PAGINATION" />
    </div>

    <div class="flex items-center gap-5">
      <p>1 - 10 of {{ total }} results</p>

      <div>
        <Button variant="link" class="pl-2">
          <ChevronLeft :size="14" />
        </Button>
        <Button variant="link" class="pl-2">
          <ChevronRight :size="14" />
        </Button>
      </div>
    </div>
  </div>

  <div v-else class="text-center mt-[15%]">
    <p class="font-semibold">{{ $t('payment_history.no_payment') }}</p>
    <p class="italic">{{ $t('payment_history.no_purchased') }}</p>
  </div>
</template>
