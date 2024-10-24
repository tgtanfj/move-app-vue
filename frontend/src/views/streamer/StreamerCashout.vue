<script setup>
import CashoutCard from '@components/cashout/CashoutCard.vue'
import { cashoutService } from '@services/cashout.services'
import { onMounted, ref } from 'vue'

const reps = ref(0)
const withdrawAmount = ref(null)
const userPaypalEmail = ref('')
const isLoadingWithdraw = ref(false)
const emailTemp = ref('')

onMounted(async () => {
  const response = await cashoutService.getChannelReps()
  if (response.message === 'success') {
    reps.value = +response?.data?.numberOfREPs
    if (response?.data?.emailPayPal) {
      userPaypalEmail.value = response?.data?.emailPayPal
    }
  }
})

const withdrawReps = async () => {
  isLoadingWithdraw.value = true
  const response = await cashoutService.withdraw(
    emailTemp.value ? emailTemp.value : userPaypalEmail.value,
    withdrawAmount.value
  )
  if (response.message === 'success') {
    reps.value = +response.data.numberOfREPs
  }
  isLoadingWithdraw.value = false
}

const handleWithdrawAll = () => {
  withdrawAmount.value = reps.value
}

const handleResetValue = () => {
  reps.value === 0
  withdrawAmount.value = null
}

const handleUpdateUserEmailPaypal = (value) => {
  userPaypalEmail.value = value
}

const handleUpdateEmailTempPaypal = (value) => {
  emailTemp.value = value
}
</script>

<template>
  <div class="w-full h-full mt-[65px]">
    <h2 class="text-2xl m-7 font-bold">Cashout</h2>
    <div class="ml-7">
      <CashoutCard
        :reps="reps"
        :userPaypalEmail="userPaypalEmail"
        :isLoadingWithdraw="isLoadingWithdraw"
        @withdrawReps="withdrawReps"
        @handleWithdrawAll="handleWithdrawAll"
        @handleResetValue="handleResetValue"
        @handleUpdateUserEmailPaypal="handleUpdateUserEmailPaypal"
        @handleUpdateEmailTempPaypal="handleUpdateEmailTempPaypal"
        v-model:withdrawAmount="withdrawAmount"
      />
    </div>
  </div>
</template>
