<script setup lang="ts">
import { Button } from '@common/ui/button'
import { ChevronLeft, ChevronRight } from 'lucide-vue-next'
import { reactive, ref, watchEffect } from 'vue'
import { PAGINATION } from '../../constants/pagination.constant'
import { usePaymentHistory } from '../../services/paymenthistory.services'
import { formatDateShort } from '../../utils/convertDate.util'
import CustomSelection from '../channel-view/CustomSelection.vue'
import PaymentHistoryCalendar from './PaymentHistoryCalendar.vue'
import PaymentHistoryTable from './PaymentHistoryTable.vue'

const payments = ref([])
const total = ref()
const totalPages = ref()
const currentPage = ref(1)
const take = ref(10)
const today = new Date()
today.setDate(today.getDate() - 30)
const startDate = ref(formatDateShort(today))
const endDate = ref(formatDateShort(new Date()))
const display_range = reactive({
  to: 1,
  from: 1
})

const { data, isLoading, refetch } = usePaymentHistory(startDate, endDate, take, currentPage)

watchEffect(() => {
  if (!isLoading.value && data.value) {
    total.value = data?.value.meta.total
    totalPages.value = data?.value.meta.totalPages
    payments.value = data.value.data
  }
})

watchEffect(() => {
  display_range.to = (currentPage.value - 1) * take.value + 1
  display_range.from = currentPage.value * take.value
  if (display_range.from > total.value) {
    display_range.from = total.value
  }
})

const handleDateRangeChange = (start, end) => {
  startDate.value = start
  endDate.value = end
  take.value = 10
  currentPage.value = 1
  refetch()
}

const handlePrevPage = () => {
  if (currentPage.value > 1) {
    currentPage.value--
    refetch()
  }
}
const handleNextPage = () => {
  if (currentPage.value < totalPages.value) {
    currentPage.value++
    refetch()
  }
}

const handleTakeChange = (val) => {
  currentPage.value = 1
  take.value = Number(val)
  refetch()
}
</script>

<template>
  <div class="flex gap-6 justify-end">
    <PaymentHistoryCalendar @date-range="handleDateRangeChange" />
  </div>

  <PaymentHistoryTable :payments="payments" />
  <div class="flex items-center justify-between mt-5" v-if="payments.length > 0">
    <div class="flex items-center">
      <p class="uppercase">{{ $t('common.show') }}</p>
      <CustomSelection :list-items="PAGINATION" @update:value="handleTakeChange" class="w-24" />
    </div>

    <div class="flex items-center gap-5">
      <p
        v-if="payments.length > 1"
        v-html="
          $t('common.display_range_record', {
            to: `<strong>${display_range.to}</strong>`,
            from: `<strong>${display_range.from}</strong>`,
            total
          })
        "
      ></p>
      <p v-else>
        {{ $t('common.display_single_record', { num: total }) }}
      </p>

      <div>
        <Button variant="link" class="p-4" @click="handlePrevPage">
          <ChevronLeft :size="17" :class="currentPage > 1 ? 'text-primary' : 'text-darkGray '" />
        </Button>
        <Button variant="link" class="p-4" @click="handleNextPage">
          <ChevronRight
            :size="17"
            :class="currentPage < totalPages ? 'text-primary' : 'text-darkGray '"
          />
        </Button>
      </div>
    </div>
  </div>

  <div v-else class="text-center mt-[15%]">
    <p class="font-semibold">{{ $t('payment_history.no_payment') }}</p>
    <p class="italic">{{ $t('payment_history.no_purchased') }}</p>
  </div>
</template>
