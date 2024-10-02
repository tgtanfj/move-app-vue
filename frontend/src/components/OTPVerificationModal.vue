<template>
  <BaseDialog :title="$t('otp_verify.title')" :description="$t('otp_verify.desc')">
    <form>
      <div class="flex flex-col space-y-1.5">
        <label for="email"
          >{{ $t('label.verify_code') }} (<Button
            variant="link"
            class="p-0 font-normal text-[14px]"
            @click.prevent="handleResendOTP"
            >{{ $t('otp_verify.resend_code') }}</Button
          >)</label
        >
        <Input v-model="code" type="number" />
        <p v-if="isError" class="text-red-500">Verification failed. Please try again</p>
      </div>

      <div class="flex justify-center mt-4">
        <Button
          :disabled="!code | isPending"
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
import { ref } from 'vue'
import { Input } from '../common/ui/input'
import { useOTPVerification } from '../services/optverify.services'
import { signupService } from '../services/signup.services'

const props = defineProps(['signupInfo'])
const emit = defineEmits(['verifySuccess'])

const code = ref('')

const mutation = useOTPVerification()
const { isPending, isError, mutate, reset } = mutation

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
        console.log('Error verifying OTP:', err)
      }
    }
  )
}

const handleResendOTP = async () => {
  await signupService.signupByEmailPassword(props.signupInfo.email)
  reset()
}
</script>
