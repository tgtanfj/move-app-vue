<template>
  <BaseDialog title="Forgot password" description="Enter email address for your account">
    <Form @submit="onSubmit" :validation-schema="emailSchema">
      <div class="flex flex-col space-y-1.5">
        <Field
          name="email"
          type="email"
          class="text-[16px] mb-1 py-2 px-3 border-darkGray border-[1px] rounded-lg focus:border-primary focus:outline-none"
          :class="borderColor"
        />
        <ErrorMessage name="email" class="text-redMisc text-sm italic" />
      </div>

      <div
        v-if="typeof sendEmailSuccess === 'boolean'"
        class="border rounded-md px-3 py-5 text-center"
        :class="bgColor"
      >
        <p class="max-w-[400px] m-auto">
          We've sent an email to. Click the link in the email to reset your password.
        </p>
      </div>

      <div class="flex justify-center mt-2">
        <Button>{{ isSendEmail ? 'Resend the link' : 'Send password reset link' }}</Button>
      </div>
    </Form>

    <div class="flex justify-center">
      <Button variant="link" @click="openLogin"> Back to login page </Button>
    </div>
  </BaseDialog>
</template>

<script setup>
import { emailSchema } from '@/validation/schema.js'
import { Button } from '@common/ui/button'
import BaseDialog from '@components/BaseDialog.vue'
import { ErrorMessage, Field, Form } from 'vee-validate'
import { computed, ref } from 'vue'

const isSendEmail = ref(false)
const sendEmailSuccess = ref()

const borderColor = computed(() => {
  if (typeof sendEmailSuccess.value === 'boolean') {
    return sendEmailSuccess.value
      ? 'border-primary focus:border-primary'
      : 'border-redMisc focus:border-redMisc'
  }
  return ''
})
const bgColor = computed(() => {
  if (typeof sendEmailSuccess.value === 'boolean') {
    return sendEmailSuccess.value
      ? 'bg-[#E6FFFB] border-primaryGreen'
      : 'bg-[#FDEDEF] border-redMisc'
  }
  return ''
})

function onSubmit(values) {
  console.log(values.email)
}

//handle open login
const emit = defineEmits(['openLogin'])
const openLogin = () => {
  emit('openLogin')
}
</script>
