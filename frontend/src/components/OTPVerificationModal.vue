<template>
  <BaseDialog
    title="Verify your email to keep account secure"
    description="We sent a 6-digit code to your email. Enter the code below to confirm your account. You may also tap on the link in the email we sent you."
  >
    <form @submit.prevent="handleSendMail">
      <div class="flex flex-col space-y-1.5">
        <label for="email"
          >Verification Code (<Button variant="link" class="p-0 font-normal text-[14px]"
            >Resend code</Button
          >)</label
        >
        <Input v-model="code" type="number" />
      </div>

      <div class="flex justify-center mt-4">
        <Button
          :disabled="!code"
          :variant="code ? 'default' : 'disabled'"
          type="submit"
          class="w-[40%]"
          >Submit</Button
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

const emit = defineEmits(['closeModal'])

const code = ref(null)
const handleSendMail = () => {
  console.log(code.value)
  code.value = null
  emit('closeModal')
}
</script>
