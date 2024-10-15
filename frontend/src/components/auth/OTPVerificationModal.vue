<script setup>
import { Button } from '@common/ui/button'
import { Input } from '@common/ui/input'
import BaseDialog from '@components/BaseDialog.vue'
import { useOTPVerification } from '@services/optverify.services'
import { signupService } from '@services/signup.services'
import { ref } from 'vue'

const props = defineProps(['signupInfo', 'countdown', 'isCounting'])
const emit = defineEmits(['verifySuccess', 'reset'])

const code = ref('')
const errorMessage = ref('')
const isBanned = ref(false)

const mutation = useOTPVerification()
const { isPending, isError, mutate, reset } = mutation

const handleSendOTP = () => {
  mutate(
    {
      email: props.signupInfo.email,
      password: props.signupInfo.password,
      otp: code.value.toString()
    },
    {
      onSuccess: (response) => {
        resetFormOnClose()
        emit('verifySuccess', {
          email: props.signupInfo.email,
          password: props.signupInfo.password
        })
      },
      onError: (err) => {
        errorMessage.value = err.response?.data?.message
        if (
          errorMessage.value ===
          "You've entered the wrong OTP too many times. Your account is locked for 10 minutes. Please try again later"
        ) {
          isBanned.value = true

          setTimeout(() => {
            isBanned.value = false
            reset()
          }, 600000)
        }
      }
    }
  )
}

const handleResendOTP = async () => {
  await signupService.signupByEmailPassword(props.signupInfo.email)
  reset()
  code.value = ''
  emit('reset')
}

const blockInvalidKeys = (event) => {
  if (!/[0-9]/.test(event.key) && event.key !== 'Backspace') {
    event.preventDefault()
  }

  if (code.value.length >= 6 && event.key !== 'Backspace') {
    event.preventDefault()
  }
}

const resetFormOnClose = () => {
  reset()
  code.value = ''
  isBanned.value = false
}
</script>

<template>
  <BaseDialog
    :title="$t('otp_verify.title')"
    :description="$t('otp_verify.desc')"
    @update:open="
      (val) => {
        if (!val) resetFormOnClose()
      }
    "
  >
    <form>
      <div class="flex flex-col space-y-1.5">
        <div class="flex gap-2 items-center">
          <label for="email">{{ $t('label.verify_code') }}</label>
          <div>
            <Button
              v-if="!props.isCounting"
              :disabled="isBanned"
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
        <Input v-model="code" type="text" @keydown="blockInvalidKeys" />
        <p v-if="isError" class="text-red-500">
          {{ errorMessage }}
        </p>
      </div>

      <div class="flex justify-center mt-4">
        <Button
          :disabled="!code || isPending || isBanned"
          :variant="!code || isBanned ? 'disabled' : 'default'"
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
