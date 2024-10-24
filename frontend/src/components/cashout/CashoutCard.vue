<script setup>
import { Button } from '@common/ui/button'
import { Dialog, DialogTrigger, DialogContent, DialogHeader, DialogTitle } from '@common/ui/dialog'
import { Input } from '@common/ui/input'
import { convertRepsToUSD } from '@utils/convertRepsToUSD.util'
import { cn } from '@utils/shadcn.util'
import { computed, ref, watch } from 'vue'
import AddEmailPaypalDialog from './AddEmailPaypalDialog.vue'
import Loading from '@components/Loading.vue'

const props = defineProps({
  reps: {
    type: Number,
    required: true
  },
  userPaypalEmail: {
    type: String,
    required: true
  },
  isLoadingWithdraw: {
    type: Boolean,
    required: true
  }
})

const withdrawAmount = defineModel('withdrawAmount')

const emit = defineEmits([
  'update:withdrawAmount',
  'withdrawReps',
  'handleWithdrawAll',
  'handleResetValue',
  'handleUpdateUserEmailPaypal',
  'handleUpdateEmailTempPaypal'
])

const isAmoutInvalid = ref('')
const isWithdrawInputRepsOpen = ref(false)
const isDoneWithdrawInputOpen = ref(false)
const isOpenModalAddEmail = ref(false)

const progressWidth = computed(() => {
  const max = 2500
  const percentage = (props.reps / max) * 100
  return `${Math.min(percentage, 100)}%`
})

const handleWithdraw = () => {
  if (withdrawAmount.value > props.reps || withdrawAmount.value < 2500) {
    isAmoutInvalid.value = 'Insufficient balance'
  } else {
    isAmoutInvalid.value = ''
    emit('withdrawReps')
    isWithdrawInputRepsOpen.value = false
    isDoneWithdrawInputOpen.value = true
  }
}

const handleWithdrawAll = () => {
  emit('handleWithdrawAll')
  isAmoutInvalid.value = ''
}

const handleResetValue = () => {
  emit('handleResetValue')
  isAmoutInvalid.value = ''
  isDoneWithdrawInputOpen.value = false
  isWithdrawInputRepsOpen.value = false
}

const handleUpdateUserEmailPaypal = (value) => {
  emit('handleUpdateUserEmailPaypal', value)
}

const handleUpdateEmailTempPaypal = (value) => {
  emit('handleUpdateEmailTempPaypal', value)
}

const handleInputReps = () => {
  isAmoutInvalid.value = ''
}
</script>

