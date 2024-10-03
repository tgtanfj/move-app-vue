<template>
  <BaseDialog :title="$t('otp_verify.title')" :description="$t('otp_verify.desc')">
    <form>
      <div class="flex flex-col space-y-1.5">
        <div class="flex gap-2 items-center">
          <label for="email">{{ $t('label.verify_code') }}</label>
          <div>
            <Button
              v-if="!props.isCounting"
              variant="link"
              class="p-0 font-normal text-[14px]"
              @click.prevent="handleResendOTP"
              >({{ $t('otp_verify.resend_code') }})</Button
            >
            <p class="text-[14px]" v-if="props.isCounting">
              <span class="text-primary">({{ props.countdown }}s)</span>
            </p>
          </div>
        </div>
        <Input v-model="code" type="number" />
        <p v-if="isError && !props.isBanned" class="text-red-500">
          Verification failed. Please try again
        </p>
        <p v-if="props.isBanned" class="text-red-500">
          You've entered the wrong OTP too many times. Your account is locked for 10 minutes. Please
          try again later
        </p>
      </div>

      <div class="flex justify-center mt-4">
        <Button
          :disabled="!code | isPending | props.isBanned"
          :variant="code ? 'default' : 'disabled'"
          type="submit"
          class="w-[40%]"
          @click.prevent="handleSendOTP"
          :isPending="isPending"
          >{{ $t('button.submit') }}</Button
        >
      </div>
    </form>
  </BaseDialog>
</template>

<script setup>
import { Button } from '@common/ui/button'
import BaseDialog from '@components/BaseDialog.vue'
import { ref, watch } from 'vue'
import { Input } from '../common/ui/input'
import { useOTPVerification } from '../services/optverify.services'
import { signupService } from '../services/signup.services'

const props = defineProps(['signupInfo', 'countdown', 'isCounting', 'isBanned'])
const emit = defineEmits(['verifySuccess', 'start', 'reset', 'getWithExpiry', 'setIsBannedToTrue'])

const invalidCodeTime = ref(0)
const code = ref('')

const mutation = useOTPVerification()
const { isPending, isError, mutate, reset } = mutation

watch(invalidCodeTime, (newValue) => {
  if (newValue === 3) {
    setWithExpiry('banOTP', 'ban', 600000)
    emit('setIsBannedToTrue')
    reset()
  }
})

const handleSendOTP = () => {
  mutate(
    {
      email: props.signupInfo.email,
      password: props.signupInfo.password,
      referralCode: props.signupInfo.code,
      otp: code.value.toString()
    },
    {
      onSuccess: (response) => {
        console.log('OTP verified successfully!', response)
        code.value = ''
        emit('verifySuccess')
        reset()
      },
      onError: (err) => {
        invalidCodeTime.value += 1
        console.log('Error verifying OTP:', err)
      }
    }
  )
}

const handleResendOTP = async () => {
  await signupService.signupByEmailPassword(props.signupInfo.email)
  reset()
  emit('reset')
}

const setWithExpiry = (key, value, ttl) => {
  const now = new Date()

  const item = {
    value: value,
    expiry: now.getTime() + ttl
  }

  localStorage.setItem(key, JSON.stringify(item))
}
</script>
