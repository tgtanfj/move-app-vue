<script setup>
import { Button } from '@common/ui/button'
import { Checkbox } from '@common/ui/checkbox'
import { Dialog, DialogContent, DialogHeader, DialogTitle } from '@common/ui/dialog'
import { Input } from '@common/ui/input'
import Loading from '@components/Loading.vue'
import { REGEX_EMAIL } from '@constants/regex.constant'
import { cashoutService } from '@services/cashout.services'
import { ref, watch } from 'vue'

const props = defineProps({
  isOpen: {
    type: Boolean,
    required: true
  }
})

const emit = defineEmits([
  'update:isOpen',
  'handleUpdateUserEmailPaypal',
  'handleUpdateEmailTempPaypal'
])

const internalValue = ref(props.isOpen)
const email = ref('')
const emailError = ref('')
const isLoading = ref(false)

const validateEmail = (value) => {
  const emailPattern = REGEX_EMAIL
  return emailPattern.test(value)
}

const handleInputEmail = (event) => {
  emailError.value = ''
  let input = event.target.value
  input = input.replace(/\s/g, '')
  input = input.trim()
  email.value = input
}

const handleAddEmail = async () => {
  if (!validateEmail(email.value)) {
    emailError.value = 'Email invalid'
  } else {
    emit('handleUpdateEmailTempPaypal', email.value)
    emailError.value = ''
    isLoading.value = true
    const response = await cashoutService.setPaypayEmail(email.value)
    if (response.message === 'success') {
      emit('update:isOpen', false)
      handleUpdateUserEmailPaypal()
      email.value = ''
    }
    isLoading.value = false
  }
}

const handleUpdateUserEmailPaypal = () => {
  emit('handleUpdateUserEmailPaypal', email.value)
}

const handleCloseModal = () => {
  email.value = ''
  emailError.value = ''
  emit('update:isOpen', false)
}

watch(internalValue, (newValue) => {
  emit('update:isOpen', newValue)
})

watch(
  () => props.isOpen,
  (newValue) => {
    internalValue.value = newValue
  }
)
</script>

<template>
  <Dialog v-model:open="internalValue" @update:open="handleCloseModal">
    <DialogContent>
      <DialogHeader>
        <DialogTitle class="text-[24px] font-bold"> {{ $t('cashout.enter_email') }} </DialogTitle>
      </DialogHeader>
      <div class="w-full flex flex-col gap-5">
        <div class="w-full flex flex-col gap-[2px]">
          <p class="text-[16px]">{{ $t('cashout.email_address') }}</p>
          <Input
            class="w-full"
            placeholder="Email address"
            type="email"
            v-model="email"
            @input="handleInputEmail"
            :class="{ 'border-destructive': emailError }"
          />
          <p v-if="emailError !== ''" class="text-destructive text-[12px]">{{ emailError }}</p>
        </div>
        <p class="text-[12px] text-[#777777]">
          {{ $t('cashout.by') }}
          <span class="text-primary text-[12px] cursor-pointer">{{ $t('cashout.end_user') }}</span>,
          <span class="text-primary text-[12px] cursor-pointer">{{ $t('cashout.privacy') }}</span> {{ $t('cashout.and') }}
          <span class="text-primary text-[12px] cursor-pointer">{{ $t('cashout.refund') }}</span>.
        </p>
        <div class="flex items-center justify-end gap-10 mt-4">
          <Button @click="handleCloseModal" variant="outline" class="font-normal"> {{ $t('cashout.back') }} </Button>
          <Button :disabled="isLoading" @click="handleAddEmail" class="w-[170px]">
            <span v-if="!isLoading">{{ $t('cashout.next') }}</span> <Loading v-if="isLoading" />
          </Button>
        </div>
      </div>
    </DialogContent>
  </Dialog>
</template>