<template>
  <div class="w-full max-w-[670px] rounded-lg shadow-custom shadow-[#ccc] flex flex-col p-4 gap-8">
    <p class="text-[18px] font-bold">{{ $t('cashout.total_reps_earned') }}</p>
    <div class="flex flex-col gap-4">
      <div class="flex gap-8">
        <div class="text-[32px] font-bold">{{ reps }} {{ $t('cashout.reps') }}</div>
        <div class="text-[16px] mt-1">
          ({{ $t('cashout.estimated_value') }} ${{ convertRepsToUSD(reps) }})
        </div>
      </div>
      <div class="flex flex-col gap-2">
        <div class="w-[80%] h-[8px] bg-[#E6FFFB]">
          <div
            class="h-full bg-primary transition-all duration-300"
            :style="{ width: progressWidth }"
          ></div>
        </div>

        <p class="text-[14px]">
          {{ $t('cashout.you_need') }}
          <span class="text-[14px] font-bold">{{ $t('cashout.2500_reps') }}</span>
          {{ $t('cashout.to_withdraw') }}.
        </p>
      </div>
      <div class="mt-4 flex items-center justify-between">
        <div class="flex flex-col gap-1">
          <p
            v-if="!userPaypalEmail"
            class="text-[14px] text-primary cursor-pointer"
            @click="isOpenModalAddEmail = true"
          >
            {{ $t('cashout.setup') }}
          </p>
          <p
            v-if="userPaypalEmail"
            class="text-[14px] text-primary cursor-pointer"
            @click="isOpenModalAddEmail = true"
          >
            {{ $t('cashout.edit') }}
          </p>
          <p v-if="!userPaypalEmail" class="text-[17px] font-bold">
            {{ $t('cashout.no_paypal') }}
          </p>
          <p v-if="userPaypalEmail" class="text-[17px] font-bold">
            {{ $t('cashout.paypal_transfer') }} {{ userPaypalEmail }}
          </p>
        </div>
        <Button
          :disabled="!userPaypalEmail"
          @click="isWithdrawInputRepsOpen = true"
          :class="{ 'bg-[#999999]': !userPaypalEmail }"
          >{{ $t('cashout.withdraw') }}</Button
        >
      </div>
    </div>
  </div>
  <Dialog v-model:open="isWithdrawInputRepsOpen" @update:open="handleResetValue">
    <DialogContent class="w-[800px]">
      <DialogHeader>
        <DialogTitle class="text-[24px]"> {{ $t('cashout.withdraw') }} </DialogTitle>
      </DialogHeader>
      <div class="w-full flex flex-col gap-6 mt-2">
        <div class="w-full flex flex-col gap-2">
          <p class="text-[16px] font-bold">{{ $t('cashout.remaining_amount') }}</p>
          <p class="text-[32px] font-bold">{{ reps }} {{ $t('cashout.reps') }}</p>
        </div>
        <div class="w-full flex flex-col gap-2">
          <div class="flex gap-4">
            <p>{{ $t('cashout.withdraw_value') }}</p>
            <p>({{ $t('cashout.estimated_value') }} ${{ convertRepsToUSD(withdrawAmount) }})</p>
          </div>
          <div class="relative flex gap-4 items-center">
            <Input
              v-model="withdrawAmount"
              type="number"
              placeholder="2500"
              @input="handleInputReps"
              :class="
                cn('w-[45%]', {
                  'border-destructive focus:border-destructive': isAmoutInvalid !== ''
                })
              "
            />
            <p @click="handleWithdrawAll" class="text-primary cursor-pointer">
              {{ $t('cashout.withdraw_all') }}
            </p>
            <p
              v-if="isAmoutInvalid !== ''"
              class="absolute -bottom-6 left-0 text-[14px] text-destructive italic"
            >
              {{ isAmoutInvalid }}
            </p>
          </div>
        </div>
      </div>
      <div class="w-full flex justify-end">
        <Button @click="handleWithdraw" class="ml-auto">
          <span class="font-bold" v-if="!isLoadingWithdraw">{{ $t('cashout.withdraw') }}</span>
          <Loading v-if="isLoadingWithdraw" />
        </Button>
      </div>
    </DialogContent>
  </Dialog>
  <Dialog v-model:open="isDoneWithdrawInputOpen" @update:open="handleResetValue">
    <DialogContent class="w-[600px]">
      <DialogHeader>
        <DialogTitle class="text-[24px]"> {{ $t('cashout.processing_payment') }} </DialogTitle>
      </DialogHeader>
      <div class="w-full flex flex-col gap-6 mt-2">
        <p class="text-[16px]">
          {{ $t('cashout.your_payment') }}
          <span class="font-bold">${{ convertRepsToUSD(withdrawAmount) }}</span>
          {{ $t('cashout.is_being') }}
        </p>
        <p class="text-[#777777] text-[12px]">
          {{ $t('cashout.note') }}
        </p>
      </div>
      <div class="w-full flex justify-center mt-4">
        <Button @click="handleResetValue">{{ $t('cashout.close') }}</Button>
      </div>
    </DialogContent>
  </Dialog>
  <AddEmailPaypalDialog
    v-model:isOpen="isOpenModalAddEmail"
    @handleUpdateUserEmailPaypal="handleUpdateUserEmailPaypal"
    @handleUpdateEmailTempPaypal="handleUpdateEmailTempPaypal"
  />
</template>

<style>
.shadow-custom {
  box-shadow:
    3px 4.6px 17.7px rgba(0, 0, 0, 0.059),
    4px 6px 20px rgba(0, 0, 0, 0.07);
}
</style>
