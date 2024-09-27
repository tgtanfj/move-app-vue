<template>
  <BaseDialog title="Forgot password" description="Enter email address for your account">
    <form @submit.prevent="handleSendMail">
      <div class="flex flex-col space-y-1.5">
        <custom-input name="email" :defineField="defineField" :errors="errors" />
      </div>

      <div v-if="isSendEmail" class="border rounded-md px-3 py-5 text-center" :class="bgColor">
        <p class="max-w-[400px] m-auto">
          We've sent an email to {{ email }}. Click the link in the email to reset your password.
        </p>
      </div>

      <div class="flex justify-center mt-2">
        <Button
          type="submit"
          :disabled="!isFormValid"
          :variant="isFormValid ? 'default' : 'disabled'"
          >{{ isSendEmail ? 'Resend the link' : 'Send password reset link' }}</Button
        >
      </div>
    </form>

    <div class="flex justify-center">
      <Button variant="link" @click="openLogin"> Back to login page </Button>
    </div>
  </BaseDialog>
</template>

<script setup>
import CustomInput from '@/components/input-validation/CustomInput.vue'
import { Button } from '@common/ui/button'
import BaseDialog from '@components/BaseDialog.vue'
import { useForm } from 'vee-validate'
import { computed, ref } from 'vue'
import { emailSchema } from '../validation/schema'

const isSendEmail = ref(false)
const sendEmailSuccess = ref(false)

const borderColor = computed(() => {
  if (isSendEmail.value) {
    return sendEmailSuccess && sendEmailSuccess.value
      ? 'border-primary focus:border-primary'
      : 'border-redMisc focus:border-redMisc'
  }
  return ''
})
const bgColor = computed(() => {
  if (isSendEmail.value) {
    return sendEmailSuccess.value
      ? 'bg-[#E6FFFB] border-primaryGreen'
      : 'bg-[#FDEDEF] border-redMisc'
  }
  return ''
})

const { values, errors, defineField, handleSubmit } = useForm({
  validationSchema: emailSchema
})

const isFillAllFields = computed(() => {
  return values.email
})

const isFormValid = computed(() => {
  return isFillAllFields.value && Object.keys(errors.value).length === 0
})

const handleSendMail = handleSubmit(async (values) => {
  console.log(values)
})

//handle open login
const emit = defineEmits(['openLogin'])
const openLogin = () => {
  emit('openLogin')
}
</script>
